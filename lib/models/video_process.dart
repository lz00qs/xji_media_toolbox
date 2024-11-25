import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/service/log_service.dart';
import 'package:xji_footage_toolbox/utils/ffmpeg_utils.dart';
import 'package:xji_footage_toolbox/utils/toast.dart';

enum VideoProcessType {
  transcode,
  trim,
  merge,
}

enum VideoProcessStatus {
  waiting,
  processing,
  finished,
  canceled,
  failed,
}

class VideoProcess {
  final String name;
  final VideoProcessType type;
  final List<String> ffmpegArgs;
  final Duration duration;
  final RxDouble progress = 0.0.obs;
  final Rx<VideoProcessStatus> status = VideoProcessStatus.waiting.obs;
  final String outputFilePath;
  final List<String> tempFilePaths;
  final completer = Completer<void>();
  final String? logFilePath;
  Timer? _heartbeatTimer;
  late File _outputFile;
  late List<File> _tempFiles;
  late File _logFile;
  Process? _process;
  bool _stopLogging = false;

  VideoProcess(
      {required this.name,
      required this.type,
      required this.ffmpegArgs,
      required this.duration,
      required this.outputFilePath,
      this.tempFilePaths = const [],
      this.logFilePath}) {
    _outputFile = File(outputFilePath);
    _tempFiles = tempFilePaths.map((path) => File(path)).toList();
    if (logFilePath != null) {
      final logFileName =
          '${DateTime.now().toString().substring(0, 19).replaceAll(':', '').replaceAll(' ', '-')}-$name.log';
      _logFile = File('$logFilePath/$logFileName');
      if (!_logFile.existsSync()) {
        _logFile.createSync(recursive: true);
      }
    }
  }

  void _deleteOutputFile() {
    if (_outputFile.existsSync()) {
      _outputFile.deleteSync();
    }
  }

  void _deleteTempFiles() {
    for (var file in _tempFiles) {
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
  }

  void _cleanUp() {
    _deleteTempFiles();
    _deleteOutputFile();
  }

  void cancel() {
    status.value = VideoProcessStatus.canceled;
    _cancelWatchDog();
    _process?.kill();
    completer.complete();
    _cleanUp();
    Toast.warning('$name canceled');
  }

  Future<void> process() async {
    LogService.info('Start processing $name');
    status.value = VideoProcessStatus.processing;
    if (kDebugMode) {
      print('ffmpegArgs: $ffmpegArgs');
    }
    _process = await Process.start(
      FFmpegUtils.ffmpeg,
      ffmpegArgs,
    );
    _process?.stdout.transform(utf8.decoder).listen((data) {
      _processStdoutData(data);
    });
    _process?.stderr.transform(utf8.decoder).listen((data) {
      _processStdoutData(data);
    });
    _process?.exitCode.then((exitCode) {
      _cancelWatchDog();
      if (status.value == VideoProcessStatus.canceled) {
        _cleanUp();
      } else if (exitCode == 0) {
        status.value = VideoProcessStatus.finished;
        Toast.success('$name finished');
      } else {
        status.value = VideoProcessStatus.failed;
        Toast.error('$name failed');
        LogService.warning('$name failed with exit code $exitCode');
        _cleanUp();
      }
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    return completer.future;
  }

  void _appendToFile(String logMessage) {
    try {
      if (!_stopLogging) {
        _logFile.writeAsStringSync(logMessage, mode: FileMode.append);
      }
    } catch (e) {
      _stopLogging = true;
      LogService.warning('Failed to write log to ${_logFile.path}: $e');
    }
  }

  void _processStdoutData(String data) {
    _resetWatchDog();
    _appendToFile(data);
    if (kDebugMode) {
      print(data);
    }
    final time = _extractTimeInSeconds(data);
    if (time > 0) {
      progress.value = time / duration.inSeconds;
    }
  }

  void _startWatchDog() {
    _heartbeatTimer = Timer(const Duration(seconds: 15), () {
      _process?.kill();
      status.value = VideoProcessStatus.failed;
    });
  }

  void _resetWatchDog() {
    _cancelWatchDog();
    _startWatchDog();
  }

  void _cancelWatchDog() {
    _heartbeatTimer?.cancel();
  }

  double _extractTimeInSeconds(String logLine) {
    if (logLine.contains('encoded')) {
      return duration.inSeconds.toDouble();
    }
    // 正则表达式匹配时间字段
    RegExp regex = RegExp(r'time=([-+\d:]+.\d+)');
    final match = regex.firstMatch(logLine);
    if (match != null) {
      String timeString = match.group(1)!;
      return _parseTimeToSeconds(timeString);
    } else {
      return 0.0;
    }
  }

  double _parseTimeToSeconds(String timeString) {
    // 匹配时间格式: -HH:MM:SS.sss 或 +HH:MM:SS.sss
    RegExp regex = RegExp(r'([-+]?)(\d+):(\d+):(\d+.\d+)');
    final match = regex.firstMatch(timeString);
    if (match != null) {
      String sign = match.group(1)!;
      int hours = int.parse(match.group(2)!);
      int minutes = int.parse(match.group(3)!);
      double seconds = double.parse(match.group(4)!);

      double totalSeconds = hours * 3600 + minutes * 60 + seconds;
      if (sign == '-') {
        totalSeconds = -totalSeconds;
      }
      if (totalSeconds < 0) {
        return 0.0;
      }
      return totalSeconds;
    } else {
      return 0.0;
    }
  }
}

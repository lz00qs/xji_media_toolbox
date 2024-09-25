import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

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
  final String ffmpegParentDir;
  final String outputFilePath;
  final List<String> tempFilePaths;
  final completer = Completer<void>();
  Timer? _heartbeatTimer;
  late File _outputFile;
  late List<File> _tempFiles;
  Process? _process;

  VideoProcess(
      {required this.name,
      required this.type,
      required this.ffmpegArgs,
      required this.duration,
      required this.ffmpegParentDir,
      required this.outputFilePath,
      this.tempFilePaths = const []}) {
    _outputFile = File(outputFilePath);
    _tempFiles = tempFilePaths.map((path) => File(path)).toList();
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
  }

  Future<void> process() async {
    status.value = VideoProcessStatus.processing;
    _process = await Process.start(
      '$ffmpegParentDir/ffmpeg',
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
      } else {
        status.value = VideoProcessStatus.failed;
        _cleanUp();
      }
      if (kDebugMode) {
        print('exit code: $exitCode');
      }
      if (!completer.isCompleted) {
        completer.complete();
      }
      _cleanUp();
    });
    return completer.future;
  }

  void _processStdoutData(String data) {
    _resetWatchDog();
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

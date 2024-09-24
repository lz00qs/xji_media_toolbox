import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:get/get.dart';

import '../utils/media_resources_utils.dart';

enum VideoProcessType {
  transcode,
  trim,
  merge,
}

enum VideoProcessStatus {
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
  final Rx<VideoProcessStatus> status = VideoProcessStatus.processing.obs;
  final String ffmpegParentDir;
  final String outputFilePath;
  final List<String> tempFilePaths;
  Isolate? _isolate;
  Timer? _heartbeatTimer;
  late File _outputFile;
  late List<File> _tempFiles;
  late SendPort _sendPort;

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

  void _killProcess() {
    _sendPort.send('kill');
    _isolate = null;
  }

  void cancel() {
    status.value = VideoProcessStatus.canceled;
    _killProcess();
    _heartbeatTimer?.cancel();
    _cleanUp();
  }

  void _startWatchDog() {
    _heartbeatTimer = Timer(const Duration(seconds: 15), () {
      _killProcess();
      status.value = VideoProcessStatus.failed;
    });
  }

  Future<void> start() async {
    final receivePort = ReceivePort();

    receivePort.listen((message) {
      if (status.value == VideoProcessStatus.processing) {
        if (message is String) {
          _heartbeatTimer?.cancel();
          if (message.contains('failed')) {
            status.value = VideoProcessStatus.failed;
            receivePort.close();
            _isolate = null;
            _cleanUp();
          } else if (message.contains('finished')) {
            status.value = VideoProcessStatus.finished;
            progress.value = 1.0;
            receivePort.close();
            _isolate = null;
          } else {
            final time = _extractTimeInSeconds(message);
            progress.value = time / duration.inSeconds;
          }
        } else if (message is SendPort) {
          _sendPort = message;
        }
        if (_isolate != null) {
          _startWatchDog();
        }
      } else {
        receivePort.close();
      }
    });
    _isolate = await Isolate.spawn(_ffmpegProcess, [
      [
        [ffmpegParentDir],
        ffmpegArgs,
        tempFilePaths,
      ],
      receivePort.sendPort
    ]);
  }

  Future<void> _ffmpegProcess(List<dynamic> args) async {
    final pathList = args[0] as List<List<String>>;
    final needDeleteFilePaths = pathList[2];
    final ffmpegParentDirIsolate = pathList[0][0];
    late Process process;
    final sendPort = args[1] as SendPort;
    final receivePort = ReceivePort();

    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      if (message == 'kill') {
        process.kill();
        receivePort.close();
      }
    });

    process =
        await Process.start('$ffmpegParentDirIsolate/ffmpeg', pathList[1]);

    process.stdout.transform(utf8.decoder).listen((data) {
      sendPort.send(data);
    });
    process.stderr.transform(utf8.decoder).listen((data) {
      sendPort.send(data);
    });
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      sendPort.send('failed');
    } else {
      sendPort.send('finished');
    }
    for (final filePath in needDeleteFilePaths) {
      if (isFileExist(filePath)) {
        File(filePath).deleteSync();
      }
    }
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

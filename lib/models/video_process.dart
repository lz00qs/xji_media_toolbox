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
  final double duration;
  final List<String> outPutFiles = [];
  Isolate? _isolate;
  final RxDouble progress = 0.0.obs;
  final Rx<VideoProcessStatus> status = VideoProcessStatus.processing.obs;

  VideoProcess(
      {required this.name, required this.type, required this.duration});

  void cancel() {
    if (_isolate != null) {
      _isolate!.kill(priority: Isolate.immediate);
    }
    _isolate = null;
    try {
      for (final file in outPutFiles) {
        if (isFileExist(file)) {
          File(file).deleteSync();
        }
      }
    } finally {}
    status.value = VideoProcessStatus.canceled;
  }

  Future<void> start(List<String> ffmpegArgs,
      {List<String> needDeleteFilePaths = const []}) async {
    final receivePort = ReceivePort();
    receivePort.listen((message) {
      if (message is String) {
        if (message.contains('failed')) {
          status.value = VideoProcessStatus.failed;
          receivePort.close();
          _isolate = null;
        } else if (message.contains('finished')) {
          status.value = VideoProcessStatus.finished;
          progress.value = 1.0;
          receivePort.close();
          _isolate = null;
        } else {
          final time = _extractTimeInSeconds(message);
          progress.value = time / duration;
        }
      }
    });

    _isolate = await Isolate.spawn(_ffmpegProcess, [
      [ffmpegArgs, needDeleteFilePaths],
      receivePort.sendPort
    ]);
  }

  Future<void> _ffmpegProcess(List<dynamic> args) async {
    final argsList = args[0] as List<List<String>>;
    final process = await Process.start('ffmpeg', argsList[0]);
    final needDeleteFilePaths = argsList[1];
    process.stdout.transform(utf8.decoder).listen((data) {
      (args[1] as SendPort).send(data);
    });
    process.stderr.transform(utf8.decoder).listen((data) {
      (args[1] as SendPort).send(data);
    });
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      (args[1] as SendPort).send('failed');
    } else {
      (args[1] as SendPort).send('finished');
    }
    for (final filePath in needDeleteFilePaths) {
      if (isFileExist(filePath)) {
        File(filePath).deleteSync();
      }
    }
  }

  double _extractTimeInSeconds(String logLine) {
    if (logLine.contains('encoded')) {
      return duration;
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

  String getTypeString() {
    switch (type) {
      case VideoProcessType.transcode:
        return 'Transcode';
      case VideoProcessType.trim:
        return 'Trim';
      case VideoProcessType.merge:
        return 'Merge';
    }
  }
}

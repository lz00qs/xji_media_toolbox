import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:get/get.dart';
import 'package:xji_footage_toolbox/settings.dart';

enum VideoProcessingType {
  transcode,
  cut,
}

enum VideoProcessingStatus {
  processing,
  finished,
  canceled,
  failed,
}

abstract class VideoProcess {
  final RxDouble progress = 0.0.obs;
  final Rx<VideoProcessingStatus> status = VideoProcessingStatus.processing.obs;
  final VideoProcessingType type;
  String name = '';

  VideoProcess({required this.type});

  Future<void> start();

  void cancel() {
    status.value = VideoProcessingStatus.canceled;
  }

  String getTypeString() {
    switch (type) {
      case VideoProcessingType.transcode:
        return 'Transcode';
      case VideoProcessingType.cut:
        return 'Cut';
    }
  }
}

class VideoTranscodeProcess extends VideoProcess {
  final TransCodePreset preset;
  final String inputFilePath;
  final String outputFilePath;
  final double duration;
  Isolate? _isolate;

  VideoTranscodeProcess(
      {required super.type,
      required this.inputFilePath,
      required this.outputFilePath,
      required this.duration,
      required this.preset}) {
    final inputFileName = inputFilePath.split('/').last;
    final outputFileName = outputFilePath.split('/').last;
    name = 'Transcode $inputFileName to $outputFileName';
  }

  @override
  void cancel() {
    super.cancel();
    if (_isolate != null) {
      _isolate!.kill(priority: Isolate.immediate);
    }
    _isolate = null;
    try {
      File(outputFilePath).deleteSync();
    } finally {}
    status.value = VideoProcessingStatus.canceled;
  }

  @override
  Future<void> start() async {
    final receivePort = ReceivePort();
    final List<String> args = [
      '-i',
      inputFilePath,
      '-c:v',
      preset.useHevc ? 'libx265' : 'libx264',
      '-crf',
      preset.crf.toString(),
      '-preset',
      'ultrafast',
      '-vf',
      'scale=${preset.width}:${preset.height}',
      outputFilePath,
    ];
    receivePort.listen((message) {
      if (message is String) {
        if (message.contains('failed')) {
          status.value = VideoProcessingStatus.failed;
          receivePort.close();
          _isolate = null;
        } else {
          final time = _extractTimeInSeconds(message);
          progress.value = time / duration;
          if (progress.value == 1.0) {
            status.value = VideoProcessingStatus.finished;
            receivePort.close();
          }
          // print(message);
        }
      }
    });
    // await compute(_ffmpegTranscodeVideo, [args, receivePort.sendPort]);
    _isolate = await Isolate.spawn(
        _ffmpegTranscodeVideo, [args, receivePort.sendPort]);
  }

  Future<void> _ffmpegTranscodeVideo(List<dynamic> args) async {
    final process = await Process.start('ffmpeg', args[0] as List<String>);
    process.stdout.transform(utf8.decoder).listen((data) {
      (args[1] as SendPort).send(data);
    });
    process.stderr.transform(utf8.decoder).listen((data) {
      (args[1] as SendPort).send(data);
    });
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      (args[1] as SendPort).send('failed');
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
}

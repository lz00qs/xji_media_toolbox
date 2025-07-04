import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/service/log_service.dart';
import 'package:xji_footage_toolbox/utils/ffmpeg_utils.dart';
import 'package:xji_footage_toolbox/utils/toast.dart';

part 'video_task.freezed.dart';

enum VideoTaskType {
  transcode,
  trim,
  merge,
}

enum VideoTaskStatus {
  waiting,
  processing,
  finished,
  canceled,
  failed,
}

class VideoTask {
  final String name;
  final VideoTaskType type;
  final List<String> ffmpegArgs;
  final Duration duration;
  final RxDouble progress = 0.0.obs;
  final Rx<VideoTaskStatus> status = VideoTaskStatus.waiting.obs;
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

  VideoTask(
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
    status.value = VideoTaskStatus.canceled;
    _cancelWatchDog();
    _process?.kill();
    completer.complete();
    _cleanUp();
    Toast.warning('$name canceled');
  }

  Future<void> process() async {
    LogService.info('Start processing $name');
    status.value = VideoTaskStatus.processing;
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
      if (status.value == VideoTaskStatus.canceled) {
        _cleanUp();
      } else if (exitCode == 0) {
        status.value = VideoTaskStatus.finished;
        Toast.success('$name finished');
      } else {
        status.value = VideoTaskStatus.failed;
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
    final time = _extractTimeInSeconds(data);
    if (time > 0) {
      progress.value = time / duration.inSeconds;
    }
  }

  void _startWatchDog() {
    _heartbeatTimer = Timer(const Duration(seconds: 15), () {
      _process?.kill();
      status.value = VideoTaskStatus.failed;
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

@freezed
class Tasks with _$Tasks {
  Tasks({required this.totalTasks, required this.waitingTasks});

  @override
  final List<VideoTask> totalTasks;
  @override
  final List<VideoTask> waitingTasks;

  factory Tasks.initial() => Tasks(totalTasks: [], waitingTasks: []);
}

final tasksProvider = StateNotifierProvider<TaskProvider, Tasks>((ref) {
  return TaskProvider();
});
class TaskProvider extends StateNotifier<Tasks> {
  TaskProvider() : super(Tasks.initial());

  var _isProcessing = false;

  Future<void> addTask(VideoTask task) async {
    state = state.copyWith(
        waitingTasks: [...state.waitingTasks, task],
        totalTasks: [...state.totalTasks, task]);
    await _process();
  }

  Future<void> _process() async {
    if (_isProcessing) {
      return;
    }
    _isProcessing = true;
    while (state.waitingTasks.isNotEmpty) {
      final task = state.waitingTasks.first;
      state = state.copyWith(waitingTasks: state.waitingTasks.sublist(1));
      await task.process();
    }
    _isProcessing = false;
  }
}

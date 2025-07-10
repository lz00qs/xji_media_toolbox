import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
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

var _isCanceled = false;

@freezed
class VideoTask with _$VideoTask {
  @override
  final String name;
  @override
  final VideoTaskStatus status;
  @override
  final VideoTaskType type;
  @override
  final List<String> ffmpegArgs;
  @override
  final Duration duration;
  @override
  final double progress;
  @override
  final File outputFile;
  @override
  final List<File> tempFiles;
  @override
  final File? logFile;
  @override
  final Duration eta;
  @override
  final Process? process;

  VideoTask({
    required this.name,
    required this.status,
    required this.type,
    required this.ffmpegArgs,
    required this.duration,
    required this.progress,
    required this.outputFile,
    required this.tempFiles,
    required this.eta,
    this.logFile,
    this.process,
  });

  void cancel() {
    process?.kill();
    _isCanceled = true;
    for (var file in tempFiles) {
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    if (outputFile.existsSync()) {
      outputFile.deleteSync();
    }
  }
}

final taskManagerProvider =
    StateNotifierProvider<TaskManagerProvider, List<VideoTask>>(
        (ref) => TaskManagerProvider([]));

class TaskManagerProvider extends StateNotifier<List<VideoTask>> {
  var _isProcessing = false;

  TaskManagerProvider(super.state);

  Future<void> addTask(VideoTask task) async {
    state = state..add(task);
    await _process();
  }

  Future<void> _process() async {
    if (_isProcessing) {
      return;
    }
    _isProcessing = true;
    for (int i = 0; i < state.length; i++) {
      var task = state[i];
      if (task.status == VideoTaskStatus.waiting) {
        _isCanceled = false;
        state = state
            .map((element) => element.copyWith(
                status: element == task
                    ? VideoTaskStatus.processing
                    : element.status))
            .toList();
        task = state[i];
        final process =
            await Process.start(FFmpegUtils.ffmpeg, task.ffmpegArgs);
        state = state
            .map((element) => element.copyWith(
                process: element == task ? process : element.process))
            .toList();
        task = state[i];
        process.stdout.transform(utf8.decoder).listen((data) {
          _appendToLogFile(task.logFile, data);
          _processStdoutData(data, i);
        });
        process.stderr.transform(utf8.decoder).listen((data) {
          _appendToLogFile(task.logFile, data);
          _processStdoutData(data, i);
        });
        await process.exitCode.then((exitCode) {
          task = state[i];
          if (exitCode == 0) {
            _deleteTempFiles(task);
            state = state
                .map((element) => element.copyWith(
                    status: element == task
                        ? VideoTaskStatus.finished
                        : element.status,
                    progress: element == task ? 1.0 : element.progress))
                .toList();
            Toast.success('${task.name} finished');
          } else {
            _deleteTempFiles(task);
            _deleteOutputFile(task);
            if (_isCanceled == true) {
              state = state
                  .map((element) => element.copyWith(
                      status: element == task
                          ? VideoTaskStatus.canceled
                          : element.status))
                  .toList();
              task = state[i];
              Toast.warning('${task.name} canceled');
            } else {
              state = state
                  .map((element) => element.copyWith(
                      status: element == task
                          ? VideoTaskStatus.failed
                          : element.status))
                  .toList();
              task = state[i];
              Toast.error('${task.name} failed');
            }
          }
        });
      }
    }
    _isProcessing = false;
  }

  void _appendToLogFile(File? logFile, String logMessage) {
    if (logFile != null) {
      try {
        if (!logFile.existsSync()) {
          logFile.createSync(recursive: true);
        }
        logFile.writeAsStringSync(logMessage, mode: FileMode.append);
      } catch (e) {
        LogService.warning('Failed to write log to ${logFile.path}: $e');
      }
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

  double _extractTimeInSeconds(String logLine, VideoTask task) {
    if (logLine.contains('encoded')) {
      return task.duration.inSeconds.toDouble();
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

  double _parseSpeed(String logLine) {
    final regex = RegExp(r'speed=([0-9.]+)x');
    final match = regex.firstMatch(logLine);
    if (match != null) {
      try {
        return double.parse(match.group(1)!);
      } catch (e) {
        return 0.0;
      }
    } else {
      return 0.0;
    }
  }

  void _processStdoutData(String logLine, int index) {
    final task = state[index];
    final time = _extractTimeInSeconds(logLine, task);
    final speed = _parseSpeed(logLine);
    var progress = task.progress;
    LogService.info(logLine);
    if (time > 0) {
      progress = time / task.duration.inSeconds;
    }
    var eta = Duration();
    if (speed > 0) {
      eta =
          Duration(seconds: ((task.duration.inSeconds - time) / speed).round());
    }
    state = state
        .map((element) => element.copyWith(
            progress: element == task ? progress : element.progress,
            eta: element == task ? eta : element.eta))
        .toList();
  }

  void _deleteTempFiles(VideoTask task) {
    for (var file in task.tempFiles) {
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
  }

  void _deleteOutputFile(VideoTask task) {
    if (task.outputFile.existsSync()) {
      task.outputFile.deleteSync();
    }
  }
}

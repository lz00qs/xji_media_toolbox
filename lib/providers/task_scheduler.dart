import 'dart:async';
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:xji_footage_toolbox/models/video_task.dart';
import 'package:xji_footage_toolbox/utils/ffmpeg_utils.dart';
import 'package:xji_footage_toolbox/utils/logger.dart';

part 'task_scheduler.g.dart';

@Riverpod(keepAlive: true)
class TaskSchedulerNotifier extends _$TaskSchedulerNotifier {
  Process? _currentProcess;
  bool _isRunning = false;

  @override
  List<VideoTask> build() => [];

  // 添加任务
  void addTask(VideoTask task) {
    state = [...state, task.copyWith(id: const Uuid().v4())];
    _tryStartNext();
  }

  void _updateTask(String id, VideoTask Function(VideoTask) updater) {
    state = [
      for (final t in state)
        if (t.id == id) updater(t) else t,
    ];
  }

  // 只允许一个任务运行
  Future<void> _tryStartNext() async {
    if (_isRunning) return;

    final next = state.firstWhere(
      (t) => t.status == VideoTaskStatus.waiting,
      orElse: () => VideoTask(),
    );

    if (next.id.isEmpty) return;

    _isRunning = true;
    _runTask(next);
  }

  Future<void> _runTask(VideoTask task) async {
    _updateTask(task.id, (t) => t.copyWith(status: VideoTaskStatus.processing));

    try {
      final process = await Process.start(
        FFmpegUtils.ffmpeg,
        task.ffmpegArgs,
      );

      _currentProcess = process;

      _listenProgress(task.id, process);

      final exitCode = await process.exitCode;

      if (exitCode == 0) {
        _updateTask(task.id,
            (t) => t.copyWith(status: VideoTaskStatus.finished, progress: 1));
      } else {
        if (!(state.firstWhere((e) => e.id == task.id).status ==
            VideoTaskStatus.canceled)) {
          _updateTask(
              task.id, (t) => t.copyWith(status: VideoTaskStatus.failed));
        }
        await _cleanupFiles(task);
      }
    } catch (e) {
      _updateTask(task.id, (t) => t.copyWith(status: VideoTaskStatus.failed));
      await _cleanupFiles(task);
    } finally {
      _currentProcess = null;
      _isRunning = false;
      _tryStartNext();
    }
  }

  // 取消任务
  Future<void> cancelTask(String id) async {
    final task = state.firstWhere((t) => t.id == id, orElse: () => VideoTask());
    if (task.id.isEmpty) return;

    if (task.status == VideoTaskStatus.processing) {
      _currentProcess?.kill(ProcessSignal.sigint);
    }

    await _cleanupFiles(task);

    _updateTask(id, (t) => t.copyWith(status: VideoTaskStatus.canceled));
  }

  // 重新执行（移到队尾）
  void rerunTask(String id) {
    final task = state.firstWhere((t) => t.id == id, orElse: () => VideoTask());
    if (task.id.isEmpty) return;

    final updated = task.copyWith(
      status: VideoTaskStatus.waiting,
      progress: 0,
      eta: Duration.zero,
    );

    state = [
      for (final t in state)
        if (t.id != id) t,
      updated,
    ];

    _tryStartNext();
  }

  // 解析 FFmpeg 输出（示例）
  void _listenProgress(String taskId, Process process) {
    process.stderr.transform(SystemEncoding().decoder).listen((line) {
      Logger.debug(line);
      _appendToLogFile(state.firstWhere((t) => t.id == taskId).logPath, line);

      if (line.contains('encoded')) {
        _updateTask(
            taskId, (t) => t.copyWith(progress: 1.0, eta: Duration.zero));
      } else {
        RegExp regex = RegExp(r'([-+]?)(\d+):(\d+):(\d+.\d+)');
        final timeMatch = regex.firstMatch(line);
        if (timeMatch != null) {
          try {
            String sign = timeMatch.group(1)!;
            int hours = int.parse(timeMatch.group(2)!);
            int minutes = int.parse(timeMatch.group(3)!);
            double seconds = double.parse(timeMatch.group(4)!);

            double totalSeconds = hours * 3600 + minutes * 60 + seconds;
            if (sign == '-') {
              totalSeconds = -totalSeconds;
            }
            if (totalSeconds < 0) {
              totalSeconds = 0.0;
            }
            final double progress = (totalSeconds /
                    (state
                        .firstWhere((t) => t.id == taskId)
                        .duration
                        .inSeconds))
                .clamp(0, 1.0);
            _updateTask(taskId, (t) => t.copyWith(progress: progress));
            regex = RegExp(r'speed=([0-9.]+)x');
            final speedMatch = regex.firstMatch(line);
            if (speedMatch != null) {
              final double speed = double.parse(speedMatch.group(1)!);
              final Duration eta = Duration(
                  seconds: ((state
                                  .firstWhere((t) => t.id == taskId)
                                  .duration
                                  .inSeconds -
                              totalSeconds) /
                          speed)
                      .round());
              _updateTask(taskId, (t) => t.copyWith(eta: eta));
            }
          } catch (_) {}
        }
      }
    });
  }
}

void _appendToLogFile(String logPath, String logMessage) {
  try {
    final logFile = File(logPath);
    if (!logFile.existsSync()) {
      logFile.createSync(recursive: true);
    }
    logFile.writeAsStringSync(logMessage, mode: FileMode.append);
  } catch (e) {
    // LogService.warning('Failed to write log to ${logFile.path}: $e');
    Logger.warn('Failed to write log to $logPath: $e');
  }
}

Future<void> _cleanupFiles(VideoTask task) async {
  try {
    final outputFile = File(task.outputPath);
    if (await outputFile.exists()) {
      await outputFile.delete();
    }
  } catch (_) {}

  // try {
  //   final logFile = File(task.logPath);
  //   if (await logFile.exists()) {
  //     await logFile.delete();
  //   }
  // } catch (_) {}

  try {
    for (final tempFilePath in task.tempFilePaths) {
      final tempFile = File(tempFilePath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  } catch (_) {}
}

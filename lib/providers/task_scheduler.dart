import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/models/video_task.dart';
import 'package:xji_footage_toolbox/utils/ffmpeg_utils.dart';
import 'package:xji_footage_toolbox/utils/logger.dart';

part 'task_scheduler.g.dart';

abstract interface class TaskProcess {
  Stream<List<int>> get stderr;
  Future<int> get exitCode;
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]);
}

typedef TaskProcessStarter =
    Future<TaskProcess> Function(String executable, List<String> arguments);
typedef TaskLogWriter = void Function(String path, String message);
typedef TaskFileCleaner = Future<void> Function(VideoTask task);

final class TaskSchedulerDependencies {
  const TaskSchedulerDependencies({
    required this.ffmpegPath,
    required this.startProcess,
    required this.writeLog,
    required this.cleanFiles,
  });

  factory TaskSchedulerDependencies.production() {
    return TaskSchedulerDependencies(
      ffmpegPath: FFmpegUtils.ffmpeg,
      startProcess: (executable, arguments) async =>
          _IoTaskProcess(await Process.start(executable, arguments)),
      writeLog: appendTaskLog,
      cleanFiles: cleanTaskFiles,
    );
  }

  final String ffmpegPath;
  final TaskProcessStarter startProcess;
  final TaskLogWriter writeLog;
  final TaskFileCleaner cleanFiles;
}

final class _IoTaskProcess implements TaskProcess {
  const _IoTaskProcess(this._process);

  final Process _process;

  @override
  Stream<List<int>> get stderr => _process.stderr;

  @override
  Future<int> get exitCode => _process.exitCode;

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    return _process.kill(signal);
  }
}

@Riverpod(keepAlive: true)
class TaskSchedulerNotifier extends _$TaskSchedulerNotifier {
  TaskSchedulerNotifier({
    TaskSchedulerDependencies? dependencies,
    this.initialTasks = const [],
  }) : _dependencies = dependencies ?? TaskSchedulerDependencies.production();

  final TaskSchedulerDependencies _dependencies;
  final List<VideoTask> initialTasks;
  TaskProcess? _currentProcess;
  bool _isRunning = false;

  @override
  List<VideoTask> build() => List.unmodifiable(initialTasks);

  void addTask(VideoTask task) {
    if (task.id.isEmpty || state.any((item) => item.id == task.id)) return;
    state = [...state, task];
    _tryStartNext();
  }

  void _updateTask(String id, VideoTask Function(VideoTask) updater) {
    state = [
      for (final task in state)
        if (task.id == id) updater(task) else task,
    ];
  }

  VideoTask? _taskById(String id) {
    for (final task in state) {
      if (task.id == id) return task;
    }
    return null;
  }

  void _tryStartNext() {
    if (_isRunning) return;

    VideoTask? next;
    for (final task in state) {
      if (task.status == VideoTaskStatus.waiting) {
        next = task;
        break;
      }
    }
    if (next == null) return;

    _isRunning = true;
    unawaited(_runTask(next));
  }

  Future<void> _runTask(VideoTask task) async {
    _updateTask(task.id, (item) {
      return item.copyWith(status: VideoTaskStatus.processing);
    });

    try {
      final process = await _dependencies.startProcess(
        _dependencies.ffmpegPath,
        task.ffmpegArgs,
      );
      _currentProcess = process;
      if (_taskById(task.id)?.status == VideoTaskStatus.canceled) {
        process.kill(ProcessSignal.sigint);
      }
      _listenProgress(task.id, process);

      final exitCode = await process.exitCode;
      final currentTask = _taskById(task.id);
      if (currentTask?.status == VideoTaskStatus.canceled) return;

      if (exitCode == 0) {
        _updateTask(task.id, (item) {
          return item.copyWith(
            status: VideoTaskStatus.finished,
            progress: 1,
            eta: Duration.zero,
          );
        });
      } else {
        _updateTask(task.id, (item) {
          return item.copyWith(status: VideoTaskStatus.failed);
        });
        await _dependencies.cleanFiles(task);
      }
    } catch (_) {
      if (_taskById(task.id)?.status != VideoTaskStatus.canceled) {
        _updateTask(task.id, (item) {
          return item.copyWith(status: VideoTaskStatus.failed);
        });
        await _dependencies.cleanFiles(task);
      }
    } finally {
      _currentProcess = null;
      _isRunning = false;
      _tryStartNext();
    }
  }

  Future<void> cancelTask(String id) async {
    final task = _taskById(id);
    if (task == null ||
        task.status == VideoTaskStatus.finished ||
        task.status == VideoTaskStatus.canceled) {
      return;
    }

    _updateTask(id, (item) {
      return item.copyWith(
        status: VideoTaskStatus.canceled,
        eta: Duration.zero,
      );
    });
    if (task.status == VideoTaskStatus.processing) {
      _currentProcess?.kill(ProcessSignal.sigint);
    }
    await _dependencies.cleanFiles(task);
  }

  void rerunTask(String id) {
    final task = _taskById(id);
    if (task == null || task.status == VideoTaskStatus.processing) return;

    final updated = task.copyWith(
      status: VideoTaskStatus.waiting,
      progress: 0,
      eta: Duration.zero,
    );
    state = [
      for (final item in state)
        if (item.id != id) item,
      updated,
    ];
    _tryStartNext();
  }

  void _listenProgress(String taskId, TaskProcess process) {
    process.stderr
        .transform(const SystemEncoding().decoder)
        .transform(const LineSplitter())
        .listen((line) {
          Logger.debug(line);
          final task = _taskById(taskId);
          if (task == null) return;
          if (task.logPath.isNotEmpty) {
            _dependencies.writeLog(task.logPath, '$line\n');
          }

          if (line.contains('encoded')) {
            _updateTask(taskId, (item) {
              return item.copyWith(progress: 1, eta: Duration.zero);
            });
            return;
          }

          final timeMatch = RegExp(
            r'([-+]?)(\d+):(\d+):(\d+(?:\.\d+)?)',
          ).firstMatch(line);
          final durationSeconds = task.duration.inMilliseconds / 1000;
          if (timeMatch == null || durationSeconds <= 0) return;

          try {
            final sign = timeMatch.group(1)!;
            final hours = int.parse(timeMatch.group(2)!);
            final minutes = int.parse(timeMatch.group(3)!);
            final seconds = double.parse(timeMatch.group(4)!);
            var totalSeconds = hours * 3600 + minutes * 60 + seconds;
            if (sign == '-') totalSeconds = -totalSeconds;
            totalSeconds = totalSeconds.clamp(0, durationSeconds);
            final progress = (totalSeconds / durationSeconds).clamp(0.0, 1.0);
            _updateTask(taskId, (item) => item.copyWith(progress: progress));

            final speedMatch = RegExp(
              r'speed=\s*(\d+(?:\.\d+)?)x',
            ).firstMatch(line);
            if (speedMatch == null) return;
            final speed = double.parse(speedMatch.group(1)!);
            if (speed <= 0) return;
            final etaSeconds = ((durationSeconds - totalSeconds) / speed)
                .round()
                .clamp(0, task.duration.inSeconds);
            _updateTask(taskId, (item) {
              return item.copyWith(eta: Duration(seconds: etaSeconds));
            });
          } on FormatException {
            // Ignore malformed progress lines and continue consuming stderr.
          }
        });
  }
}

void appendTaskLog(String logPath, String logMessage) {
  if (logPath.isEmpty) return;
  try {
    final logFile = File(logPath);
    if (!logFile.existsSync()) {
      logFile.createSync(recursive: true);
    }
    logFile.writeAsStringSync(logMessage, mode: FileMode.append);
  } catch (error) {
    Logger.warn('Failed to write log to $logPath: $error');
  }
}

Future<void> cleanTaskFiles(VideoTask task) async {
  try {
    final outputFile = File(task.outputPath);
    if (task.outputPath.isNotEmpty && await outputFile.exists()) {
      await outputFile.delete();
    }
  } catch (_) {}

  for (final tempFilePath in task.tempFilePaths) {
    try {
      final tempFile = File(tempFilePath);
      if (await tempFile.exists()) await tempFile.delete();
    } catch (_) {}
  }
}

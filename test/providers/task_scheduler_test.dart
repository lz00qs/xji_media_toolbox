import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:xji_footage_toolbox/models/video_task.dart';
import 'package:xji_footage_toolbox/providers/task_scheduler.dart';

import '../helpers/test_environment.dart';

void main() {
  late Directory temporaryDirectory;

  setUp(() async {
    temporaryDirectory = await createTestDirectory('task-scheduler-test');
  });

  tearDown(() => deleteTestDirectory(temporaryDirectory));

  test('runs queued tasks serially and completes them in order', () async {
    final firstProcess = FakeTaskProcess();
    final secondProcess = FakeTaskProcess();
    final harness = SchedulerHarness([firstProcess, secondProcess]);
    final container = harness.container();
    addTearDown(container.dispose);
    final notifier = container.read(taskSchedulerProvider.notifier);

    notifier.addTask(task('first'));
    notifier.addTask(task('second'));
    await flushEvents();

    expect(harness.startedIds, ['first']);
    expect(statuses(container), [
      VideoTaskStatus.processing,
      VideoTaskStatus.waiting,
    ]);

    await firstProcess.complete(0);
    await flushEvents();
    expect(harness.startedIds, ['first', 'second']);
    expect(statuses(container), [
      VideoTaskStatus.finished,
      VideoTaskStatus.processing,
    ]);

    await secondProcess.complete(0);
    await flushEvents();
    expect(statuses(container), [
      VideoTaskStatus.finished,
      VideoTaskStatus.finished,
    ]);
    expect(container.read(taskSchedulerProvider).last.progress, 1);
  });

  test('parses progress and ETA and records complete stderr lines', () async {
    final process = FakeTaskProcess();
    final harness = SchedulerHarness([process]);
    final container = harness.container();
    addTearDown(container.dispose);

    container
        .read(taskSchedulerProvider.notifier)
        .addTask(
          task(
            'progress',
            duration: const Duration(seconds: 100),
            hasLog: true,
          ),
        );
    await flushEvents();
    process.emit('frame=10 time=00:00:25.00 speed=2.0x\n');
    await flushEvents();

    var current = container.read(taskSchedulerProvider).single;
    expect(current.progress, closeTo(0.25, 0.001));
    expect(current.eta, const Duration(seconds: 38));
    expect(harness.logs.single.$1, 'progress.log');
    expect(harness.logs.single.$2, contains('time=00:00:25.00'));

    process.emit('encoded 100 frames\n');
    await flushEvents();
    current = container.read(taskSchedulerProvider).single;
    expect(current.progress, 1);
    expect(current.eta, Duration.zero);
    await process.complete(0);
  });

  test(
    'allows ETA to exceed media duration for slower-than-real-time work',
    () async {
      final process = FakeTaskProcess();
      final harness = SchedulerHarness([process]);
      final container = harness.container();
      addTearDown(container.dispose);

      container
          .read(taskSchedulerProvider.notifier)
          .addTask(
            task(
              'slow-progress',
              duration: const Duration(milliseconds: 19390),
            ),
          );
      await flushEvents();
      process.emit('frame=70 time=00:00:01.39 speed=0.05x\n');
      await flushEvents();

      final current = container.read(taskSchedulerProvider).single;
      expect(current.eta, const Duration(minutes: 6));
      await process.complete(0);
    },
  );

  test('ignores malformed, zero-duration, and zero-speed progress', () async {
    final process = FakeTaskProcess();
    final harness = SchedulerHarness([process]);
    final container = harness.container();
    addTearDown(container.dispose);

    container.read(taskSchedulerProvider.notifier).addTask(task('zero'));
    await flushEvents();
    process.emit('time=00:00:10.00 speed=0x\nnot progress\n');
    await flushEvents();

    final current = container.read(taskSchedulerProvider).single;
    expect(current.progress, 0);
    expect(current.eta, Duration.zero);
    await process.complete(0);
  });

  test('marks non-zero exits failed, cleans files, and starts next', () async {
    final firstProcess = FakeTaskProcess();
    final secondProcess = FakeTaskProcess();
    final harness = SchedulerHarness([firstProcess, secondProcess]);
    final container = harness.container();
    addTearDown(container.dispose);
    final notifier = container.read(taskSchedulerProvider.notifier);

    notifier.addTask(task('failure'));
    notifier.addTask(task('next'));
    await flushEvents();
    await firstProcess.complete(2);
    await flushEvents();

    expect(harness.cleanedIds, ['failure']);
    expect(statuses(container), [
      VideoTaskStatus.failed,
      VideoTaskStatus.processing,
    ]);
    await secondProcess.complete(0);
  });

  test('handles process-start exceptions and continues the queue', () async {
    final nextProcess = FakeTaskProcess();
    final harness = SchedulerHarness(
      [nextProcess],
      startErrors: [const ProcessException('fake-ffmpeg', [])],
    );
    final container = harness.container();
    addTearDown(container.dispose);
    final notifier = container.read(taskSchedulerProvider.notifier);

    notifier.addTask(task('broken'));
    notifier.addTask(task('next'));
    await flushEvents();

    expect(harness.cleanedIds, ['broken']);
    expect(harness.startedIds, ['broken', 'next']);
    expect(statuses(container), [
      VideoTaskStatus.failed,
      VideoTaskStatus.processing,
    ]);
    await nextProcess.complete(0);
  });

  test(
    'cancels running and waiting tasks without cancellation races',
    () async {
      final process = FakeTaskProcess();
      final harness = SchedulerHarness([process]);
      final container = harness.container();
      addTearDown(container.dispose);
      final notifier = container.read(taskSchedulerProvider.notifier);

      notifier.addTask(task('running'));
      notifier.addTask(task('waiting'));
      await flushEvents();
      await notifier.cancelTask('waiting');
      await notifier.cancelTask('running');

      expect(process.killSignals, [ProcessSignal.sigint]);
      expect(harness.cleanedIds, ['waiting', 'running']);
      expect(statuses(container), [
        VideoTaskStatus.canceled,
        VideoTaskStatus.canceled,
      ]);

      await process.complete(0);
      await flushEvents();
      expect(statuses(container), [
        VideoTaskStatus.canceled,
        VideoTaskStatus.canceled,
      ]);
      expect(harness.startedIds, ['running']);
    },
  );

  test(
    'interrupts a task canceled while process startup is still pending',
    () async {
      final starter = Completer<TaskProcess>();
      final process = FakeTaskProcess();
      final cleaned = <String>[];
      final dependencies = TaskSchedulerDependencies(
        ffmpegPath: 'fake-ffmpeg',
        startProcess: (_, _) => starter.future,
        writeLog: (_, _) {},
        cleanFiles: (task) async => cleaned.add(task.id),
      );
      final container = ProviderContainer(
        overrides: [
          taskSchedulerProvider.overrideWith(
            () => TaskSchedulerNotifier(dependencies: dependencies),
          ),
        ],
      );
      addTearDown(container.dispose);
      final notifier = container.read(taskSchedulerProvider.notifier);

      notifier.addTask(task('starting'));
      await notifier.cancelTask('starting');
      expect(statuses(container), [VideoTaskStatus.canceled]);
      expect(cleaned, ['starting']);

      starter.complete(process);
      await flushEvents();
      expect(process.killSignals, [ProcessSignal.sigint]);
      await process.complete(0);
      await flushEvents();
      expect(statuses(container), [VideoTaskStatus.canceled]);
    },
  );

  test(
    'reruns a terminal task at the queue tail and rejects invalid actions',
    () async {
      final process = FakeTaskProcess();
      final initial = [
        task('other', status: VideoTaskStatus.finished),
        task(
          'retry',
          status: VideoTaskStatus.failed,
          progress: 0.7,
          eta: const Duration(seconds: 4),
        ),
      ];
      final harness = SchedulerHarness([process], initialTasks: initial);
      final container = harness.container();
      addTearDown(container.dispose);
      final notifier = container.read(taskSchedulerProvider.notifier);

      notifier.addTask(task(''));
      notifier.addTask(task('other'));
      notifier.rerunTask('missing');
      await notifier.cancelTask('missing');
      notifier.rerunTask('retry');
      await flushEvents();

      expect(harness.startedIds, ['retry']);
      expect(container.read(taskSchedulerProvider).map((item) => item.id), [
        'other',
        'retry',
      ]);
      final retried = container.read(taskSchedulerProvider).last;
      expect(retried.status, VideoTaskStatus.processing);
      expect(retried.progress, 0);
      expect(retried.eta, Duration.zero);

      notifier.rerunTask('retry');
      expect(harness.startedIds, ['retry']);
      await process.complete(0);
    },
  );

  test('default log writer and cleaner manage task artifacts', () async {
    final logPath = p.join(temporaryDirectory.path, 'logs', 'task.log');
    final outputPath = p.join(temporaryDirectory.path, 'output.mp4');
    final firstTemp = p.join(temporaryDirectory.path, 'first.tmp');
    final missingTemp = p.join(temporaryDirectory.path, 'missing.tmp');
    await File(outputPath).writeAsString('output');
    await File(firstTemp).writeAsString('temporary');

    appendTaskLog(logPath, 'first\n');
    appendTaskLog(logPath, 'second\n');
    appendTaskLog('', 'ignored');
    expect(await File(logPath).readAsString(), 'first\nsecond\n');

    await cleanTaskFiles(
      task('files').copyWith(
        outputPath: outputPath,
        tempFilePaths: [firstTemp, missingTemp],
      ),
    );
    expect(File(outputPath).existsSync(), isFalse);
    expect(File(firstTemp).existsSync(), isFalse);
  });
}

VideoTask task(
  String id, {
  Duration duration = Duration.zero,
  VideoTaskStatus status = VideoTaskStatus.waiting,
  double progress = 0,
  Duration eta = Duration.zero,
  bool hasLog = false,
}) {
  return VideoTask(
    id: id,
    name: id,
    duration: duration,
    status: status,
    progress: progress,
    eta: eta,
    ffmpegArgs: [id],
    logPath: hasLog ? '$id.log' : '',
  );
}

List<VideoTaskStatus> statuses(ProviderContainer container) {
  return container
      .read(taskSchedulerProvider)
      .map((item) => item.status)
      .toList();
}

Future<void> flushEvents() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

final class SchedulerHarness {
  SchedulerHarness(
    this.processes, {
    this.startErrors = const [],
    this.initialTasks = const [],
  });

  final List<FakeTaskProcess> processes;
  final List<Object> startErrors;
  final List<VideoTask> initialTasks;
  final List<String> startedIds = [];
  final List<String> cleanedIds = [];
  final List<(String, String)> logs = [];
  int _attempt = 0;
  int _processIndex = 0;

  ProviderContainer container() {
    final dependencies = TaskSchedulerDependencies(
      ffmpegPath: 'fake-ffmpeg',
      startProcess: (executable, arguments) async {
        startedIds.add(arguments.single);
        final attempt = _attempt++;
        if (attempt < startErrors.length) throw startErrors[attempt];
        return processes[_processIndex++];
      },
      writeLog: (path, message) => logs.add((path, message)),
      cleanFiles: (task) async => cleanedIds.add(task.id),
    );
    return ProviderContainer(
      overrides: [
        taskSchedulerProvider.overrideWith(
          () => TaskSchedulerNotifier(
            dependencies: dependencies,
            initialTasks: initialTasks,
          ),
        ),
      ],
    );
  }
}

final class FakeTaskProcess implements TaskProcess {
  final StreamController<List<int>> _stderr = StreamController();
  final Completer<int> _exitCode = Completer();
  final List<ProcessSignal> killSignals = [];

  @override
  Stream<List<int>> get stderr => _stderr.stream;

  @override
  Future<int> get exitCode => _exitCode.future;

  void emit(String line) => _stderr.add(utf8.encode(line));

  Future<void> complete(int code) async {
    if (!_stderr.isClosed) await _stderr.close();
    if (!_exitCode.isCompleted) _exitCode.complete(code);
  }

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    killSignals.add(signal);
    return true;
  }
}

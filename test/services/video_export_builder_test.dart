import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xji_footage_toolbox/models/lut.model.dart';
import 'package:xji_footage_toolbox/models/transcode_preset.model.dart';
import 'package:xji_footage_toolbox/models/video_task.dart';
import 'package:xji_footage_toolbox/services/video_export_builder.dart';

import '../helpers/media_fixtures.dart';

void main() {
  const h265Preset = TranscodePreset(
    id: 7,
    name: 'Delivery',
    useInputResolution: false,
    useHevc: true,
    width: 1920,
    height: 1080,
    crf: 20,
    ffmpegPreset: FFmpegPreset.slow,
    lutId: 3,
  );
  const lut = Lut(id: 3, name: 'Look', path: '/luts/film look.cube');

  test('derives safe default output names with or without extensions', () {
    expect(defaultVideoOutputFileName('clip.MP4'), 'clip_OUTPUT');
    expect(
      defaultVideoOutputFileName('archive.clip.mov'),
      'archive.clip_OUTPUT',
    );
    expect(defaultVideoOutputFileName('untitled'), 'untitled_OUTPUT');
  });

  test('validates output names and detects existing destination files', () {
    final checkedPaths = <String>[];
    bool exists(String path) {
      checkedPaths.add(path);
      return path.endsWith('taken.MP4');
    }

    expect(
      isValidVideoOutputName('', directory: '/exports', fileExists: exists),
      isFalse,
    );
    expect(
      isValidVideoOutputName('available', directory: '', fileExists: exists),
      isFalse,
    );
    expect(
      isValidVideoOutputName(
        'bad/name',
        directory: '/exports',
        fileExists: exists,
      ),
      isFalse,
    );
    expect(
      isValidVideoOutputName(
        'taken',
        directory: '/exports',
        fileExists: exists,
      ),
      isFalse,
    );
    expect(
      isValidVideoOutputName(
        'available',
        directory: '/exports',
        fileExists: exists,
      ),
      isTrue,
    );
    expect(checkedPaths, ['/exports/taken.MP4', '/exports/available.MP4']);
  });

  test('calculates transcode, trim, and merge output durations', () {
    final primary = videoFixture(duration: const Duration(seconds: 12));
    final second = videoFixture(
      name: 'second.MP4',
      duration: const Duration(seconds: 8),
    );

    expect(
      videoOutputDuration(
        taskType: VideoTaskType.transcode,
        videoResource: primary,
      ),
      const Duration(seconds: 12),
    );
    expect(
      videoOutputDuration(
        taskType: VideoTaskType.trim,
        videoResource: primary,
        cutStart: const Duration(seconds: 2),
        cutEnd: const Duration(seconds: 9),
      ),
      const Duration(seconds: 7),
    );
    expect(
      videoOutputDuration(
        taskType: VideoTaskType.trim,
        videoResource: primary,
        cutStart: const Duration(seconds: 9),
        cutEnd: const Duration(seconds: 2),
      ),
      primary.duration,
    );
    expect(
      videoOutputDuration(
        taskType: VideoTaskType.merge,
        videoResource: primary,
        selectedResources: [primary, second],
      ),
      const Duration(seconds: 20),
    );
  });

  test('builds H.265 transcode args with one combined filter chain', () {
    final input = videoFixture(
      file: File('/media/source clip.MP4'),
      duration: const Duration(seconds: 30),
    );
    final plan = buildVideoExportPlan(
      VideoExportRequest(
        taskId: 'task-1234',
        taskType: VideoTaskType.transcode,
        videoResource: input,
        preset: h265Preset,
        lut: lut,
        outputFileName: 'delivery',
        debugLogging: true,
      ),
    );

    expect(plan.task.type, VideoTaskType.transcode);
    expect(plan.task.status, VideoTaskStatus.waiting);
    expect(plan.task.outputPath, '/media/delivery.MP4');
    expect(plan.task.logPath, '/media/delivery.MP4.log');
    expect(plan.task.duration, const Duration(seconds: 30));
    expect(
      plan.task.ffmpegArgs,
      containsAllInOrder([
        '-i',
        '/media/source clip.MP4',
        '-c:v',
        'libx265',
        '-tag:v',
        'hvc1',
        '-crf',
        '20',
        '-preset',
        'slow',
        '-vf',
        'lut3d=/luts/film look.cube,format=yuv420p10le,scale=1920:1080',
        '-map_metadata',
        '0',
        '/media/delivery.MP4',
      ]),
    );
    expect(plan.task.ffmpegArgs.where((item) => item == '-vf'), hasLength(1));
    expect(plan.concatFilePath, isNull);
  });

  test('builds a trim copy task only when the selected range is valid', () {
    final input = videoFixture(file: File('/media/input.MP4'));
    final plan = buildVideoExportPlan(
      VideoExportRequest(
        taskId: 'trim-5678',
        taskType: VideoTaskType.trim,
        videoResource: input,
        preset: h265Preset,
        outputFileName: 'trimmed',
        selectedDirectory: '/exports',
        useSameDirectory: false,
        useInputEncodeSettings: true,
        cutStart: const Duration(seconds: 2),
        cutEnd: const Duration(seconds: 7),
      ),
    );

    expect(plan.task.outputPath, '/exports/trimmed.MP4');
    expect(plan.task.duration, const Duration(seconds: 5));
    expect(
      plan.task.ffmpegArgs,
      containsAllInOrder([
        '-c:v',
        'copy',
        '-ss',
        '0:00:02.000000',
        '-to',
        '0:00:07.000000',
        '-map_metadata',
        '0',
      ]),
    );
    expect(plan.task.ffmpegArgs, isNot(contains('-crf')));
  });

  test('builds merge concat metadata, task duration, and cleanup path', () {
    final first = videoFixture(file: File("/media/first's clip.MP4"));
    final second = videoFixture(
      name: 'second.MP4',
      file: File('/media/second.MP4'),
      duration: const Duration(seconds: 6),
    );
    final plan = buildVideoExportPlan(
      VideoExportRequest(
        taskId: 'merge-abcd',
        taskType: VideoTaskType.merge,
        videoResource: first,
        selectedResources: [first, second],
        preset: const TranscodePreset(useHevc: false),
        outputFileName: 'joined',
      ),
    );

    expect(plan.concatFilePath, '/media/.joined_abcd.txt');
    expect(plan.concatFileContents, contains(r"first'\''s clip.MP4"));
    expect(plan.concatFileContents, contains("file '/media/second.MP4'"));
    expect(plan.task.tempFilePaths, ['/media/.joined_abcd.txt']);
    expect(plan.task.duration, const Duration(seconds: 16));
    expect(
      plan.task.ffmpegArgs,
      containsAllInOrder([
        '-f',
        'concat',
        '-safe',
        '0',
        '-i',
        '/media/.joined_abcd.txt',
        '-i',
        "/media/first's clip.MP4",
        '-map_metadata',
        '1',
        '-c:v',
        'libx264',
      ]),
    );
  });

  test(
    'builds command-only plans with relative paths and quoted command text',
    () {
      final input = videoFixture(file: File('/media/source clip.MP4'));
      final plan = buildVideoExportPlan(
        VideoExportRequest(
          taskId: 'command-9999',
          taskType: VideoTaskType.transcode,
          videoResource: input,
          preset: const TranscodePreset(),
          outputFileName: 'output clip',
          exportCommandOnly: true,
        ),
      );

      expect(plan.task.status, VideoTaskStatus.finished);
      expect(plan.task.outputPath, 'output clip.MP4');
      expect(plan.task.ffmpegArgs.take(2), ['-i', 'source clip.MP4']);
      expect(plan.commandFilePath, '/media/output clip_9999.txt');
      expect(plan.commandFileContents, startsWith('ffmpeg -i'));
      expect(plan.commandFileContents, contains("'source clip.MP4'"));
      expect(plan.commandFileContents, contains("'output clip.MP4'"));
    },
  );

  test('rejects incomplete export requests', () {
    final input = videoFixture();
    expect(
      () => buildVideoExportPlan(
        VideoExportRequest(
          taskId: '',
          taskType: VideoTaskType.transcode,
          videoResource: input,
          preset: const TranscodePreset(),
          outputFileName: 'output',
        ),
      ),
      throwsArgumentError,
    );
    expect(
      () => buildVideoExportPlan(
        VideoExportRequest(
          taskId: 'merge',
          taskType: VideoTaskType.merge,
          videoResource: input,
          preset: const TranscodePreset(),
          outputFileName: 'output',
        ),
      ),
      throwsArgumentError,
    );
  });
}

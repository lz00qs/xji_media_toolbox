import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as p;
import 'package:xji_footage_toolbox/constants.dart';
import 'package:xji_footage_toolbox/models/media_resource.model.dart';
import 'package:xji_footage_toolbox/models/settings.model.dart';
import 'package:xji_footage_toolbox/providers/media_resources_state.notifier.dart';
import 'package:xji_footage_toolbox/services/media_analyzer.dart';

import '../helpers/test_environment.dart';

void main() {
  late Directory temporaryDirectory;
  late List<String> errors;

  setUp(() async {
    temporaryDirectory = await createTestDirectory('media-analyzer-test');
    errors = [];
  });

  tearDown(() => deleteTestDirectory(temporaryDirectory));

  test('prepares a thumbnail folder and clears all stale contents', () async {
    final analyzer = MediaAnalyzer(showError: errors.add);
    analyzer.prepareThumbnailFolder(temporaryDirectory.path);
    final thumbnailDirectory = Directory(
      p.join(temporaryDirectory.path, thumbnailFolderName),
    );
    expect(await thumbnailDirectory.exists(), isTrue);

    await File(p.join(thumbnailDirectory.path, 'stale.jpg')).writeAsString('x');
    final nested = Directory(p.join(thumbnailDirectory.path, 'nested'));
    await nested.create();
    await File(p.join(nested.path, 'stale.jpg')).writeAsString('x');

    analyzer.prepareThumbnailFolder(temporaryDirectory.path);

    expect(thumbnailDirectory.listSync(), isEmpty);
  });

  test(
    'classifies JPG and MP4 files case-insensitively and ignores other entries',
    () async {
      final jpg = await _writeFile(temporaryDirectory, 'photo.JPG');
      final lowerJpg = await _writeFile(temporaryDirectory, 'photo-2.jpg');
      final mp4 = await _writeFile(temporaryDirectory, 'video.MP4');
      final lowerMp4 = await _writeFile(temporaryDirectory, 'video-2.mp4');
      await _writeFile(temporaryDirectory, 'raw.DNG');
      await _writeFile(temporaryDirectory, 'notes.txt');
      await Directory(p.join(temporaryDirectory.path, 'folder.JPG')).create();
      final analyzer = MediaAnalyzer(showError: errors.add);

      final classified = analyzer.classifyMediaResources(
        temporaryDirectory.listSync(),
      );

      expect(classified.photos.map((file) => file.path), [
        jpg.path,
        lowerJpg.path,
      ]);
      expect(classified.videos.map((file) => file.path), [
        mp4.path,
        lowerMp4.path,
      ]);
      expect(classified.total, 4);
      expect(() => classified.photos.add(jpg), throwsUnsupportedError);
    },
  );

  test(
    'parses DJI creation time and sequence from a standard file name',
    () async {
      final file = await _writeFile(
        temporaryDirectory,
        'DJI_20251231235958_0042_D.JPG',
      );
      final analyzer = MediaAnalyzer(showError: errors.add);

      final metadata = analyzer.readMetadata(file);

      expect(metadata.creationTime, DateTime(2025, 12, 31, 23, 59, 58));
      expect(metadata.sequence, 42);
      expect(metadata.errors, isEmpty);
      expect(errors, isEmpty);
    },
  );

  test(
    'falls back to file modification time and records renamed-file errors',
    () async {
      final file = await _writeFile(temporaryDirectory, 'renamed.JPG');
      await file.setLastModified(DateTime(2024, 2, 3, 4, 5, 6));
      final expectedModifiedTime = file.lastModifiedSync();
      final analyzer = MediaAnalyzer(showError: errors.add);

      final metadata = analyzer.readMetadata(file);

      expect(metadata.creationTime, expectedModifiedTime);
      expect(metadata.sequence, 0);
      expect(metadata.errors[parseMediaResourceErrorCode], [
        parseMediaResourceTimeError,
        parseMediaResourceSequenceError,
      ]);
    },
  );

  test(
    'reports an invalid DJI timestamp while retaining a valid sequence',
    () async {
      final file = await _writeFile(
        temporaryDirectory,
        'DJI_20251340259999_0012_D.JPG',
      );
      final analyzer = MediaAnalyzer(showError: errors.add);

      final metadata = analyzer.readMetadata(file);

      expect(metadata.sequence, 12);
      expect(metadata.errors[parseMediaResourceErrorCode], [
        parseMediaResourceTimeError,
      ]);
      expect(errors.single, contains('creation time'));
    },
  );

  test('detects DJI AEB keywords and maps every supported exposure bias', () {
    final analyzer = MediaAnalyzer(showError: errors.add);
    final image = _imageWithAebMetadata('7/10');

    expect(analyzer.isAebImage(image), isTrue);
    expect(analyzer.parseEvBias(image), '+0.7');
    expect(
      [
        '0/10',
        '-7/10',
        '7/10',
        '-13/10',
        '13/10',
        '-20/10',
        '20/10',
      ].map(analyzer.evBiasString),
      MediaAnalyzer.aebBiasSequence,
    );
    expect(analyzer.evBiasString('1/3'), isEmpty);

    image.exif.imageIfd[0x9C9E] = IfdValueUndefined.list(
      Uint8List.fromList([97, 0, 101, 0, 120, 0]),
    );
    expect(analyzer.isAebImage(image), isFalse);
  });

  test('decodes a real JPEG into a photo resource with DJI metadata', () async {
    final sourceImage = Image(width: 4, height: 3);
    final file = File(
      p.join(temporaryDirectory.path, 'DJI_20240102030405_0008_D.JPG'),
    );
    await file.writeAsBytes(encodeJpg(sourceImage));
    final analyzer = MediaAnalyzer(
      decodeImage: decodeJpgFile,
      showError: errors.add,
    );

    final resource = await analyzer.processPhoto(file);

    expect(resource, isA<PhotoResource>());
    expect(resource?.name, p.basename(file.path));
    expect(resource?.width, 4);
    expect(resource?.height, 3);
    expect(resource?.sizeInBytes, greaterThan(0));
    expect(resource?.creationTime, DateTime(2024, 1, 2, 3, 4, 5));
    expect(resource?.sequence, 8);
    expect(resource?.thumbFile.path, file.path);
  });

  test('creates an AEB photo resource from decoded EXIF metadata', () async {
    final file = await _writeFile(
      temporaryDirectory,
      'DJI_20240102030405_0009_D.JPG',
    );
    final analyzer = MediaAnalyzer(
      decodeImage: (_) async => _imageWithAebMetadata('-13/10'),
      showError: errors.add,
    );

    final resource = await analyzer.processPhoto(file);

    expect(resource, isA<AebPhotoResource>());
    expect((resource as AebPhotoResource).evBias, '-1.3');
    expect(resource.aebResources, isEmpty);
  });

  test('skips photos when decoding throws or returns null', () async {
    final file = await _writeFile(temporaryDirectory, 'broken.JPG');
    final throwingAnalyzer = MediaAnalyzer(
      decodeImage: (_) async => throw const FormatException('bad JPEG'),
      showError: errors.add,
    );
    final nullAnalyzer = MediaAnalyzer(
      decodeImage: (_) async => null,
      showError: errors.add,
    );

    expect(await throwingAnalyzer.processPhoto(file), isNull);
    expect(await nullAnalyzer.processPhoto(file), isNull);
  });

  test(
    'probes video with the expected FFprobe arguments and decodes JSON',
    () async {
      final file = await _writeFile(temporaryDirectory, 'clip.MP4');
      final payload = _videoProbePayload();
      final runner = RecordingProcessRunner(
        (_, _) => processResult(stdout: jsonEncode(payload)),
      );
      final analyzer = MediaAnalyzer(
        runProcess: runner.call,
        ffprobePath: () => '/tools/ffprobe',
        showError: errors.add,
      );

      final result = await analyzer.probeVideo(file);

      expect(result, payload);
      expect(runner.invocations.single.executable, '/tools/ffprobe');
      expect(runner.invocations.single.arguments, [
        '-v',
        'error',
        '-show_entries',
        'format',
        '-show_entries',
        'stream',
        '-of',
        'json',
        file.path,
      ]);
    },
  );

  test(
    'returns null for FFprobe failures, malformed JSON, and process errors',
    () async {
      final file = await _writeFile(temporaryDirectory, 'clip.MP4');
      final failed = MediaAnalyzer(
        runProcess: (_, _) async =>
            processResult(exitCode: 2, stderr: 'failed'),
        showError: errors.add,
      );
      final malformed = MediaAnalyzer(
        runProcess: (_, _) async => processResult(stdout: '{bad-json'),
        showError: errors.add,
      );
      final unavailable = MediaAnalyzer(
        runProcess: (executable, arguments) async =>
            throw ProcessException(executable, arguments, 'missing'),
        showError: errors.add,
      );

      expect(await failed.probeVideo(file), isNull);
      expect(await malformed.probeVideo(file), isNull);
      expect(await unavailable.probeVideo(file), isNull);
    },
  );

  test(
    'parses the video stream, rotation, frame rate, codec, and thumbnail',
    () async {
      final file = await _writeFile(
        temporaryDirectory,
        'DJI_20240203040506_0015_D.MP4',
      );
      final runner = RecordingProcessRunner((executable, arguments) {
        if (executable == '/tools/ffprobe') {
          return processResult(stdout: jsonEncode(_videoProbePayload()));
        }
        return processResult();
      });
      final analyzer = MediaAnalyzer(
        runProcess: runner.call,
        ffprobePath: () => '/tools/ffprobe',
        ffmpegPath: () => '/tools/ffmpeg',
        showError: errors.add,
      );

      final resource = await analyzer.processVideo(file);

      expect(resource, isA<VideoResource>());
      final video = resource as VideoResource;
      expect(video.width, 2160);
      expect(video.height, 3840);
      expect(video.sizeInBytes, 123456);
      expect(video.frameRate, closeTo(59.94, 0.01));
      expect(video.duration, const Duration(milliseconds: 12345));
      expect(video.isHevc, isTrue);
      expect(video.colorProfile, VideoColorProfile.unknown);
      expect(video.creationTime, DateTime(2024, 2, 3, 4, 5, 6));
      expect(video.sequence, 15);
      expect(
        video.thumbFile.path,
        p.join(
          temporaryDirectory.path,
          'thumb',
          '${p.basenameWithoutExtension(file.path)}.thumb.JPG',
        ),
      );
      expect(runner.invocations.map((call) => call.executable), [
        '/tools/ffprobe',
        '/tools/ffmpeg',
      ]);
      expect(runner.invocations.last.arguments.last, video.thumbFile.path);
    },
  );

  test('reads D-Log2 from DJI container metadata', () async {
    final file = await _writeFile(
      temporaryDirectory,
      'DJI_20240203040506_0016_D.MP4',
    );
    final runner = RecordingProcessRunner((executable, _) {
      if (executable == 'probe') {
        return processResult(
          stdout: jsonEncode(
            _videoProbePayload(
              tags: const {
                'encoder': 'DJI OsmoPocket4P',
                'com.dji.camera.ColorGammaSxS': 'D-Log2',
              },
            ),
          ),
        );
      }
      return processResult();
    });
    final analyzer = MediaAnalyzer(
      runProcess: runner.call,
      ffprobePath: () => 'probe',
      ffmpegPath: () => 'ffmpeg',
      showError: errors.add,
    );

    final resource = await analyzer.processVideo(file) as VideoResource;

    expect(resource.colorProfile, VideoColorProfile.dLog2);
    expect(runner.invocations.map((call) => call.executable), [
      'probe',
      'ffmpeg',
    ]);
  });

  test(
    'reads D-Log M from the first Action 5 Pro DJI metadata packet',
    () async {
      final file = await _writeFile(
        temporaryDirectory,
        'DJI_20240203040506_0017_D.MP4',
      );
      final runner = RecordingProcessRunner((executable, arguments) {
        if (executable == 'probe' && arguments.contains('-show_packets')) {
          return processResult(
            stdout: jsonEncode({
              'packets': [
                {'data': '\n00000000: 1204 2202 0813  .."...\n'},
              ],
            }),
          );
        }
        if (executable == 'probe') {
          return processResult(
            stdout: jsonEncode(
              _videoProbePayload(
                tags: const {'encoder': 'DJI OsmoAction5 Pro'},
              ),
            ),
          );
        }
        return processResult();
      });
      final analyzer = MediaAnalyzer(
        runProcess: runner.call,
        ffprobePath: () => 'probe',
        ffmpegPath: () => 'ffmpeg',
        showError: errors.add,
      );

      final resource = await analyzer.processVideo(file) as VideoResource;

      expect(resource.colorProfile, VideoColorProfile.dLogM);
      expect(runner.invocations.map((call) => call.executable), [
        'probe',
        'probe',
        'ffmpeg',
      ]);
      expect(runner.invocations[1].arguments, [
        '-v',
        'error',
        '-select_streams',
        'd:0',
        '-read_intervals',
        '%+0.001',
        '-show_packets',
        '-show_data',
        '-show_entries',
        'packet=data',
        '-of',
        'json',
        file.path,
      ]);
    },
  );

  test('does not label a normal Action 5 Pro metadata packet', () async {
    final file = await _writeFile(
      temporaryDirectory,
      'DJI_20240203040506_0018_D.MP4',
    );
    final runner = RecordingProcessRunner((executable, arguments) {
      if (executable == 'probe' && arguments.contains('-show_packets')) {
        return processResult(
          stdout: jsonEncode({
            'packets': [
              {'data': '\n00000000: 1202 2200  ..".\n'},
            ],
          }),
        );
      }
      if (executable == 'probe') {
        return processResult(
          stdout: jsonEncode(
            _videoProbePayload(tags: const {'encoder': 'DJI OsmoAction5 Pro'}),
          ),
        );
      }
      return processResult();
    });
    final analyzer = MediaAnalyzer(
      runProcess: runner.call,
      ffprobePath: () => 'probe',
      ffmpegPath: () => 'ffmpeg',
      showError: errors.add,
    );

    final resource = await analyzer.processVideo(file) as VideoResource;

    expect(resource.colorProfile, VideoColorProfile.unknown);
  });

  test(
    'uses the placeholder thumbnail when FFmpeg thumbnail generation fails',
    () async {
      final file = await _writeFile(
        temporaryDirectory,
        'DJI_20240203040506_0015_D.MP4',
      );
      final analyzer = MediaAnalyzer(
        runProcess: (executable, _) async => executable == 'probe'
            ? processResult(stdout: jsonEncode(_videoProbePayload(rotation: 0)))
            : processResult(exitCode: 1, stderr: 'thumbnail failed'),
        ffprobePath: () => 'probe',
        ffmpegPath: () => 'ffmpeg',
        placeholderThumbnailPath: '/fallback/not-found.jpeg',
        showError: errors.add,
      );

      final resource = await analyzer.processVideo(file);

      expect(resource, isA<VideoResource>());
      expect(resource?.thumbFile.path, '/fallback/not-found.jpeg');
    },
  );

  test('rejects malformed video metadata without throwing', () async {
    final file = await _writeFile(temporaryDirectory, 'clip.MP4');
    final analyzer = MediaAnalyzer(
      runProcess: (_, _) async =>
          processResult(stdout: jsonEncode({'format': {}, 'streams': []})),
      showError: errors.add,
    );

    expect(await analyzer.processVideo(file), isNull);
    expect(errors.single, contains('video info'));
  });

  test(
    'groups a complete seven-shot AEB sequence without mutating its input',
    () {
      final analyzer = MediaAnalyzer(showError: errors.add);
      final input = <MediaResource>[
        _photo('before.JPG'),
        ...MediaAnalyzer.aebBiasSequence.indexed.map(
          (entry) => _aebPhoto(entry.$1, entry.$2),
        ),
        _photo('after.JPG'),
      ];

      final grouped = analyzer.groupAebFootage(input);

      expect(grouped, hasLength(3));
      expect(grouped.first, isA<PhotoResource>());
      final aeb = grouped[1] as AebPhotoResource;
      expect(
        aeb.aebResources.map((resource) => resource.evBias),
        MediaAnalyzer.aebBiasSequence,
      );
      expect(aeb.errors[parseAebErrorCode], isNull);
      expect(grouped.last, isA<PhotoResource>());
      expect(input, hasLength(9));
    },
  );

  test('marks an incomplete AEB group and preserves existing parse errors', () {
    final analyzer = MediaAnalyzer(showError: errors.add);
    final start = _aebPhoto(
      0,
      '0',
      errors: {
        parseMediaResourceErrorCode: [parseMediaResourceTimeError],
      },
    );

    final grouped = analyzer.groupAebFootage([
      start,
      _aebPhoto(1, '-0.7'),
      _aebPhoto(2, '+0.7'),
      _photo('break.JPG'),
    ]);

    final aeb = grouped.first as AebPhotoResource;
    expect(aeb.aebResources, hasLength(3));
    expect(aeb.errors[parseMediaResourceErrorCode], [
      parseMediaResourceTimeError,
    ]);
    expect(aeb.errors[parseAebErrorCode], [parseAebEndError]);
    expect(grouped.last, isA<PhotoResource>());
  });

  test('marks an AEB sequence truncated at the end of the directory', () {
    final analyzer = MediaAnalyzer(showError: errors.add);

    final grouped = analyzer.groupAebFootage([
      _aebPhoto(0, '0'),
      _aebPhoto(1, '-0.7'),
    ]);

    expect(grouped, hasLength(1));
    final aeb = grouped.single as AebPhotoResource;
    expect(aeb.aebResources, hasLength(2));
    expect(aeb.errors[parseAebErrorCode], [parseAebEndError]);
  });

  test('marks orphan AEB frames as missing a valid sequence start', () {
    final analyzer = MediaAnalyzer(showError: errors.add);

    final grouped = analyzer.groupAebFootage([
      _aebPhoto(1, '-0.7'),
      _aebPhoto(2, '+0.7'),
    ]);

    expect(grouped, hasLength(2));
    for (final resource in grouped.cast<AebPhotoResource>()) {
      expect(resource.aebResources, isEmpty);
      expect(resource.errors[parseAebErrorCode], [parseAebStartError]);
    }
  });

  test(
    'loads a directory through the analyzer and publishes sorted resources',
    () async {
      await _writeFile(temporaryDirectory, 'DJI_20240102030405_0002_D.JPG');
      await _writeFile(temporaryDirectory, 'DJI_20240102030405_0001_D.MP4');
      await _writeFile(temporaryDirectory, 'ignored.txt');
      final analyzer = MediaAnalyzer(
        decodeImage: (_) async => Image(width: 3, height: 2),
        runProcess: (executable, _) async => executable == 'probe'
            ? processResult(stdout: jsonEncode(_videoProbePayload(rotation: 0)))
            : processResult(),
        ffprobePath: () => 'probe',
        ffmpegPath: () => 'ffmpeg',
        showError: errors.add,
      );
      final container = ProviderContainer(
        overrides: [
          mediaResourcesStateProvider.overrideWith(
            () => MediaResourcesStateNotifier(analyzer: analyzer),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(mediaResourcesStateProvider.notifier)
          .loadMediaResourcesFromDir(
            temporaryDirectory.path,
            false,
            2,
            const Sort(sortType: SortType.sequence),
          );
      final state = container.read(mediaResourcesStateProvider);

      expect(state.isLoading, isFalse);
      expect(state.resourcesPath, temporaryDirectory.path);
      expect(state.loadProgress, 1);
      expect(state.resources.map((resource) => resource.sequence), [1, 2]);
      expect(state.resources.first, isA<VideoResource>());
      expect(state.resources.last, isA<PhotoResource>());
    },
  );
}

Future<File> _writeFile(Directory directory, String name) async {
  final file = File(p.join(directory.path, name));
  await file.writeAsString('fixture');
  return file;
}

Image _imageWithAebMetadata(String rawBias) {
  final image = Image(width: 3, height: 2);
  image.exif.imageIfd[0x9C9E] = IfdValueUndefined.list(
    Uint8List.fromList([97, 0, 101, 0, 98, 0]),
  );
  final parts = rawBias.split('/').map(int.parse).toList();
  image.exif.exifIfd[0x9204] = IfdValueSRational(parts[0], parts[1]);
  return image;
}

Map<String, dynamic> _videoProbePayload({
  int rotation = -90,
  Map<String, String> tags = const {},
}) {
  return {
    'format': {
      'size': '123456',
      'duration': '12.345',
      if (tags.isNotEmpty) 'tags': tags,
    },
    'streams': [
      {'codec_type': 'audio', 'codec_name': 'aac'},
      {
        'codec_type': 'video',
        'codec_name': 'hevc',
        'avg_frame_rate': '60000/1001',
        'width': 3840,
        'height': 2160,
        'side_data_list': [
          {'rotation': rotation},
        ],
      },
    ],
  };
}

PhotoResource _photo(String name) {
  final file = File(p.join('/fixtures', name));
  return PhotoResource(
    name: name,
    file: file,
    width: 10,
    height: 10,
    sizeInBytes: 100,
    creationTime: DateTime(2024),
    sequence: 1,
    thumbFile: file,
  );
}

AebPhotoResource _aebPhoto(
  int index,
  String bias, {
  Map<int, List<String>> errors = const {},
}) {
  final file = File(p.join('/fixtures', 'aeb-$index.JPG'));
  return AebPhotoResource(
    name: p.basename(file.path),
    file: file,
    width: 10,
    height: 10,
    sizeInBytes: 100,
    creationTime: DateTime(2024),
    sequence: index,
    thumbFile: file,
    errors: errors,
    evBias: bias,
    aebResources: const [],
  );
}

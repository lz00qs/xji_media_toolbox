import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:xji_footage_toolbox/models/ffmpeg_configuration.dart';
import 'package:xji_footage_toolbox/utils/ffmpeg_utils.dart';

void main() {
  late Directory temporaryDirectory;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'xji-ffmpeg-utils-test-',
    );
  });

  tearDown(() async {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('accepts a compatible FFmpeg directory', () async {
    if (Platform.isWindows) return;
    await _writeFakeExecutable(
      temporaryDirectory,
      'ffmpeg',
      includeRequiredFeatures: true,
    );
    await _writeFakeExecutable(
      temporaryDirectory,
      'ffprobe',
      includeRequiredFeatures: true,
    );

    final result = await FFmpegUtils.inspectDirectory(
      temporaryDirectory.path,
      source: FFmpegSource.custom,
    );

    expect(result.isAvailable, isTrue);
    expect(result.source, FFmpegSource.custom);
    expect(result.version, '9.0.1-test');
    expect(result.directory, p.normalize(temporaryDirectory.absolute.path));
  });

  test('rejects a directory without both executables', () async {
    final result = await FFmpegUtils.inspectDirectory(
      temporaryDirectory.path,
      source: FFmpegSource.custom,
    );

    expect(result.isAvailable, isFalse);
    expect(result.errorMessage, contains('both'));
    expect(result.errorMessage, contains('ffprobe'));
  });

  test('rejects a build missing required encoders and filters', () async {
    if (Platform.isWindows) return;
    await _writeFakeExecutable(
      temporaryDirectory,
      'ffmpeg',
      includeRequiredFeatures: false,
    );
    await _writeFakeExecutable(
      temporaryDirectory,
      'ffprobe',
      includeRequiredFeatures: false,
    );

    final result = await FFmpegUtils.inspectDirectory(
      temporaryDirectory.path,
      source: FFmpegSource.custom,
    );

    expect(result.isAvailable, isFalse);
    expect(result.errorMessage, contains('libx264'));
    expect(result.errorMessage, contains('libx265'));
    expect(result.errorMessage, contains('lut3d'));
    expect(result.errorMessage, contains('scale'));
  });

  test('resolves the release runtime next to the application', () {
    if (Platform.isMacOS) {
      expect(
        FFmpegUtils.bundledDirectory(
          executablePath:
              '/Applications/XJI Media Toolbox.app/Contents/MacOS/XJI Media Toolbox',
          debugMode: false,
        ),
        '/Applications/XJI Media Toolbox.app/Contents/Helpers',
      );
    } else if (Platform.isWindows) {
      expect(
        FFmpegUtils.bundledDirectory(
          executablePath: r'C:\Program Files\XJI\xji_media_toolbox.exe',
          debugMode: false,
        ),
        p.join(r'C:\Program Files\XJI', 'ffmpeg'),
      );
    }
  });
}

Future<void> _writeFakeExecutable(
  Directory directory,
  String name, {
  required bool includeRequiredFeatures,
}) async {
  final features = includeRequiredFeatures
      ? '''
case "\$*" in
  *-encoders*) echo " V..... libx264 libx265" ;;
  *-filters*) echo " .. lut3d scale" ;;
esac
'''
      : '';
  final file = File(p.join(directory.path, name));
  await file.writeAsString('''#!/bin/sh
echo "ffmpeg version 9.0.1-test Copyright"
$features
''');
  final chmod = await Process.run('chmod', ['755', file.path]);
  expect(chmod.exitCode, 0);
}

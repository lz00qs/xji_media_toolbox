import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:xji_footage_toolbox/models/ffmpeg_configuration.dart';
import 'package:xji_footage_toolbox/utils/ffmpeg_utils.dart';

import '../helpers/test_environment.dart';

void main() {
  late Directory temporaryDirectory;

  setUp(() async {
    FFmpegUtils.resetForTesting();
    temporaryDirectory = await createTestDirectory('ffmpeg-utils-test');
  });

  tearDown(() async {
    FFmpegUtils.resetForTesting();
    await deleteTestDirectory(temporaryDirectory);
  });

  test(
    'accepts a compatible FFmpeg directory and inspects each capability',
    () async {
      await createFFmpegPlaceholders(temporaryDirectory);
      final runner = RecordingProcessRunner(_compatibleFFmpegResponse);

      final result = await FFmpegUtils.inspectDirectory(
        ' ${temporaryDirectory.path}${p.separator}. ',
        source: FFmpegSource.custom,
        processRunner: runner.call,
      );

      expect(result.isAvailable, isTrue);
      expect(result.source, FFmpegSource.custom);
      expect(result.version, '9.0.1-test');
      expect(result.directory, p.normalize(temporaryDirectory.absolute.path));
      expect(
        result.ffmpegPath,
        p.join(result.directory, _executable('ffmpeg')),
      );
      expect(
        result.ffprobePath,
        p.join(result.directory, _executable('ffprobe')),
      );
      expect(runner.invocations.map((invocation) => invocation.arguments), [
        ['-version'],
        ['-version'],
        ['-hide_banner', '-encoders'],
        ['-hide_banner', '-filters'],
      ]);
    },
  );

  test(
    'rejects a directory without both executables before starting a process',
    () async {
      final runner = RecordingProcessRunner(_compatibleFFmpegResponse);

      final result = await FFmpegUtils.inspectDirectory(
        temporaryDirectory.path,
        source: FFmpegSource.custom,
        processRunner: runner.call,
      );

      expect(result.isAvailable, isFalse);
      expect(result.errorMessage, contains('both'));
      expect(result.errorMessage, contains(_executable('ffprobe')));
      expect(runner.invocations, isEmpty);
    },
  );

  test('reports an FFmpeg version command failure using stderr', () async {
    await createFFmpegPlaceholders(temporaryDirectory);
    final runner = RecordingProcessRunner((executable, arguments) {
      if (p.basename(executable) == _executable('ffmpeg') &&
          arguments.length == 1) {
        return processResult(exitCode: 13, stderr: 'permission denied');
      }
      return _compatibleFFmpegResponse(executable, arguments);
    });

    final result = await FFmpegUtils.inspectDirectory(
      temporaryDirectory.path,
      source: FFmpegSource.custom,
      processRunner: runner.call,
    );

    expect(result.isAvailable, isFalse);
    expect(result.errorMessage, contains('FFmpeg could not be started'));
    expect(result.errorMessage, contains('permission denied'));
    expect(runner.invocations, hasLength(1));
  });

  test('reports an FFprobe failure and falls back to the exit code', () async {
    await createFFmpegPlaceholders(temporaryDirectory);
    final runner = RecordingProcessRunner((executable, arguments) {
      if (p.basename(executable) == _executable('ffprobe')) {
        return processResult(exitCode: 7);
      }
      return _compatibleFFmpegResponse(executable, arguments);
    });

    final result = await FFmpegUtils.inspectDirectory(
      temporaryDirectory.path,
      source: FFmpegSource.custom,
      processRunner: runner.call,
    );

    expect(result.isAvailable, isFalse);
    expect(result.errorMessage, contains('FFprobe could not be started'));
    expect(result.errorMessage, contains('exit code 7'));
    expect(runner.invocations, hasLength(2));
  });

  test('reports encoder and filter inspection command failures', () async {
    await createFFmpegPlaceholders(temporaryDirectory);

    for (final failingArgument in ['-encoders', '-filters']) {
      final runner = RecordingProcessRunner((executable, arguments) {
        if (arguments.contains(failingArgument)) {
          return processResult(exitCode: 2, stderr: '$failingArgument failed');
        }
        return _compatibleFFmpegResponse(executable, arguments);
      });

      final result = await FFmpegUtils.inspectDirectory(
        temporaryDirectory.path,
        source: FFmpegSource.custom,
        processRunner: runner.call,
      );

      expect(result.isAvailable, isFalse);
      expect(result.errorMessage, contains('$failingArgument failed'));
    }
  });

  test('rejects a build missing required encoders and filters', () async {
    await createFFmpegPlaceholders(temporaryDirectory);
    final runner = RecordingProcessRunner((executable, arguments) {
      if (arguments.contains('-encoders')) {
        return processResult(stdout: ' V..... native_encoder');
      }
      if (arguments.contains('-filters')) {
        return processResult(stdout: ' .. crop');
      }
      return _compatibleFFmpegResponse(executable, arguments);
    });

    final result = await FFmpegUtils.inspectDirectory(
      temporaryDirectory.path,
      source: FFmpegSource.custom,
      processRunner: runner.call,
    );

    expect(result.isAvailable, isFalse);
    expect(result.errorMessage, contains('libx264'));
    expect(result.errorMessage, contains('libx265'));
    expect(result.errorMessage, contains('lut3d'));
    expect(result.errorMessage, contains('scale'));
  });

  test(
    'uses Unknown when the version output has an unexpected format',
    () async {
      await createFFmpegPlaceholders(temporaryDirectory);
      final runner = RecordingProcessRunner((executable, arguments) {
        if (arguments.length == 1 &&
            p.basename(executable) == _executable('ffmpeg')) {
          return processResult(stdout: 'custom multimedia tool');
        }
        return _compatibleFFmpegResponse(executable, arguments);
      });

      final result = await FFmpegUtils.inspectDirectory(
        temporaryDirectory.path,
        source: FFmpegSource.custom,
        processRunner: runner.call,
      );

      expect(result.version, 'Unknown');
    },
  );

  test('activates successful custom and bundled configurations', () async {
    await createFFmpegPlaceholders(temporaryDirectory);
    final runner = RecordingProcessRunner(_compatibleFFmpegResponse);

    final custom = await FFmpegUtils.useCustom(
      temporaryDirectory.path,
      processRunner: runner.call,
    );
    expect(FFmpegUtils.configuration, same(custom));
    expect(FFmpegUtils.ffmpeg, custom.ffmpegPath);
    expect(FFmpegUtils.ffprobe, custom.ffprobePath);

    final bundled = await FFmpegUtils.useBundled(
      directoryOverride: temporaryDirectory.path,
      processRunner: runner.call,
    );
    expect(bundled.source, FFmpegSource.bundled);
    expect(FFmpegUtils.configuration, same(bundled));
  });

  test(
    'does not replace the active configuration when a custom directory fails',
    () async {
      await createFFmpegPlaceholders(temporaryDirectory);
      final runner = RecordingProcessRunner(_compatibleFFmpegResponse);
      final active = await FFmpegUtils.useCustom(
        temporaryDirectory.path,
        processRunner: runner.call,
      );

      final missingDirectory = Directory(
        p.join(temporaryDirectory.path, 'missing'),
      );
      await missingDirectory.create();
      final failed = await FFmpegUtils.useCustom(
        missingDirectory.path,
        processRunner: runner.call,
      );

      expect(failed.isAvailable, isFalse);
      expect(FFmpegUtils.configuration, same(active));
    },
  );

  test('initialize prefers a compatible custom directory', () async {
    await createFFmpegPlaceholders(temporaryDirectory);
    final runner = RecordingProcessRunner(_compatibleFFmpegResponse);

    final result = await FFmpegUtils.initialize(
      customDirectory: temporaryDirectory.path,
      processRunner: runner.call,
    );

    expect(result.source, FFmpegSource.custom);
    expect(FFmpegUtils.configuration, same(result));
  });

  test('resolves bundled runtime locations for the current platform', () {
    if (Platform.isMacOS) {
      expect(
        FFmpegUtils.bundledDirectory(
          workingDirectory: '/workspace',
          debugMode: true,
        ),
        p.join('/workspace', 'assets', 'macos', 'ffmpeg'),
      );
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
          workingDirectory: r'C:\workspace',
          debugMode: true,
        ),
        p.join(r'C:\workspace', 'assets', 'windows', 'ffmpeg'),
      );
      expect(
        FFmpegUtils.bundledDirectory(
          executablePath: r'C:\Program Files\XJI\xji_media_toolbox.exe',
          debugMode: false,
        ),
        p.join(r'C:\Program Files\XJI', 'ffmpeg'),
      );
    } else {
      expect(FFmpegUtils.bundledDirectory(), isNull);
    }
  });
}

String _executable(String name) => '$name${Platform.isWindows ? '.exe' : ''}';

ProcessResult _compatibleFFmpegResponse(
  String executable,
  List<String> arguments,
) {
  if (arguments.contains('-encoders')) {
    return processResult(stdout: ' V..... libx264\n V..... libx265');
  }
  if (arguments.contains('-filters')) {
    return processResult(stdout: ' .. lut3d\n .. scale');
  }
  return processResult(stdout: 'ffmpeg version 9.0.1-test Copyright\n');
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../models/ffmpeg_configuration.dart';

typedef FFmpegProcessRunner =
    Future<ProcessResult> Function(String executable, List<String> arguments);

class FFmpegUtils {
  static FFmpegConfiguration _configuration =
      const FFmpegConfiguration.unavailable();

  static FFmpegConfiguration get configuration => _configuration;
  static String get ffmpeg => _configuration.ffmpegPath;
  static String get ffprobe => _configuration.ffprobePath;

  static Future<FFmpegConfiguration> initialize({
    String customDirectory = '',
    @visibleForTesting FFmpegProcessRunner? processRunner,
  }) async {
    if (customDirectory.trim().isNotEmpty) {
      final custom = await inspectDirectory(
        customDirectory,
        source: FFmpegSource.custom,
        processRunner: processRunner,
      );
      if (custom.isAvailable) return _activate(custom);
    }

    return useBundled(processRunner: processRunner);
  }

  static Future<FFmpegConfiguration> useCustom(
    String directory, {
    @visibleForTesting FFmpegProcessRunner? processRunner,
  }) async {
    final result = await inspectDirectory(
      directory,
      source: FFmpegSource.custom,
      processRunner: processRunner,
    );
    return result.isAvailable ? _activate(result) : result;
  }

  static Future<FFmpegConfiguration> useBundled({
    @visibleForTesting String? directoryOverride,
    @visibleForTesting FFmpegProcessRunner? processRunner,
  }) async {
    final directory = directoryOverride ?? bundledDirectory();
    if (directory == null) {
      return _activate(
        const FFmpegConfiguration.unavailable(
          'Bundled FFmpeg is not supported on this platform.',
        ),
      );
    }

    final result = await inspectDirectory(
      directory,
      source: FFmpegSource.bundled,
      processRunner: processRunner,
    );
    return _activate(result);
  }

  @visibleForTesting
  static String? bundledDirectory({
    String? executablePath,
    String? workingDirectory,
    bool? debugMode,
  }) {
    if (!Platform.isMacOS && !Platform.isWindows) return null;

    if (debugMode ?? kDebugMode) {
      return p.join(
        workingDirectory ?? Directory.current.path,
        'assets',
        Platform.isWindows ? 'windows' : 'macos',
        'ffmpeg',
      );
    }

    final executableDirectory = p.dirname(
      executablePath ?? Platform.resolvedExecutable,
    );
    if (Platform.isWindows) return p.join(executableDirectory, 'ffmpeg');
    return p.normalize(p.join(executableDirectory, '..', 'Helpers'));
  }

  @visibleForTesting
  static Future<FFmpegConfiguration> inspectDirectory(
    String directory, {
    required FFmpegSource source,
    FFmpegProcessRunner? processRunner,
  }) async {
    final normalizedDirectory = p.normalize(p.absolute(directory.trim()));
    final executableSuffix = Platform.isWindows ? '.exe' : '';
    final ffmpegPath = p.join(normalizedDirectory, 'ffmpeg$executableSuffix');
    final ffprobePath = p.join(normalizedDirectory, 'ffprobe$executableSuffix');

    if (!File(ffmpegPath).existsSync() || !File(ffprobePath).existsSync()) {
      return FFmpegConfiguration.unavailable(
        'The selected directory must contain both '
        'ffmpeg$executableSuffix and ffprobe$executableSuffix.',
      );
    }

    final runProcess = processRunner ?? _runProcess;

    try {
      final ffmpegVersion = await runProcess(ffmpegPath, const ['-version']);
      if (ffmpegVersion.exitCode != 0) {
        return FFmpegConfiguration.unavailable(
          'FFmpeg could not be started: ${_processError(ffmpegVersion)}',
        );
      }

      final ffprobeVersion = await runProcess(ffprobePath, const ['-version']);
      if (ffprobeVersion.exitCode != 0) {
        return FFmpegConfiguration.unavailable(
          'FFprobe could not be started: ${_processError(ffprobeVersion)}',
        );
      }

      final encoders = await runProcess(ffmpegPath, const [
        '-hide_banner',
        '-encoders',
      ]);
      final filters = await runProcess(ffmpegPath, const [
        '-hide_banner',
        '-filters',
      ]);
      final encodersOutput = '${encoders.stdout}\n${encoders.stderr}';
      final filtersOutput = '${filters.stdout}\n${filters.stderr}';
      if (encoders.exitCode != 0) {
        return FFmpegConfiguration.unavailable(
          'Unable to inspect FFmpeg encoders: ${_processError(encoders)}',
        );
      }
      if (filters.exitCode != 0) {
        return FFmpegConfiguration.unavailable(
          'Unable to inspect FFmpeg filters: ${_processError(filters)}',
        );
      }

      final missingFeatures = <String>[
        if (!encodersOutput.contains('libx264')) 'libx264',
        if (!encodersOutput.contains('libx265')) 'libx265',
        if (!RegExp(r'\blut3d\b').hasMatch(filtersOutput)) 'lut3d',
        if (!RegExp(r'\bscale\b').hasMatch(filtersOutput)) 'scale',
      ];
      if (missingFeatures.isNotEmpty) {
        return FFmpegConfiguration.unavailable(
          'This FFmpeg build is missing required features: '
          '${missingFeatures.join(', ')}.',
        );
      }

      return FFmpegConfiguration(
        source: source,
        directory: normalizedDirectory,
        ffmpegPath: ffmpegPath,
        ffprobePath: ffprobePath,
        version: _parseVersion(ffmpegVersion.stdout.toString()),
      );
    } on ProcessException catch (error) {
      return FFmpegConfiguration.unavailable(
        'Unable to run FFmpeg from this directory: ${error.message}',
      );
    } on FileSystemException catch (error) {
      return FFmpegConfiguration.unavailable(
        'Unable to access this FFmpeg directory: ${error.message}',
      );
    }
  }

  static FFmpegConfiguration _activate(FFmpegConfiguration configuration) {
    _configuration = configuration;
    return configuration;
  }

  static Future<ProcessResult> _runProcess(
    String executable,
    List<String> arguments,
  ) {
    return Process.run(executable, arguments);
  }

  @visibleForTesting
  static void resetForTesting() {
    _configuration = const FFmpegConfiguration.unavailable();
  }

  static String _parseVersion(String output) {
    final firstLine = output.split(RegExp(r'\r?\n')).firstOrNull ?? '';
    final match = RegExp(r'^ffmpeg version\s+([^\s]+)').firstMatch(firstLine);
    return match?.group(1) ?? 'Unknown';
  }

  static String _processError(ProcessResult result) {
    final stderr = result.stderr.toString().trim();
    if (stderr.isNotEmpty) return stderr;
    return 'exit code ${result.exitCode}';
  }
}

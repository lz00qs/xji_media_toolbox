import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as p;

import '../constants.dart';
import '../models/media_resource.model.dart';
import '../utils/ffmpeg_utils.dart';
import '../utils/logger.dart';
import '../utils/toast.dart';

typedef MediaImageDecoder = Future<Image?> Function(String path);
typedef MediaProcessRunner =
    Future<ProcessResult> Function(String executable, List<String> arguments);

final class ClassifiedMediaFiles {
  ClassifiedMediaFiles({required List<File> photos, required List<File> videos})
    : photos = List.unmodifiable(photos),
      videos = List.unmodifiable(videos);

  final List<File> photos;
  final List<File> videos;

  int get total => photos.length + videos.length;
}

final class MediaFileMetadata {
  MediaFileMetadata({
    required this.creationTime,
    required this.sequence,
    required Map<int, List<String>> errors,
  }) : errors = Map<int, List<String>>.unmodifiable({
         for (final entry in errors.entries)
           entry.key: List<String>.unmodifiable(entry.value),
       });

  final DateTime creationTime;
  final int sequence;
  final Map<int, List<String>> errors;
}

final class MediaAnalyzer {
  MediaAnalyzer({
    MediaImageDecoder? decodeImage,
    MediaProcessRunner? runProcess,
    String Function()? ffmpegPath,
    String Function()? ffprobePath,
    void Function(String message)? showError,
    this.placeholderThumbnailPath =
        'assets/common/images/resource_not_found.jpeg',
  }) : _decodeImage = decodeImage ?? _decodeJpegInBackground,
       _runProcess = runProcess ?? _runProcessDefault,
       _ffmpegPath = ffmpegPath ?? (() => FFmpegUtils.ffmpeg),
       _ffprobePath = ffprobePath ?? (() => FFmpegUtils.ffprobe),
       _showError = showError ?? Toast.error;

  static const List<String> aebBiasSequence = [
    '0',
    '-0.7',
    '+0.7',
    '-1.3',
    '+1.3',
    '-2',
    '+2',
  ];

  final MediaImageDecoder _decodeImage;
  final MediaProcessRunner _runProcess;
  final String Function() _ffmpegPath;
  final String Function() _ffprobePath;
  final void Function(String message) _showError;
  final String placeholderThumbnailPath;

  void prepareThumbnailFolder(String mediaResourcesPath) {
    final thumbnailDirectory = Directory(
      p.join(mediaResourcesPath, thumbnailFolderName),
    );
    if (!thumbnailDirectory.existsSync()) {
      thumbnailDirectory.createSync(recursive: true);
      Logger.debug('Create thumb folder');
      return;
    }

    for (final entity in thumbnailDirectory.listSync()) {
      entity.deleteSync(recursive: true);
    }
    Logger.debug('Clear thumb folder');
  }

  bool isPhoto(Uri uri) => p.extension(uri.path).toLowerCase() == '.jpg';

  bool isVideo(Uri uri) => p.extension(uri.path).toLowerCase() == '.mp4';

  ClassifiedMediaFiles classifyMediaResources(
    Iterable<FileSystemEntity> entities,
  ) {
    final photos = <File>[];
    final videos = <File>[];
    for (final entity in entities) {
      if (entity is! File) continue;
      if (isPhoto(entity.uri)) {
        photos.add(entity);
      } else if (isVideo(entity.uri)) {
        videos.add(entity);
      }
    }
    return ClassifiedMediaFiles(photos: photos, videos: videos);
  }

  DateTime parseCreationTime(File file) {
    final match = RegExp(
      r'DJI_(\d{14})_(\d{4})_D',
    ).firstMatch(p.basename(file.path));
    if (match == null) return DateTime(0);

    try {
      final raw = match.group(1)!;
      final year = int.parse(raw.substring(0, 4));
      final month = int.parse(raw.substring(4, 6));
      final day = int.parse(raw.substring(6, 8));
      final hour = int.parse(raw.substring(8, 10));
      final minute = int.parse(raw.substring(10, 12));
      final second = int.parse(raw.substring(12, 14));
      final parsed = DateTime(year, month, day, hour, minute, second);
      if (parsed.year != year ||
          parsed.month != month ||
          parsed.day != day ||
          parsed.hour != hour ||
          parsed.minute != minute ||
          parsed.second != second) {
        throw const FormatException('Timestamp components are out of range.');
      }
      return parsed;
    } catch (error) {
      _showError('Failed to parse ${p.basename(file.path)} creation time');
      Logger.warn('${p.basename(file.path)} parse creation time error: $error');
      return DateTime(0);
    }
  }

  int parseSequence(File file) {
    final match = RegExp(
      r'DJI_(\d{14})_(\d{4})_D',
    ).firstMatch(p.basename(file.path));
    if (match == null) return 0;

    try {
      return int.parse(match.group(2)!);
    } catch (error) {
      _showError('Failed to parse ${p.basename(file.path)} sequence');
      Logger.warn('${p.basename(file.path)} parse sequence error: $error');
      return 0;
    }
  }

  MediaFileMetadata readMetadata(File file) {
    final errors = <int, List<String>>{};
    final parsedCreationTime = parseCreationTime(file);
    if (parsedCreationTime == DateTime(0)) {
      errors[parseMediaResourceErrorCode] = [parseMediaResourceTimeError];
    }
    final creationTime = parsedCreationTime == DateTime(0)
        ? file.lastModifiedSync()
        : parsedCreationTime;

    final sequence = parseSequence(file);
    if (sequence == 0) {
      errors
          .putIfAbsent(parseMediaResourceErrorCode, () => <String>[])
          .add(parseMediaResourceSequenceError);
    }

    return MediaFileMetadata(
      creationTime: creationTime,
      sequence: sequence,
      errors: errors,
    );
  }

  bool isAebImage(Image image) {
    final keywords = image.exif.imageIfd[0x9C9E]?.toData();
    const expected = [97, 0, 101, 0, 98, 0];
    if (keywords == null || keywords.length != expected.length) return false;
    for (var index = 0; index < expected.length; index++) {
      if (keywords[index] != expected[index]) return false;
    }
    return true;
  }

  String evBiasString(String rawEv) {
    return switch (rawEv) {
      '0/10' => '0',
      '-7/10' => '-0.7',
      '7/10' => '+0.7',
      '-13/10' => '-1.3',
      '13/10' => '+1.3',
      '-20/10' => '-2',
      '20/10' => '+2',
      _ => '',
    };
  }

  String parseEvBias(Image image) {
    final rawBias = image.exif.exifIfd[0x9204]?.toString();
    return rawBias == null ? '' : evBiasString(rawBias);
  }

  Future<MediaResource?> processPhoto(File mediaResourceFile) async {
    final metadata = readMetadata(mediaResourceFile);

    Image? image;
    try {
      image = await _decodeImage(mediaResourceFile.path);
    } catch (error, stackTrace) {
      Logger.error(
        '${p.basename(mediaResourceFile.path)} decode error: $error',
        error,
        stackTrace,
      );
      return null;
    }
    if (image == null) {
      Logger.error(
        '${p.basename(mediaResourceFile.path)} decode error: null',
        null,
        StackTrace.current,
      );
      return null;
    }

    final common = (
      name: p.basename(mediaResourceFile.path),
      width: image.width,
      height: image.height,
      sizeInBytes: image.lengthInBytes,
    );
    if (isAebImage(image)) {
      return AebPhotoResource(
        name: common.name,
        file: mediaResourceFile,
        width: common.width,
        height: common.height,
        sizeInBytes: common.sizeInBytes,
        creationTime: metadata.creationTime,
        sequence: metadata.sequence,
        evBias: parseEvBias(image),
        thumbFile: mediaResourceFile,
        errors: metadata.errors,
        aebResources: const [],
      );
    }

    return PhotoResource(
      name: common.name,
      file: mediaResourceFile,
      width: common.width,
      height: common.height,
      sizeInBytes: common.sizeInBytes,
      creationTime: metadata.creationTime,
      sequence: metadata.sequence,
      thumbFile: mediaResourceFile,
      errors: metadata.errors,
    );
  }

  Future<MediaResource?> processVideo(File mediaResourceFile) async {
    final metadata = readMetadata(mediaResourceFile);
    final ffprobeOutput = await probeVideo(mediaResourceFile);
    if (ffprobeOutput == null) return null;

    try {
      final format = _objectMap(ffprobeOutput['format']);
      final streams = ffprobeOutput['streams'];
      if (format == null || streams is! List) {
        throw const FormatException('Missing format or stream information.');
      }
      final stream = streams
          .map(_objectMap)
          .whereType<Map<String, dynamic>>()
          .firstWhere(
            (item) =>
                item['codec_type'] == 'video' ||
                (item.containsKey('width') && item.containsKey('height')),
          );

      final sizeInBytes = int.parse(format['size'].toString());
      final frameRate = _parseFrameRate(stream['avg_frame_rate'].toString());
      final duration = double.parse(format['duration'].toString());
      final rotation = _readRotation(stream);
      final sourceWidth = _readInt(stream, 'width');
      final sourceHeight = _readInt(stream, 'height');
      final swapsDimensions = rotation.abs() % 180 == 90;
      final thumbFile = await generateThumbnail(mediaResourceFile);
      if (thumbFile == null) {
        Logger.warn(
          '${p.basename(mediaResourceFile.path)} generate thumbnail error',
        );
      }

      return VideoResource(
        name: p.basename(mediaResourceFile.path),
        file: mediaResourceFile,
        width: swapsDimensions ? sourceHeight : sourceWidth,
        height: swapsDimensions ? sourceWidth : sourceHeight,
        sizeInBytes: sizeInBytes,
        creationTime: metadata.creationTime,
        sequence: metadata.sequence,
        frameRate: frameRate,
        duration: Duration(
          microseconds: (duration * Duration.microsecondsPerSecond).toInt(),
        ),
        isHevc: stream['codec_name'] == 'hevc',
        thumbFile: thumbFile ?? File(placeholderThumbnailPath),
        errors: metadata.errors,
      );
    } catch (error) {
      _showError(
        'Failed to parse ${p.basename(mediaResourceFile.path)} video info',
      );
      Logger.warn(
        '${p.basename(mediaResourceFile.path)} parse video info error: $error',
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> probeVideo(File file) async {
    ProcessResult result;
    try {
      result = await _runProcess(_ffprobePath(), [
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
    } on ProcessException catch (error) {
      Logger.warn('${p.basename(file.path)} ffprobe error: ${error.message}');
      return null;
    } on FileSystemException catch (error) {
      Logger.warn('${p.basename(file.path)} ffprobe error: ${error.message}');
      return null;
    }

    if (result.exitCode != 0) {
      Logger.warn('${p.basename(file.path)} ffprobe error: ${result.stderr}');
      return null;
    }

    try {
      final decoded = jsonDecode(result.stdout.toString());
      return _objectMap(decoded);
    } on FormatException catch (error) {
      Logger.warn('${p.basename(file.path)} ffprobe JSON error: $error');
      return null;
    }
  }

  Future<File?> generateThumbnail(File file) async {
    final thumbnailDirectory = Directory(
      p.join(file.parent.path, thumbnailFolderName),
    );
    await thumbnailDirectory.create(recursive: true);
    final thumbnailPath = p.join(
      thumbnailDirectory.path,
      '${p.basenameWithoutExtension(file.path)}.thumb.JPG',
    );

    ProcessResult result;
    try {
      result = await _runProcess(_ffmpegPath(), [
        '-i',
        file.path,
        '-ss',
        '00:00:00.001',
        '-vframes',
        '1',
        '-strict',
        'unofficial',
        thumbnailPath,
      ]);
    } on ProcessException catch (error) {
      Logger.warn(
        '${p.basename(file.path)} generate thumbnail error: ${error.message}',
      );
      return null;
    } on FileSystemException catch (error) {
      Logger.warn(
        '${p.basename(file.path)} generate thumbnail error: ${error.message}',
      );
      return null;
    }

    if (result.exitCode != 0) {
      Logger.warn(
        '${p.basename(file.path)} generate thumbnail error: ${result.stderr}',
      );
      return null;
    }
    Logger.debug('${p.basename(file.path)} generate thumbnail success');
    return File(thumbnailPath);
  }

  List<MediaResource> groupAebFootage(Iterable<MediaResource> resources) {
    final input = List<MediaResource>.of(resources);
    final grouped = <MediaResource>[];

    for (var index = 0; index < input.length;) {
      final resource = input[index];
      if (resource is! AebPhotoResource) {
        grouped.add(resource);
        index++;
        continue;
      }

      if (resource.evBias != aebBiasSequence.first) {
        grouped.add(
          resource.copyWith(
            errors: _appendError(
              resource.errors,
              parseAebErrorCode,
              parseAebStartError,
            ),
          ),
        );
        index++;
        continue;
      }

      final members = <AebPhotoResource>[resource];
      var cursor = index + 1;
      while (members.length < aebBiasSequence.length && cursor < input.length) {
        final candidate = input[cursor];
        if (candidate is! AebPhotoResource ||
            candidate.evBias != aebBiasSequence[members.length]) {
          break;
        }
        members.add(candidate);
        cursor++;
      }

      final errors = members.length == aebBiasSequence.length
          ? resource.errors
          : _appendError(resource.errors, parseAebErrorCode, parseAebEndError);
      grouped.add(resource.copyWith(aebResources: members, errors: errors));
      index = cursor;
    }

    return grouped;
  }

  static Future<Image?> _decodeJpegInBackground(String path) {
    return compute(decodeJpgFile, path);
  }

  static Future<ProcessResult> _runProcessDefault(
    String executable,
    List<String> arguments,
  ) {
    return Process.run(executable, arguments);
  }

  static Map<String, dynamic>? _objectMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return null;
  }

  static double _parseFrameRate(String value) {
    final parts = value.split('/');
    if (parts.length != 2) throw const FormatException('Invalid frame rate.');
    final numerator = double.parse(parts[0]);
    final denominator = double.parse(parts[1]);
    if (denominator == 0) {
      throw const FormatException('Frame-rate denominator cannot be zero.');
    }
    return numerator / denominator;
  }

  static int _readRotation(Map<String, dynamic> stream) {
    final sideData = stream['side_data_list'];
    if (sideData is! List || sideData.isEmpty) return 0;
    final first = _objectMap(sideData.first);
    final rotation = first?['rotation'];
    return rotation is num ? rotation.toInt() : 0;
  }

  static int _readInt(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.parse(value.toString());
  }

  static Map<int, List<String>> _appendError(
    Map<int, List<String>> errors,
    int code,
    String message,
  ) {
    final updated = {
      for (final entry in errors.entries)
        entry.key: List<String>.of(entry.value),
    };
    final messages = updated.putIfAbsent(code, () => []);
    if (!messages.contains(message)) messages.add(message);
    return updated;
  }
}

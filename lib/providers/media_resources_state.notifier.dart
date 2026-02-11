import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/utils/logger.dart';
import 'package:image/image.dart';

import '../constants.dart';
import '../models/media_resource.model.dart';
import '../models/media_resources_state.model.dart';
import '../models/settings.model.dart';
import '../utils/ffmpeg_utils.dart';
import '../utils/toast.dart';

part 'media_resources_state.notifier.g.dart';

final stopwatch = Stopwatch();
var _mediaResourcesCount = 0;
var _processedMediaResourcesCount = 0;

@Riverpod(keepAlive: true)
class MediaResourcesStateNotifier extends _$MediaResourcesStateNotifier {
  @override
  MediaResourcesState build() {
    return MediaResourcesState();
  }

  void toggleIsMultipleSelection() {
    state = state.copyWith(isMultipleSelection: !state.isMultipleSelection);
  }

  void _clearState() {
    state = MediaResourcesState();
    _mediaResourcesCount = 0;
    _processedMediaResourcesCount = 0;
  }

  Future<void> loadMediaResourcesFromDir(
      String resourcesPath, bool isDebugMode, int cpuThreads, Sort sort) async {
    _clearState();
    state = state.copyWith(
      isLoading: true,
      resourcesPath: resourcesPath,
    );
    final mediaResourcesDir = Directory(resourcesPath);
    if (!mediaResourcesDir.existsSync()) {
      _clearState();
      return;
    }
    if (isDebugMode) {
      await Logger.enableFileOutput('$resourcesPath/$logFolderName');
    }

    stopwatch.reset();
    stopwatch.start();

    _prepareThumbnailFolder(resourcesPath);

    final classifyResult =
        _classifyMediaResources(mediaResourcesDir.listSync());

    Logger.debug('classifyTime: ${stopwatch.elapsedMilliseconds}ms');

    final List<File> photos = classifyResult[0];
    var processedPhotos = <MediaResource>[];
    final List<File> videos = classifyResult[1];
    var processedVideos = <MediaResource>[];

    Logger.debug('photos: ${photos.length}');
    Logger.debug('videos: ${videos.length}');

    processedPhotos = await _multiThreadProcess(
        mediaResourceFiles: photos,
        processFunc: _photoResourceProcess,
        cpuThreads: cpuThreads);
    processedPhotos.sort((a, b) => a.name.compareTo(b.name));
    processedPhotos = await _analyzeAebFootage(processedPhotos);
    Logger.debug('processedPhotos: ${processedPhotos.length}');
    Logger.debug('Photo processTime: ${stopwatch.elapsedMilliseconds}ms');

    processedVideos = await _multiThreadProcess(
        mediaResourceFiles: videos,
        processFunc: _videoResourceProcess,
        cpuThreads: cpuThreads);
    Logger.debug('processedVideos: ${processedVideos.length}');
    Logger.debug('Video processTime: ${stopwatch.elapsedMilliseconds}ms');

    final mediaResources = [...processedPhotos, ...processedVideos];

    final sortType = sort.sortType;
    final sortAsc = sort.sortAsc;

    switch (sortType) {
      case SortType.name:
        mediaResources.sort((a, b) =>
            sortAsc ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case SortType.date:
        mediaResources.sort((a, b) => sortAsc
            ? a.creationTime.compareTo(b.creationTime)
            : b.creationTime.compareTo(a.creationTime));
        break;
      case SortType.size:
        mediaResources.sort((a, b) => sortAsc
            ? a.sizeInBytes.compareTo(b.sizeInBytes)
            : b.sizeInBytes.compareTo(a.sizeInBytes));
        break;
      case SortType.sequence:
        mediaResources.sort((a, b) => sortAsc
            ? a.sequence.compareTo(b.sequence)
            : b.sequence.compareTo(a.sequence));
        break;
    }

    Logger.debug("sortTime: ${stopwatch.elapsedMilliseconds}ms");
    stopwatch.stop();

    state = state.copyWith(
      resources: mediaResources,
      isLoading: false,
    );
  }

  void setCurrentResourceIndex(int index) {
    if (index < state.resources.length) {
      state = state.copyWith(currentResourceIndex: index);
      if (state.resources[index] is AebPhotoResource) {
        state = state.copyWith(currentAebIndex: 0);
      }
    }
  }

  void increaseCurrentResourceIndex() {
    if (state.currentResourceIndex < state.resources.length - 1) {
      setCurrentResourceIndex(state.currentResourceIndex + 1);
    }
  }

  void decreaseCurrentResourceIndex() {
    if (state.currentResourceIndex > 0) {
      setCurrentResourceIndex(state.currentResourceIndex - 1);
    }
  }

  void setCurrentAebIndex(int index) {
    if (state.resources[state.currentResourceIndex] is AebPhotoResource) {
      if (index <
          (state.resources[state.currentResourceIndex] as AebPhotoResource)
              .aebResources
              .length) {
        state = state.copyWith(currentAebIndex: index);
      }
    }
  }

  void increaseCurrentAebIndex() {
    if (state.resources[state.currentResourceIndex] is AebPhotoResource) {
      if (state.currentAebIndex <
          (state.resources[state.currentResourceIndex] as AebPhotoResource)
                  .aebResources
                  .length -
              1) {
        setCurrentAebIndex(state.currentAebIndex + 1);
      }
    }
  }

  void decreaseCurrentAebIndex() {
    if (state.resources[state.currentResourceIndex] is AebPhotoResource) {
      if (state.currentAebIndex > 0) {
        setCurrentAebIndex(state.currentAebIndex - 1);
      }
    }
  }

  void clearSelectedResources() {
    state = state.copyWith(selectedResources: []);
  }

  void addSelectedResource(MediaResource mediaResource) {
    state = state.copyWith(
      selectedResources: [...state.selectedResources, mediaResource],
    );
  }

  void removeSelectedResource(MediaResource mediaResource) {
    state = state.copyWith(
      selectedResources:
          state.selectedResources.where((e) => e != mediaResource).toList(),
    );
  }

  void sortMediaResources(Sort sort) {
    final resources = state.resources.toList();

    switch (sort.sortType) {
      case SortType.name:
        // state.resources.sort((a, b) =>
        //     sort.sortAsc ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        resources.sort((a, b) =>
            sort.sortAsc ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case SortType.date:
        resources.sort((a, b) => sort.sortAsc
            ? a.creationTime.compareTo(b.creationTime)
            : b.creationTime.compareTo(a.creationTime));
        break;
      case SortType.size:
        resources.sort((a, b) => sort.sortAsc
            ? a.sizeInBytes.compareTo(b.sizeInBytes)
            : b.sizeInBytes.compareTo(a.sizeInBytes));
        break;
      case SortType.sequence:
        resources.sort((a, b) => sort.sortAsc
            ? a.sequence.compareTo(b.sequence)
            : b.sequence.compareTo(a.sequence));
        break;
    }
    state = state.copyWith(resources: resources);
  }

  Future<List<MediaResource>> _multiThreadProcess(
      {required List<File> mediaResourceFiles,
      required Future<MediaResource?> Function(File mediaResourceFile)
          processFunc,
      required int cpuThreads}) async {
    final mediaResources = <MediaResource>[];
    final pool = _Pool(cpuThreads);
    final tasks = mediaResourceFiles.map((file) {
      return pool.run(() async {
        final mediaResource = await processFunc(file);
        if (mediaResource != null) {
          mediaResources.add(mediaResource);
          _processedMediaResourcesCount++;
          state = state.copyWith(
              loadProgress:
                  _processedMediaResourcesCount / _mediaResourcesCount);
          Logger.debug(
              '${file.uri.pathSegments.last} processed | loadProgress: ${_processedMediaResourcesCount / _mediaResourcesCount}');
        }
      });
    });

    await Future.wait(tasks);

    return mediaResources;
  }

  void reorderSelectedResources(
      {required int oldIndex, required int newIndex}) {
    if (oldIndex < newIndex) newIndex -= 1;
    final updated = [...(state.selectedResources)];
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    state = state.copyWith(selectedResources: updated);
  }

  Future<void> _deleteResource(MediaResource mediaResource) async {
    final mediaResourceIndex = state.resources.indexOf(mediaResource);
    if (mediaResourceIndex != -1) {
      if (mediaResourceIndex == state.currentResourceIndex) {
        if (mediaResourceIndex != 0 &&
            (mediaResourceIndex == state.resources.length - 1)) {
          setCurrentResourceIndex(state.currentResourceIndex - 1);
        }
      }
      state = state.copyWith(
        resources: state.resources.where((e) => e != mediaResource).toList(),
      );
      switch (mediaResource) {
        case PhotoResource():
        case VideoResource():
          try {
            await mediaResource.file.delete();
          } catch (e) {
            Logger.error(
                'Delete media resource ${mediaResource.file.uri.pathSegments.last} failed: $e');
            Toast.error(
                'Delete media resource ${mediaResource.file.uri.pathSegments.last} failed: $e');
          }
          if (mediaResource is VideoResource) {
            try {
              await mediaResource.thumbFile.delete();
            } catch (e) {
              Logger.error(
                  'Delete media resource thumbnail ${mediaResource.thumbFile.uri.pathSegments.last} failed: $e');
              Toast.error(
                  'Delete media resource thumbnail ${mediaResource.thumbFile.uri.pathSegments.last} failed: $e');
            }
          }
          break;
        case AebPhotoResource():
          for (final aebResource in mediaResource.aebResources) {
            try {
              await aebResource.file.delete();
            } catch (e) {
              Logger.error(
                  'Delete media resource ${aebResource.file.uri.pathSegments.last} failed: $e');
              Toast.error(
                  'Delete media resource ${aebResource.file.uri.pathSegments.last} failed: $e');
            }
          }
          break;
      }
    }
  }

  Future<void> deleteCurrentMediaResource() async {
    if (state.currentResourceIndex != -1) {
      await _deleteResource(state.resources[state.currentResourceIndex]);
    }
  }

  Future<void> deleteSelectedMediaResources() async {
    for (final mediaResource in state.selectedResources) {
      await _deleteResource(mediaResource);
    }
  }
}

void _prepareThumbnailFolder(String mediaResourcesPath) {
  if (!Directory('$mediaResourcesPath/$thumbnailFolderName').existsSync()) {
    Directory('$mediaResourcesPath/$thumbnailFolderName').createSync();
    Logger.debug('Create thumb folder');
  } else {
    Directory('$mediaResourcesPath/$thumbnailFolderName')
        .listSync()
        .forEach((file) {
      file.deleteSync();
    });
    Logger.debug('Clear thumb folder');
  }
}

bool _isPhoto(Uri uri) {
  final ext = uri.path.split('.').last.toUpperCase();
  // return ext == 'JPG' || ext == 'DNG';
  return ext == 'JPG';
}

bool _isVideo(Uri uri) {
  final ext = uri.path.split('.').last.toUpperCase();
  return ext == 'MP4';
}

List<List<File>> _classifyMediaResources(List<FileSystemEntity> files) {
  final List<File> photos = [];
  final List<File> videos = [];
  for (final file in files) {
    if (file is File) {
      if (_isPhoto(file.uri)) {
        photos.add(file);
        _mediaResourcesCount++;
      } else if (_isVideo(file.uri)) {
        videos.add(file);
        _mediaResourcesCount++;
      }
    }
  }
  return [photos, videos];
}

class _Pool {
  final int max;
  int _running = 0;
  final _queue = <Future Function()>[];

  _Pool(this.max);

  Future<T> run<T>(Future<T> Function() task) {
    final completer = Completer<T>();
    _queue.add(() async {
      try {
        completer.complete(await task());
      } catch (e, st) {
        completer.completeError(e, st);
      } finally {
        _running--;
        _next();
      }
    });
    _next();
    return completer.future;
  }

  void _next() {
    if (_running >= max || _queue.isEmpty) return;
    _running++;
    _queue.removeAt(0)();
  }
}

DateTime _getMediaCreationTime(File file) {
  RegExp regex = RegExp(r'DJI_(\d{14})_(\d{4})_D');

  Match? match = regex.firstMatch(file.uri.pathSegments.last);

  if (match != null) {
    try {
      return DateTime.parse(
          ('${match.group(1)!.substring(0, 8)}T${match.group(1)!.substring(8)}'));
    } catch (e) {
      Toast.error(
          'Failed to parse ${file.uri.pathSegments.last} creation time');
      Logger.warn(
          '${file.uri.pathSegments.last} parse creation time error: $e');
    }
  }
  return DateTime(0);
}

int _getMediaSequence(File file) {
  RegExp regex = RegExp(r'DJI_(\d{14})_(\d{4})_D');

  Match? match = regex.firstMatch(file.uri.pathSegments.last);

  if (match != null) {
    try {
      return int.parse(match.group(2)!);
    } catch (e) {
      Toast.error('Failed to parse ${file.uri.pathSegments.last} sequence');
      Logger.warn('${file.uri.pathSegments.last} parse sequence error: $e');
    }
  }
  return 0;
}

Map<String, dynamic> _getGenericMediaResourceInfo(File file) {
  final Map<int, List<String>> errors = {};
  final creationTimeResult = _getMediaCreationTime(file);
  if (creationTimeResult == DateTime(0)) {
    errors[parseMediaResourceErrorCode] = [parseMediaResourceTimeError];
  }
  final creationTime = creationTimeResult == DateTime(0)
      ? file.lastModifiedSync()
      : creationTimeResult;

  final sequence = _getMediaSequence(file);
  if (sequence == 0) {
    if (errors.containsKey(parseMediaResourceErrorCode)) {
      errors[parseMediaResourceErrorCode]!.add(parseMediaResourceSequenceError);
    } else {
      errors[parseMediaResourceErrorCode] = [parseMediaResourceSequenceError];
    }
  }

  return {
    'creationTime': creationTime,
    'sequence': sequence,
    'errors': errors,
  };
}

bool _isAebImage(Image image) {
  if (image.exif.imageIfd.containsKey(0x9C9E)) {
    final keyWords = image.exif.imageIfd[0x9C9E]?.toData();
    if (keyWords != null &&
        keyWords.length == 6 &&
        keyWords[0] == 97 &&
        keyWords[1] == 0 &&
        keyWords[2] == 101 &&
        keyWords[3] == 0 &&
        keyWords[4] == 98 &&
        keyWords[5] == 0) {
      return true;
    }
  }
  return false;
}

String _getEvBiasString(String rawEv) {
  if (rawEv == '0/10') {
    return '0';
  } else if (rawEv == '-7/10') {
    return '-0.7';
  } else if (rawEv == '7/10') {
    return '+0.7';
  } else if (rawEv == '-13/10') {
    return '-1.3';
  } else if (rawEv == '13/10') {
    return '+1.3';
  } else if (rawEv == '-20/10') {
    return '-2';
  } else if (rawEv == '20/10') {
    return '+2';
  } else {
    return '';
  }
}

String _parseEvBias(Image image) {
  final evBias = image.exif.exifIfd[0x9204]?.toString();
  if (evBias != null) {
    return _getEvBiasString(evBias);
  }
  return '';
}

Future<MediaResource?> _photoResourceProcess(File mediaResourceFile) async {
  final Map<String, dynamic> info =
      _getGenericMediaResourceInfo(mediaResourceFile);
  final creationTime = info['creationTime'];
  final sequence = info['sequence'];
  final errors = info['errors'];

  Image? image;
  try {
    image = await compute(decodeJpgFile, mediaResourceFile.path);
  } catch (e) {
    Logger.error("${mediaResourceFile.uri.pathSegments.last} decode error: $e",
        e, StackTrace.current);
    errors[parseMediaResourceErrorCode] = parseImageError;
    return null;
  }
  if (image == null) {
    Logger.error(
        "${mediaResourceFile.uri.pathSegments.last} decode error: null",
        null,
        StackTrace.current);
    errors[parseMediaResourceErrorCode] = parseImageError;
    return null;
  }
  final width = image.width;
  final height = image.height;
  final sizeInBytes = image.lengthInBytes;
  final isAeb = _isAebImage(image);

  late final MediaResource resource;

  if (isAeb) {
    final evBias = _parseEvBias(image);
    resource = AebPhotoResource(
      name: mediaResourceFile.uri.pathSegments.last,
      file: mediaResourceFile,
      width: width,
      height: height,
      sizeInBytes: sizeInBytes,
      creationTime: creationTime,
      sequence: sequence,
      evBias: evBias,
      thumbFile: mediaResourceFile,
      hide: false,
      errors: errors,
      aebResources: [],
    );
  } else {
    resource = PhotoResource(
      name: mediaResourceFile.uri.pathSegments.last,
      file: mediaResourceFile,
      width: width,
      height: height,
      sizeInBytes: sizeInBytes,
      creationTime: creationTime,
      sequence: sequence,
      thumbFile: mediaResourceFile,
      hide: false,
      errors: errors,
    );
  }
  return resource;
}

Future<MediaResource?> _videoResourceProcess(File mediaResourceFile) async {
  final Map<String, dynamic> info =
      _getGenericMediaResourceInfo(mediaResourceFile);
  final creationTime = info['creationTime'];
  final sequence = info['sequence'];
  final errors = info['errors'];

  final ffprobeOutput = await _ffprobeVideoInfo(mediaResourceFile);
  if (ffprobeOutput == null) {
    return null;
  }

  try {
    final sizeInBytes = int.parse(ffprobeOutput['format']['size']);
    final frameRate = double.parse(
            ffprobeOutput['streams'][0]['avg_frame_rate'].split('/')[0]) /
        double.parse(
            ffprobeOutput['streams'][0]['avg_frame_rate'].split('/')[1]);
    final duration = double.parse(ffprobeOutput['format']['duration']);
    final isHevc = ffprobeOutput['streams'][0]['codec_name'] == 'hevc';
    late int rotation;
    try {
      rotation =
          ffprobeOutput['streams'][0]['side_data_list'][0]['rotation'] ?? 0;
    } catch (e) {
      rotation = 0;
    }
    late int width;
    late int height;
    if (rotation == 90 || rotation == 270) {
      width = ffprobeOutput['streams'][0]['height'];
      height = ffprobeOutput['streams'][0]['width'];
    } else {
      width = ffprobeOutput['streams'][0]['width'];
      height = ffprobeOutput['streams'][0]['height'];
    }
    final thumbFile = await compute(
        _generateThumbnail, [mediaResourceFile.path, FFmpegUtils.ffmpeg]);
    if (thumbFile == null) {
      Logger.warn(
          '${mediaResourceFile.uri.pathSegments.last} generate thumbnail error');
    }
    final resource = VideoResource(
      name: mediaResourceFile.uri.pathSegments.last,
      file: mediaResourceFile,
      width: width,
      height: height,
      sizeInBytes: sizeInBytes,
      creationTime: creationTime,
      sequence: sequence,
      frameRate: frameRate,
      duration: Duration(microseconds: (duration * 1000000).toInt()),
      isHevc: isHevc,
      thumbFile:
          thumbFile ?? File('assets/common/images/resource_not_found.jpeg'),
      errors: errors,
      hide: false,
    );

    return resource;
  } catch (e) {
    Toast.error(
        'Failed to parse ${mediaResourceFile.uri.pathSegments.last} video info');
    Logger.warn(
        '${mediaResourceFile.uri.pathSegments.last} parse video info error: $e');
  }

  return null;
}

Future<Map<String, dynamic>?> _ffprobeVideoInfo(File file) async {
  final result = await Process.run(FFmpegUtils.ffprobe, [
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
  if (result.exitCode != 0) {
    Logger.warn(
        '${file.uri.pathSegments.last} ffprobe error: ${result.stderr}');
    return null;
  } else {
    final Map<String, dynamic> ffprobeOutput = json.decode(result.stdout);
    return ffprobeOutput;
  }
}

Future<File?> _generateThumbnail(List<String> args) async {
  final file = File(args[0]);
  final ffmpegPath = args[1];
  final mediaResourcesPath = file.parent.path;
  final videoResourceName = file.uri.pathSegments.last;
  final thumbFileName =
      '$mediaResourcesPath/$thumbnailFolderName/${videoResourceName.replaceAll('MP4', 'thumb')}.JPG';
  final result = await Process.run(ffmpegPath, [
    '-i',
    '$mediaResourcesPath/$videoResourceName',
    '-ss',
    '00:00:00.001',
    '-vframes',
    '1',
    // 添加严格标准合规性参数，允许非标准YUV范围
    '-strict',
    'unofficial',
    thumbFileName,
  ]);
  if (result.exitCode != 0) {
    // Toast.error('Failed to generate thumbnail for $videoResourceName');
    Logger.warn(
        '$videoResourceName generate thumbnail error: ${result.stderr}');
    return null;
  } else {
    Logger.debug('$videoResourceName generate thumbnail success');
    return File(thumbFileName);
  }
}

Future<List<MediaResource>> _analyzeAebFootage(
    List<MediaResource> mediaResources) async {
  if (mediaResources.isNotEmpty) {
    for (var i = 0; i < mediaResources.length;) {
      if (mediaResources[i] is VideoResource) {
        i++;
        continue;
      }
      if (mediaResources[i] is AebPhotoResource) {
        // final startResource = mediaResources[i] as AebPhotoResource;
        final startIndex = i;
        if ((mediaResources[i] as AebPhotoResource).evBias == '0') {
          mediaResources[startIndex] = (mediaResources[startIndex]
                  as AebPhotoResource)
              .copyWith(aebResources: [mediaResources[i] as AebPhotoResource]);
          Logger.debug('${mediaResources[startIndex].name}: 0 found');
          i++;
          if (i >= mediaResources.length) {
            break;
          }
          if (mediaResources[i] is AebPhotoResource &&
              (mediaResources[i] as AebPhotoResource).evBias == '-0.7') {
            // mediaResources[startIndex].aebResources
            //     .add(mediaResources[i] as AebPhotoResource);
            mediaResources[startIndex] =
                (mediaResources[startIndex] as AebPhotoResource).copyWith(
                    aebResources:
                        (mediaResources[startIndex] as AebPhotoResource)
                                .aebResources +
                            [mediaResources[i] as AebPhotoResource]);
            mediaResources[i] = mediaResources[i].copyWith(hide: true);
            Logger.debug('${mediaResources[startIndex].name}: -0.7 found');
            i++;
            if (i >= mediaResources.length) {
              break;
            }
            if (mediaResources[i] is AebPhotoResource &&
                (mediaResources[i] as AebPhotoResource).evBias == '+0.7') {
              mediaResources[startIndex] =
                  (mediaResources[startIndex] as AebPhotoResource).copyWith(
                      aebResources:
                          (mediaResources[startIndex] as AebPhotoResource)
                                  .aebResources +
                              [mediaResources[i] as AebPhotoResource]);
              mediaResources[i] = mediaResources[i].copyWith(hide: true);
              Logger.debug('${mediaResources[startIndex].name}: +0.7 found');
              i++;
              if (i >= mediaResources.length) {
                break;
              }
              if (mediaResources[i] is AebPhotoResource &&
                  (mediaResources[i] as AebPhotoResource).evBias == '-1.3') {
                mediaResources[startIndex] =
                    (mediaResources[startIndex] as AebPhotoResource).copyWith(
                        aebResources:
                            (mediaResources[startIndex] as AebPhotoResource)
                                    .aebResources +
                                [mediaResources[i] as AebPhotoResource]);
                mediaResources[i] = mediaResources[i].copyWith(hide: true);
                Logger.debug('${mediaResources[startIndex].name}: -1.3 found');
                i++;
                if (i >= mediaResources.length) {
                  break;
                }
                if (mediaResources[i] is AebPhotoResource &&
                    (mediaResources[i] as AebPhotoResource).evBias == '+1.3') {
                  mediaResources[startIndex] =
                      (mediaResources[startIndex] as AebPhotoResource).copyWith(
                          aebResources:
                              (mediaResources[startIndex] as AebPhotoResource)
                                      .aebResources +
                                  [mediaResources[i] as AebPhotoResource]);
                  mediaResources[i] = mediaResources[i].copyWith(hide: true);
                  Logger.debug(
                      '${mediaResources[startIndex].name}: +1.3 found');
                  i++;
                  if (i >= mediaResources.length) {
                    break;
                  }
                  if (mediaResources[i] is AebPhotoResource &&
                      (mediaResources[i] as AebPhotoResource).evBias == '-2') {
                    mediaResources[startIndex] = (mediaResources[startIndex]
                            as AebPhotoResource)
                        .copyWith(
                            aebResources:
                                (mediaResources[startIndex] as AebPhotoResource)
                                        .aebResources +
                                    [mediaResources[i] as AebPhotoResource]);
                    mediaResources[i] = mediaResources[i].copyWith(hide: true);
                    Logger.debug(
                        '${mediaResources[startIndex].name}: -2 found');
                    i++;
                    if (i >= mediaResources.length) {
                      break;
                    }
                    if (mediaResources[i] is AebPhotoResource &&
                        (mediaResources[i] as AebPhotoResource).evBias ==
                            '+2') {
                      mediaResources[startIndex] =
                          (mediaResources[startIndex] as AebPhotoResource)
                              .copyWith(
                                  aebResources: (mediaResources[startIndex]
                                              as AebPhotoResource)
                                          .aebResources +
                                      [mediaResources[i] as AebPhotoResource]);
                      mediaResources[i] =
                          mediaResources[i].copyWith(hide: true);
                      Logger.debug(
                          '${mediaResources[startIndex].name}: +2 found');
                      i++;
                      if (i >= mediaResources.length) {
                        break;
                      }
                      continue;
                    } else {
                      mediaResources[startIndex] =
                          (mediaResources[startIndex] as AebPhotoResource)
                              .copyWith(errors: {
                        parseAebErrorCode: [parseAebEndError]
                      });
                      continue;
                    }
                  } else {
                    continue;
                  }
                } else {
                  mediaResources[startIndex] =
                      (mediaResources[startIndex] as AebPhotoResource)
                          .copyWith(errors: {
                    parseAebErrorCode: [parseAebEndError]
                  });
                  continue;
                }
              } else {
                continue;
              }
            } else {
              mediaResources[startIndex] =
                  (mediaResources[startIndex] as AebPhotoResource)
                      .copyWith(errors: {
                parseAebErrorCode: [parseAebEndError]
              });
              continue;
            }
          } else {
            mediaResources[startIndex] =
                (mediaResources[startIndex] as AebPhotoResource)
                    .copyWith(errors: {
              parseAebErrorCode: [parseAebEndError]
            });
            continue;
          }
        }
        mediaResources[i] =
            (mediaResources[i] as AebPhotoResource).copyWith(errors: {
          parseAebErrorCode: [parseAebStartError]
        });
      }
      i++;
    }
  }
  mediaResources.removeWhere((element) => element.hide);
  return mediaResources;
}

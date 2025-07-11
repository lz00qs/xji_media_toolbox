import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:xji_footage_toolbox/models/settings.dart';
import 'package:xji_footage_toolbox/service/log_service.dart';
import 'package:xji_footage_toolbox/utils/ffmpeg_utils.dart';
import 'package:xji_footage_toolbox/utils/toast.dart';

import '../constants.dart';
import '../models/media_resource.dart';

final _mediaResources = <MediaResource>[];
var _mediaResourcesCount = 0;
var _processedMediaResourcesCount = 0;
final stopwatch = Stopwatch();

bool _isPhoto(Uri uri) {
  final ext = uri.path.split('.').last.toUpperCase();
  return ext == 'JPG' || ext == 'DNG';
}

bool _isVideo(Uri uri) {
  final ext = uri.path.split('.').last.toUpperCase();
  return ext == 'MP4';
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
      LogService.warning(
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
      LogService.warning(
          '${file.uri.pathSegments.last} parse sequence error: $e');
    }
  }
  return 0;
}

String _getEvBiasString(String rawEv){
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

Future<Map<String, dynamic>?> _ffprobeVideoInfo(File file) async {
  // Get.find<GlobalSettingsController>();
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
    LogService.warning(
        '${file.uri.pathSegments.last} ffprobe error: ${result.stderr}');
    return null;
  } else {
    final Map<String, dynamic> ffprobeOutput = json.decode(result.stdout);
    return ffprobeOutput;
  }
}

void _prepareThumbnailFolder(String mediaResourcesPath) {
  if (!Directory('$mediaResourcesPath/$thumbnailFolderName').existsSync()) {
    Directory('$mediaResourcesPath/$thumbnailFolderName').createSync();
    LogService.info('Create thumb folder');
  } else {
    Directory('$mediaResourcesPath/$thumbnailFolderName')
        .listSync()
        .forEach((file) {
      file.deleteSync();
    });
    LogService.info('Clear thumb folder');
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
    '00:00:01.000',
    '-vframes',
    '1',
    thumbFileName,
  ]);
  if (result.exitCode != 0) {
    Toast.error('Failed to generate thumbnail for $videoResourceName');
    LogService.warning(
        '$videoResourceName generate thumbnail error: ${result.stderr}');
    return null;
  } else {
    LogService.info('$videoResourceName generate thumbnail success');
    return File(thumbFileName);
  }
}

Future<List<MediaResource>> _analyzeAebFootage(
    List<MediaResource> mediaResources) async {
  if (mediaResources.isNotEmpty) {
    for (var i = 0; i < mediaResources.length;) {
      if (mediaResources[i].isVideo) {
        i++;
        continue;
      }
      if (mediaResources[i] is AebPhotoResource) {
        final startResource = mediaResources[i] as AebPhotoResource;
        if ((mediaResources[i] as AebPhotoResource).evBias == '0') {
          (mediaResources[i] as AebPhotoResource)
              .aebResources
              .add(mediaResources[i] as AebPhotoResource);
          LogService.info('${startResource.name}: 0 found');
          i++;
          if (i >= mediaResources.length) {
            break;
          }
          if (mediaResources[i].isAeb &&
              (mediaResources[i] as AebPhotoResource).evBias == '-0.7') {
            startResource.aebResources.add(mediaResources[i] as AebPhotoResource);
            mediaResources[i].hide = true;
            LogService.info('${startResource.name}: -0.7 found');
            i++;
            if (i >= mediaResources.length) {
              break;
            }
            if (mediaResources[i].isAeb &&
                (mediaResources[i] as AebPhotoResource).evBias == '+0.7') {
              startResource.aebResources.add(mediaResources[i] as AebPhotoResource);
              mediaResources[i].hide = true;
              LogService.info('${startResource.name}: +0.7 found');
              i++;
              if (i >= mediaResources.length) {
                break;
              }
              if (mediaResources[i].isAeb &&
                  (mediaResources[i] as AebPhotoResource).evBias == '-1.3') {
                startResource.aebResources.add(mediaResources[i] as AebPhotoResource);
                mediaResources[i].hide = true;
                LogService.info('${startResource.name}: -1.3 found');
                i++;
                if (i >= mediaResources.length) {
                  break;
                }
                if (mediaResources[i].isAeb &&
                    (mediaResources[i] as AebPhotoResource).evBias == '+1.3') {
                  startResource.aebResources.add(mediaResources[i] as AebPhotoResource);
                  mediaResources[i].hide = true;
                  LogService.info('${startResource.name}: +1.3 found');
                  i++;
                  if (i >= mediaResources.length) {
                    break;
                  }
                  if (mediaResources[i].isAeb &&
                      (mediaResources[i] as AebPhotoResource).evBias ==
                          '-2') {
                    startResource.aebResources.add(mediaResources[i] as AebPhotoResource);
                    mediaResources[i].hide = true;
                    LogService.info('${startResource.name}: -2 found');
                    i++;
                    if (i >= mediaResources.length) {
                      break;
                    }
                    if (mediaResources[i].isAeb &&
                        (mediaResources[i] as AebPhotoResource).evBias ==
                            '+2') {
                      startResource.aebResources.add(mediaResources[i] as AebPhotoResource);
                      mediaResources[i].hide = true;
                      LogService.info('${startResource.name}: +2 found');
                      i++;
                      if (i >= mediaResources.length) {
                        break;
                      }
                      continue;
                    } else {
                      startResource.errors[parseAebErrorCode] = [
                        parseAebEndError
                      ];
                      continue;
                    }
                  } else {
                    continue;
                  }
                } else {
                  startResource.errors[parseAebErrorCode] = [parseAebEndError];
                  continue;
                }
              } else {
                continue;
              }
            } else {
              startResource.errors[parseAebErrorCode] = [parseAebEndError];
              continue;
            }
          } else {
            startResource.errors[parseAebErrorCode] = [parseAebEndError];
            continue;
          }
        }
        mediaResources[i].errors[parseAebErrorCode] = [parseAebStartError];
      }
      i++;
    }
  }
  mediaResources.removeWhere((element) => element.hide);
  return mediaResources;
}

List<List<File>> _classifyMediaResources(List<FileSystemEntity> files) {
  final List<File> photos = [];
  final List<File> videos = [];
  _mediaResourcesCount = 0;
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

Future<List<MediaResource>> _photoResourcesProcess(
    {required List<File> files, required WidgetRef ref}) async {
  final mediaResources = <MediaResource>[];
  for (final file in files) {
    final Map<String, dynamic> info = _getGenericMediaResourceInfo(file);
    final creationTime = info['creationTime'];
    final sequence = info['sequence'];
    final errors = info['errors'];

    final image = await compute(decodeJpgFile, file.path);
    if (image == null) {
      continue;
    }
    final width = image.width;
    final height = image.height;
    final sizeInBytes = image.lengthInBytes;
    final isAeb = _isAebImage(image);

    if (isAeb) {
      final evBias = _parseEvBias(image);
      final resource = AebPhotoResource(
        name: file.uri.pathSegments.last,
        file: file,
        width: width,
        height: height,
        sizeInBytes: sizeInBytes,
        creationTime: creationTime,
        sequence: sequence,
        evBias: evBias,
      )..thumbFile = file;
      resource.errors.addAll(errors);
      mediaResources.add(resource);
    } else {
      final resource = NormalPhotoResource(
        name: file.uri.pathSegments.last,
        file: file,
        width: width,
        height: height,
        sizeInBytes: sizeInBytes,
        creationTime: creationTime,
        sequence: sequence,
      )..thumbFile = file;
      resource.errors.addAll(errors);
      mediaResources.add(resource);
    }
    _processedMediaResourcesCount += 1;
    ref
        .read(mediaResourcesProvider.notifier)
        .setLoadProgress(_processedMediaResourcesCount / _mediaResourcesCount);
  }
  return mediaResources;
}

Future<List<MediaResource>> _videoResourcesProcess(
    {required List<File> files, required WidgetRef ref}) async {
  final mediaResources = <MediaResource>[];
  for (final file in files) {
    final Map<String, dynamic> info = _getGenericMediaResourceInfo(file);
    final creationTime = info['creationTime'];
    final sequence = info['sequence'];
    final errors = info['errors'];

    final ffprobeOutput = await _ffprobeVideoInfo(file);
    if (ffprobeOutput == null) {
      continue;
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
      final thumbFile =
          await compute(_generateThumbnail, [file.path, FFmpegUtils.ffmpeg]);
      final resource = NormalVideoResource(
        name: file.uri.pathSegments.last,
        file: file,
        width: width,
        height: height,
        sizeInBytes: sizeInBytes,
        creationTime: creationTime,
        sequence: sequence,
        frameRate: frameRate,
        duration: Duration(microseconds: (duration * 1000000).toInt()),
        isHevc: isHevc,
      )..thumbFile = thumbFile;
      resource.errors.addAll(errors);
      mediaResources.add(resource);
    } catch (e) {
      Toast.error('Failed to parse ${file.uri.pathSegments.last} video info');
      LogService.warning(
          '${file.uri.pathSegments.last} parse video info error: $e');
    }
    _processedMediaResourcesCount += 1;
    ref
        .read(mediaResourcesProvider.notifier)
        .setLoadProgress(_processedMediaResourcesCount / _mediaResourcesCount);
  }
  return mediaResources;
}

Future<List<MediaResource>> _multiThreadsProcessResources(
    {required List<File> mediaResourceFiles,
    required Future<List<MediaResource>> Function(
            {required List<File> files, required WidgetRef ref})
        processFunction,
    required WidgetRef ref}) async {
  final mediaResources = <MediaResource>[];
  if (mediaResourceFiles.length > 1) {
    final cpuThreads =
        ref.watch(settingsProvider.select((state) => state.cpuThreads));
    if (mediaResourceFiles.length > cpuThreads) {
      final chunkSize = (mediaResourceFiles.length / cpuThreads).ceil();
      final chunks = <List<File>>[];
      for (var i = 0; i < mediaResourceFiles.length; i += chunkSize) {
        chunks.add(mediaResourceFiles.sublist(
            i,
            i + chunkSize > mediaResourceFiles.length
                ? mediaResourceFiles.length
                : i + chunkSize));
      }
      final futures = <Future<List<MediaResource>>>[];
      for (final chunk in chunks) {
        futures.add(processFunction(files: chunk, ref: ref));
      }
      for (final future in futures) {
        final result = await future;
        mediaResources.addAll(result);
        if (kDebugMode) {
          print(
              'progress: ${ref.watch(mediaResourcesProvider.select((state) => state.loadProgress))}');
        }
      }
    } else {
      final futures = <Future<List<MediaResource>>>[];
      for (final mediaResourceFile in mediaResourceFiles) {
        futures.add(processFunction(files: [mediaResourceFile], ref: ref));
      }
      for (final future in futures) {
        final result = await future;
        mediaResources.addAll(result);
        if (kDebugMode) {
          print(
              'progress: ${ref.watch(mediaResourcesProvider.select((state) => state.loadProgress))}');
        }
      }
    }
  } else {
    mediaResources
        .addAll(await processFunction(files: mediaResourceFiles, ref: ref));
    if (kDebugMode) {
      print(
          'progress: ${ref.watch(mediaResourcesProvider.select((state) => state.loadProgress))}');
    }
  }
  return mediaResources;
}

Future<List<MediaResource>> loadMediaResources(
    {required Directory mediaResourcesDir, required WidgetRef ref}) async {
  _mediaResources.clear();
  _prepareThumbnailFolder(mediaResourcesDir.path);
  _processedMediaResourcesCount = 0;
  final classifyResult = _classifyMediaResources(mediaResourcesDir.listSync());
  LogService.info('classifyTime: ${stopwatch.elapsedMilliseconds}ms');

  final List<File> photos = classifyResult[0];
  var processedPhotos = <MediaResource>[];
  final List<File> videos = classifyResult[1];
  var processedVideos = <MediaResource>[];

  processedPhotos = await _multiThreadsProcessResources(
      mediaResourceFiles: photos,
      processFunction: _photoResourcesProcess,
      ref: ref);
  processedPhotos.sort((a, b) => a.sequence.compareTo(b.sequence));
  LogService.info('photoProcessTime: ${stopwatch.elapsedMilliseconds}ms');
  processedPhotos = await _analyzeAebFootage(processedPhotos);
  processedVideos = await _multiThreadsProcessResources(
      mediaResourceFiles: videos,
      processFunction: _videoResourcesProcess,
      ref: ref);
  LogService.info('videoProcessTime: ${stopwatch.elapsedMilliseconds}ms');

  _mediaResources.addAll(processedPhotos);
  _mediaResources.addAll(processedVideos);

  final sortType =
      ref.watch(settingsProvider.select((state) => state.sortType));
  final sortOrder =
      ref.watch(settingsProvider.select((state) => state.sortAsc));
  switch (sortType) {
    case SortType.name:
      _mediaResources.sort((a, b) =>
          sortOrder ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
      break;
    case SortType.date:
      _mediaResources.sort((a, b) => sortOrder
          ? a.creationTime.compareTo(b.creationTime)
          : b.creationTime.compareTo(a.creationTime));
      break;
    case SortType.size:
      _mediaResources.sort((a, b) => sortOrder
          ? a.sizeInBytes.compareTo(b.sizeInBytes)
          : b.sizeInBytes.compareTo(a.sizeInBytes));
      break;
    case SortType.sequence:
      _mediaResources.sort((a, b) => sortOrder
          ? a.sequence.compareTo(b.sequence)
          : b.sequence.compareTo(a.sequence));
      break;
  }

  LogService.info('sortTime: ${stopwatch.elapsedMilliseconds}ms');

  return _mediaResources;
}

Future<void> openMediaResourcesFolder({required WidgetRef ref}) async {
  final selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory != null) {
    final mediaResourcesDir = Directory(selectedDirectory);
    if (LogService.isDebug) {
      LogService.disableDebug();
      await LogService.enableDebug('$selectedDirectory/$logFolderName');
    }
    if (mediaResourcesDir.existsSync()) {
      ref.read(mediaResourcesProvider.notifier).setLoading(true);
      ref.read(mediaResourcesProvider.notifier).setLoadProgress(0.0);
      stopwatch.reset();
      stopwatch.start();
      await loadMediaResources(mediaResourcesDir: mediaResourcesDir, ref: ref);
      stopwatch.stop();
      LogService.info(
          'loadMediaResourcesTime: ${stopwatch.elapsedMilliseconds}ms');
      ref.read(mediaResourcesProvider.notifier).setResources(_mediaResources);
      ref.read(mediaResourcesProvider.notifier).setCurrentIndex(0);
      ref.read(mediaResourcesProvider.notifier).setLoading(false);
      LogService.info(
          'Media resources loaded, total media resources: ${_mediaResources.length}');
      Toast.success('Media resources loaded');
    } else {
      Toast.error('Invalid directory: $selectedDirectory');
      LogService.warning('Invalid directory: $selectedDirectory');
    }
  }
}

int deleteMediaResource(
    {required MediaResource mediaResource}) {
  try {
    if (mediaResource.isAeb) {
      final aebPhotoResource = mediaResource as AebPhotoResource;
      for (final aebResource in aebPhotoResource.aebResources) {
        aebResource.file.deleteSync();
        if (aebResource.thumbFile != null &&
            aebResource.thumbFile!.existsSync()) {
          aebResource.thumbFile!.deleteSync();
        }
      }
    } else {
      if (mediaResource.isVideo && Platform.isWindows) {
        // Delay to avoid file in use error on Windows
        Future.delayed(const Duration(milliseconds: 500), () {
          mediaResource.file.deleteSync();
        });
      } else {
        mediaResource.file.deleteSync();
      }
      if (mediaResource.thumbFile != null &&
          mediaResource.thumbFile!.existsSync()) {
        mediaResource.thumbFile!.deleteSync();
      }
    }
  } catch (e) {
    Toast.error('Failed to delete ${mediaResource.file.uri.pathSegments.last}');
    LogService.warning(
        'Error deleting file: ${mediaResource.file.path}, error: $e');
    return -1;
  }
  return 0;
}

//
File? renameMediaResource({required MediaResource mediaResource, required String newName}) {
  final oldFile = mediaResource.file;
  try {
    final newFile = oldFile.renameSync('${oldFile.parent.path}/$newName');
    if (newFile.existsSync()) {
      return newFile;
    } else {
      Toast.error('Failed to rename ${mediaResource.file.uri.pathSegments.last}');
      LogService.warning('Failed to rename ${mediaResource.file.path}');
      return null;
    }
  } catch (e) {
    Toast.error('Failed to rename ${mediaResource.file.uri.pathSegments.last}');
    LogService.warning(
        'Error renaming file: ${mediaResource.file.path}, error: $e');
  }
  return null;
}
//
AebPhotoResource addSuffixToAebFilesName({required AebPhotoResource aebResource}) {
  for (var i = 0; i < aebResource.aebResources.length; i++) {
    var evBias = '';
    switch (i) {
      case 0:
        evBias = '0';
        break;
      case 1:
        evBias = '-0.7';
        break;
      case 2:
        evBias = '+0.7';
        break;
      case 3:
        evBias = '-1.3';
        break;
      case 4:
        evBias = '+1.3';
        break;
      case 5:
        evBias = '-2';
        break;
      case 6:
        evBias = '+2';
        break;
      default:
        evBias = '0';
    }
    final suffix = '_AEB_${aebResource.sequence}_$evBias';
    final oldFile = aebResource.aebResources[i].file;
    final newPath =
        '${oldFile.parent.path}/${oldFile.uri.pathSegments.last.split('.').first}$suffix.${oldFile.uri.pathSegments.last.split('.').last}';
    final newFile = File(newPath);
    try {
      oldFile.renameSync(newFile.path);
      aebResource.aebResources[i] = (AebPhotoResource(
          name: newFile.uri.pathSegments.last,
          file: newFile,
          width: aebResource.width,
          height: aebResource.height,
          sizeInBytes: aebResource.sizeInBytes,
          creationTime: aebResource.creationTime,
          sequence: aebResource.sequence,
          evBias: evBias)
        ..thumbFile = newFile);
    } catch (e) {
      Toast.error('Failed to rename ${oldFile.uri.pathSegments.last}');
      LogService.warning('Error renaming file: ${oldFile.path}');
    }
  }
  final newAebPhotoResource = (AebPhotoResource(
      name: aebResource.aebResources[0].file.uri.pathSegments.last,
      file: aebResource.aebResources[0].file,
      width: aebResource.width,
      height: aebResource.height,
      sizeInBytes: aebResource.sizeInBytes,
      creationTime: aebResource.creationTime,
      sequence: aebResource.sequence,
      evBias: aebResource.evBias)
    ..thumbFile = aebResource.thumbFile);
  newAebPhotoResource.aebResources.addAll(aebResource.aebResources);
  return newAebPhotoResource;
}
//
bool isFileExist(String path) {
  final file = File(path);
  return file.existsSync();
}

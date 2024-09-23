import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:xji_footage_toolbox/controllers/global_settings_controller.dart';
import 'package:xji_footage_toolbox/ui/pages/loading_media_resources_page.dart';

import '../constants.dart';
import '../controllers/global_media_resources_controller.dart';
import '../models/media_resource.dart';

final _mediaResources = <MediaResource>[];
var _mediaResourcesCount = 0;
var _processedMediaResourcesCount = 0;

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

void _debugLogging(String message, String logDir) {
  // final logFile = File('$logDir/log.txt');
  // logFile.writeAsStringSync('$message\n', mode: FileMode.append);
}

DateTime _getMediaCreationTime(File file) {
  RegExp regex = RegExp(r'DJI_(\d{14})_(\d{4})_D');

  Match? match = regex.firstMatch(file.uri.pathSegments.last);

  if (match != null) {
    try {
      return DateTime.parse(
          ('${match.group(1)!.substring(0, 8)}T${match.group(1)!.substring(8)}'));
    } catch (e) {
      if (kDebugMode) {
        print('Parse footage time error: $e');
      }
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
      if (kDebugMode) {
        print('Parse footage sequence error: $e');
      }
    }
  }
  return 0;
}

String _parseEvBias(Image image) {
  final evBias = image.exif.exifIfd[0x9204]?.toString();
  if (evBias != null) {
    return evBias;
  }
  return '';
}

Future<Map<String, dynamic>?> _ffprobeVideoInfo(File file) async {
  final GlobalSettingsController globalSettingsController =
      Get.find<GlobalSettingsController>();
  final result =
      await Process.run('${globalSettingsController.ffmpegParentDir}/ffprobe', [
    '-v',
    'error',
    '-show_entries',
    'format=size,duration',
    '-show_entries',
    'stream=width,height,codec_name,avg_frame_rate',
    '-of',
    'json',
    file.path,
  ]);
  if (result.exitCode != 0) {
    _debugLogging(
        'FFprobe error: ${result.stderr} for ${file.uri.pathSegments.last}',
        file.parent.path);
    return null;
  } else {
    final Map<String, dynamic> ffprobeOutput = json.decode(result.stdout);
    return ffprobeOutput;
  }
}

void _prepareThumbnailFolder(String mediaResourcesPath) {
  if (!Directory('$mediaResourcesPath/$thumbnailFolderName').existsSync()) {
    Directory('$mediaResourcesPath/$thumbnailFolderName').createSync();
    if (kDebugMode) {
      print('Create thumb folder');
    }
  } else {
    Directory('$mediaResourcesPath/$thumbnailFolderName')
        .listSync()
        .forEach((file) {
      file.deleteSync();
    });
    if (kDebugMode) {
      print('Clear thumb folder');
    }
  }
}

Future<File?> _generateThumbnail(List<String> args) async {
  final file = File(args[0]);
  final ffmpegParentDir = args[1];
  final mediaResourcesPath = file.parent.path;
  final videoResourceName = file.uri.pathSegments.last;
  final thumbFileName =
      '$mediaResourcesPath/$thumbnailFolderName/${videoResourceName.replaceAll('MP4', 'thumb')}.JPG';
  final result = await Process.run('$ffmpegParentDir/ffmpeg', [
    '-i',
    '$mediaResourcesPath/$videoResourceName',
    '-ss',
    '00:00:01.000',
    '-vframes',
    '1',
    thumbFileName,
  ]);
  if (result.exitCode != 0) {
    _debugLogging('FFmpeg error: ${result.stderr} for $videoResourceName',
        mediaResourcesPath);
    return null;
  } else {
    if (kDebugMode) {
      print('Thumbnail path: $thumbFileName');
    }
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
      final startIndex = i;
      if (mediaResources[i] is AebPhotoResource) {
        if ((mediaResources[i] as AebPhotoResource).evBias == '0/10') {
          (mediaResources[i] as AebPhotoResource)
              .aebResources
              .add(mediaResources[i]);
          if (kDebugMode) {
            print('0/10 found');
          }
          i++;
          if (i >= mediaResources.length) {
            break;
          }
          if (mediaResources[i].isAeb &&
              (mediaResources[i] as AebPhotoResource).evBias == '-7/10') {
            (mediaResources[startIndex] as AebPhotoResource)
                .aebResources
                .add(mediaResources[i]);
            mediaResources[i].hide = true;
            if (kDebugMode) {
              print('-7/10 found');
            }
            i++;
            if (i >= mediaResources.length) {
              break;
            }
            if (mediaResources[i].isAeb &&
                (mediaResources[i] as AebPhotoResource).evBias == '7/10') {
              (mediaResources[startIndex] as AebPhotoResource)
                  .aebResources
                  .add(mediaResources[i]);
              mediaResources[i].hide = true;
              if (kDebugMode) {
                print('7/10 found');
              }
              i++;
              if (i >= mediaResources.length) {
                break;
              }
              if (mediaResources[i].isAeb &&
                  (mediaResources[i] as AebPhotoResource).evBias == '-13/10') {
                (mediaResources[startIndex] as AebPhotoResource)
                    .aebResources
                    .add(mediaResources[i]);
                mediaResources[i].hide = true;
                if (kDebugMode) {
                  print('-13/10 found');
                }
                i++;
                if (i >= mediaResources.length) {
                  break;
                }
                if (mediaResources[i].isAeb &&
                    (mediaResources[i] as AebPhotoResource).evBias == '13/10') {
                  (mediaResources[startIndex] as AebPhotoResource)
                      .aebResources
                      .add(mediaResources[i]);
                  mediaResources[i].hide = true;
                  if (kDebugMode) {
                    print('13/10 found');
                  }
                  i++;
                  if (i >= mediaResources.length) {
                    break;
                  }
                  if (mediaResources[i].isAeb &&
                      (mediaResources[i] as AebPhotoResource).evBias ==
                          '-20/10') {
                    (mediaResources[startIndex] as AebPhotoResource)
                        .aebResources
                        .add(mediaResources[i]);
                    mediaResources[i].hide = true;
                    if (kDebugMode) {
                      print('-20/10 found');
                    }
                    i++;
                    if (i >= mediaResources.length) {
                      break;
                    }
                    if (mediaResources[i].isAeb &&
                        (mediaResources[i] as AebPhotoResource).evBias ==
                            '20/10') {
                      (mediaResources[startIndex] as AebPhotoResource)
                          .aebResources
                          .add(mediaResources[i]);
                      mediaResources[i].hide = true;
                      if (kDebugMode) {
                        print('20/10 found');
                      }
                      i++;
                      if (i >= mediaResources.length) {
                        break;
                      }
                      continue;
                    } else {
                      mediaResources[startIndex].errors[parseAebErrorCode] = [
                        parseAebEndError
                      ];
                      continue;
                    }
                  } else {
                    continue;
                  }
                } else {
                  mediaResources[startIndex].errors[parseAebErrorCode] = [
                    parseAebEndError
                  ];
                  continue;
                }
              } else {
                continue;
              }
            } else {
              mediaResources[startIndex].errors[parseAebErrorCode] = [
                parseAebEndError
              ];
              continue;
            }
          } else {
            mediaResources[startIndex].errors[parseAebErrorCode] = [
              parseAebEndError
            ];
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

Future<List<MediaResource>> _photoResourcesProcess(List<File> photos) async {
  final mediaResources = <MediaResource>[];
  for (final file in photos) {
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
  }
  return mediaResources;
}

Future<List<MediaResource>> _videoResourcesProcess(List<File> videos) async {
  final mediaResources = <MediaResource>[];
  final globalSettingsController = Get.find<GlobalSettingsController>();
  for (final file in videos) {
    final Map<String, dynamic> info = _getGenericMediaResourceInfo(file);
    final creationTime = info['creationTime'];
    final sequence = info['sequence'];
    final errors = info['errors'];

    final ffprobeOutput = await _ffprobeVideoInfo(file);
    if (ffprobeOutput == null) {
      continue;
    }
    try {
      final width = (ffprobeOutput['streams'][0]['width']);
      final height = (ffprobeOutput['streams'][0]['height']);
      final sizeInBytes = int.parse(ffprobeOutput['format']['size']);
      final frameRate = double.parse(
              ffprobeOutput['streams'][0]['avg_frame_rate'].split('/')[0]) /
          double.parse(
              ffprobeOutput['streams'][0]['avg_frame_rate'].split('/')[1]);
      final duration = double.parse(ffprobeOutput['format']['duration']);
      final isHevc = ffprobeOutput['streams'][0]['codec_name'] == 'hevc';
      final thumbFile = await compute(_generateThumbnail,
          [file.path, globalSettingsController.ffmpegParentDir]);
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
      _debugLogging('FFprobe error: $e for ${file.uri.pathSegments.last}',
          file.parent.path);
      if (kDebugMode) {
        print('Parse video info error: $e');
      }
    }
  }
  return mediaResources;
}

Future<List<MediaResource>> _multiThreadsProcessResources(
    List<File> mediaResourceFiles,
    Future<List<MediaResource>> Function(List<File> files)
        processFunction) async {
  final GlobalSettingsController globalSettingsController =
      Get.find<GlobalSettingsController>();
  final mediaResources = <MediaResource>[];
  final LoadingMediaResourcesController loadingMediaResourcesController =
      Get.find<LoadingMediaResourcesController>();
  if (mediaResourceFiles.length > 1) {
    if (mediaResourceFiles.length > globalSettingsController.cpuThreads) {
      final chunkSize =
          (mediaResourceFiles.length / globalSettingsController.cpuThreads)
              .ceil();
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
        futures.add(processFunction(chunk));
      }
      // final results = await Future.wait(futures);
      await Future.wait(futures).asStream().listen((results) {
        for (final result in results) {
          mediaResources.addAll(result);
          _processedMediaResourcesCount += result.length;
          loadingMediaResourcesController.progress.value =
              _processedMediaResourcesCount / _mediaResourcesCount;
        }
      }).asFuture();
    } else {
      final futures = <Future<List<MediaResource>>>[];
      for (final mediaResourceFile in mediaResourceFiles) {
        futures.add(processFunction([mediaResourceFile]));
      }
      await Future.wait(futures).asStream().listen((results) {
        for (final result in results) {
          mediaResources.addAll(result);
          _processedMediaResourcesCount += result.length;
          loadingMediaResourcesController.progress.value =
              _processedMediaResourcesCount / _mediaResourcesCount;
        }
      }).asFuture();
    }
  } else {
    mediaResources.addAll(await processFunction(mediaResourceFiles));
    _processedMediaResourcesCount += 1;
    loadingMediaResourcesController.progress.value =
        _processedMediaResourcesCount / _mediaResourcesCount;
  }
  return mediaResources;
}

Future<List<MediaResource>> loadMediaResources(
    Directory mediaResourcesDir) async {
  _mediaResources.clear();
  _prepareThumbnailFolder(mediaResourcesDir.path);
  _processedMediaResourcesCount = 0;
  final classifyResult = _classifyMediaResources(mediaResourcesDir.listSync());
  final List<File> photos = classifyResult[0];
  var processedPhotos = <MediaResource>[];
  final List<File> videos = classifyResult[1];
  var processedVideos = <MediaResource>[];

  processedPhotos =
      await _multiThreadsProcessResources(photos, _photoResourcesProcess);
  processedPhotos.sort((a, b) => a.sequence.compareTo(b.sequence));
  processedPhotos = await _analyzeAebFootage(processedPhotos);
  processedVideos =
      await _multiThreadsProcessResources(videos, _videoResourcesProcess);

  _mediaResources.addAll(processedPhotos);
  _mediaResources.addAll(processedVideos);

  final GlobalSettingsController globalSettingsController =
      Get.find<GlobalSettingsController>();
  switch (globalSettingsController.sortType.value) {
    case SortType.name:
      _mediaResources.sort((a, b) => globalSettingsController.sortAsc.value
          ? a.name.compareTo(b.name)
          : b.name.compareTo(a.name));
      break;
    case SortType.date:
      _mediaResources.sort((a, b) => globalSettingsController.sortAsc.value
          ? a.creationTime.compareTo(b.creationTime)
          : b.creationTime.compareTo(a.creationTime));
      break;
    case SortType.size:
      _mediaResources.sort((a, b) => globalSettingsController.sortAsc.value
          ? a.sizeInBytes.compareTo(b.sizeInBytes)
          : b.sizeInBytes.compareTo(a.sizeInBytes));
      break;
    case SortType.sequence:
      _mediaResources.sort((a, b) => globalSettingsController.sortAsc.value
          ? a.sequence.compareTo(b.sequence)
          : b.sequence.compareTo(a.sequence));
      break;
  }

  return _mediaResources;
}

Future<void> openMediaResourcesFolder() async {
  final selectedDirectory = await FilePicker.platform.getDirectoryPath();
  final globalMediaResourcesController =
      Get.find<GlobalMediaResourcesController>();
  final LoadingMediaResourcesController loadingMediaResourcesController =
      Get.find<LoadingMediaResourcesController>();
  if (selectedDirectory != null) {
    final mediaResourcesDir = Directory(selectedDirectory);
    if (mediaResourcesDir.existsSync()) {
      loadingMediaResourcesController.progress.value = 0.0;
      loadingMediaResourcesController.isLoadingMediaResources.value = true;
      globalMediaResourcesController.mediaResourceDir = mediaResourcesDir;
      final stopwatch = Stopwatch()..start();
      await loadMediaResources(mediaResourcesDir);
      stopwatch.stop();
      if (kDebugMode) {
        print('Load media resources time: ${stopwatch.elapsedMilliseconds}ms');
      }
      globalMediaResourcesController.mediaResources.addAll(_mediaResources);
      globalMediaResourcesController.currentMediaIndex.value = 0;
      loadingMediaResourcesController.isLoadingMediaResources.value = false;
      if (kDebugMode) {
        print('Media resources loaded');
      }
    } else {
      _debugLogging('Invalid directory: $selectedDirectory', selectedDirectory);
    }
  }
}

void deleteMediaResource(int index) {
  final globalMediaResourcesController =
      Get.find<GlobalMediaResourcesController>();
  if (index > 0 &&
      index < globalMediaResourcesController.mediaResources.length) {
    if (index == globalMediaResourcesController.currentMediaIndex.value &&
        index == globalMediaResourcesController.mediaResources.length - 1) {
      globalMediaResourcesController.currentMediaIndex.value -= 1;
    }
    try {
      globalMediaResourcesController.mediaResources[index].file.deleteSync();
      if (globalMediaResourcesController.mediaResources[index].thumbFile !=
              null &&
          globalMediaResourcesController.mediaResources[index].thumbFile!
              .existsSync()) {
        globalMediaResourcesController.mediaResources[index].thumbFile!
            .deleteSync();
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            'Error deleting file: ${globalMediaResourcesController.mediaResources[index].file.path}');
      }
    }
    globalMediaResourcesController.mediaResources.removeAt(index);
  }
}

void addSuffixToCurrentAebFilesName() {
  final globalMediaResourcesController =
      Get.find<GlobalMediaResourcesController>();
  final currentMediaResource = globalMediaResourcesController.mediaResources[
          globalMediaResourcesController.currentMediaIndex.value]
      as AebPhotoResource;
  for (var i = 0; i < currentMediaResource.aebResources.length; i++) {
    var evBias = '';
    switch (i) {
      case 0:
        evBias = '0.0';
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
        evBias = '-2.0';
        break;
      case 6:
        evBias = '+2.0';
        break;
      default:
        evBias = '0.0';
    }
    final suffix = '_AEB_${currentMediaResource.sequence}_$evBias';
    final oldFile = currentMediaResource.aebResources[i].file;
    final newPath =
        '${oldFile.parent.path}/${oldFile.uri.pathSegments.last.split('.').first}$suffix.${oldFile.uri.pathSegments.last.split('.').last}';
    final newFile = File(newPath);
    try {
      oldFile.renameSync(newFile.path);
      currentMediaResource.aebResources[i] = (AebPhotoResource(
          name: newFile.uri.pathSegments.last,
          file: newFile,
          width: currentMediaResource.width,
          height: currentMediaResource.height,
          sizeInBytes: currentMediaResource.sizeInBytes,
          creationTime: currentMediaResource.creationTime,
          sequence: currentMediaResource.sequence,
          evBias: evBias)
        ..thumbFile = currentMediaResource.thumbFile);
    } catch (e) {
      _debugLogging(
          'Error renaming file: ${oldFile.path}', oldFile.parent.path);
    }
  }
  final newAebPhotoResource = (AebPhotoResource(
      name: currentMediaResource.aebResources[0].file.uri.pathSegments.last,
      file: currentMediaResource.aebResources[0].file,
      width: currentMediaResource.width,
      height: currentMediaResource.height,
      sizeInBytes: currentMediaResource.sizeInBytes,
      creationTime: currentMediaResource.creationTime,
      sequence: currentMediaResource.sequence,
      evBias: currentMediaResource.evBias)
    ..thumbFile = currentMediaResource.thumbFile);
  newAebPhotoResource.aebResources.addAll(currentMediaResource.aebResources);
  globalMediaResourcesController.mediaResources[globalMediaResourcesController
      .currentMediaIndex.value] = newAebPhotoResource;
}

bool isFileExist(String path) {
  final file = File(path);
  return file.existsSync();
}

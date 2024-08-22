import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';

import '../constants.dart';
import '../controllers/global_media_resources_controller.dart';
import '../models/media_resource.dart';

final _mediaResources = <MediaResource>[];

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
  final result = await Process.run('ffprobe', [
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
    Fluttertoast.showToast(
        msg: 'Failed to get video info for ${file.uri.pathSegments.last}');
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

Future<File?> _generateThumbnail(
    String mediaResourcesPath, String videoResourceName) async {
  final thumbFileName =
      '$mediaResourcesPath/$thumbnailFolderName/${videoResourceName.replaceAll('MP4', 'thumb')}.JPG';
  final result = await Process.run('ffmpeg', [
    '-i',
    '$mediaResourcesPath/$videoResourceName',
    '-ss',
    '00:00:01.000',
    '-vframes',
    '1',
    thumbFileName,
  ]);
  if (result.exitCode != 0) {
    Fluttertoast.showToast(
        msg: 'Failed to generate thumbnail for $videoResourceName');
    return null;
  } else {
    if (kDebugMode) {
      print('Thumbnail path: $thumbFileName');
    }
    return File(thumbFileName);
  }
}

Future<void> _analyzeAebFootage() async {
  if (_mediaResources.isNotEmpty) {
    for (var i = 0; i < _mediaResources.length;) {
      if (_mediaResources[i].isVideo) {
        i++;
        continue;
      }
      final startIndex = i;
      if (_mediaResources[i] is AebPhotoResource) {
        if ((_mediaResources[i] as AebPhotoResource).evBias == '0/10') {
          (_mediaResources[i] as AebPhotoResource)
              .aebFiles
              .add(_mediaResources[i].file);
          if (kDebugMode) {
            print('0/10 found');
          }
          i++;
          if (i >= _mediaResources.length) {
            break;
          }
          if (_mediaResources[i].isAeb &&
              (_mediaResources[i] as AebPhotoResource).evBias == '-7/10') {
            (_mediaResources[startIndex] as AebPhotoResource)
                .aebFiles
                .add(_mediaResources[i].file);
            _mediaResources[i].hide = true;
            if (kDebugMode) {
              print('-7/10 found');
            }
            i++;
            if (i >= _mediaResources.length) {
              break;
            }
            if (_mediaResources[i].isAeb &&
                (_mediaResources[i] as AebPhotoResource).evBias == '7/10') {
              (_mediaResources[startIndex] as AebPhotoResource)
                  .aebFiles
                  .add(_mediaResources[i].file);
              _mediaResources[i].hide = true;
              if (kDebugMode) {
                print('7/10 found');
              }
              i++;
              if (i >= _mediaResources.length) {
                break;
              }
              if (_mediaResources[i].isAeb &&
                  (_mediaResources[i] as AebPhotoResource).evBias == '-13/10') {
                (_mediaResources[startIndex] as AebPhotoResource)
                    .aebFiles
                    .add(_mediaResources[i].file);
                _mediaResources[i].hide = true;
                if (kDebugMode) {
                  print('-13/10 found');
                }
                i++;
                if (i >= _mediaResources.length) {
                  break;
                }
                if (_mediaResources[i].isAeb &&
                    (_mediaResources[i] as AebPhotoResource).evBias ==
                        '13/10') {
                  (_mediaResources[startIndex] as AebPhotoResource)
                      .aebFiles
                      .add(_mediaResources[i].file);
                  _mediaResources[i].hide = true;
                  if (kDebugMode) {
                    print('13/10 found');
                  }
                  i++;
                  if (i >= _mediaResources.length) {
                    break;
                  }
                  if (_mediaResources[i].isAeb &&
                      (_mediaResources[i] as AebPhotoResource).evBias ==
                          '-20/10') {
                    (_mediaResources[startIndex] as AebPhotoResource)
                        .aebFiles
                        .add(_mediaResources[i].file);
                    _mediaResources[i].hide = true;
                    if (kDebugMode) {
                      print('-20/10 found');
                    }
                    i++;
                    if (i >= _mediaResources.length) {
                      break;
                    }
                    if (_mediaResources[i].isAeb &&
                        (_mediaResources[i] as AebPhotoResource).evBias ==
                            '20/10') {
                      (_mediaResources[startIndex] as AebPhotoResource)
                          .aebFiles
                          .add(_mediaResources[i].file);
                      _mediaResources[i].hide = true;
                      if (kDebugMode) {
                        print('20/10 found');
                      }
                      i++;
                      if (i >= _mediaResources.length) {
                        break;
                      }
                      continue;
                    } else {
                      _mediaResources[startIndex].errors[parseAebErrorCode] = [
                        parseAebEndError
                      ];
                      continue;
                    }
                  } else {
                    continue;
                  }
                } else {
                  _mediaResources[startIndex].errors[parseAebErrorCode] = [
                    parseAebEndError
                  ];
                  continue;
                }
              } else {
                continue;
              }
            } else {
              _mediaResources[startIndex].errors[parseAebErrorCode] = [
                parseAebEndError
              ];
              continue;
            }
          } else {
            _mediaResources[startIndex].errors[parseAebErrorCode] = [
              parseAebEndError
            ];
            continue;
          }
        }
        _mediaResources[i].errors[parseAebErrorCode] = [parseAebStartError];
      }
      i++;
    }
  }
  _mediaResources.removeWhere((element) => element.hide);
}

Future<List<MediaResource>> loadMediaResources(
    Directory mediaResourcesDir) async {
  _mediaResources.clear();
  _prepareThumbnailFolder(mediaResourcesDir.path);
  for (final file in mediaResourcesDir.listSync()) {
    if (file is File && (_isPhoto(file.uri) || _isVideo(file.uri))) {
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
          errors[parseMediaResourceErrorCode]!
              .add(parseMediaResourceSequenceError);
        } else {
          errors[parseMediaResourceErrorCode] = [
            parseMediaResourceSequenceError
          ];
        }
      }

      if (_isPhoto(file.uri)) {
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
          _mediaResources.add(resource);
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
          _mediaResources.add(resource);
        }
      } else if (_isVideo(file.uri)) {
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
          final thumbFile = await _generateThumbnail(
              mediaResourcesDir.path, file.uri.pathSegments.last);
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
          _mediaResources.add(resource);
        } catch (e) {
          Fluttertoast.showToast(
              msg:
                  'Failed to parse video info for ${file.uri.pathSegments.last}');
          if (kDebugMode) {
            print('Parse video info error: $e');
          }
        }
      }
    }
  }
  _mediaResources.sort((a, b) => a.sequence.compareTo(b.sequence));
  await _analyzeAebFootage();
  return _mediaResources;
}

Future<void> openMediaResourcesFolder() async {
  final selectedDirectory = await FilePicker.platform.getDirectoryPath();
  final globalMediaResourcesController =
      Get.find<GlobalMediaResourcesController>();
  if (selectedDirectory != null) {
    final mediaResourcesDir = Directory(selectedDirectory);
    if (mediaResourcesDir.existsSync()) {
      globalMediaResourcesController.isLoadingMediaResources.value = true;
      globalMediaResourcesController.mediaResourceDir = mediaResourcesDir;
      await loadMediaResources(mediaResourcesDir);
      globalMediaResourcesController.mediaResources.addAll(_mediaResources);
      globalMediaResourcesController.isLoadingMediaResources.value = false;
      if (kDebugMode) {
        print('Media resources loaded');
      }
    } else {
      Fluttertoast.showToast(msg: 'Invalid directory');
    }
  }
}

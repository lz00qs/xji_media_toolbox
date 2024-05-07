import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:xji_footage_toolbox/global_controller.dart';
import 'package:xji_footage_toolbox/utils.dart';

import 'constants.dart';
import 'footage.dart';

Future<File?> _generateThumbnail(Footage footage) async {
  final controller = Get.find<GlobalController>();
  final thumbFileName =
      '${controller.footageDir!.path}/$thumbnailFolderName/${footage.name.replaceAll('MP4', 'thumb')}.JPG';
  final result = await Process.run('ffmpeg', [
    '-i',
    footage.file.path,
    '-ss',
    '00:00:01.000',
    '-vframes',
    '1',
    thumbFileName,
  ]);
  if (result.exitCode != 0) {
    Fluttertoast.showToast(
        msg: 'Failed to generate thumbnail for ${footage.name}');
    return null;
  } else {
    if (kDebugMode) {
      print('Thumbnail path: $thumbFileName');
    }
    return File(thumbFileName);
  }
}

void _prepareThumbnailFolder() {
  final controller = Get.find<GlobalController>();
  if (!Directory('${controller.footageDir!.path}/$thumbnailFolderName')
      .existsSync()) {
    Directory('${controller.footageDir!.path}/$thumbnailFolderName')
        .createSync();
    if (kDebugMode) {
      print('Create thumb folder');
    }
  } else {
    Directory('${controller.footageDir!.path}/$thumbnailFolderName')
        .listSync()
        .forEach((file) {
      file.deleteSync();
    });
    if (kDebugMode) {
      print('Clear thumb folder');
    }
  }
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

String _parseEvBias(Image image) {
  final evBias = image.exif.exifIfd[0x9204]?.toString();
  if (evBias != null) {
    return evBias;
  }
  return '';
}

Future<void> _analyzeAebFootage() async {
  final controller = Get.find<GlobalController>();
  if (controller.footageList.isNotEmpty) {
    for (var i = 0; i < controller.footageList.length;) {
      if (controller.footageList[i].isVideo) {
        i++;
        continue;
      }
      final startIndex = i;
      var image = await decodeJpgFile(controller.footageList[i].file.path);
      if (image != null && _isAebImage(image)) {
        if (_parseEvBias(image) == '0/10') {
          controller.footageList[startIndex].aebFiles
              .add(controller.footageList[i].file);
          print('0/10 found');
          i++;
          if (i >= controller.footageList.length) {
            break;
          }
          image = await decodeJpgFile(controller.footageList[i].file.path);
          if (image != null &&
              _isAebImage(image) &&
              _parseEvBias(image) == '-7/10') {
            controller.footageList[startIndex].aebFiles
                .add(controller.footageList[i].file);
            controller.footageList[i].hide = true;
            print('-7/10 found');
            i++;
            if (i >= controller.footageList.length) {
              break;
            }
            image = await decodeJpgFile(controller.footageList[i].file.path);
            if (image != null &&
                _isAebImage(image) &&
                _parseEvBias(image) == '7/10') {
              controller.footageList[startIndex].aebFiles
                  .add(controller.footageList[i].file);
              controller.footageList[i].hide = true;
              print('7/10 found');
              i++;
              if (i >= controller.footageList.length) {
                break;
              }
              image = await decodeJpgFile(controller.footageList[i].file.path);
              if (image != null &&
                  _isAebImage(image) &&
                  _parseEvBias(image) == '-13/10') {
                controller.footageList[startIndex].aebFiles
                    .add(controller.footageList[i].file);
                controller.footageList[i].hide = true;
                print('-13/10 found');
                i++;
                if (i >= controller.footageList.length) {
                  break;
                }
                image =
                await decodeJpgFile(controller.footageList[i].file.path);
                if (image != null &&
                    _isAebImage(image) &&
                    _parseEvBias(image) == '13/10') {
                  controller.footageList[startIndex].aebFiles
                      .add(controller.footageList[i].file);
                  controller.footageList[i].hide = true;
                  print('13/10 found');
                  i++;
                  if (i >= controller.footageList.length) {
                    break;
                  }
                  image =
                  await decodeJpgFile(controller.footageList[i].file.path);
                  if (image != null &&
                      _isAebImage(image) &&
                      _parseEvBias(image) == '-20/10') {
                    controller.footageList[startIndex].aebFiles
                        .add(controller.footageList[i].file);
                    controller.footageList[i].hide = true;
                    print('-20/10 found');
                    i++;
                    if (i >= controller.footageList.length) {
                      break;
                    }
                    image = await decodeJpgFile(
                        controller.footageList[i].file.path);
                    if (image != null &&
                        _isAebImage(image) &&
                        _parseEvBias(image) == '20/10') {
                      controller.footageList[startIndex].aebFiles
                          .add(controller.footageList[i].file);
                      controller.footageList[i].hide = true;
                      print('20/10 found');
                      i++;
                      if (i >= controller.footageList.length) {
                        break;
                      }
                      continue;
                    } else {
                      controller.footageList[startIndex]
                          .errors[parseAebErrorCode] = [parseAebEndError];
                      continue;
                    }
                  } else {
                    continue;
                  }
                } else {
                  controller.footageList[startIndex].errors[parseAebErrorCode] =
                  [parseAebEndError];
                  continue;
                }
              } else {
                continue;
              }
            } else {
              controller.footageList[startIndex].errors[parseAebErrorCode] = [
                parseAebEndError
              ];
              continue;
            }
          } else {
            controller.footageList[startIndex].errors[parseAebErrorCode] = [
              parseAebEndError
            ];
            continue;
          }
        }
        controller.footageList[i].errors[parseAebErrorCode] = [
          parseAebStartError
        ];
      }
      i++;
    }
  }
  controller.footageList.removeWhere((element) => element.hide);
}

Future<void> _loadFootage() async {
  final controller = Get.find<GlobalController>();
  if (controller.footageDir == null) {
    Fluttertoast.showToast(msg: 'Please select a footage folder first');
    return;
  }

  _prepareThumbnailFolder();
  controller.footageList.clear();

  final dir = Directory(controller.footageDir!.path);
  for (final file in dir.listSync()) {
    if (isMediaFile(file.uri)) {
      final footage = Footage(file: File(file.uri.toFilePath()));
      if (footage.isVideo) {
        footage.thumbFile = await _generateThumbnail(footage);
      } else {
        // final image = await decodeJpgFile(footage.file.path);
        // if (image != null) {
        //   // print("${footage.name}\n");
        //   // print("${image.exif}\n");
        //   // print("\n\n");
        // }
        footage.thumbFile = footage.file;
      }
      controller.footageList.add(footage);
    }
  }
  controller.footageList.sort((a, b) => a.sequence.compareTo(b.sequence));

  await _analyzeAebFootage();

  for (final footage in controller.footageList) {
    if (kDebugMode) {
      print('Footage: ${footage.name}, ${footage.hide}');
    }
  }
}

Future<void> openFootageFolder() async {
  final controller = Get.find<GlobalController>();
  final selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory != null) {
    final dir = Directory(selectedDirectory);
    for (final file in dir.listSync()) {
      if (isMediaFile(file.uri)) {
        controller.footageDir = dir;
        if (kDebugMode) {
          print('Footage folder: $selectedDirectory');
        }
        // 弹出加载圈
        await _loadFootage();
        if (kDebugMode) {
          print('Footage list: ${controller.footageList.length}');
        }
        // Get.to(() => MyGalleryScreen());
        break;
      }
    }
  }
}

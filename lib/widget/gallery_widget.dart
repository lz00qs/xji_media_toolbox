import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/global_controller.dart';
import 'package:xji_footage_toolbox/widget/gallery_grid_widget.dart';
import 'package:xji_footage_toolbox/widget/gallery_list_widget.dart';

import '../constants.dart';
import '../footage.dart';
import '../utils.dart';

class GalleryWidget extends StatelessWidget {
  final GlobalController controller = Get.find();
  final openPressed = false.obs;

  GalleryWidget({super.key});

  Future<void> prepareWorkSpace() async {
    if (controller.footageDir == null) {
      Fluttertoast.showToast(msg: 'Please select a footage folder first');
      return;
    }

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

    controller.footageList.clear();

    final dir = Directory(controller.footageDir!.path);
    for (final file in dir.listSync()) {
      if (isMediaFile(file.uri)) {
        final footage = Footage(file: File(file.uri.toFilePath()));
        if (footage.isVideo) {
          final thumbFileName =
              '${controller.footageDir!.path}/$thumbnailFolderName/${footage.name.replaceAll('MP4', 'thumb')}.JPG';
          final result = await Process.run('ffmpeg', [
            '-i',
            file.uri.toFilePath(),
            '-ss',
            '00:00:01.000',
            '-vframes',
            '1',
            thumbFileName,
          ]);
          if (result.exitCode != 0) {
            Fluttertoast.showToast(
                msg: 'Failed to generate thumbnail for ${footage.name}');
          } else {
            if (kDebugMode) {
              print('Thumbnail path: $thumbFileName');
            }
            footage.thumbFile = File(thumbFileName);
          }
        } else {
          footage.thumbFile = footage.file;
        }
        controller.footageList.add(footage);
      }
    }

    for (final footage in controller.footageList) {
      if (kDebugMode) {
        print('Footage: ${footage.name}, ${footage.file}, ${footage.isVideo}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.footageList.isEmpty) {
        return Center(
          child: IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () async {
              if (openPressed.value) {
                return;
              }
              openPressed.value = true;
              // 打开视频文件夹
              final selectedDirectory =
                  await FilePicker.platform.getDirectoryPath();
              if (selectedDirectory != null) {
                final dir = Directory(selectedDirectory);
                for (final file in dir.listSync()) {
                  if (isMediaFile(file.uri)) {
                    controller.footageDir = dir;
                    if (kDebugMode) {
                      print('Footage folder: $selectedDirectory');
                    }
                    // 弹出加载圈

                    await prepareWorkSpace();
                    if (kDebugMode) {
                      print('Footage list: ${controller.footageList.length}');
                    }
                    // Get.to(() => MyGalleryScreen());
                    break;
                  }
                }
              }
              openPressed.value = false;
            },
          ),
        );
      } else {
        return Obx(() {
          if (controller.isFootageListView.value) {
            return const GalleryListWidget();
          } else {
            return const GalleryGridWidget();
          }
        });
      }
    });
  }
}

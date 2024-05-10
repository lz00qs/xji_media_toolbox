import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/global_controller.dart';
import 'package:xji_footage_toolbox/widget/gallery_list_widget.dart';

import '../load_footage.dart';

class GalleryWidget extends StatelessWidget {
  final GlobalController controller = Get.find();
  final openPressed = false.obs;

  GalleryWidget({super.key});

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
              await openFootageFolder();
              openPressed.value = false;
            },
          ),
        );
      } else {
        // if (controller.isFootageListView.value) {
        //   return const GalleryListWidget();
        // } else {
        //   return const GalleryGridWidget();
        // }
        return const GalleryListWidget();
      }
    });
  }
}

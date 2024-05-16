import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../global_controller.dart';

class NormalPhotoEditorWidget extends StatelessWidget {
  const NormalPhotoEditorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GlobalController>();
    return Scaffold(
        appBar: PreferredSize(
          // windows 和 macos size 做区分
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.help),
              ),
            ],
          ),
        ),
        body: Center(
          child: Obx(() => ClipRect(
                child: PhotoView(
                    backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                    imageProvider: FileImage(controller
                        .footageList[controller.currentFootageIndex.value]
                        .file)),
              )),
        ));
  }
}

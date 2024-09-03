import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/global_media_resources_controller.dart';
import '../panels/views/video_player_view.dart';
import 'app_bar_button.dart';

void _flipEditingMediaResources() {
  Get.find<GlobalMediaResourcesController>().isEditingMediaResources.value =
      !Get.find<GlobalMediaResourcesController>().isEditingMediaResources.value;
  Get.find<VideoPlayerGetxController>().videoPlayerController.pause();
}

class AppBarNormalVideoEditButton extends StatelessWidget {
  const AppBarNormalVideoEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Get.find<GlobalMediaResourcesController>().isEditingMediaResources.value
            ? const AppBarButton(
                iconData: Icons.edit_off, onPressed: _flipEditingMediaResources)
            : const AppBarButton(
                iconData: Icons.edit, onPressed: _flipEditingMediaResources));
  }
}

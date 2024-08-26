import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/widgets/video_player_widget.dart';

import '../../controllers/global_media_resources_controller.dart';
import 'main_page_app_bar_button.dart';

void _flipEditingMediaResources() {
  Get.find<GlobalMediaResourcesController>().isEditingMediaResources.value =
      !Get.find<GlobalMediaResourcesController>().isEditingMediaResources.value;
  Get.find<VideoPlayerGetxController>().videoPlayerController.pause();
}

class NormalVideoEditButton extends StatelessWidget {
  const NormalVideoEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Get.find<GlobalMediaResourcesController>().isEditingMediaResources.value
            ? const MainPageAppBarButton(
                iconData: Icons.edit_off, onPressed: _flipEditingMediaResources)
            : const MainPageAppBarButton(
                iconData: Icons.edit, onPressed: _flipEditingMediaResources));
  }
}

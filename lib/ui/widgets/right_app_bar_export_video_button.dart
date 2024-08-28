import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/global_media_resources_controller.dart';
import '../../models/media_resource.dart';
import 'export_video_dialog.dart';
import 'main_page_app_bar_button.dart';

class RightAppBarExportVideoButton extends StatelessWidget {
  const RightAppBarExportVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    return MainPageAppBarButton(
        iconData: Icons.upload,
        onPressed: () {
          Get.dialog(ExportVideoDialog(
              videoResource: globalMediaResourcesController.mediaResources[
                      globalMediaResourcesController.currentMediaIndex.value]
                  as NormalVideoResource));
        });
  }
}

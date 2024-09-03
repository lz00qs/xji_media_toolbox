import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/global_media_resources_controller.dart';
import '../../../models/media_resource.dart';
import '../dialogs/export_video_dialog.dart';
import 'app_bar_button.dart';

class AppBarExportVideoButton extends StatelessWidget {
  const AppBarExportVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    return AppBarButton(
        iconData: Icons.upload,
        onPressed: () {
          Get.dialog(ExportVideoDialog(
              videoResource: globalMediaResourcesController.mediaResources[
                      globalMediaResourcesController.currentMediaIndex.value]
                  as NormalVideoResource));
        });
  }
}

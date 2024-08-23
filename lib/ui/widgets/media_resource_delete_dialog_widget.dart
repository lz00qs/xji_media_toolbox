import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/utils/media_resources_utils.dart';

import '../../controllers/global_focus_nodes_controller.dart';
import '../../controllers/global_media_resources_controller.dart';

class MediaResourceDeleteDialog extends StatelessWidget {
  const MediaResourceDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final globalFocusNodesController = Get.find<GlobalFocusNodesController>();
    final globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    return Focus(
        focusNode:
            globalFocusNodesController.mediaResourceDeleteDialogFocusNode,
        child: AlertDialog(
          title: const Text('Delete footage'),
          content: const Text('Are you sure you want to delete this footage?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                globalFocusNodesController.mediaResourcesListPanelFocusNode
                    .requestFocus();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                deleteMediaResource(
                    globalMediaResourcesController.currentMediaIndex.value);
                Get.back();
                globalFocusNodesController.mediaResourcesListPanelFocusNode
                    .requestFocus();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ));
  }
}

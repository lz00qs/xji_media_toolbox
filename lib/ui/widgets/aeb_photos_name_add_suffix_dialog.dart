import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/global_focus_nodes_controller.dart';
import '../../controllers/global_media_resources_controller.dart';
import '../../utils/media_resources_utils.dart';

class AebPhotosNameAddSuffixDialog extends StatelessWidget {
  const AebPhotosNameAddSuffixDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final globalFocusNodesController = Get.find<GlobalFocusNodesController>();
    Get.find<GlobalMediaResourcesController>();
    return Focus(
        focusNode: globalFocusNodesController.dialogFocusNode,
        child: AlertDialog(
          title: const Text('Add AEB suffix to the photo name'),
          content: const Text(
              'Are you sure you want to add AEB suffix to all these AEB photos?'),
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
                addSuffixToCurrentAebFilesName();
                Get.back();
                globalFocusNodesController.mediaResourcesListPanelFocusNode
                    .requestFocus();
              },
              child: const Text('Add', style: TextStyle(color: Colors.red)),
            ),
          ],
        ));
  }
}

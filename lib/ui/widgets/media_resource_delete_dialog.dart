import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/utils/media_resources_utils.dart';

import '../../controllers/global_focus_nodes_controller.dart';
import '../../controllers/global_media_resources_controller.dart';
import 'media_resources_list_panel_widget.dart';

class MediaResourceDeleteDialog extends StatelessWidget {
  final bool isDeleteMultipleMediaResources;

  const MediaResourceDeleteDialog(
      {super.key, required this.isDeleteMultipleMediaResources});

  @override
  Widget build(BuildContext context) {
    final globalFocusNodesController = Get.find<GlobalFocusNodesController>();
    final globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    Get.find<MediaResourcesListPanelController>();
    return Focus(
        focusNode: globalFocusNodesController.dialogFocusNode,
        child: AlertDialog(
          title: const Text('Delete'),
          content: Text(isDeleteMultipleMediaResources
              ? 'Are you sure you want to delete '
                  '${globalMediaResourcesController.selectedIndexList.length} media resources?'
              : 'Are you sure you want to delete this media resource?'),
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
                if (isDeleteMultipleMediaResources) {
                  for (int i = globalMediaResourcesController
                              .selectedIndexList.length -
                          1;
                      i >= 0;
                      i--) {
                    deleteMediaResource(
                        globalMediaResourcesController.selectedIndexList[i]);
                  }
                  globalMediaResourcesController.selectedIndexList.clear();
                } else {
                  deleteMediaResource(
                      globalMediaResourcesController.currentMediaIndex.value);
                }
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

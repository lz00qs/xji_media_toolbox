import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/video_merger_widget.dart';

import '../../controllers/global_media_resources_controller.dart';
import 'media_resource_delete_dialog.dart';
import 'media_resources_list_panel_widget.dart';

class MultiSelectPanelController extends GetxController {
  final isMerging = false.obs;
}

class MultiSelectPanel extends StatelessWidget {
  const MultiSelectPanel({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MediaResourcesListPanelController>();
    final globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    final MultiSelectPanelController multiSelectPanelController = Get.find();
    multiSelectPanelController.isMerging.value = false;
    return Center(
      child: Obx(() {
        final containPhotos = globalMediaResourcesController.selectedIndexList
            .any((element) =>
                globalMediaResourcesController
                    .mediaResources[element].isVideo ==
                false);
        if (containPhotos) {
          return _DeleteButton();
        } else {
          return Obx(() =>
              globalMediaResourcesController.selectedIndexList.isEmpty
                  ? const Text('Select some resources first!')
                  : multiSelectPanelController.isMerging.value
                      ? VideoMergerWidget(
                          videoResources: globalMediaResourcesController
                              .selectedIndexList
                              .map((e) => globalMediaResourcesController
                                  .mediaResources[e] as NormalVideoResource)
                              .toList())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _DeleteButton(),
                            _MergeButton(),
                          ],
                        ));
        }
      }),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Get.dialog(const MediaResourceDeleteDialog(
            isDeleteMultipleMediaResources: true,
          ));
        },
        icon: const Icon(Icons.delete));
  }
}

class _MergeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MultiSelectPanelController multiSelectPanelController =
        Get.find<MultiSelectPanelController>();
    return IconButton(
        onPressed: () {
          multiSelectPanelController.isMerging.value = true;
        },
        icon: const Icon(Icons.video_collection_outlined));
  }
}

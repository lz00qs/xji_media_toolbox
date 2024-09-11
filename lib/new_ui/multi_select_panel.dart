import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/global_media_resources_controller.dart';
import '../models/media_resource.dart';
import 'design_tokens.dart';
import 'main_panel_button.dart';
import 'video_merger_view.dart';

class MultiSelectPanelController extends GetxController {
  final isMerging = false.obs;
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var isPressed = false;
    return MainPanelButton(
        iconData: Icons.delete,
        onPressed: () async {
          if (isPressed) {
            return;
          }
          isPressed = true;
          onPressed();
          isPressed = false;
        });
  }
}

class _MergeVideoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _MergeVideoButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var isPressed = false;
    return MainPanelButton(
        iconData: Icons.merge_type,
        onPressed: () async {
          if (isPressed) {
            return;
          }
          isPressed = true;
          onPressed();
          isPressed = false;
        });
  }
}

class MultiSelectPanel extends StatelessWidget {
  const MultiSelectPanel({super.key});

  @override
  Widget build(BuildContext context) {
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

        if (globalMediaResourcesController.selectedIndexList.isEmpty) {
          return Text('Select some resources first!',
              style: SemiTextStyles.header4ENRegular
                  .copyWith(color: ColorDark.text0));
        }
        if (containPhotos) {
          return _DeleteButton(onPressed: () {});
        }
        if (!multiSelectPanelController.isMerging.value) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DeleteButton(onPressed: () {}),
              const SizedBox(
                width: 64,
              ),
              _MergeVideoButton(onPressed: () {
                multiSelectPanelController.isMerging.value = true;
              })
            ],
          );
        }
        return VideoMergerView(
              videoResources: globalMediaResourcesController.selectedIndexList
                  .map((e) => globalMediaResourcesController.mediaResources[e]
                      as NormalVideoResource)
                  .toList(),
            );
      }),
    );
  }
}

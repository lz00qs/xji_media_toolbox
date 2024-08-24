import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/load_media_resources_icon_button_widget.dart';
import 'package:xji_footage_toolbox/ui/widgets/media_resources_list_panel_widget.dart';

import '../../controllers/global_focus_nodes_controller.dart';
import '../../controllers/global_media_resources_controller.dart';
import '../widgets/aeb_photo_viewer_widget.dart';
import '../widgets/main_page_left_app_bar.dart';
import '../widgets/media_resource_info_panel_widget.dart';
import '../widgets/media_resource_main_panel_widget.dart';
import '../widgets/resizable_triple_panel_widget.dart';

void _decreaseCurrentMediaIndex() {
  final globalMediaResourcesController =
      Get.find<GlobalMediaResourcesController>();
  final mediaResourcesListPanelController =
      Get.find<MediaResourcesListPanelController>();

  if (globalMediaResourcesController.currentMediaIndex > 0) {
    globalMediaResourcesController.currentMediaIndex.value -= 1;

    if (globalMediaResourcesController.currentMediaIndex.value <
        mediaResourcesListPanelController
            .mediaResourcesListScrollListener.itemPositions.value.first.index) {
      mediaResourcesListPanelController.mediaResourcesListScrollController
          .jumpTo(
              index: globalMediaResourcesController.currentMediaIndex.value);
    }
  }
}

void _increaseCurrentMediaIndex() {
  final globalMediaResourcesController =
      Get.find<GlobalMediaResourcesController>();
  final mediaResourcesListPanelController =
      Get.find<MediaResourcesListPanelController>();

  if (globalMediaResourcesController.currentMediaIndex <
      globalMediaResourcesController.mediaResources.length - 1) {
    globalMediaResourcesController.currentMediaIndex.value += 1;

    if (globalMediaResourcesController.currentMediaIndex.value >
        mediaResourcesListPanelController
            .mediaResourcesListScrollListener.itemPositions.value.last.index) {
      mediaResourcesListPanelController.mediaResourcesListScrollController
          .jumpTo(
              index: globalMediaResourcesController.currentMediaIndex.value);
    }
  }
}

void _increaseCurrentAebIndex() {
  final aebPhotoViewerController = Get.find<AebPhotoViewerController>();
  final globalMediaResourcesController =
      Get.find<GlobalMediaResourcesController>();

  if (aebPhotoViewerController.currentAebIndex <
      (globalMediaResourcesController.mediaResources[
                      globalMediaResourcesController.currentMediaIndex.value]
                  as AebPhotoResource)
              .aebFiles
              .length -
          1) {
    aebPhotoViewerController.currentAebIndex.value += 1;
  }

  if (aebPhotoViewerController
          .aebListScrollListener.itemPositions.value.last.index <
      aebPhotoViewerController.currentAebIndex.value) {
    aebPhotoViewerController.aebListScrollController.jumpTo(
        index: aebPhotoViewerController.currentAebIndex.value, alignment: 0.5);
  }
}

void _decreaseCurrentAebIndex() {
  final aebPhotoViewerController = Get.find<AebPhotoViewerController>();

  if (aebPhotoViewerController.currentAebIndex > 0) {
    aebPhotoViewerController.currentAebIndex.value -= 1;
  }

  if (aebPhotoViewerController
          .aebListScrollListener.itemPositions.value.first.index >
      aebPhotoViewerController.currentAebIndex.value) {
    aebPhotoViewerController.aebListScrollController.jumpTo(
        index: aebPhotoViewerController.currentAebIndex.value, alignment: 0.5);
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    final globalFocusNodesController = Get.find<GlobalFocusNodesController>();

    return KeyboardListener(
        focusNode: globalFocusNodesController.mediaResourcesListPanelFocusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent || event is KeyRepeatEvent) {
            switch (event.logicalKey) {
              case LogicalKeyboardKey.arrowUp:
                _decreaseCurrentMediaIndex();
                break;
              case LogicalKeyboardKey.arrowDown:
                _increaseCurrentMediaIndex();
                break;
              case LogicalKeyboardKey.arrowLeft:
                if (globalMediaResourcesController.mediaResources.isNotEmpty &&
                    globalMediaResourcesController
                        .mediaResources[globalMediaResourcesController
                            .currentMediaIndex.value]
                        .isAeb) {
                  _decreaseCurrentAebIndex();
                }
                break;
              case LogicalKeyboardKey.arrowRight:
                if (globalMediaResourcesController.mediaResources.isNotEmpty &&
                    globalMediaResourcesController
                        .mediaResources[globalMediaResourcesController
                            .currentMediaIndex.value]
                        .isAeb) {
                  _increaseCurrentAebIndex();
                }
                break;
            }
          }
        },
        child: Scaffold(
          body: ResizableTriplePanelWidget(
            topLeftPanel:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const MainPageLeftAppBar(),
              Obx(() => Expanded(
                  child: globalMediaResourcesController.mediaResources.isEmpty
                      ? const Center(
                          child: LoadMediaResourcesIconButtonWidget(),
                        )
                      : const MediaResourcesListPanelWidget())),
            ]),
            bottomLeftPanel: Obx(() =>
                globalMediaResourcesController.mediaResources.isEmpty
                    ? const SizedBox()
                    : MediaResourceInfoPanelWidget(
                        mediaResource:
                            globalMediaResourcesController.mediaResources[
                                globalMediaResourcesController
                                    .currentMediaIndex.value])),
            rightPanel: Obx(() =>
                globalMediaResourcesController.mediaResources.isEmpty
                    ? const SizedBox()
                    : MediaResourceMainPanelWidget(
                        mediaResource:
                            globalMediaResourcesController.mediaResources[
                                globalMediaResourcesController
                                    .currentMediaIndex.value])),
          ),
        ));
  }
}

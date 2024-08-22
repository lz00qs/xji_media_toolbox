import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:xji_footage_toolbox/controllers/global_media_resources_controller.dart';

import '../../controllers/global_focus_nodes_controller.dart';

class MediaResourcesListPanelController extends GetxController {
  static const _thumbnailMaxWidth = 200;
  static const _thumbnailMinWidth = 100;
  final thumbnailWidth = 100.0.obs;
  final mediaResourcesListScrollController = ItemScrollController();
  final mediaResourcesListScrollListener = ItemPositionsListener.create();

  void zoomIn() {
    if (thumbnailWidth.value < _thumbnailMaxWidth) {
      thumbnailWidth.value += 10;
    }
  }

  void zoomOut() {
    if (thumbnailWidth.value > _thumbnailMinWidth) {
      thumbnailWidth.value -= 10;
    }
  }
}

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

class MediaResourcesListPanelWidget
    extends GetView<MediaResourcesListPanelController> {
  const MediaResourcesListPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
            }
          }
        },
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        controller.zoomIn();
                      },
                      icon: const Icon(
                        Icons.zoom_in,
                        size: 20,
                      )),
                  IconButton(
                      onPressed: () {
                        controller.zoomOut();
                      },
                      icon: const Icon(
                        Icons.zoom_out,
                        size: 20,
                      )),
                ],
              ),
            ),
            const _MediaResourcesListWidget(),
          ],
        ));
  }
}

class _MediaResourcesListWidget
    extends GetView<MediaResourcesListPanelController> {
  const _MediaResourcesListWidget();

  @override
  Widget build(BuildContext context) {
    final globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    return Expanded(
      child: ScrollablePositionedList.builder(
        itemScrollController: controller.mediaResourcesListScrollController,
        itemPositionsListener: controller.mediaResourcesListScrollListener,
        itemCount: globalMediaResourcesController.mediaResources.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              globalMediaResourcesController.currentMediaIndex.value = index;
            },
            child: Obx(() => Container(
                  color:
                      globalMediaResourcesController.currentMediaIndex.value ==
                              index
                          ? Colors.grey
                          : Colors.transparent,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Flex(
                              direction: Axis.vertical,
                              children: [
                                Obx(() => SizedBox(
                                      width: controller.thumbnailWidth.value,
                                      height: controller.thumbnailWidth.value *
                                          0.618,
                                      child: globalMediaResourcesController
                                                  .mediaResources[index]
                                                  .thumbFile ==
                                              null
                                          ? Image.asset(
                                              'assets/images/resource_not_found.jpeg',
                                              fit: BoxFit.cover)
                                          : Image.file(
                                              globalMediaResourcesController
                                                  .mediaResources[index]
                                                  .thumbFile!,
                                              fit: BoxFit.contain),
                                    )),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                globalMediaResourcesController
                                    .mediaResources[index].name,
                                style: const TextStyle(
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}

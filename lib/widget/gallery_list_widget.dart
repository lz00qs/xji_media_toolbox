import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../global_controller.dart';

class GalleryListWidget extends StatelessWidget {
  const GalleryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    final ItemScrollController itemScrollController = ItemScrollController();
    final ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();
    const scrollDuration = Duration(milliseconds: 100);

    final focusNodes =
        List.generate(controller.footageList.length, (index) => FocusNode());
    return CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowUp): () {
            if (controller.currentFootageIndex.value > 0) {
              controller.currentFootageIndex.value -= 1;
              FocusScope.of(context).requestFocus(
                  focusNodes[controller.currentFootageIndex.value]);
              if (controller.currentFootageIndex.value <
                  itemPositionsListener.itemPositions.value.first.index) {
                itemScrollController.scrollTo(
                    index: controller.currentFootageIndex.value,
                    duration: scrollDuration);
              }
            }
          },
          const SingleActivator(LogicalKeyboardKey.arrowDown): () {
            if (controller.currentFootageIndex.value <
                controller.footageList.length - 1) {
              controller.currentFootageIndex.value += 1;
              FocusScope.of(context).requestFocus(
                  focusNodes[controller.currentFootageIndex.value]);
              final delta =
                  itemPositionsListener.itemPositions.value.last.index -
                      itemPositionsListener.itemPositions.value.first.index;
              if (controller.currentFootageIndex.value >
                  itemPositionsListener.itemPositions.value.last.index - 1) {
                itemScrollController.scrollTo(
                    index: controller.currentFootageIndex.value - delta + 1,
                    duration: scrollDuration);
              }
            }
          },
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () {},
          const SingleActivator(LogicalKeyboardKey.arrowRight): () {},
          const SingleActivator(LogicalKeyboardKey.tab): () {
            if (controller.currentFootageIndex.value <
                controller.footageList.length - 1) {
              controller.currentFootageIndex.value += 1;
              FocusScope.of(context).requestFocus(
                  focusNodes[controller.currentFootageIndex.value]);
              final delta =
                  itemPositionsListener.itemPositions.value.last.index -
                      itemPositionsListener.itemPositions.value.first.index;
              if (controller.currentFootageIndex.value >
                  itemPositionsListener.itemPositions.value.last.index - 1) {
                itemScrollController.scrollTo(
                    index: controller.currentFootageIndex.value - delta + 1,
                    duration: scrollDuration);
              }
            }
          },
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
                        if (controller.thumbnailWidth.value < 200) {
                          controller.thumbnailWidth.value += 10;
                        }
                      },
                      icon: const Icon(
                        Icons.zoom_in,
                        size: 20,
                      )),
                  IconButton(
                      onPressed: () {
                        if (controller.thumbnailWidth.value > 100) {
                          controller.thumbnailWidth.value -= 10;
                        }
                      },
                      icon: const Icon(
                        Icons.zoom_out,
                        size: 20,
                      )),
                  IconButton(
                      onPressed: () {
                        controller.isFootageListView.value = false;
                      },
                      icon: const Icon(
                        Icons.grid_view,
                        size: 20,
                      )),
                ],
              ),
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemCount: controller.footageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Obx(() => ListTile(
                        selected: controller.currentFootageIndex.value == index,
                        selectedTileColor: Colors.grey[300],
                        focusNode: focusNodes[index],
                        autofocus:
                            controller.currentFootageIndex.value == index,
                        title: Row(
                          children: [
                            Flex(
                              direction: Axis.vertical,
                              children: [
                                SizedBox(
                                  width: controller.thumbnailWidth.value,
                                  height:
                                      controller.thumbnailWidth.value * 0.618,
                                  child: controller
                                              .footageList[index].thumbFile ==
                                          null
                                      ? Image.asset(
                                          'assets/images/resource_not_found.jpeg',
                                          fit: BoxFit.cover)
                                      : Image.file(
                                          controller
                                              .footageList[index].thumbFile!,
                                          fit: BoxFit.contain),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                controller.footageList[index].name,
                                style: const TextStyle(
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // 获取 index
                          controller.currentFootageIndex.value = index;
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index]);
                        },
                      ));
                },
              ),
            ),
          ],
        ));
  }
}

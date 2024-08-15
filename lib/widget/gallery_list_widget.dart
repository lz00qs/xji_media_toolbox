import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../footage.dart';
import '../global_controller.dart';

class GalleryListWidget extends StatelessWidget {
  const GalleryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();

    return Column(
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
        Obx(() => _ItemListWidget(
            footageList: controller.footageList.toList(),
            currentFootageIndex: controller.currentFootageIndex.value)),
      ],
    );
  }
}

class _ItemListWidget extends StatelessWidget {
  const _ItemListWidget(
      {required this.footageList, required this.currentFootageIndex});

  final List<Footage> footageList;
  final int currentFootageIndex;

  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    return Expanded(
      child: ScrollablePositionedList.builder(
        itemScrollController: controller.galleryListScrollController,
        itemPositionsListener: controller.galleryListScrollListener,
        itemCount: footageList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              controller.currentFootageIndex.value = index;
              controller.isEditingVideo.value = false;
            },
            child: Container(
              color: currentFootageIndex == index
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
                                  height:
                                      controller.thumbnailWidth.value * 0.618,
                                  child: footageList[index].thumbFile == null
                                      ? Image.asset(
                                          'assets/images/resource_not_found.jpeg',
                                          fit: BoxFit.cover)
                                      : Image.file(
                                          footageList[index].thumbFile!,
                                          fit: BoxFit.contain),
                                )),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Obx(() => Text(
                                footageList[index].name.value,
                                style: const TextStyle(
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

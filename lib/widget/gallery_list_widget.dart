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
        Expanded(
          child: ScrollablePositionedList.builder(
            itemScrollController: controller.galleryListScrollController,
            itemPositionsListener: controller.galleryListScrollListener,
            itemCount: controller.footageList.length,
            itemBuilder: (BuildContext context, int index) {
              return Obx(() => GestureDetector(
                    onTap: () {
                      controller.currentFootageIndex.value = index;
                    },
                    child: Container(
                      color: controller.currentFootageIndex.value == index
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
                                    SizedBox(
                                      width: controller.thumbnailWidth.value,
                                      height: controller.thumbnailWidth.value *
                                          0.618,
                                      child: controller.footageList[index]
                                                  .thumbFile ==
                                              null
                                          ? Image.asset(
                                              'assets/images/resource_not_found.jpeg',
                                              fit: BoxFit.cover)
                                          : Image.file(
                                              controller.footageList[index]
                                                  .thumbFile!,
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
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }
}

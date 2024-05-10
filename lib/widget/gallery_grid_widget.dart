import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/global_controller.dart';
import 'package:xji_footage_toolbox/widget/thumbnail_widget.dart';

class GalleryGridWidget extends StatelessWidget {
  const GalleryGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    int columnCount = 2;
    double gridWidth = 0;
    final focusNodes =
    List.generate(controller.footageList.length, (index) => FocusNode());
    final scrollController = ScrollController();

    void scrollToIndex(int index, int columnCount, double rowHeight) {

      double offset = rowHeight * (index ~/ columnCount) + 1;
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    return CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowUp): () {
            if (controller.currentFootageIndex.value > columnCount) {
              controller.currentFootageIndex.value -= columnCount;
              FocusScope.of(context)
                  .requestFocus(focusNodes[controller.currentFootageIndex.value]);
              // FocusScope.of(context).requestFocus(
              //     focusNodes[controller.currentFootageIndex.value]);
              // if (controller.currentFootageIndex.value <
              //     itemPositionsListener.itemPositions.value.first.index) {
              //   itemScrollController.scrollTo(
              //       index: controller.currentFootageIndex.value,
              //       duration: const Duration(milliseconds: 500));
              // }
              scrollToIndex(controller.currentFootageIndex.value, columnCount, gridWidth / 0.618);
            }
          },
          const SingleActivator(LogicalKeyboardKey.arrowDown): () {
            if (controller.currentFootageIndex.value <
                controller.footageList.length - columnCount) {
              controller.currentFootageIndex.value += columnCount;
              FocusScope.of(context)
                  .requestFocus(focusNodes[controller.currentFootageIndex.value]);
              // FocusScope.of(context).requestFocus(
              //     focusNodes[controller.currentFootageIndex.value]);
              // final delta =
              //     itemPositionsListener.itemPositions.value.last.index -
              //         itemPositionsListener.itemPositions.value.first.index;
              // if (controller.currentFootageIndex.value >
              //     itemPositionsListener.itemPositions.value.last.index - 1) {
              //   itemScrollController.scrollTo(
              //       index: controller.currentFootageIndex.value - delta + 1,
              //       duration: const Duration(milliseconds: 500));
              // }
              scrollToIndex(controller.currentFootageIndex.value, columnCount, gridWidth / 0.618);
            }
          },
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
            if (controller.currentFootageIndex.value > 0) {
              controller.currentFootageIndex.value -= 1;
              FocusScope.of(context)
                  .requestFocus(focusNodes[controller.currentFootageIndex.value]);
              // FocusScope.of(context).requestFocus(
              //     focusNodes[controller.currentFootageIndex.value]);
              // if (controller.currentFootageIndex.value <
              //     itemPositionsListener.itemPositions.value.first.index) {
              //   itemScrollController.scrollTo(
              //       index: controller.currentFootageIndex.value,
              //       duration: const Duration(milliseconds: 500));
              // }
              scrollToIndex(controller.currentFootageIndex.value, columnCount, gridWidth / 0.618);
            }
          },
          const SingleActivator(LogicalKeyboardKey.arrowRight): () {
            if (controller.currentFootageIndex.value <
                controller.footageList.length - 1) {
              controller.currentFootageIndex.value += 1;
              FocusScope.of(context)
                  .requestFocus(focusNodes[controller.currentFootageIndex.value]);
              scrollToIndex(controller.currentFootageIndex.value, columnCount, gridWidth / 0.618);
            }
          },
          const SingleActivator(LogicalKeyboardKey.tab): () {
            // if (controller.currentFootageIndex.value <
            //     controller.footageList.length - 1) {
            //   controller.currentFootageIndex.value += 1;
            //   FocusScope.of(context).requestFocus(
            //       focusNodes[controller.currentFootageIndex.value]);
            //   final delta =
            //       itemPositionsListener.itemPositions.value.last.index -
            //           itemPositionsListener.itemPositions.value.first.index;
            //   if (controller.currentFootageIndex.value >
            //       itemPositionsListener.itemPositions.value.last.index - 1) {
            //     itemScrollController.scrollTo(
            //         index: controller.currentFootageIndex.value - delta + 1,
            //         duration: const Duration(milliseconds: 500));
            //   }
            // }
          },
        },
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final parentWidth = constraints.maxWidth;
          if (kDebugMode) {
            print("parentWidth: $parentWidth");
          }
          final RxInt calculatedColumnCount = 0.obs;
          const minimumTileWidth = 150;

          void updateColumn() {
            calculatedColumnCount.value =
                min((parentWidth / minimumTileWidth).floor(), columnCount);
            calculatedColumnCount.value =
                max(calculatedColumnCount.value, 1); // 至少有一列
            if (kDebugMode) {
              print("columnCount: $calculatedColumnCount");
            }
            gridWidth =
                _calculateGridWidth(parentWidth, calculatedColumnCount.value);
          }

          updateColumn();
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
                          if (columnCount > 1) {
                            columnCount -= 1;
                            if (kDebugMode) {
                              print(columnCount);
                            }
                            updateColumn();
                          }
                        },
                        icon: const Icon(
                          Icons.zoom_in,
                          size: 20,
                        )),
                    IconButton(
                        onPressed: () {
                          columnCount += 1;
                          columnCount = min(
                              (parentWidth / minimumTileWidth).floor(),
                              columnCount);
                          updateColumn();
                          if (kDebugMode) {
                            print(columnCount);
                          }
                        },
                        icon: const Icon(Icons.zoom_out, size: 20)),
                    IconButton(
                        onPressed: () {
                          controller.isFootageListView.value = true;
                        },
                        icon: const Icon(
                          Icons.list,
                          size: 20,
                        )),
                  ],
                ),
              ),
              Obx(() => Expanded(
                      child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: controller.footageList.length,
                    padding: const EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: calculatedColumnCount.value,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1 / 0.618,
                    ),
                    controller: scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            controller.currentFootageIndex.value = index;
                            FocusScope.of(context)
                                .requestFocus(focusNodes[index]);
                          },
                          child: Obx(() => ThumbnailWidget(
                                footage: controller.footageList[index],
                                width: gridWidth,
                                height: gridWidth / 0.618,
                                isSelected:
                                    controller.currentFootageIndex.value ==
                                        index,
                                focusNode: focusNodes[index],
                              )));
                    },
                  ))),
            ],
          );
        }));
  }

  // 计算每个网格的宽度
  double _calculateGridWidth(double screenWidth, int columnCount) {
    if (kDebugMode) {
      print("screenWidth: $screenWidth");
    }
    double gridWidth = screenWidth / columnCount;
    return gridWidth;
  }
}

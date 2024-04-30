import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/global_controller.dart';
import 'package:xji_footage_toolbox/widget/thumbnail_widget.dart';

class GalleryGridWidget extends StatelessWidget {
  const GalleryGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    int columnCount = 2;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final parentWidth = constraints.maxWidth;
      if (kDebugMode) {
        print("parentWidth: $parentWidth");
      }
      final RxInt calculatedColumnCount = 0.obs;
      double gridWidth = 0;
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
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print("index: $index");
                      }
                    },
                    child: ThumbnailWidget(
                      footage: controller.footageList[index],
                      width: gridWidth,
                      height: gridWidth,
                    ),
                  );
                },
              ))),
        ],
      );
    });
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

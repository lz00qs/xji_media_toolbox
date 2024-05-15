import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/widget/footage_info_widget.dart';
import 'package:xji_footage_toolbox/widget/gallery_widget.dart';

import 'load_footage.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final openPressed = false.obs;
    var appBarHeight = 40.0;
    if (GetPlatform.isWindows || GetPlatform.isMacOS) {
      appBarHeight = 40.0;
    }
    return Scaffold(
      appBar: PreferredSize(
        // windows 和 macos size 做区分
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          leadingWidth: 200,
          leading: IconButton(
            onPressed: () async {
              if (openPressed.value) {
                return;
              }
              openPressed.value = true;
              // 打开视频文件夹
              await openFootageFolder();
              openPressed.value = false;
            },
            icon: const Icon(Icons.folder_open),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.help),
            ),
          ],
        ),
      ),
      body: ResizableLayout(),
    );
  }
}

class ResizableLayout extends StatelessWidget {
  final leftColumnMinWidth = 300.0;
  final rightColumnMinWidth = 400.0;
  final rowMinHeight = 300.0;
  final draggableAreaSize = 8.0;
  final leftColumnWidth = 300.0.obs;
  final topRowHeight = 400.0.obs;
  final dragIconSize = 20.0;

  ResizableLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final parentWidth = MediaQuery.of(context).size.width;
    final parentHeight = MediaQuery.of(context).size.height;
    if (topRowHeight.value + rowMinHeight >= parentHeight) {
      topRowHeight.value = parentHeight - rowMinHeight;
    }
    if (leftColumnWidth.value + rightColumnMinWidth >= parentWidth) {
      leftColumnWidth.value = parentWidth - rightColumnMinWidth;
    }
    return Obx(() => Row(children: [
          Container(
              constraints: BoxConstraints(
                minWidth: leftColumnMinWidth,
              ),
              child: Column(
                children: [
                  Container(
                    width: leftColumnWidth.value,
                    height: topRowHeight.value,
                    constraints: BoxConstraints(minHeight: rowMinHeight),
                    child: GalleryWidget(),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.resizeRow,
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (kDebugMode) {
                          print("details.delta.dx: ${details.delta.dy}");
                        }
                        if (topRowHeight.value + details.delta.dy >=
                                rowMinHeight &&
                            parentHeight -
                                    topRowHeight.value -
                                    details.delta.dy >=
                                rowMinHeight) {
                          topRowHeight.value += details.delta.dy;
                        }
                      },
                      child: Container(
                        width: leftColumnWidth.value,
                        height: draggableAreaSize,
                        color: Colors.grey,
                        child: Stack(
                          children: [
                            Positioned(
                              top: draggableAreaSize / 2 - dragIconSize / 2,
                              left:
                                  leftColumnWidth.value / 2 - dragIconSize / 2,
                              child: Icon(
                                Icons.drag_handle,
                                size: dragIconSize,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: leftColumnWidth.value,
                      constraints: BoxConstraints(minHeight: rowMinHeight),
                      // color: Colors.yellow,
                      child: const FootageInfoWidget(),
                    ),
                  ),
                ],
              )),
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                // print("details.delta.dx: ${details.delta.dx}");
                if (leftColumnWidth.value + details.delta.dx >=
                        leftColumnMinWidth &&
                    parentWidth - leftColumnWidth.value - details.delta.dx >=
                        rightColumnMinWidth) {
                  leftColumnWidth.value += details.delta.dx;
                }
              },
              child: Container(
                width: draggableAreaSize,
                height: parentHeight,
                color: Colors.grey,
                child: Stack(
                  children: [
                    Positioned(
                      top: parentHeight / 2 - dragIconSize / 2,
                      left: draggableAreaSize / 2 - dragIconSize / 2,
                      child: Transform.rotate(
                        angle: 90 * (3.141592653589793 / 180),
                        child: Icon(
                          Icons.drag_handle,
                          size: dragIconSize,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: Container(color: Colors.red)),
        ]));
  }
}

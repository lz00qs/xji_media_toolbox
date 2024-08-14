import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/constants.dart';
import 'package:xji_footage_toolbox/global_controller.dart';
import 'package:xji_footage_toolbox/settings_page.dart';
import 'package:xji_footage_toolbox/video_processing.dart';
import 'package:xji_footage_toolbox/widget/aeb_photo_editor_widget.dart';
import 'package:xji_footage_toolbox/widget/export_video_dialog.dart';
import 'package:xji_footage_toolbox/widget/footage_info_widget.dart';
import 'package:xji_footage_toolbox/widget/gallery_widget.dart';
import 'package:xji_footage_toolbox/widget/normal_photo_editor_widget.dart';
import 'package:xji_footage_toolbox/widget/normal_video_editor_widget.dart';

import 'load_footage.dart';

const scrollDuration = Duration(milliseconds: 100);

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    Get.put(ExportVideoDialogController());
    final openPressed = false.obs;
    if (GetPlatform.isMacOS) {
      controller.appBarHeight.value = macAppBarHeight;
      controller.topButtonPadding.value = macTopButtonPadding;
      controller.topButtonSize.value =
          macAppBarHeight - 2 * macTopButtonPadding;
    }

    controller.galleryFocusNode.requestFocus();
    return CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowUp): () {
            if (controller.currentFootageIndex.value > 0) {
              controller.currentFootageIndex.value -= 1;
              if (controller.currentFootageIndex.value <
                  controller.galleryListScrollListener.itemPositions.value.first
                      .index) {
                controller.galleryListScrollController
                    .jumpTo(index: controller.currentFootageIndex.value);
              }
            }
          },
          const SingleActivator(LogicalKeyboardKey.arrowDown): () {
            if (controller.currentFootageIndex.value <
                controller.footageList.length - 1) {
              controller.currentFootageIndex.value += 1;
              final delta = controller.galleryListScrollListener.itemPositions
                      .value.last.index -
                  controller.galleryListScrollListener.itemPositions.value.first
                      .index;
              if (controller.currentFootageIndex.value >
                  controller.galleryListScrollListener.itemPositions.value.last
                          .index -
                      1) {
                controller.galleryListScrollController.jumpTo(
                  index: controller.currentFootageIndex.value - delta + 1,
                );
              }
            }
          },
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
            if (controller.footageList
                .toList()[controller.currentFootageIndex.value]
                .isAeb) {
              if (controller.currentAebIndex.value > 0) {
                controller.currentAebIndex.value -= 1;
                // print(
                //     'aebScrollListener: ${controller.aebListScrollListener.itemPositions.value}');
                if (controller
                        .aebListScrollListener.itemPositions.value.first.index >
                    controller.currentAebIndex.value) {
                  controller.aebListScrollController.scrollTo(
                      index: controller.currentAebIndex.value,
                      duration: scrollDuration);
                }
              }
            }
          },
          const SingleActivator(LogicalKeyboardKey.arrowRight): () {
            if (controller.footageList
                .toList()[controller.currentFootageIndex.value]
                .isAeb) {
              if (controller.currentAebIndex.value <
                  controller.footageList
                          .toList()[controller.currentFootageIndex.value]
                          .aebFiles
                          .length -
                      1) {
                controller.currentAebIndex.value += 1;
                // print(
                //     'aebScrollListener: ${controller.aebListScrollListener.itemPositions.value}');
                if (controller
                        .aebListScrollListener.itemPositions.value.last.index <
                    controller.currentAebIndex.value) {
                  controller.aebListScrollController.scrollTo(
                      index: controller.currentAebIndex.value,
                      duration: scrollDuration);
                }
              }
            }
          },
          const SingleActivator(LogicalKeyboardKey.tab): () {
            if (controller.currentFootageIndex.value <
                controller.footageList.length - 1) {
              controller.currentFootageIndex.value += 1;
              final delta = controller.galleryListScrollListener.itemPositions
                      .value.last.index -
                  controller.galleryListScrollListener.itemPositions.value.first
                      .index;
              if (controller.currentFootageIndex.value >
                  controller.galleryListScrollListener.itemPositions.value.last
                          .index -
                      1) {
                controller.galleryListScrollController.scrollTo(
                    index: controller.currentFootageIndex.value - delta + 1,
                    duration: scrollDuration);
              }
            }
          },
        },
        child: Focus(
            focusNode: controller.galleryFocusNode,
            child: Scaffold(
              key: scaffoldKey,
              appBar: PreferredSize(
                // windows 和 macos size 做区分
                preferredSize: Size.fromHeight(controller.appBarHeight.value),
                child: AppBar(
                  leadingWidth: 300,
                  leading: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 75,
                      ),
                      IconButton(
                        padding:
                            EdgeInsets.all(controller.topButtonPadding.value),
                        onPressed: () async {
                          if (openPressed.value) {
                            return;
                          }
                          openPressed.value = true;
                          // 打开视频文件夹
                          await openFootageFolder();
                          openPressed.value = false;
                        },
                        icon: Icon(
                          Icons.folder_open,
                          size: controller.topButtonSize.value,
                        ),
                      ),
                      IconButton(
                        padding:
                            EdgeInsets.all(controller.topButtonPadding.value),
                        onPressed: () {
                          Get.to(() => const SettingsPage());
                        },
                        icon: Icon(Icons.settings,
                            size: controller.topButtonSize.value),
                      ),
                      IconButton(
                        padding:
                            EdgeInsets.all(controller.topButtonPadding.value),
                        onPressed: () {},
                        icon: Icon(Icons.help,
                            size: controller.topButtonSize.value),
                      ),
                    ],
                  ),
                  // actions: controller.appBarActions,
                  actions: [
                    Obx(() {
                      if (controller.footageList.isEmpty) {
                        return const SizedBox();
                      }
                      if (controller
                          .footageList[controller.currentFootageIndex.value]
                          .isVideo) {
                        return _NormalVideoEditorActions();
                      } else {
                        if (controller
                            .footageList[controller.currentFootageIndex.value]
                            .isAeb) {
                          return _AebPhotoEditorActions();
                        } else {
                          return _NormalPhotoEditorActions();
                        }
                      }
                    })
                  ],
                ),
              ),
              body: ResizableLayout(),
              endDrawer: Drawer(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        scaffoldKey.currentState?.closeEndDrawer();
                      },
                      icon: const Icon(Icons.arrow_forward)),
                  Obx(() => Expanded(
                      child: ListView.builder(
                          itemCount: controller.videoProcessingTasks.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                title: Obx(() => Text(
                                    '${controller.videoProcessingTasks[index].getTypeString()} (${(controller.videoProcessingTasks[index].progress * 100).toInt()}%)')),
                                subtitle: Column(
                                  children: [
                                    Text(controller
                                        .videoProcessingTasks[index].name),
                                    Obx(() => controller
                                                .videoProcessingTasks[index]
                                                .status
                                                .value ==
                                            VideoProcessingStatus.processing
                                        ? LinearProgressIndicator(
                                            value: controller
                                                .videoProcessingTasks[index]
                                                .progress
                                                .value,
                                          )
                                        : const SizedBox())
                                  ],
                                ),
                                trailing: Obx(() {
                                  switch (controller.videoProcessingTasks[index]
                                      .status.value) {
                                    case VideoProcessingStatus.processing:
                                      return IconButton(
                                          onPressed: () {
                                            controller
                                                .videoProcessingTasks[index]
                                                .cancel();
                                          },
                                          icon: const Icon(Icons.cancel));
                                    case VideoProcessingStatus.finished:
                                      return const Icon(Icons.check);
                                    case VideoProcessingStatus.canceled:
                                      return const Icon(Icons.cancel_outlined);
                                    case VideoProcessingStatus.failed:
                                      return const Icon(Icons.error);
                                  }
                                }));
                          })))
                ],
              )),
            )));
  }
}

class _NormalPhotoEditorActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _EditorActionsDeleteButton(),
      ],
    );
  }
}

class _AebPhotoEditorActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RenameAebButton(),
        _EditorActionsDeleteButton(),
      ],
    );
  }
}

class _NormalVideoEditorActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ExportVideoButton(),
        _EditVideoButton(),
        _EditorActionsDeleteButton(),
        _OpenEndDrawerButton()
      ],
    );
  }
}

class _OpenEndDrawerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    return IconButton(
      padding: EdgeInsets.all(controller.topButtonPadding.value),
      icon: Icon(Icons.task_alt, size: controller.topButtonSize.value),
      onPressed: () {
        scaffoldKey.currentState?.openEndDrawer();
        // scaffoldKey.currentState?.closeEndDrawer();
      },
    );
  }
}

class _EditorActionsDeleteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    return IconButton(
      padding: EdgeInsets.all(controller.topButtonPadding.value),
      icon: Icon(
        Icons.delete,
        size: controller.topButtonSize.value,
      ),
      onPressed: () {
        controller.galleryFocusNode.unfocus();
        // FocusScope.of(context).requestFocus(controller.deleteDialogFocusNode);
        controller.deleteDialogFocusNode.requestFocus();
        Get.dialog(Focus(
            focusNode: controller.deleteDialogFocusNode,
            child: AlertDialog(
              title: const Text('Delete footage'),
              content:
                  const Text('Are you sure you want to delete this footage?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    controller.galleryFocusNode.requestFocus();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    controller.deleteCurrentFootage();
                    Get.back();
                    controller.galleryFocusNode.requestFocus();
                  },
                  child: const Text('Delete'),
                ),
              ],
            )));
        // controller.deleteCurrentFootage();
      },
    );
  }
}

class _RenameAebButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    return IconButton(
      padding: EdgeInsets.all(controller.topButtonPadding.value),
      icon: Icon(
        Icons.drive_file_rename_outline_rounded,
        size: controller.topButtonSize.value,
      ),
      onPressed: () {
        controller.galleryFocusNode.unfocus();
        controller.renameAebDialogFocusNode.requestFocus();
        Get.dialog(Focus(
            focusNode: controller.renameAebDialogFocusNode,
            child: AlertDialog(
              title: const Text('Rename AEB'),
              content: const Text(
                  'Are you sure you want to rename these AEB files?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    controller.galleryFocusNode.requestFocus();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    controller.renameCurrentAebFiles();
                    Get.back();
                    controller.galleryFocusNode.requestFocus();
                  },
                  child: const Text('Yes'),
                ),
              ],
            )));
      },
    );
  }
}

class _EditVideoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    return IconButton(
      padding: EdgeInsets.all(controller.topButtonPadding.value),
      icon: Obx(() => Icon(
            controller.isEditingVideo.value ? Icons.edit_off : Icons.edit,
            size: controller.topButtonSize.value,
          )),
      onPressed: () {
        controller.isEditingVideo.value = !controller.isEditingVideo.value;
      },
    );
  }
}

class _ExportVideoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    return IconButton(
      padding: EdgeInsets.all(controller.topButtonPadding.value),
      icon: const Icon(Icons.upload),
      onPressed: () async {
        Get.dialog(const ExportVideoDialog());
      },
    );
  }
}

class ResizableLayout extends GetView<GlobalController> {
  final leftColumnMinWidth = 300.0;
  final rightColumnMinWidth = 400.0;
  final rowMinHeight = 300.0;
  final draggableAreaSize = 8.0;
  final leftColumnWidth = 300.0.obs;
  final topRowHeight = 400.0.obs;
  final dragIconSize = 20.0;
  // final GlobalController controller = Get.find();

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
          Expanded(child: Obx(() {
            if (controller.footageList.isEmpty) {
              return const Center(
                child: Text('No footage'),
              );
            }

            if (controller
                .footageList[controller.currentFootageIndex.value].isVideo) {
              return NormalVideoEditorWidget(
                footage: controller
                    .footageList[controller.currentFootageIndex.value],
              );
            } else {
              if (controller
                  .footageList[controller.currentFootageIndex.value].isAeb) {
                return AebPhotoEditorWidget(
                  footage: controller
                      .footageList[controller.currentFootageIndex.value],
                );
              } else {
                return NormalPhotoEditorWidget(
                    footage: controller
                        .footageList[controller.currentFootageIndex.value]);
              }
            }
          })),
        ]));
  }
}

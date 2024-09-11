// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:xji_footage_toolbox/controllers/global_tasks_controller.dart';
// import 'package:xji_footage_toolbox/models/media_resource.dart';
// import 'package:xji_footage_toolbox/ui/widgets/buttons/load_media_resources_button.dart';
// import 'package:xji_footage_toolbox/ui/widgets/panels/media_resources_list_panel.dart';
// import 'package:xji_footage_toolbox/ui/widgets/panels/multi_select_panel.dart';
//
// import '../../controllers/global_focus_nodes_controller.dart';
// import '../../controllers/global_media_resources_controller.dart';
// import '../../models/video_process.dart';
// import '../widgets/app_bars/left_app_bar.dart';
//
// import '../widgets/panels/media_resource_info_panel.dart';
// import '../widgets/panels/media_resource_main_panel.dart';
// import '../widgets/panels/resizable_triple_panel.dart';
// import '../widgets/panels/views/aeb_photo_view.dart';
//
// void _decreaseCurrentMediaIndex() {
//   final globalMediaResourcesController =
//       Get.find<GlobalMediaResourcesController>();
//   final mediaResourcesListPanelController =
//       Get.find<MediaResourcesListPanelController>();
//
//   if (globalMediaResourcesController.currentMediaIndex > 0) {
//     globalMediaResourcesController.currentMediaIndex.value -= 1;
//
//     if (globalMediaResourcesController.currentMediaIndex.value <
//         mediaResourcesListPanelController
//             .mediaResourcesListScrollListener.itemPositions.value.first.index) {
//       mediaResourcesListPanelController.mediaResourcesListScrollController
//           .jumpTo(
//               index: globalMediaResourcesController.currentMediaIndex.value);
//     }
//   }
// }
//
// void _increaseCurrentMediaIndex() {
//   final globalMediaResourcesController =
//       Get.find<GlobalMediaResourcesController>();
//   final mediaResourcesListPanelController =
//       Get.find<MediaResourcesListPanelController>();
//
//   if (globalMediaResourcesController.currentMediaIndex <
//       globalMediaResourcesController.mediaResources.length - 1) {
//     globalMediaResourcesController.currentMediaIndex.value += 1;
//
//     if (globalMediaResourcesController.currentMediaIndex.value >
//         mediaResourcesListPanelController
//             .mediaResourcesListScrollListener.itemPositions.value.last.index) {
//       mediaResourcesListPanelController.mediaResourcesListScrollController
//           .jumpTo(
//               index: globalMediaResourcesController.currentMediaIndex.value);
//     }
//   }
// }
//
// void _increaseCurrentAebIndex() {
//   final aebPhotoViewerController = Get.find<AebPhotoViewController>();
//   final globalMediaResourcesController =
//       Get.find<GlobalMediaResourcesController>();
//
//   if (aebPhotoViewerController.currentAebIndex <
//       (globalMediaResourcesController.mediaResources[
//                       globalMediaResourcesController.currentMediaIndex.value]
//                   as AebPhotoResource)
//               .aebFiles
//               .length -
//           1) {
//     aebPhotoViewerController.currentAebIndex.value += 1;
//   }
//
//   if (aebPhotoViewerController
//           .aebListScrollListener.itemPositions.value.last.index <
//       aebPhotoViewerController.currentAebIndex.value) {
//     aebPhotoViewerController.aebListScrollController.jumpTo(
//         index: aebPhotoViewerController.currentAebIndex.value, alignment: 0.5);
//   }
// }
//
// void _decreaseCurrentAebIndex() {
//   final aebPhotoViewerController = Get.find<AebPhotoViewController>();
//
//   if (aebPhotoViewerController.currentAebIndex > 0) {
//     aebPhotoViewerController.currentAebIndex.value -= 1;
//   }
//
//   if (aebPhotoViewerController
//           .aebListScrollListener.itemPositions.value.first.index >
//       aebPhotoViewerController.currentAebIndex.value) {
//     aebPhotoViewerController.aebListScrollController.jumpTo(
//         index: aebPhotoViewerController.currentAebIndex.value, alignment: 0.5);
//   }
// }
//
// class MainPage extends StatelessWidget {
//   const MainPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final globalMediaResourcesController =
//         Get.find<GlobalMediaResourcesController>();
//     final globalFocusNodesController = Get.find<GlobalFocusNodesController>();
//     final GlobalTasksController globalTasksController =
//         Get.find<GlobalTasksController>();
//     Get.find<MediaResourcesListPanelController>();
//
//     return KeyboardListener(
//         focusNode: globalFocusNodesController.mediaResourcesListPanelFocusNode,
//         autofocus: true,
//         onKeyEvent: (event) {
//           if (event is KeyDownEvent || event is KeyRepeatEvent) {
//             switch (event.logicalKey) {
//               case LogicalKeyboardKey.arrowUp:
//                 _decreaseCurrentMediaIndex();
//                 break;
//               case LogicalKeyboardKey.arrowDown:
//                 _increaseCurrentMediaIndex();
//                 break;
//               case LogicalKeyboardKey.arrowLeft:
//                 if (globalMediaResourcesController.mediaResources.isNotEmpty &&
//                     globalMediaResourcesController
//                         .mediaResources[globalMediaResourcesController
//                             .currentMediaIndex.value]
//                         .isAeb) {
//                   _decreaseCurrentAebIndex();
//                 }
//                 break;
//               case LogicalKeyboardKey.arrowRight:
//                 if (globalMediaResourcesController.mediaResources.isNotEmpty &&
//                     globalMediaResourcesController
//                         .mediaResources[globalMediaResourcesController
//                             .currentMediaIndex.value]
//                         .isAeb) {
//                   _increaseCurrentAebIndex();
//                 }
//                 break;
//             }
//           }
//         },
//         child: Scaffold(
//           endDrawer: Drawer(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               IconButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   icon: const Icon(Icons.arrow_forward)),
//               Obx(() => Expanded(
//                   child: ListView.builder(
//                       itemCount:
//                           globalTasksController.videoProcessingTasks.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return ListTile(
//                             title: Obx(() => Text(
//                                 '${globalTasksController.videoProcessingTasks[index].getTypeString()} (${(globalTasksController.videoProcessingTasks[index].progress * 100).toInt()}%)')),
//                             subtitle: Column(
//                               children: [
//                                 Text(globalTasksController
//                                     .videoProcessingTasks[index].name),
//                                 Obx(() => globalTasksController
//                                             .videoProcessingTasks[index]
//                                             .status
//                                             .value ==
//                                         VideoProcessStatus.processing
//                                     ? LinearProgressIndicator(
//                                         value: globalTasksController
//                                             .videoProcessingTasks[index]
//                                             .progress
//                                             .value,
//                                       )
//                                     : const SizedBox())
//                               ],
//                             ),
//                             trailing: Obx(() {
//                               switch (globalTasksController
//                                   .videoProcessingTasks[index].status.value) {
//                                 case VideoProcessStatus.processing:
//                                   return IconButton(
//                                       onPressed: () {
//                                         globalTasksController
//                                             .videoProcessingTasks[index]
//                                             .cancel();
//                                       },
//                                       icon: const Icon(Icons.cancel));
//                                 case VideoProcessStatus.finished:
//                                   return const Icon(Icons.check);
//                                 case VideoProcessStatus.canceled:
//                                   return const Icon(Icons.cancel_outlined);
//                                 case VideoProcessStatus.failed:
//                                   return const Icon(Icons.error);
//                               }
//                             }));
//                       })))
//             ],
//           )),
//           body: ResizableTriplePanel(
//             topLeftPanel:
//                 Column(mainAxisAlignment: MainAxisAlignment.start, children: [
//               const LeftAppBar(),
//               Obx(() => Expanded(
//                   child: globalMediaResourcesController.mediaResources.isEmpty
//                       ? const Center(
//                           child: LoadMediaResourcesButton(),
//                         )
//                       : const MediaResourcesListPanel())),
//             ]),
//             bottomLeftPanel: Obx(() =>
//                 globalMediaResourcesController.mediaResources.isEmpty ||
//                         globalMediaResourcesController.isMultipleSelection.value
//                     ? const SizedBox()
//                     : MediaResourceInfoPanel(
//                         mediaResource:
//                             globalMediaResourcesController.mediaResources[
//                                 globalMediaResourcesController
//                                     .currentMediaIndex.value])),
//             rightPanel: Obx(() =>
//                 globalMediaResourcesController.mediaResources.isEmpty
//                     ? const SizedBox()
//                     : globalMediaResourcesController.isMultipleSelection.value
//                         ? const MultiSelectPanel()
//                         : MediaResourceMainPanel(
//                             mediaResource:
//                                 globalMediaResourcesController.mediaResources[
//                                     globalMediaResourcesController
//                                         .currentMediaIndex.value])),
//           ),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_media_resources_controller.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/new_ui/design_tokens.dart';
import 'package:xji_footage_toolbox/new_ui/media_resource_info_panel.dart';
import 'package:xji_footage_toolbox/new_ui/resizable_triple_panel.dart';

import '../../new_ui/aeb_photo_view.dart';
import '../../new_ui/main_page_app_bar.dart';
import '../../new_ui/main_panel.dart';
import '../../new_ui/main_panel_button.dart';
import '../../new_ui/media_resources_list_panel.dart';
import '../../new_ui/multi_select_panel.dart';
import '../../utils/media_resources_utils.dart';

class _MainPageEmpty extends StatelessWidget {
  const _MainPageEmpty();

  @override
  Widget build(BuildContext context) {
    var onPressed = false;
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: ColorDark.bg0,
      child: Center(
        child: MainPanelButton(
            iconData: Icons.folder_open,
            onPressed: () async {
              if (onPressed) {
                return;
              }
              onPressed = true;
              await openMediaResourcesFolder();
              onPressed = false;
            }),
      ),
    );
  }
}

class _MainPageNotEmpty extends StatelessWidget {
  final MediaResource mediaResource;
  final bool isMultipleSelection;

  const _MainPageNotEmpty(
      {required this.mediaResource, required this.isMultipleSelection});

  @override
  Widget build(BuildContext context) {
    final AebPhotoViewController aebPhotoViewController = Get.find();
    aebPhotoViewController.currentAebIndex.value = 0;
    return ResizableTriplePanel(
        topLeftPanel: const MediaResourcesListPanel(),
        bottomLeftPanel: MediaResourceInfoPanel(mediaResource: mediaResource),
        rightPanel: isMultipleSelection
            ? const MultiSelectPanel()
            : MainPanel(mediaResource: mediaResource));
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResizableTriplePanelController());
    final GlobalMediaResourcesController globalMediaResourcesController =
        Get.find();
    return Column(
      children: [
        const MainPageAppBar(),
        Expanded(
            child: Obx(() => globalMediaResourcesController
                    .mediaResources.isEmpty
                ? const _MainPageEmpty()
                : Obx(() => _MainPageNotEmpty(
                    mediaResource: globalMediaResourcesController
                            .mediaResources[
                        globalMediaResourcesController.currentMediaIndex.value],
                    isMultipleSelection: globalMediaResourcesController
                        .isMultipleSelection.value)))),
      ],
    );
  }
}

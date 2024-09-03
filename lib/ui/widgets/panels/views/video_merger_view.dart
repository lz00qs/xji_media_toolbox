import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/export_merged_video_dialog.dart';

import '../../../../controllers/global_media_resources_controller.dart';
import '../../app_bars/right_app_bar.dart';
import '../../buttons/app_bar_button.dart';
import '../multi_select_panel.dart';

class VideoMergerController extends GetxController {
  final reorderableListScrollController = ScrollController();
}

class VideoMergerView extends GetView<VideoMergerController> {
  final List<NormalVideoResource> videoResources;

  const VideoMergerView({super.key, required this.videoResources});

  @override
  Widget build(BuildContext context) {
    final rxVideoResources = videoResources.obs;
    Get.find<GlobalMediaResourcesController>();
    return Column(
      children: [
        RightAppBar(
          disableDeleteButton: true,
          children: [
            const _RightAppBarGoBackButton(),
            _RightAppBarExportMergedVideoButton(videoResources: videoResources),
          ],
        ),
        Flexible(
            child: Center(
          child: Obx(() => SizedBox(
                height: 100,
                child: Scrollbar(
                    controller: controller.reorderableListScrollController,
                    thumbVisibility: true,
                    child: ReorderableListView.builder(
                        buildDefaultDragHandles: false,
                        scrollDirection: Axis.horizontal,
                        scrollController:
                            controller.reorderableListScrollController,
                        // footer: const SizedBox(width: 100),
                        itemBuilder: (context, index) {
                          return ReorderableDragStartListener(
                              key: ValueKey(rxVideoResources[index]),
                              index: index,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        // height: 200,
                                        // width: 200,
                                        child: rxVideoResources[index]
                                                    .thumbFile ==
                                                null
                                            ? Image.asset(
                                                'assets/images/resource_not_found.jpeg',
                                                fit: BoxFit.cover)
                                            : Image.file(
                                                rxVideoResources[index]
                                                    .thumbFile!,
                                                fit: BoxFit.contain),
                                      ),
                                      Text(
                                        rxVideoResources[index]
                                            .name
                                            .split('.')
                                            .first,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  )));
                        },
                        itemCount: rxVideoResources.length,
                        onReorder: (int oldIndex, int newIndex) {
                          final NormalVideoResource videoResource =
                              rxVideoResources.removeAt(oldIndex);
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          rxVideoResources.insert(newIndex, videoResource);
                        })),
              )),
        )),
      ],
    );
  }
}

class _RightAppBarGoBackButton extends StatelessWidget {
  const _RightAppBarGoBackButton();

  @override
  Widget build(BuildContext context) {
    final MultiSelectPanelController multiSelectPanelController =
        Get.find<MultiSelectPanelController>();
    return AppBarButton(
        iconData: Icons.arrow_back_ios_new,
        onPressed: () {
          multiSelectPanelController.isMerging.value = false;
        });
  }
}

class _RightAppBarExportMergedVideoButton extends StatelessWidget {
  final List<NormalVideoResource> videoResources;

  const _RightAppBarExportMergedVideoButton({required this.videoResources});

  @override
  Widget build(BuildContext context) {
    Get.find<GlobalMediaResourcesController>();
    return AppBarButton(
        iconData: Icons.upload,
        onPressed: () {
          Get.dialog(ExportMergedVideoDialog(videoResources: videoResources));
        });
  }
}
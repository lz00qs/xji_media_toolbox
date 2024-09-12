import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/new_ui/design_tokens.dart';
import 'package:xji_footage_toolbox/new_ui/multi_select_panel.dart';
import 'package:xji_footage_toolbox/new_ui/video_export_dialog.dart';

import 'custom_icon_button.dart';
import 'main_panel.dart';

class _VideoThumbnail extends StatelessWidget {
  final NormalVideoResource videoResource;

  const _VideoThumbnail({required this.videoResource});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 272,
      height: 173,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 153,
              width: 272,
              child: videoResource.thumbFile == null
                  ? Image.asset('assets/images/resource_not_found.jpeg')
                  : Image.file(
                      videoResource.thumbFile!,
                      fit: BoxFit.fill,
                    )),
          Expanded(
              child: Text(
            videoResource.name.split('.').first,
            style: SemiTextStyles.regularENSemiBold
                .copyWith(color: ColorDark.text0),
          )),
          SizedBox(
            height: DesignValues.smallPadding,
          ),
        ],
      ),
    );
  }
}

class VideoMergerView extends StatelessWidget {
  final List<MediaResource> videoResources;

  const VideoMergerView({super.key, required this.videoResources});

  @override
  Widget build(BuildContext context) {
    final rxVideoResources = <NormalVideoResource>[].obs;
    rxVideoResources.addAll(videoResources
        .map((e) => e as NormalVideoResource)
        .toList()
        .cast<NormalVideoResource>());
    final scrollController = ScrollController();
    final MultiSelectPanelController multiSelectPanelController = Get.find();
    return Row(
      children: [
        Expanded(
            child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(
                Radius.circular(DesignValues.mediumBorderRadius)),
            child: Container(
              height: 200,
              color: ColorDark.bg3,
              child: Padding(
                padding: EdgeInsets.only(
                    left: DesignValues.mediumPadding,
                    right: DesignValues.mediumPadding,
                    top: DesignValues.mediumPadding),
                child: RawScrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    radius: Radius.circular(DesignValues.smallBorderRadius),
                    child: Obx(() => Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: ColorDark.bg3,
                          // shadowColor: Colors.transparent,
                        ),
                        child: ReorderableListView.builder(
                            buildDefaultDragHandles: false,
                            scrollDirection: Axis.horizontal,
                            scrollController: scrollController,
                            itemBuilder: (context, index) {
                              return ReorderableDragStartListener(
                                  key: ValueKey(rxVideoResources[index]),
                                  index: index,
                                  child: _VideoThumbnail(
                                    videoResource: rxVideoResources[index],
                                  ));
                            },
                            itemCount: rxVideoResources.length,
                            onReorder: (int oldIndex, int newIndex) {
                              final NormalVideoResource videoResource =
                                  rxVideoResources.removeAt(oldIndex);
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              rxVideoResources.insert(newIndex, videoResource);
                            })))),
              ),
            ),
          ),
        )),
        MainPanelSideBar(
          children: [
            CustomIconButton(
                iconData: Icons.arrow_back_ios_new,
                onPressed: () {
                  multiSelectPanelController.isMerging.value = false;
                },
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.macAppBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.save,
                onPressed: () async {
                  await Get.dialog(VideoExportDialog(
                    videoResources: rxVideoResources,
                  ));
                },
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.macAppBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
          ],
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/custom_icon_button.dart';

import '../../../controllers/global_media_resources_controller.dart';
import '../../../utils/format.dart';
import '../../design_tokens.dart';



class MediaResourcesListPanelController extends GetxController {
  final mediaResourcesListScrollController = ScrollController();
}

class MediaResourceThumbnail extends StatelessWidget {
  final MediaResource mediaResource;

  const MediaResourceThumbnail({super.key, required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 56,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignValues.smallBorderRadius),
        child: mediaResource.thumbFile == null
            ? Image.asset('assets/images/resource_not_found.jpeg')
            : Image.file(
                mediaResource.thumbFile!,
                fit: BoxFit.fill,
              ),
      ),
    );
  }
}

class _MediaResourcesListTopBar
    extends GetView<GlobalMediaResourcesController> {
  const _MediaResourcesListTopBar();

  @override
  Widget build(BuildContext context) {
    /// todo: implement windows app bar height
    return ClipRRect(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignValues.mediumBorderRadius)),
        child: Container(
          height: DesignValues.macAppBarHeight,
          width: double.infinity,
          color: ColorDark.bg3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: DesignValues.smallPadding,
              ),
              Text(
                'Files',
                style: SemiTextStyles.header6ENRegular
                    .copyWith(color: ColorDark.text2),
              ),
              const Spacer(),
              Obx(() => CustomIconButton(
                  iconData: controller.isMultipleSelection.value
                      ? Icons.keyboard_return
                      : Icons.checklist_rtl,
                  onPressed: () {
                    if (controller.isMultipleSelection.value) {
                      controller.selectedIndexList.clear();
                    }
                    controller.isMultipleSelection.value =
                        !controller.isMultipleSelection.value;
                  },
                  iconSize: DesignValues.mediumIconSize,
                  buttonSize: 32.0,
                  hoverColor: ColorDark.defaultHover,
                  focusColor: ColorDark.defaultActive,
                  iconColor: ColorDark.text2)),
            ],
          ),
        ));
  }
}

class _FileTypeFab extends StatelessWidget {
  final String fileType;
  final Color color;

  const _FileTypeFab({required this.fileType, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2.0),
      child: Container(
        height: 14,
        color: color,
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 2),
          child: Text(
            fileType,
            style:
                SemiTextStyles.smallENRegular.copyWith(color: ColorDark.text0),
          ),
        ),
      ),
    );
  }
}

class _MediaResourceListWidget extends StatelessWidget {
  final MediaResource mediaResource;
  final bool isSelected;
  final bool isMultipleSelection;
  final int index;

  const _MediaResourceListWidget(
      {required this.index,
      required this.mediaResource,
      this.isSelected = false,
      this.isMultipleSelection = false});

  @override
  Widget build(BuildContext context) {
    final fileName = mediaResource.name.split('.').first;
    final extension = mediaResource.name.split('.').last.toUpperCase();
    final GlobalMediaResourcesController globalMediaResourcesController =
        Get.find();
    return Row(
      children: [
        Expanded(
            child: GestureDetector(
          onTap: () {
            if (isMultipleSelection) {
              globalMediaResourcesController.selectedIndexList.contains(index)
                  ? globalMediaResourcesController.selectedIndexList
                      .remove(index)
                  : globalMediaResourcesController.selectedIndexList.add(index);
            } else {
              globalMediaResourcesController.currentMediaIndex.value = index;
            }
          },
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(DesignValues.mediumBorderRadius),
            child: Column(
              children: [
                Container(
                  height: 72,
                  width: double.infinity,
                  color: isSelected
                      ? ColorDark.blue0.withOpacity(0.8)
                      : Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: DesignValues.smallPadding,
                        top: DesignValues.smallPadding,
                        bottom: DesignValues.smallPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MediaResourceThumbnail(mediaResource: mediaResource),
                        SizedBox(
                          width: DesignValues.ultraSmallPadding,
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  fileName,
                                  style: SemiTextStyles.regularENSemiBold
                                      .copyWith(
                                          color: ColorDark.text0,
                                          overflow: TextOverflow.ellipsis),
                                )),
                                // const Spacer(),
                                SizedBox(
                                  width: DesignValues.smallPadding,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 26,
                              child: Center(
                                child: Row(
                                  children: [
                                    extension == 'JPG'
                                        ? const _FileTypeFab(
                                            fileType: 'JPG',
                                            color: ColorDark.data4)
                                        : const SizedBox(),
                                    extension == 'JPG'
                                        ? mediaResource.isAeb
                                            ? SizedBox(
                                                width: DesignValues
                                                    .ultraSmallPadding)
                                            : const SizedBox()
                                        : const SizedBox(),
                                    extension == 'JPG'
                                        ? mediaResource.isAeb
                                            ? const _FileTypeFab(
                                                fileType: 'AEB',
                                                color: ColorDark.data8)
                                            : const SizedBox()
                                        : const SizedBox(),
                                    extension == 'MP4'
                                        ? const _FileTypeFab(
                                            fileType: 'MP4',
                                            color: ColorDark.data0)
                                        : const SizedBox(),
                                    extension == 'MP4'
                                        ? (mediaResource as NormalVideoResource)
                                                .isHevc
                                            ? SizedBox(
                                                width: DesignValues
                                                    .ultraSmallPadding)
                                            : const SizedBox()
                                        : const SizedBox(),
                                    extension == 'MP4'
                                        ? (mediaResource as NormalVideoResource)
                                                .isHevc
                                            ? const _FileTypeFab(
                                                fileType: 'HEVC',
                                                color: ColorDark.data2)
                                            : const SizedBox()
                                        : const SizedBox(),
                                    const Spacer(),
                                    isMultipleSelection
                                        ? CustomIconButton(
                                            iconData: isSelected
                                                ? Icons.check_box_outlined
                                                : Icons.check_box_outline_blank,
                                            onPressed: () {
                                              if (isMultipleSelection) {
                                                globalMediaResourcesController
                                                        .selectedIndexList
                                                        .contains(index)
                                                    ? globalMediaResourcesController
                                                        .selectedIndexList
                                                        .remove(index)
                                                    : globalMediaResourcesController
                                                        .selectedIndexList
                                                        .add(index);
                                              }
                                            },
                                            iconSize:
                                                DesignValues.smallIconSize,
                                            buttonSize: 24,
                                            hoverColor: ColorDark.defaultHover,
                                            focusColor: ColorDark.defaultActive,
                                            iconColor: ColorDark.text1)
                                        : const SizedBox(),
                                    SizedBox(
                                      width: DesignValues.mediumPadding,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${mediaResource.width}x${mediaResource.height}',
                                  style: SemiTextStyles.smallENRegular
                                      .copyWith(color: ColorDark.text2),
                                ),
                                const Spacer(),
                                Text(
                                  mediaResource.isVideo
                                      ? formatDuration(
                                          (mediaResource as NormalVideoResource)
                                              .duration)
                                      : formatSize(mediaResource.sizeInBytes),
                                  style: SemiTextStyles.smallENRegular
                                      .copyWith(color: ColorDark.text2),
                                ),
                                SizedBox(
                                  width: DesignValues.smallPadding,
                                )
                              ],
                            )
                          ],
                        )),
                        SizedBox(
                          width: DesignValues.smallPadding,
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: ColorDark.border,
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

class MediaResourcesListPanel extends StatelessWidget {
  const MediaResourcesListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaResourcesListPanelController mediaResourcesListPanelController =
        Get.find();
    final globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const _MediaResourcesListTopBar(),
        Expanded(
            child: RawScrollbar(
                thickness: DesignValues.smallPadding,
                trackVisibility: false,
                thumbVisibility: true,
                radius: Radius.circular(DesignValues.smallBorderRadius),
                controller: mediaResourcesListPanelController
                    .mediaResourcesListScrollController,
                child: Row(
                  children: [
                    Expanded(
                        child: Obx(() => ListView.builder(
                            scrollDirection: Axis.vertical,
                            controller: mediaResourcesListPanelController
                                .mediaResourcesListScrollController,
                            itemCount: globalMediaResourcesController
                                .mediaResources.length,
                            itemBuilder: (context, index) {
                              final mediaResource =
                                  globalMediaResourcesController
                                      .mediaResources[index];
                              return Obx(() => _MediaResourceListWidget(
                                    index: index,
                                    mediaResource: mediaResource,
                                    isSelected: globalMediaResourcesController
                                            .selectedIndexList
                                            .contains(index) ||
                                        (!globalMediaResourcesController
                                                .isMultipleSelection.value &&
                                            globalMediaResourcesController
                                                    .currentMediaIndex.value ==
                                                index),
                                    isMultipleSelection:
                                        globalMediaResourcesController
                                            .isMultipleSelection.value,
                                  ));
                            }))),
                  ],
                )))
      ],
    );
  }
}

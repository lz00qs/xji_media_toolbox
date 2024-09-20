
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/photo_viewer.dart';

import '../../../models/media_resource.dart';
import '../buttons/custom_icon_button.dart';
import '../../design_tokens.dart';
import '../../main_panel.dart';
import 'media_resources_list_panel.dart';

class AebPhotoViewController extends GetxController {
  final currentAebIndex = 0.obs;
  final aebListScrollController = ScrollController();
}

class _AebPhotoThumbnail extends StatelessWidget {
  final AebPhotoResource photoResource;
  final bool isSelected;
  final int index;

  const _AebPhotoThumbnail(
      {required this.photoResource,
      required this.index,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final AebPhotoViewController controller = Get.find();
    return Column(
      children: [
        Expanded(
            child: GestureDetector(
          onTap: () {
            controller.currentAebIndex.value = index;
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DesignValues.ultraSmallPadding),
            child: Container(
              height: 100 - DesignValues.smallPadding,
              color: isSelected
                  ? ColorDark.data8.withOpacity(0.7)
                  : Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: DesignValues.ultraSmallPadding,
                        left: DesignValues.ultraSmallPadding,
                        right: DesignValues.ultraSmallPadding),
                    child: MediaResourceThumbnail(mediaResource: photoResource),
                  ),
                  Expanded(
                      child: Center(
                    child: Text(photoResource.evBias,
                        style: SemiTextStyles.regularENRegular.copyWith(
                            color: isSelected
                                ? ColorDark.text0
                                : ColorDark.text1,
                            overflow: TextOverflow.ellipsis)),
                  )),
                ],
              ),
            ),
          ),
        )),
        SizedBox(
          height: DesignValues.smallPadding,
        ),
      ],
    );
  }
}

class _AebPhotoThumbnailList extends GetView<AebPhotoViewController> {
  final List<MediaResource> resources;

  const _AebPhotoThumbnailList({required this.resources});

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
        thickness: DesignValues.smallPadding,
        trackVisibility: false,
        thumbVisibility: true,
        radius: Radius.circular(DesignValues.smallBorderRadius),
        controller: controller.aebListScrollController,
        child: ListView.builder(
            controller: controller.aebListScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: resources.length,
            itemBuilder: (context, index) {
              return Obx(() => _AebPhotoThumbnail(
                  photoResource: resources[index] as AebPhotoResource,
                  index: index,
                  isSelected: index == controller.currentAebIndex.value));
            }));
  }
}

class AebPhotoView extends GetView<AebPhotoViewController> {
  final AebPhotoResource photoResource;

  const AebPhotoView({super.key, required this.photoResource});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(
                  DesignValues.smallPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Obx(() => PhotoViewer(
                        photoFile: photoResource
                            .aebResources[controller.currentAebIndex.value]
                            .file)),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButton(
                          iconData: Icons.chevron_left,
                          onPressed: () {
                            if (controller.currentAebIndex.value > 0) {
                              controller.currentAebIndex.value--;
                            }
                          },
                          iconSize: 32,
                          buttonSize: 48,
                          hoverColor: ColorDark.defaultHover,
                          focusColor: ColorDark.defaultActive,
                          iconColor: ColorDark.text0,
                        ),
                        SizedBox(
                          width: DesignValues.largePadding,
                        ),
                        CustomIconButton(
                          iconData: Icons.chevron_right,
                          onPressed: () {
                            if (controller.currentAebIndex.value <
                                photoResource.aebResources.length - 1) {
                              controller.currentAebIndex.value++;
                            }
                          },
                          iconSize: 32,
                          buttonSize: 48,
                          hoverColor: ColorDark.defaultHover,
                          focusColor: ColorDark.defaultActive,
                          iconColor: ColorDark.text0,
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(DesignValues.smallBorderRadius)),
                    child: Container(
                      color: ColorDark.bg2,
                      height: 100,
                      child: Column(
                        children: [
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: DesignValues.ultraSmallPadding,
                                    right: DesignValues.ultraSmallPadding,
                                    top: DesignValues.ultraSmallPadding),
                                child: _AebPhotoThumbnailList(
                                    resources: photoResource.aebResources),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        MainPanelSideBar(
          children: [
            const MainPanelSideBarControlButtons(),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.drive_file_rename_outline_rounded,
                onPressed: () {},
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.macAppBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
          ],
        ),
      ],
    );
  }
}

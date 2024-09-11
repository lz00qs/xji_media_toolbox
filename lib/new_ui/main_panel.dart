import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_media_resources_controller.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/new_ui/design_tokens.dart';
import 'package:xji_footage_toolbox/new_ui/normal_video_view.dart';

import 'aeb_photo_view.dart';
import 'custom_icon_button.dart';
import 'media_resource_delete_dialog.dart';
import 'normal_photo_view.dart';

class MainPanelSideBarControlButtons extends StatelessWidget {
  const MainPanelSideBarControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement windows
    final GlobalMediaResourcesController globalMediaResourcesController =
        Get.find();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomIconButton(
          iconData: Icons.delete,
          onPressed: () async {
            await Get.dialog(const MediaResourceDeleteDialog());
          },
          iconSize: DesignValues.mediumIconSize,
          buttonSize: DesignValues.macAppBarHeight,
          hoverColor: ColorDark.defaultHover,
          focusColor: ColorDark.defaultActive,
          iconColor: ColorDark.text0,
        ),
        SizedBox(
          height: DesignValues.mediumPadding,
        ),
        CustomIconButton(
          iconData: Icons.arrow_upward,
          onPressed: () {
            if (globalMediaResourcesController.currentMediaIndex.value > 0) {
              globalMediaResourcesController.currentMediaIndex.value--;
            }
          },
          iconSize: DesignValues.mediumIconSize,
          buttonSize: DesignValues.macAppBarHeight,
          hoverColor: ColorDark.defaultHover,
          focusColor: ColorDark.defaultActive,
          iconColor: ColorDark.text0,
        ),
        SizedBox(
          height: DesignValues.mediumPadding,
        ),
        CustomIconButton(
          iconData: Icons.arrow_downward,
          onPressed: () {
            if (globalMediaResourcesController.currentMediaIndex.value <
                globalMediaResourcesController.mediaResources.length - 1) {
              globalMediaResourcesController.currentMediaIndex.value++;
            }
          },
          iconSize: DesignValues.mediumIconSize,
          buttonSize: DesignValues.macAppBarHeight,
          hoverColor: ColorDark.defaultHover,
          focusColor: ColorDark.defaultActive,
          iconColor: ColorDark.text0,
        ),
      ],
    );
  }
}

class MainPanelSideBar extends StatelessWidget {
  final List<Widget> children;

  const MainPanelSideBar({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(
          right: Radius.circular(DesignValues.mediumBorderRadius)),
      child: Container(
        color: ColorDark.bg2,
        width: DesignValues.macAppBarHeight,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: DesignValues.smallPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}

class MainPanel extends StatelessWidget {
  final MediaResource mediaResource;

  const MainPanel({super.key, required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    if (mediaResource.isVideo) {
      return NormalVideoView(
          videoResource: mediaResource as NormalVideoResource);
    } else if (mediaResource.isAeb) {
      return AebPhotoView(photoResource: mediaResource as AebPhotoResource);
    } else {
      return NormalPhotoView(
          photoResource: mediaResource as NormalPhotoResource);
    }
  }
}

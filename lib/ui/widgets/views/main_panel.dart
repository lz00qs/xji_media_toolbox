import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/aeb_photo_view.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/chewie_video_player.dart';
import '../buttons/custom_icon_button.dart';
import 'normal_photo_view.dart';

class MainPanelSideBarControlButtons extends ConsumerWidget {
  const MainPanelSideBarControlButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement windows
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomIconButton(
          iconData: Icons.delete,
          onPressed: () async {
            // await Get.dialog(const MediaResourceDeleteDialog());
          },
          iconSize: DesignValues.mediumIconSize,
          buttonSize: DesignValues.appBarHeight,
          hoverColor: ColorDark.defaultHover,
          focusColor: ColorDark.defaultActive,
          iconColor: ColorDark.text0,
        ),
        SizedBox(
          height: DesignValues.mediumPadding,
        ),
        CustomIconButton(
          iconData: Icons.drive_file_rename_outline_rounded,
          onPressed: () async {
            // await Get.dialog(const MediaResourceRenameDialog());
          },
          iconSize: DesignValues.mediumIconSize,
          buttonSize: DesignValues.appBarHeight,
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
            // if (globalMediaResourcesController.currentMediaIndex.value > 0) {
            //   final MediaResourcesListPanelController
            //       mediaResourcesListPanelController = Get.find();
            //   globalMediaResourcesController.currentMediaIndex.value--;
            //   mediaResourcesListPanelController.scrollToIndex(
            //       globalMediaResourcesController.currentMediaIndex.value,
            //       false);
            // }
            ref.read(mediaResourcesProvider.notifier).decreaseCurrentIndex();
          },
          iconSize: DesignValues.mediumIconSize,
          buttonSize: DesignValues.appBarHeight,
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
            // if (globalMediaResourcesController.currentMediaIndex.value <
            //     globalMediaResourcesController.mediaResources.length - 1) {
            //   final MediaResourcesListPanelController
            //       mediaResourcesListPanelController = Get.find();
            //   globalMediaResourcesController.currentMediaIndex.value++;
            //   mediaResourcesListPanelController.scrollToIndex(
            //       globalMediaResourcesController.currentMediaIndex.value, true);
            // }
            ref.read(mediaResourcesProvider.notifier).increaseCurrentIndex();
          },
          iconSize: DesignValues.mediumIconSize,
          buttonSize: DesignValues.appBarHeight,
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
        width: DesignValues.appBarHeight,
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

class MainPanel extends ConsumerWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaResource = ref.watch(mediaResourcesProvider
        .select((state) => state.resources[state.currentIndex]));
    if (mediaResource.isVideo) {
      return ChewieVideoPlayer(videoFile: mediaResource.file);
    } else if (mediaResource.isAeb) {
      return AebPhotoView(photoResource: mediaResource as AebPhotoResource);
    } else {
      return NormalPhotoView(photoFile: mediaResource.file);
    }
  }
}

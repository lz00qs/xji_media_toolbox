import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/photo_panel.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/video_panel.dart';
import '../../../providers/media_resources_provider.dart';
import '../buttons/custom_icon_button.dart';
import '../dialogs/media_resource_delete_dialog.dart';
import '../dialogs/media_resource_rename_dialog.dart';

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
            await showDialog(
                context: context,
                builder: (BuildContext context) => MediaResourceDeleteDialog());
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
            // final mediaResourcesLength = ref.watch(mediaResourcesProvider
            //     .select((value) => value.resources.length));

            final mediaResourcesLength = ref.watch(mediaResourcesProvider.select((m) => m.resources.length));
            if (mediaResourcesLength == 0) {
              return;
            }
            final mediaResources = ref.watch(
                mediaResourcesProvider.select((value) => value.resources));
            final currentIndex = ref.watch(
                mediaResourcesProvider.select((value) => value.currentIndex));
            final mediaResource = mediaResources[currentIndex];
            if (mediaResource.isAeb) {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) => MediaResourceRenameDialog(
                      mediaResource:
                          (mediaResource as AebPhotoResource).aebResources[
                              ref.watch(mediaResourcesProvider
                                  .select((value) => value.currentAebIndex))]));
            } else {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      MediaResourceRenameDialog(mediaResource: mediaResource));
            }
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
    final mediaResources =
        ref.watch(mediaResourcesProvider.select((state) => state.resources));
    final currentIndex =
        ref.watch(mediaResourcesProvider.select((state) => state.currentIndex));
    final mediaResourcesLength = ref.watch(
        mediaResourcesProvider.select((state) => state.resources.length));
    if (mediaResourcesLength == 0) {
      return Container();
    }
    final mediaResource = mediaResources[currentIndex];
    if (mediaResource.isVideo) {
      return VideoPanel(videoFile: mediaResource.file);
    } else {
      return PhotoPanel(photoResource: mediaResource);
    }
  }
}

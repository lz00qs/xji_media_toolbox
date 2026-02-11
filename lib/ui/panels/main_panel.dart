import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.model.dart';
import 'package:xji_footage_toolbox/providers/media_resources_state.notifier.dart';
import 'package:xji_footage_toolbox/ui/panels/photo_viewer_panel.dart';
import 'package:xji_footage_toolbox/ui/panels/video_panel.dart';

import '../buttons/custom_icon_button.dart';
import '../design_tokens.dart';
import '../dialogs/media_resource_delete_dialog.dart';
import '../dialogs/media_resource_rename_dialog.dart';
import 'aeb_photo_viewer_panel.dart';

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
            final result = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) => MediaResourceDeleteDialog(
                      mediaResourcesLength: 1,
                    ));
            if (result == true) {
              await ref
                  .read(mediaResourcesStateProvider.notifier)
                  .deleteCurrentMediaResource();
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
          iconData: Icons.drive_file_rename_outline_rounded,
          onPressed: () async {
            final newName = await showDialog<String>(
                context: context,
                builder: (BuildContext context) => MediaResourceRenameDialog(
                    mediaResource:
                        ref.watch(mediaResourcesStateProvider).resources[ref
                            .watch(mediaResourcesStateProvider)
                            .currentResourceIndex]));
            if (newName != null && newName != '') {
              await ref
                  .read(mediaResourcesStateProvider.notifier)
                  .renameCurrentMediaResource(newName);
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
            ref
                .read(mediaResourcesStateProvider.notifier)
                .decreaseCurrentResourceIndex();
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
            ref
                .read(mediaResourcesStateProvider.notifier)
                .increaseCurrentResourceIndex();
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

class MainPanel extends StatelessWidget {
  final MediaResource resource;

  const MainPanel({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    switch (resource) {
      case PhotoResource():
        // TODO: Handle this case.
        return PhotoViewerPanel(photoFile: resource.file);
      case AebPhotoResource():
        // TODO: Handle this case.
        return AebPhotoViewerPanel(photoResource: resource as AebPhotoResource);
      case VideoResource():
        // TODO: Handle this case.
        return VideoPanel(resource: resource as VideoResource);
    }
  }
}

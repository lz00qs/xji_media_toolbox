import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/video_export_dialog.dart';

import '../../../models/media_resource.dart';
import '../../design_tokens.dart';
import '../buttons/custom_icon_button.dart';
import 'chewie_video_player_hook.dart';
import 'main_panel.dart';

class VideoPlayerPanel extends ConsumerWidget {
  final File videoFile;

  const VideoPlayerPanel({super.key, required this.videoFile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(DesignValues.smallPadding),
            child: ChewieVideoPlayerHook(
              videoFile: videoFile,
              showControls: true,
            ),
          ),
        ),
        MainPanelSideBar(
          children: [
            const MainPanelSideBarControlButtons(),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.cut,
                onPressed: () async {
                  ref.read(mediaResourcesProvider.notifier).setIsEditing(true);
                },
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.appBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.upload,
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return VideoExportDialog();
                      });
                },
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.appBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
          ],
        ),
      ],
    );
  }
}

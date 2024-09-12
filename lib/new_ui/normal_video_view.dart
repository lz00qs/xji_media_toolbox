import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/new_ui/custom_icon_button.dart';
import 'package:xji_footage_toolbox/new_ui/video_export_dialog.dart';
import 'package:xji_footage_toolbox/new_ui/video_player.dart';

import '../models/media_resource.dart';
import 'design_tokens.dart';
import 'main_panel.dart';

class NormalVideoView extends StatelessWidget {
  final NormalVideoResource videoResource;

  const NormalVideoView({super.key, required this.videoResource});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(DesignValues.smallPadding),
              child: VideoPlayer(videoResource: videoResource)),
        ),
        MainPanelSideBar(
          children: [
            const MainPanelSideBarControlButtons(),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.cut,
                onPressed: () async {},
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.macAppBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.upload,
                onPressed: () async {
                  await Get.dialog(const VideoExportDialog());
                },
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

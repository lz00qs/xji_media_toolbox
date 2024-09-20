import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/custom_icon_button.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/video_export_dialog.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/video_player_getx.dart';

import '../../../controllers/global_media_resources_controller.dart';
import '../../../models/media_resource.dart';
import '../../design_tokens.dart';
import '../../main_panel.dart';

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
              child: VideoPlayerGetx(videoResource: videoResource)),
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
                  final GlobalMediaResourcesController
                      globalMediaResourcesController =
                      Get.find<GlobalMediaResourcesController>();
                  globalMediaResourcesController.isEditingMediaResources.value =
                      true;
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

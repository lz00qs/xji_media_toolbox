import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/video_export_dialog.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/video_trimmer.dart';

import '../../../controllers/global_media_resources_controller.dart';
import '../buttons/custom_icon_button.dart';
import '../../design_tokens.dart';
import '../../main_panel.dart';

class NormalVideoTrimmerView extends StatelessWidget {
  final NormalVideoResource videoResource;

  const NormalVideoTrimmerView({super.key, required this.videoResource});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(DesignValues.smallPadding),
              child: VideoTrimmer(videoResource: videoResource)),
        ),
        MainPanelSideBar(
          children: [
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.arrow_back_ios_new,
                onPressed: () async {
                  final GlobalMediaResourcesController
                      globalMediaResourcesController =
                      Get.find<GlobalMediaResourcesController>();
                  globalMediaResourcesController.isEditingMediaResources.value =
                      false;
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

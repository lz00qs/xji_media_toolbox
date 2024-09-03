import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_media_resources_controller.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/app_bar_normal_video_edit_button.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/app_bar_export_video_button.dart';
import 'package:xji_footage_toolbox/ui/widgets/panels/views/video_cutter_view.dart';
import 'package:xji_footage_toolbox/ui/widgets/panels/views/video_player_view.dart';

import '../../app_bars/right_app_bar.dart';

class NormalVideoView extends StatelessWidget {
  final NormalVideoResource videoResource;

  const NormalVideoView({super.key, required this.videoResource});

  @override
  Widget build(BuildContext context) {
    final globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    globalMediaResourcesController.isEditingMediaResources.value = false;
    return Column(
      children: [
        const RightAppBar(
          children: [
            AppBarNormalVideoEditButton(),
            AppBarExportVideoButton(),
          ],
        ),
        Expanded(
          child: Center(
            child: Obx(() =>
                globalMediaResourcesController.isEditingMediaResources.value
                    ? VideoCutterView(videoResource: videoResource)
                    : VideoPlayerView(
                        videoResource: videoResource,
                      )),
          ),
        ),
      ],
    );
  }
}

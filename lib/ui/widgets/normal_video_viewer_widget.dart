import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_media_resources_controller.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/normal_video_edit_button.dart';
import 'package:xji_footage_toolbox/ui/widgets/right_app_bar_media_delete_button.dart';
import 'package:xji_footage_toolbox/ui/widgets/video_cutter_widget.dart';
import 'package:xji_footage_toolbox/ui/widgets/video_player_widget.dart';

import 'main_page_right_app_bar.dart';

class NormalVideoViewerWidget extends StatelessWidget {
  final NormalVideoResource videoResource;

  const NormalVideoViewerWidget({super.key, required this.videoResource});

  @override
  Widget build(BuildContext context) {
    final globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    globalMediaResourcesController.isEditingMediaResources.value = false;
    return Column(
      children: [
        const MainPageRightAppBar(
          children: [
            NormalVideoEditButton(),
            RightAppBarMediaDeleteButton(),
          ],
        ),
        Expanded(
          child: Center(
            child: Obx(() =>
                globalMediaResourcesController.isEditingMediaResources.value
                    ? VideoCutterWidget(videoResource: videoResource)
                    : VideoPlayerWidget(videoResource: videoResource,)),
          ),
        ),
      ],
    );
  }
}

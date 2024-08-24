import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/right_app_bar_media_delete_button.dart';
import 'package:xji_footage_toolbox/ui/widgets/video_player_widget.dart';

import 'main_page_right_app_bar.dart';

class NormalVideoViewerWidget extends StatelessWidget {
  final NormalVideoResource videoResource;

  const NormalVideoViewerWidget({super.key, required this.videoResource});

  @override
  Widget build(BuildContext context) {
    Get.delete<VideoPlayerGetxController>();
    Get.put(VideoPlayerGetxController(videoFile: videoResource.file));
    return Column(
      children: [
        const MainPageRightAppBar(
          children: [
            RightAppBarMediaDeleteButton(),
          ],
        ),
        Expanded(
          child: Center(
            child: VideoPlayerWidget(videoFile: videoResource.file),
          ),
        ),
      ],
    );
  }
}

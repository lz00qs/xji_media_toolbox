import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/widgets/panels/views/video_player_view.dart';
import 'package:xji_footage_toolbox/ui/widgets/panels/views/video_trimmer_view.dart';

import '../../../../models/media_resource.dart';

class VideoCutterView extends StatelessWidget {
  final NormalVideoResource videoResource;

  const VideoCutterView({super.key, required this.videoResource});

  @override
  Widget build(BuildContext context) {
    Get.delete<VideoTrimmerController>();
    Get.put(VideoTrimmerController(videoResource: videoResource));
    return Column(
      children: [
        Expanded(
            child: VideoPlayerView(
          videoResource: videoResource,
          showControls: false,
        )),
        const VideoTrimmerView()
      ],
    );
  }
}

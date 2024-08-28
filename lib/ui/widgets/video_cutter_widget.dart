import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/widgets/video_player_widget.dart';
import 'package:xji_footage_toolbox/ui/widgets/video_trimmer_widget.dart';

import '../../models/media_resource.dart';

class VideoCutterWidget extends StatelessWidget {
  final NormalVideoResource videoResource;

  const VideoCutterWidget({super.key, required this.videoResource});

  @override
  Widget build(BuildContext context) {
    Get.delete<VideoTrimmerController>();
    Get.put(VideoTrimmerController(videoResource: videoResource));
    return Column(
      children: [
        Expanded(
            child: VideoPlayerWidget(
          videoResource: videoResource,
          showControls: false,
        )),
        const VideoTrimmerWidget()
      ],
    );
  }
}

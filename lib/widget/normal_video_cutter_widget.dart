import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/widget/video_trim_widget.dart';

import '../footage.dart';

class NormalVideoCutterWidget extends StatelessWidget {
  final Footage footage;

  const NormalVideoCutterWidget({super.key, required this.footage});

  @override
  Widget build(BuildContext context) {
    Get.delete<VideoTrimController>();
    final controller = Get.put(VideoTrimController(footage: footage));
    return GetBuilder<VideoTrimController>(
        init: controller,
        builder: (controller) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                    child: GetBuilder<VideoTrimController>(
                  builder: (controller) =>
                      controller.chewieController != null &&
                              controller.chewieController!.videoPlayerController
                                  .value.isInitialized
                          ? Chewie(
                              controller: controller.chewieController!,
                            )
                          : Container(),
                )),
                const VideoTrimWidget(height: 200),
              ],
            )));
  }
}

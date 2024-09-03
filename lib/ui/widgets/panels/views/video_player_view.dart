import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../models/media_resource.dart';

class VideoPlayerGetxController extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  final File videoFile;
  final footageInitialized = false.obs;
  final bool showControls;

  VideoPlayerGetxController(
      {required this.videoFile, required this.showControls});

  @override
  void onInit() {
    super.onInit();
    _initializePlayer();
  }

  @override
  Future<void> onClose() async {
    await videoPlayerController.dispose();
    chewieController?.dispose();
    super.onClose();
  }

  Future<void> _initializePlayer() async {
    footageInitialized.value = false;
    videoPlayerController = VideoPlayerController.file(videoFile);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      autoInitialize: true,
      showControls: showControls,
    );
    footageInitialized.value = true;
    update();
  }
}

class VideoPlayerView extends StatelessWidget {
  final NormalVideoResource videoResource;
  final bool showControls;

  const VideoPlayerView(
      {super.key, required this.videoResource, this.showControls = true});

  @override
  Widget build(BuildContext context) {
    Get.delete<VideoPlayerGetxController>();
    final controller = Get.put(VideoPlayerGetxController(
        videoFile: videoResource.file, showControls: showControls));
    return Obx(() => controller.footageInitialized.value
        ? Chewie(
            controller: controller.chewieController!,
          )
        : const CircularProgressIndicator());
  }
}

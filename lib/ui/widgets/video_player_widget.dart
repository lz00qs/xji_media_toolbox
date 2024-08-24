
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerGetxController extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  final File videoFile;
  final footageInitialized = false.obs;

  VideoPlayerGetxController({required this.videoFile});

  @override
  void onInit() {
    super.onInit();
    _initializePlayer();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
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
    );
    footageInitialized.value = true;
    update();
  }
}

class VideoPlayerWidget extends GetView<VideoPlayerGetxController> {
  final File videoFile;

  const VideoPlayerWidget({super.key, required this.videoFile});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.footageInitialized.value
        ? Chewie(
            controller: controller.chewieController!,
          )
        : const CircularProgressIndicator());
  }
}
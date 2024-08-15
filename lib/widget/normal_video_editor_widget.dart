import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:xji_footage_toolbox/footage.dart';

class NormalVideoEditorWidget extends StatelessWidget {
  final Footage footage;

  const NormalVideoEditorWidget({super.key, required this.footage});

  @override
  Widget build(BuildContext context) {
    Get.delete<_VideoPlayerGetxController>();
    final controller =
        Get.put(_VideoPlayerGetxController(videoFile: footage.file));
    controller._initializePlayer();
    return Center(child: _VideoPlayerWidget(videoFile: footage.file));
  }
}

class _VideoPlayerWidget extends GetView<_VideoPlayerGetxController> {
  final File videoFile;

  const _VideoPlayerWidget({required this.videoFile});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.footageInitialized.value
        ? Chewie(
            controller: controller.chewieController!,
          )
        : const CircularProgressIndicator());
  }
}

class _VideoPlayerGetxController extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  final File videoFile;
  final footageInitialized = false.obs;

  _VideoPlayerGetxController({required this.videoFile});

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

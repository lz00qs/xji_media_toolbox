import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:xji_footage_toolbox/footage.dart';
import 'package:xji_footage_toolbox/global_controller.dart';

import 'normal_video_cutter_widget.dart';

class NormalVideoEditorWidget extends GetView<GlobalController> {
  final Footage footage;

  const NormalVideoEditorWidget({super.key, required this.footage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() => controller.isEditingVideo.value
          ? NormalVideoCutterWidget(footage: footage)
          : _VideoPlayerWidget(videoFile: footage.file)),
    );
  }
}

class _VideoPlayerWidget extends StatelessWidget {
  final File videoFile;

  const _VideoPlayerWidget({required this.videoFile});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_VideoPlayerGetxController>(
      init: _VideoPlayerGetxController(videoFile: videoFile),
      builder: (controller) => controller.chewieController != null &&
              controller
                  .chewieController!.videoPlayerController.value.isInitialized
          ? Chewie(
              controller: controller.chewieController!,
            )
          : Container(),
    );
  }
}

class _VideoPlayerGetxController extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  final File videoFile;

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
    videoPlayerController = VideoPlayerController.file(videoFile);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      autoInitialize: true,
    );
    update();
  }
}

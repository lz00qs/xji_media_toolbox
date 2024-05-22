import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:xji_footage_toolbox/footage.dart';

import '../video_test_page.dart';

class NormalVideoEditorWidget extends StatelessWidget {
  final Footage footage;

  const NormalVideoEditorWidget({super.key, required this.footage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GetBuilder<_VideoGetxController>(
        init: _VideoGetxController(videoFile: footage.file),
        builder: (controller) => Expanded(
            child: controller.chewieController != null &&
                    controller.chewieController!.videoPlayerController.value
                        .isInitialized
                ? Chewie(controller: controller.chewieController!,)
                : Container()),
      ),
    );
  }
}

class _VideoGetxController extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  final File videoFile;

  _VideoGetxController({required this.videoFile});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initializePlayer();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> initializePlayer() async {
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

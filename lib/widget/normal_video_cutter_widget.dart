import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class _VideoCutterGetxController extends GetxController {
  final File videoFile;
  final videoPosition = 0.0.obs;
  final lastVideoPosition = 0.0.obs;
  final isPlaying = false.obs;
  final cutStartPosition = 0.0.obs;
  final cutEndPosition = 0.0.obs;
  late VideoPlayerController videoPlayerController;
  late Timer _timer;

  _VideoCutterGetxController({required this.videoFile});

  Future<void> _fetchVideoData() async {
    if (videoPlayerController.value.isInitialized) {
      final duration = await videoPlayerController.position;
      if (duration != null) {
        videoPosition.value = duration.inMilliseconds.toDouble();
      }
      isPlaying.value = videoPlayerController.value.isPlaying;
    }
  }

  void _startFetchVideoData() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _fetchVideoData();
    });
  }

  @override
  void onInit() {
    super.onInit();
    _initializePlayer();
    _startFetchVideoData();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    _timer.cancel();
    super.onClose();
  }

  Future<void> _initializePlayer() async {
    videoPlayerController = VideoPlayerController.file(videoFile);
    await videoPlayerController.initialize();
    cutEndPosition.value =
        videoPlayerController.value.duration.inMilliseconds.toDouble();
    update();
  }
}

class _CustomRectThumbShape extends SliderComponentShape {
  final double thumbWidth;
  final double thumbHeight;

  _CustomRectThumbShape(this.thumbWidth, this.thumbHeight);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromCenter(
      center: center,
      width: thumbWidth,
      height: thumbHeight,
    );

    canvas.drawRect(rect, paint);
  }
}

class NormalVideoCutterWidget extends StatelessWidget {
  final File videoFile;

  const NormalVideoCutterWidget({super.key, required this.videoFile});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_VideoCutterGetxController>(
      init: _VideoCutterGetxController(videoFile: videoFile),
      builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: Center(
                child: controller.videoPlayerController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio:
                            controller.videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(controller.videoPlayerController),
                      )
                    : Container(),
              ),
            ),
            Obx(() => IconButton(
                onPressed: () {
                  controller.isPlaying.value
                      ? controller.videoPlayerController.pause()
                      : controller.videoPlayerController.play();
                },
                icon: controller.isPlaying.value
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow))),
            Obx(() => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(controller.cutStartPosition.value.toString()),
                      Expanded(
                        child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: _CustomRectThumbShape(10, 20),
                            ),
                            child: Slider(
                              value: controller.videoPosition.value,
                              onChanged: (double value) {
                                controller.videoPlayerController.seekTo(
                                    Duration(milliseconds: value.toInt()));
                              },
                              min: controller.cutStartPosition.value,
                              max: controller.cutEndPosition.value,
                            )),
                      ),
                      Text(controller.cutEndPosition.value.toString()),
                    ],
                  ),
                )),
            // TDRangeSlider(
            //   sliderThemeData: TDSliderThemeData.capsule(
            //     showScaleValue: true,
            //     divisions: 5,
            //     min: 0,
            //     max: 100,
            //     scaleFormatter: (value) => value.toInt().toString(),
            //   )..updateSliderThemeData((data) => data.copyWith(
            //         activeTickMarkColor: const Color(0xFFE7E7E7),
            //         inactiveTickMarkColor: const Color(0xFFE7E7E7),
            //         rangeTrackShape: RangeSliderTrackShape(
            //           activeTrackColor: const Color(0xFFE7E7E7),
            //           inactiveTrackColor: const Color(0xFFE7E7E7),
            //         )
            //       )),
            //   value: const RangeValues(20, 60),
            //   // divisions: 5,
            //   onChanged: (value) {},
            // )
          ],
        );
      },
    );
  }
}

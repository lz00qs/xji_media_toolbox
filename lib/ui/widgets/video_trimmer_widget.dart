import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/video_player_widget.dart';

class VideoTrimmerController extends GetxController {
  final isPlaying = false.obs;
  final startPosition = const Duration(seconds: 0).obs;
  final endPosition = const Duration(seconds: 0).obs;
  final playerPosition = const Duration(seconds: 0).obs;
  final NormalVideoResource videoResource;
  var isRangeChanging = false;

  VideoTrimmerController({required this.videoResource}) {
    startPosition.value = const Duration(seconds: 0);
    endPosition.value = videoResource.duration;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}

String _getFormattedTime(Duration duration) {
  final origString = duration.toString();
  return origString.substring(0, origString.length - 2);
}

class _VideoPlayerControlBar extends GetView<VideoTrimmerController> {
  @override
  Widget build(BuildContext context) {
    final videoPlayerGetxController = Get.find<VideoPlayerGetxController>();
    videoPlayerGetxController.videoPlayerController.addListener(() async {
      if (videoPlayerGetxController.videoPlayerController.value.isPlaying) {
        controller.isPlaying.value = true;
      } else {
        controller.isPlaying.value = false;
      }
      if (!controller.isRangeChanging) {
        controller.playerPosition.value =
            videoPlayerGetxController.videoPlayerController.value.position;
      }
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
            Obx(() => IconButton(
                onPressed: () {
                  if (controller.isPlaying.value) {
                    videoPlayerGetxController.videoPlayerController.pause();
                  } else {
                    videoPlayerGetxController.videoPlayerController.play();
                  }
                },
                icon: Icon(controller.isPlaying.value
                    ? Icons.pause
                    : Icons.play_arrow))),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
        Obx(() => Text(
            'Start: ${_getFormattedTime(controller.startPosition.value)} | '
            'End: ${_getFormattedTime(controller.endPosition.value)} | '
            'Duration: ${_getFormattedTime(controller.endPosition.value - controller.startPosition.value)}')),
        Obx(() => Row(
              children: [
                Text(_getFormattedTime(controller.playerPosition.value -
                    controller.startPosition.value)),
                Expanded(
                    child: Slider(
                        value: controller.playerPosition.value.inMicroseconds
                            .toDouble(),
                        min: controller.startPosition.value.inMicroseconds
                            .toDouble(),
                        max: controller.endPosition.value.inMicroseconds
                            .toDouble(),
                        onChanged: (value) {
                          videoPlayerGetxController.videoPlayerController
                              .seekTo(Duration(microseconds: value.toInt()));
                        })),
                Text(_getFormattedTime(controller.endPosition.value -
                    controller.startPosition.value)),
              ],
            ))
      ],
    );
  }
}

class _VideoTrimmerBar extends GetView<VideoTrimmerController> {
  @override
  Widget build(BuildContext context) {
    final videoPlayerGetxController = Get.find<VideoPlayerGetxController>();
    final startValue = 0.0.obs;
    final endValue =
        controller.videoResource.duration.inMilliseconds.toDouble().obs;
    return Obx(() => RangeSlider(
          values: RangeValues(startValue.value, endValue.value),
          min: 0,
          max: controller.videoResource.duration.inMilliseconds.toDouble(),
          onChanged: (values) {
            if (values.end != endValue.value) {
              videoPlayerGetxController.videoPlayerController
                  .seekTo(Duration(milliseconds: values.end.toInt()));
            }
            if (values.start != startValue.value) {
              videoPlayerGetxController.videoPlayerController
                  .seekTo(Duration(milliseconds: values.start.toInt()));
            }
            startValue.value = values.start;
            endValue.value = values.end;
          },
          onChangeStart: (values) {
            controller.isRangeChanging = true;
          },
          onChangeEnd: (values) {
            controller.playerPosition.value =
                Duration(milliseconds: values.start.toInt());
            controller.startPosition.value =
                Duration(milliseconds: values.start.toInt());
            controller.endPosition.value =
                Duration(milliseconds: values.end.toInt());
            videoPlayerGetxController.videoPlayerController
                .seekTo(controller.startPosition.value);
            controller.isRangeChanging = false;
          },
        ));
  }
}

class VideoTrimmerWidget extends StatelessWidget {
  const VideoTrimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        color: Colors.black12,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                _VideoPlayerControlBar(),
                Expanded(child: _VideoTrimmerBar()),
              ],
            )));
  }
}

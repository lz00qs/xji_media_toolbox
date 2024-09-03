import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/panels/views/video_player_view.dart';

// 1ms ~ 1s
const _scaleValueList = [
  // 1000, // 1ms
  // 5000,
  // 10000,
  50000, // 50ms
  100000,
  500000,
  1000000, // 1s
  5000000,
  10000000,
];

const _divisionWidth = 10.0;

class VideoTrimmerController extends GetxController {
  final isPlaying = false.obs;
  final videoPlayerStartPosition = const Duration(seconds: 0).obs;
  final videoPlayerEndPosition = const Duration(seconds: 0).obs;
  final videoTrimmerStartValue = const Duration(seconds: 0).obs;
  final videoTrimmerEndValue = const Duration(seconds: 0).obs;
  final playerPosition = const Duration(seconds: 0).obs;
  final NormalVideoResource videoResource;
  var isRangeChanging = false;
  final trimmerBarScrollController = ScrollController();
  final scaleFactor = 0.obs;
  final trimmerBarWidth = 0.0.obs;
  var isPlayEnd = false;

  VideoTrimmerController({required this.videoResource}) {
    videoPlayerStartPosition.value = const Duration(seconds: 0);
    videoPlayerEndPosition.value = videoResource.duration;
  }
}

String getFormattedTime(Duration duration) {
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
        if (videoPlayerGetxController.videoPlayerController.value.position >=
            controller.videoPlayerEndPosition.value) {
          await videoPlayerGetxController.videoPlayerController
              .seekTo(controller.videoPlayerEndPosition.value);
          videoPlayerGetxController.videoPlayerController.pause();
          controller.isPlaying.value = false;
          controller.isPlayEnd = true;
        }
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
                onPressed: () {
                  _scrollToThumb(
                      controller.videoPlayerStartPosition.value.inMicroseconds);
                },
                icon: const Icon(Icons.arrow_back_ios_new)),
            Obx(() => IconButton(
                onPressed: () async {
                  if (controller.isPlaying.value) {
                    videoPlayerGetxController.videoPlayerController.pause();
                  } else {
                    if (controller.isPlayEnd) {
                      await videoPlayerGetxController.videoPlayerController
                          .seekTo(controller.videoPlayerStartPosition.value);
                      controller.isPlayEnd = false;
                    }
                    videoPlayerGetxController.videoPlayerController.play();
                  }
                },
                icon: Icon(controller.isPlaying.value
                    ? Icons.pause
                    : Icons.play_arrow))),
            IconButton(
                onPressed: () {
                  _scrollToThumb(
                      controller.videoPlayerEndPosition.value.inMicroseconds);
                },
                icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
        Obx(() => Row(
              children: [
                Text(getFormattedTime(controller.playerPosition.value -
                    controller.videoPlayerStartPosition.value)),
                Expanded(
                    child: Slider(
                        value: controller.playerPosition.value.inMicroseconds
                            .toDouble(),
                        min: controller
                            .videoPlayerStartPosition.value.inMicroseconds
                            .toDouble(),
                        max: controller
                            .videoPlayerEndPosition.value.inMicroseconds
                            .toDouble(),
                        onChanged: (value) async {
                          await videoPlayerGetxController.videoPlayerController
                              .seekTo(Duration(microseconds: value.toInt()));
                        })),
                Text(getFormattedTime(controller.videoPlayerEndPosition.value -
                    controller.videoPlayerStartPosition.value)),
              ],
            ))
      ],
    );
  }
}

int _getDefaultScale(Duration duration) {
  for (var i = 0; i < _scaleValueList.length; i++) {
    if (duration.inMicroseconds / _scaleValueList[i] < 100) {
      return i;
    }
  }
  return _scaleValueList.length - 1;
}

int _getDivisionCount(Duration duration, int scaleFactor) {
  return (duration.inMicroseconds / _scaleValueList[scaleFactor]).ceil();
}

double _getRangeSliderMax(Duration duration, int scaleFactor) =>
    (((duration.inMicroseconds + _scaleValueList[scaleFactor] - 1) ~/
                _scaleValueList[scaleFactor]) *
            _scaleValueList[scaleFactor])
        .toDouble();

int _getSafeValue(int value, int min, int max) {
  if (value < min) {
    return min;
  }
  if (value > max) {
    return max;
  }
  return value;
}

int _getRoundedInt(double value) {
  return (value * 100).round() ~/ 100;
}

void _scrollToThumb(int thumbPosition) {
  final controller = Get.find<VideoTrimmerController>();
  final thumbPositionPixel = thumbPosition /
      _scaleValueList[controller.scaleFactor.value] *
      _divisionWidth;
  if (thumbPositionPixel < (controller.trimmerBarWidth.value / 2)) {
    controller.trimmerBarScrollController.animateTo(0,
        duration: const Duration(milliseconds: 1), curve: Curves.linear);
  } else {
    controller.trimmerBarScrollController.animateTo(
        thumbPositionPixel - (controller.trimmerBarWidth.value / 2),
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear);
  }
}

class _VideoTrimmerBar extends GetView<VideoTrimmerController> {
  @override
  Widget build(BuildContext context) {
    final videoPlayerGetxController = Get.find<VideoPlayerGetxController>();
    controller.scaleFactor.value =
        _getDefaultScale(controller.videoResource.duration);
    controller.videoTrimmerEndValue.value = Duration(
        microseconds: _getRangeSliderMax(
                controller.videoResource.duration, controller.scaleFactor.value)
            .toInt());
    return LayoutBuilder(builder: (context, constrains) {
      controller.trimmerBarWidth.value = constrains.maxWidth;
      return Column(
        children: [
          Obx(() {
            final start = Duration(
                microseconds: _getSafeValue(
                    controller.videoTrimmerStartValue.value.inMicroseconds,
                    0,
                    controller.videoResource.duration.inMicroseconds));
            final end = Duration(
                microseconds: _getSafeValue(
                    controller.videoTrimmerEndValue.value.inMicroseconds,
                    0,
                    controller.videoResource.duration.inMicroseconds));
            return Text('Start: ${getFormattedTime(start)} | '
                'End: ${getFormattedTime(end)} | '
                'Duration: ${getFormattedTime(end - start)}');
          }),
          MouseRegion(
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  if (HardwareKeyboard.instance.isMetaPressed ||
                      HardwareKeyboard.instance.isControlPressed) {
                    var isEndValueMax = false;
                    if (controller.videoTrimmerEndValue.value.inMicroseconds >
                        controller.videoResource.duration.inMicroseconds) {
                      isEndValueMax = true;
                    }

                    controller.scaleFactor.value = _getSafeValue(
                        controller.scaleFactor.value +
                            event.scrollDelta.dy.sign.toInt(),
                        0,
                        _getDefaultScale(controller.videoResource.duration));

                    if (isEndValueMax) {
                      controller.videoTrimmerEndValue.value = Duration(
                          microseconds: _getRangeSliderMax(
                                  controller.videoResource.duration,
                                  controller.scaleFactor.value)
                              .toInt());
                    }
                  }
                }
              },
              child: Obx(() => Container(
                    color: Colors.black12,
                    width: double.infinity,
                    child: Center(
                        child: RawScrollbar(
                            thumbVisibility: true,
                            thumbColor: Colors.black54,
                            thickness: 10,
                            radius: const Radius.circular(10),
                            controller: controller.trimmerBarScrollController,
                            child: SingleChildScrollView(
                                controller:
                                    controller.trimmerBarScrollController,
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                    height: 60,
                                    width: _getDivisionCount(
                                            controller.videoResource.duration,
                                            controller.scaleFactor.value) *
                                        _divisionWidth,
                                    child: RangeSlider(
                                      values: RangeValues(
                                          controller.videoTrimmerStartValue
                                              .value.inMicroseconds
                                              .toDouble(),
                                          controller.videoTrimmerEndValue.value
                                              .inMicroseconds
                                              .toDouble()),
                                      min: 0,
                                      max: _getRangeSliderMax(
                                          controller.videoResource.duration,
                                          controller.scaleFactor.value),
                                      divisions: _getDivisionCount(
                                          controller.videoResource.duration,
                                          controller.scaleFactor.value),
                                      onChanged: (values) async {
                                        final start =
                                            _getRoundedInt(values.start);
                                        final end = _getRoundedInt(values.end);
                                        if (end !=
                                            controller.videoTrimmerEndValue
                                                .value.inMicroseconds) {
                                          await videoPlayerGetxController
                                              .videoPlayerController
                                              .seekTo(Duration(
                                                  microseconds: _getSafeValue(
                                                      end,
                                                      0,
                                                      controller
                                                          .videoResource
                                                          .duration
                                                          .inMicroseconds)));
                                        }
                                        if (start !=
                                            controller.videoTrimmerStartValue
                                                .value.inMicroseconds) {
                                          await videoPlayerGetxController
                                              .videoPlayerController
                                              .seekTo(Duration(
                                                  microseconds: _getSafeValue(
                                                      start,
                                                      0,
                                                      controller
                                                          .videoResource
                                                          .duration
                                                          .inMicroseconds)));
                                        }

                                        controller
                                                .videoTrimmerStartValue.value =
                                            Duration(microseconds: start);
                                        controller.videoTrimmerEndValue.value =
                                            Duration(microseconds: end);
                                      },
                                      onChangeStart: (values) {
                                        controller.isRangeChanging = true;
                                      },
                                      onChangeEnd: (values) async {
                                        final start =
                                            _getRoundedInt(values.start);
                                        final end = _getRoundedInt(values.end);
                                        controller.playerPosition.value =
                                            Duration(
                                                microseconds: _getSafeValue(
                                                    start,
                                                    0,
                                                    controller
                                                        .videoResource
                                                        .duration
                                                        .inMicroseconds));
                                        controller.videoPlayerStartPosition
                                                .value =
                                            controller.playerPosition.value;
                                        controller
                                                .videoPlayerEndPosition.value =
                                            Duration(
                                                microseconds: _getSafeValue(
                                                    end,
                                                    0,
                                                    controller
                                                        .videoResource
                                                        .duration
                                                        .inMicroseconds));
                                        await videoPlayerGetxController
                                            .videoPlayerController
                                            .seekTo(controller
                                                .videoPlayerStartPosition
                                                .value);
                                        controller.isRangeChanging = false;
                                      },
                                    ))))),
                  )),
            ),
          ),
        ],
      );
    });
  }
}

class VideoTrimmerView extends StatelessWidget {
  const VideoTrimmerView({super.key});

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

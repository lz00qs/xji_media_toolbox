import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'package:xji_footage_toolbox/footage.dart';

const scaleFactorList = [
  20,
  100,
  200,
  1000,
  2000,
  10000,
  20000,
  100000,
  200000
];

String _getFormattedTime(Duration duration) {
  final origString = duration.toString();
  return origString.substring(0, origString.length - 2);
}

class VideoTrimController extends GetxController {
  final Rx<Duration> sourceDuration = const Duration(milliseconds: 0).obs;
  final Rx<Duration> startTime = const Duration(milliseconds: 0).obs;
  final Rx<Duration> endTime = const Duration(milliseconds: 0).obs;
  final Rx<Duration> outputDuration = const Duration(milliseconds: 0).obs;
  final division = 1.obs;
  final timeScaleInMs = 1.obs;
  final RxInt scale = 0.obs;
  final RxBool isPlaying = false.obs;
  final RxDouble trimmerBarWidth = 0.0.obs;
  final trimmerBarScrollController = ScrollController();
  var startThumbPosition = 0.0;
  var endThumbPosition = 0.0;
  final Footage footage;
  ChewieController? chewieController;
  late VideoPlayerController videoPlayerController;
  final playerPosition = 0.obs;
  final playerStartPosition = 0.obs;
  final playerEndPosition = 0.obs;
  var playerEnded = false;
  var changeEnd = true;

  VideoTrimController({required this.footage});

  @override
  void onInit() {
    super.onInit();
    _initializePlayer();

    sourceDuration.value =
        Duration(microseconds: footage.duration.toInt() * 1000 * 1000);
    // for dev
    sourceDuration.value = const Duration(microseconds: 9209200);
    endTime.value = sourceDuration.value;

    if (sourceDuration.value.inMilliseconds / scaleFactorList.last > 50) {
      scale.value = scaleFactorList.length - 1;
    } else {
      for (int i = 0; i < scaleFactorList.length; i++) {
        if (sourceDuration.value.inMilliseconds / scaleFactorList[i] < 50) {
          scale.value = i;

          break;
        }
      }
    }

    timeScaleInMs.value = scaleFactorList[scale.value];

    if (sourceDuration.value.inMilliseconds % timeScaleInMs.value == 0) {
      division.value =
          sourceDuration.value.inMilliseconds ~/ timeScaleInMs.value;
    } else {
      division.value =
          sourceDuration.value.inMilliseconds ~/ timeScaleInMs.value + 1;
    }

    endThumbPosition = sourceDuration.value.inMilliseconds.toDouble();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.onClose();
  }

  Future<void> _initializePlayer() async {
    videoPlayerController = VideoPlayerController.file(footage.file);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      autoInitialize: true,
      showControls: false,
    );
    update();
  }
}

class VideoTrimWidget extends GetView<VideoTrimController> {
  const VideoTrimWidget({super.key, required this.height});

  final double height;

  void scrollToThumb(double thumbPosition) {
    final thumbPositionPixel =
        thumbPosition / controller.timeScaleInMs.value * 10;
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // display start and end position in 00:00.000 format
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: () {
                  scrollToThumb(controller.startThumbPosition);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            IconButton(
                onPressed: () async {
                  controller.isPlaying.value = !controller.isPlaying.value;
                  if (controller.isPlaying.value) {
                    if (controller.playerEnded == true) {
                      controller.playerEnded = false;
                      await controller.videoPlayerController.seekTo(Duration(
                          milliseconds: controller.startThumbPosition.toInt()));
                    }
                    await controller.videoPlayerController.play();
                  } else {
                    await controller.videoPlayerController.pause();
                  }
                },
                icon: Obx(() => Icon(controller.isPlaying.value
                    ? Icons.pause
                    : Icons.play_arrow))),
            IconButton(
                onPressed: () {
                  scrollToThumb(controller.endThumbPosition);
                },
                icon: const Icon(Icons.arrow_forward_ios)),
          ]),
          SizedBox(
            child: Obx(() => Text(
                "Start: ${_getFormattedTime(controller.startTime.value)} | End: ${_getFormattedTime(controller.endTime.value)} | Duration: ${_getFormattedTime(controller.endTime.value - controller.startTime.value)}")),
          ),
          _VideoPlayerBar(),
          _VideoTrimmerBar(),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}

class _VideoPlayerBar extends GetView<VideoTrimController> {
  @override
  Widget build(BuildContext context) {
    // final playerPosition = controller.startTime.value.inMilliseconds.obs;
    controller.videoPlayerController.addListener(() async {
      if (controller.changeEnd == true) {
        controller.playerPosition.value =
            controller.videoPlayerController.value.position.inMilliseconds;
        if (controller.videoPlayerController.value.position >=
            controller.endTime.value) {
          controller.playerPosition.value =
              controller.endTime.value.inMilliseconds;
          await controller.videoPlayerController.seekTo(
              Duration(milliseconds: controller.endTime.value.inMilliseconds));
          controller.videoPlayerController.pause();
          controller.isPlaying.value = false;
          controller.playerEnded = true;
        }
      }
    });
    controller.playerStartPosition.value =
        controller.startTime.value.inMilliseconds;
    controller.playerEndPosition.value =
        controller.endTime.value.inMilliseconds;
    return Container(
        height: 40,
        color: Colors.black12,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Obx(() => Text(_getFormattedTime(controller.startTime.value))),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: SliderTheme(
                  data: const SliderThemeData(
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                  ),
                  child: Obx(() => Slider(
                        value: controller.playerPosition.value.toDouble(),
                        min: controller.playerStartPosition.value.toDouble(),
                        max: controller.playerEndPosition.value.toDouble(),
                        onChanged: (value) async {
                          controller.playerEnded = false;
                          controller.playerPosition.value = value.toInt();
                          await controller.videoPlayerController
                              .seekTo(Duration(milliseconds: value.toInt()));
                        },
                      )),
                )),
                const SizedBox(
                  width: 10,
                ),
                Obx(() => Text(_getFormattedTime(
                    Duration(milliseconds: controller.playerPosition.value)))),
              ],
            )));
  }
}

class _VideoTrimmerBar extends GetView<VideoTrimController> {
  @override
  Widget build(BuildContext context) {
    int zoomSoftCount = 0;
    return LayoutBuilder(builder: (context, constrains) {
      controller.trimmerBarWidth.value = constrains.maxWidth;
      return MouseRegion(
        child: Listener(
          onPointerPanZoomUpdate: (event) {
            if (zoomSoftCount == 3) {
              zoomSoftCount = 0;
              if (event.scale > 1.0) {
                controller.scale.value += 1;
              } else {
                controller.scale.value -= 1;
              }
              controller.scale.value = controller.scale.value
                  .clamp(0.0, scaleFactorList.length - 1)
                  .toInt();
              controller.timeScaleInMs.value =
                  scaleFactorList[controller.scale.value.toInt()];

              while (controller.sourceDuration.value.inMilliseconds ~/
                      controller.timeScaleInMs.value <
                  20) {
                controller.scale.value -= 1;
                controller.timeScaleInMs.value =
                    scaleFactorList[controller.scale.value.toInt()];
              }

              if (controller.sourceDuration.value.inMilliseconds %
                      controller.timeScaleInMs.value ==
                  0) {
                controller.division.value =
                    controller.sourceDuration.value.inMilliseconds ~/
                        controller.timeScaleInMs.value;
              } else {
                controller.division.value =
                    controller.sourceDuration.value.inMilliseconds ~/
                            controller.timeScaleInMs.value +
                        1;
              }
            } else {
              zoomSoftCount++;
            }
          },
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              if (HardwareKeyboard.instance.isMetaPressed ||
                  HardwareKeyboard.instance.isControlPressed) {
                controller.scale.value += (event.scrollDelta.dy * 0.09).toInt();
                controller.scale.value = controller.scale.value
                    .clamp(0.0, scaleFactorList.length - 1)
                    .toInt();
                controller.timeScaleInMs.value =
                    scaleFactorList[controller.scale.value.toInt()];

                while (controller.sourceDuration.value.inMilliseconds ~/
                        controller.timeScaleInMs.value <
                    20) {
                  controller.scale.value -= 1;
                  controller.timeScaleInMs.value =
                      scaleFactorList[controller.scale.value.toInt()];
                }

                if (controller.sourceDuration.value.inMilliseconds %
                        controller.timeScaleInMs.value ==
                    0) {
                  controller.division.value =
                      controller.sourceDuration.value.inMilliseconds ~/
                          controller.timeScaleInMs.value;
                } else {
                  controller.division.value =
                      controller.sourceDuration.value.inMilliseconds ~/
                              controller.timeScaleInMs.value +
                          1;
                }
              }
            }
          },
          child: Obx(() => Container(
                color: Colors.black26,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        fit: FlexFit.loose,
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
                                  width: controller.division.value * 10.0,
                                  child: Obx(() => SliderTheme(
                                      data: const SliderThemeData(
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 10),
                                      ),
                                      child: RangeSlider(
                                          values: RangeValues(
                                              controller.startTime.value
                                                  .inMilliseconds
                                                  .toDouble(),
                                              controller
                                                  .endTime.value.inMilliseconds
                                                  .toDouble()),
                                          min: 0,
                                          max: controller.sourceDuration.value
                                              .inMilliseconds
                                              .toDouble(),
                                          divisions: controller.division.value,
                                          onChangeStart: (values) async {
                                            await controller
                                                .videoPlayerController
                                                .pause();
                                            controller.isPlaying.value = false;
                                            controller.changeEnd = false;
                                          },
                                          onChangeEnd: (values) async {
                                            controller.changeEnd = true;
                                            controller.playerStartPosition
                                                .value = values.start.toInt();
                                            controller.playerEndPosition.value =
                                                values.end.toInt();
                                            controller.playerPosition.value =
                                                values.start.toInt();
                                            await controller
                                                .videoPlayerController
                                                .seekTo(Duration(
                                                    milliseconds:
                                                        values.start.toInt()));
                                          },
                                          onChanged:
                                              (RangeValues values) async {
                                            double changedThumbPosition = 0.0;
                                            bool isIncrease = false;
                                            bool changed = false;

                                            if (values.start !=
                                                controller.startThumbPosition) {
                                              changed = true;
                                              changedThumbPosition =
                                                  values.start /
                                                      controller
                                                          .timeScaleInMs.value *
                                                      10;
                                              if (values.start <
                                                  controller
                                                      .startThumbPosition) {
                                                // decrease
                                                isIncrease = false;
                                              } else {
                                                // increase
                                                isIncrease = true;
                                              }
                                              controller.startThumbPosition =
                                                  values.start;
                                              await controller
                                                  .videoPlayerController
                                                  .seekTo(Duration(
                                                      milliseconds: values.start
                                                          .toInt()));
                                            }

                                            if (values.end !=
                                                controller.endThumbPosition) {
                                              changed = true;
                                              changedThumbPosition =
                                                  values.end /
                                                      controller
                                                          .timeScaleInMs.value *
                                                      10;
                                              if (values.end <
                                                  controller.endThumbPosition) {
                                                // decrease
                                                isIncrease = false;
                                              } else {
                                                // increase
                                                isIncrease = true;
                                              }
                                              controller.endThumbPosition =
                                                  values.end;
                                              await controller
                                                  .videoPlayerController
                                                  .seekTo(Duration(
                                                      milliseconds:
                                                          values.end.toInt()));
                                            }

                                            if (changed) {
                                              if (isIncrease) {
                                                if (changedThumbPosition >
                                                    controller.trimmerBarWidth
                                                            .value +
                                                        controller
                                                            .trimmerBarScrollController
                                                            .offset) {
                                                  controller
                                                      .trimmerBarScrollController
                                                      .animateTo(
                                                          changedThumbPosition -
                                                              controller
                                                                  .trimmerBarWidth
                                                                  .value +
                                                              15,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      1),
                                                          curve:
                                                              Curves.easeInOut);
                                                } else if (changedThumbPosition >
                                                    controller.trimmerBarWidth
                                                        .value) {
                                                  if (changedThumbPosition %
                                                              controller
                                                                  .trimmerBarWidth
                                                                  .value >
                                                          controller
                                                                  .trimmerBarScrollController
                                                                  .offset %
                                                              controller
                                                                  .trimmerBarWidth
                                                                  .value &&
                                                      controller
                                                              .trimmerBarScrollController
                                                              .offset !=
                                                          controller
                                                              .trimmerBarScrollController
                                                              .position
                                                              .maxScrollExtent) {
                                                    controller
                                                        .trimmerBarScrollController
                                                        .animateTo(
                                                            controller
                                                                    .trimmerBarScrollController
                                                                    .offset +
                                                                15,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1),
                                                            curve: Curves
                                                                .easeInOut);
                                                  }
                                                }
                                              } else {
                                                if (changedThumbPosition <
                                                    controller.trimmerBarWidth
                                                        .value) {
                                                  if (changedThumbPosition <
                                                      controller
                                                          .trimmerBarScrollController
                                                          .offset) {
                                                    controller.trimmerBarScrollController
                                                        .animateTo(
                                                            changedThumbPosition -
                                                                15,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1),
                                                            curve:
                                                                Curves.linear);
                                                  }
                                                } else if (changedThumbPosition <
                                                    controller
                                                        .trimmerBarScrollController
                                                        .offset) {
                                                  controller
                                                      .trimmerBarScrollController
                                                      .animateTo(
                                                          changedThumbPosition -
                                                              15,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      1),
                                                          curve: Curves.linear);
                                                }
                                              }
                                            }

                                            controller.startTime.value =
                                                Duration(
                                                    milliseconds:
                                                        values.start.toInt());
                                            controller.endTime.value = Duration(
                                                milliseconds:
                                                    values.end.toInt());
                                            if (controller.endTime.value >
                                                controller
                                                    .sourceDuration.value) {
                                              controller.endTime.value =
                                                  controller
                                                      .sourceDuration.value;
                                            }
                                          }))),
                                )))),
                  ],
                ),
              )),
        ),
      );
    });
  }
}

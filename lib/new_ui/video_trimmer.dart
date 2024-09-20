import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:xji_footage_toolbox/new_ui/custom_icon_button.dart';

import '../models/media_resource.dart';
import 'design_tokens.dart';

const _scaleValueList = [
  50000, // 50ms
  100000,
  500000,
  1000000, // 1s
  5000000,
  10000000,
];

class _TrimmerDragHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      color: ColorDark.yellow5,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignValues.smallBorderRadius),
          child: Container(
            color: ColorDark.tertiary,
            width: 4,
            height: 32,
          ),
        ),
      ),
    );
  }
}

class _FormattedTimeText extends StatelessWidget {
  final Duration duration;
  final Color? color;

  const _FormattedTimeText({required this.duration, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(getFormattedTime(duration),
        style: SemiTextStyles.smallENRegular
            .copyWith(color: color, overflow: TextOverflow.ellipsis));
  }
}

String getFormattedTime(Duration duration) {
  final origString = duration.toString();
  return origString.substring(0, origString.length - 2);
}

class VideoTrimmerController extends GetxController {
  final start = const Duration(seconds: 0).obs;
  final end = const Duration(seconds: 0).obs;
  final savedStart = const Duration(seconds: 0).obs;
  final savedEnd = const Duration(seconds: 0).obs;
  final playPosition = const Duration(seconds: 0).obs;
  final isPlaying = false.obs;
  final scrollController = ScrollController();
  final videoResourceWidth = 0.0.obs;
  final startPosition = 0.0.obs;
  final endPosition = 0.0.obs;
  static const double _stepWidth = 5.0;
  static const double _thumbBetweenDistance = 20.0;
  final stepValueIndex = 0.obs; // microseconds
  late int _minimumStepIndex;
  var _lastStepValueIndex = 0;

  var actualStartPosition = 0.0;
  var actualEndPosition = 0.0;
  var mouseHorizontalPosition = 0.0;

  final NormalVideoResource videoResource;

  // late final VideoPlayerGetxController videoPlayerGetxController;
  var changing = false;

  var trimmerWidth = 0.0;

  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  final footageInitialized = false.obs;

  VideoTrimmerController({required this.videoResource});

  Future<void> _initializePlayer() async {
    footageInitialized.value = false;
    videoPlayerController = VideoPlayerController.file(videoResource.file);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      autoInitialize: true,
      showControls: false,
    );
    footageInitialized.value = true;
    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializePlayer();
    _getDefaultStepValueIndex();
    _minimumStepIndex = stepValueIndex.value;
    _lastStepValueIndex = stepValueIndex.value;
    savedEnd.value = videoResource.duration;
    _initSize();
    scrollController.addListener(() {
      if (kDebugMode) {
        // print(
        //     'scroll position: ${scrollController.position.pixels}, width: $videoResourceWidth, trimmerWidth: $trimmerWidth');
      }
    });
    videoPlayerController.addListener(() async {
      isPlaying.value = videoPlayerController.value.isPlaying;
      if (!changing) {
        final position = videoPlayerController.value.position;
        if (position < start.value || position > end.value) {
          await videoPlayerController.pause();
          isPlaying.value = false;
          await videoPlayerController.seekTo(start.value);
          playPosition.value = start.value;
        } else {
          playPosition.value = position;
        }
      }
    });
  }

  @override
  Future<void> onClose() async {
    await videoPlayerController.dispose();
    chewieController?.dispose();
    super.onClose();
  }

  void _getDefaultStepValueIndex() {
    final duration = videoResource.duration.inMicroseconds;
    const scale = 50;
    if (duration < _scaleValueList.first * scale) {
      stepValueIndex.value = 0;
    } else if (duration > _scaleValueList.last * scale) {
      stepValueIndex.value = _scaleValueList.length - 1;
    } else {
      for (var i = 0; i < _scaleValueList.length - 1; i++) {
        if (duration >= (_scaleValueList[i] * scale) &&
            duration < (_scaleValueList[i + 1] * 50)) {
          stepValueIndex.value = i;
          break;
        }
      }
    }
  }

  void _initSize() {
    videoResourceWidth.value = (videoResource.duration.inMicroseconds /
                    (_scaleValueList[stepValueIndex.value]) +
                1)
            .round() *
        _stepWidth;
    endPosition.value = videoResourceWidth.value;
    actualEndPosition = videoResourceWidth.value;
    end.value = videoResource.duration;
  }

  void updateSize() {
    videoResourceWidth.value = (videoResource.duration.inMicroseconds /
                    (_scaleValueList[stepValueIndex.value]) +
                1)
            .round() *
        _stepWidth;
    double scrollFactor = 1;
    // print('stepValueIndex: ${stepValueIndex.value}');
    if (_lastStepValueIndex > stepValueIndex.value) {
      // _zoomIn();
      final ration = stepValueIndex.isOdd ? 5 : 2;
      for (var i = 0; i < _lastStepValueIndex - stepValueIndex.value; i++) {
        actualStartPosition = actualStartPosition * ration;
        startPosition.value =
            (actualStartPosition / _stepWidth).round() * _stepWidth;
        actualEndPosition = actualEndPosition * ration;
        endPosition.value =
            (actualEndPosition / _stepWidth).round() * _stepWidth;
        if (endPosition.value > videoResourceWidth.value) {
          endPosition.value = videoResourceWidth.value;
          actualEndPosition = videoResourceWidth.value;
        }
      }
      scrollFactor = (1 * ration).toDouble();
    } else if (_lastStepValueIndex < stepValueIndex.value) {
      // _zoomOut();
      final ration = stepValueIndex.isOdd ? 2 : 5;
      for (var i = 0; i < stepValueIndex.value - _lastStepValueIndex; i++) {
        actualStartPosition = actualStartPosition / ration;
        startPosition.value =
            (actualStartPosition / _stepWidth).round() * _stepWidth;
        actualEndPosition = actualEndPosition / ration;
        endPosition.value =
            (actualEndPosition / _stepWidth).round() * _stepWidth;
      }
      scrollFactor = 1 / ration;
    }
    if (endPosition.value - startPosition.value < _thumbBetweenDistance) {
      // 距离过近，向左或者向右扩展
      if (actualEndPosition + _thumbBetweenDistance <
          videoResourceWidth.value) {
        actualEndPosition = actualStartPosition + _thumbBetweenDistance;
        endPosition.value =
            (actualEndPosition / _stepWidth).round() * _stepWidth;
      } else if (actualStartPosition - _thumbBetweenDistance > 0) {
        actualStartPosition = actualEndPosition - _thumbBetweenDistance;
        startPosition.value =
            (actualStartPosition / _stepWidth).round() * _stepWidth;
      }
    }
    scrollController.jumpTo(scrollController.position.pixels * scrollFactor);
    // print(
    //     'start: ${startPosition.value}, end: ${endPosition.value}, width: $videoResourceWidth');
    _lastStepValueIndex = stepValueIndex.value;
  }

  void zoomIn() {
    if (stepValueIndex.value > 0) {
      stepValueIndex.value--;
      updateSize();
    }
  }

  void zoomOut() {
    if (stepValueIndex.value < _minimumStepIndex) {
      stepValueIndex.value++;
      updateSize();
    }
  }

  void _edgeScroll(double position, bool increase, bool isLeft) {
    if (increase) {
      if (kDebugMode) {
        print(
            'scroll to right, position: $position, pixels: ${scrollController.position.pixels}, trimmerWidth: $trimmerWidth');
      }
      var offset = 0.0;
      if (isLeft) {
        offset = -10;
      }
      if (position >
          trimmerWidth +
              scrollController.position.pixels -
              DesignValues.mediumPadding +
              offset) {
        scrollController.jumpTo(
            position - trimmerWidth + DesignValues.mediumPadding - offset);
      }
    } else {
      if (kDebugMode) {
        print(
            'scroll to left, position: $position, pixels: ${scrollController.position.pixels}, trimmerWidth: $trimmerWidth');
      }
      var offset = 0.0;
      if (!isLeft) {
        offset = -10;
      }
      if (position < scrollController.position.pixels - offset) {
        scrollController.jumpTo(position + offset);
      }
    }
  }

  Future<void> _onDragLeft(DragUpdateDetails details) async {
    actualStartPosition = (actualStartPosition + details.delta.dx)
        .clamp(0.0, endPosition.value - _thumbBetweenDistance);
    startPosition.value =
        (actualStartPosition / _stepWidth).round() * _stepWidth;
    start.value = Duration(
        microseconds: (startPosition.value /
                _stepWidth *
                _scaleValueList[stepValueIndex.value])
            .round());
    await videoPlayerController.seekTo(start.value);
    _edgeScroll(startPosition.value, details.delta.dx > 0, true);
  }

  Future<void> _onDragRight(DragUpdateDetails details) async {
    actualEndPosition = (actualEndPosition + details.delta.dx).clamp(
        startPosition.value + _thumbBetweenDistance, videoResourceWidth.value);
    endPosition.value = (actualEndPosition / _stepWidth).round() * _stepWidth;
    end.value = Duration(
        microseconds: (endPosition.value /
                _stepWidth *
                _scaleValueList[stepValueIndex.value])
            .round());
    if (end.value > videoResource.duration) {
      end.value = videoResource.duration;
    }
    await videoPlayerController.seekTo(end.value);
    _edgeScroll(endPosition.value, details.delta.dx > 0, false);
  }

  void _onDragStart(DragStartDetails details) {
    changing = true;
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    changing = false;
    savedStart.value = start.value;
    savedEnd.value = end.value;
    playPosition.value = start.value;
    await videoPlayerController.seekTo(start.value);
  }

  void scrollToMarker(Duration position) {
    final positionInMicroseconds = position.inMicroseconds;
    final positionInStep = positionInMicroseconds /
        _scaleValueList[stepValueIndex.value] *
        _stepWidth;
    var scrollPosition = positionInStep - trimmerWidth / 2;
    if (scrollPosition < 0) {
      scrollPosition = 0;
    } else if (scrollPosition > videoResourceWidth.value - trimmerWidth) {
      scrollPosition = scrollController.position.maxScrollExtent;
    }
    scrollController.jumpTo(scrollPosition);
  }
}

class VideoTrimmer extends GetView<VideoTrimmerController> {
  const VideoTrimmer({super.key, required this.videoResource});

  final NormalVideoResource videoResource;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoTrimmerController>(
      init: VideoTrimmerController(videoResource: videoResource),
      builder: (controller) {
        // final size = MediaQuery.of(context).size;
        // controller.trimmerWidth = size.width - 2 * DesignValues.smallPadding;
        return Column(
          children: [
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.all(
                  Radius.circular(DesignValues.smallBorderRadius)),
              child: Obx(() => controller.footageInitialized.value
                  ? Chewie(
                      controller: controller.chewieController!,
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: ColorDark.primary,
                      ),
                    )),
            )),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            SizedBox(
              height: 48,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      iconData: Icons.chevron_left,
                      onPressed: () {
                        controller.scrollToMarker(controller.start.value);
                      },
                      iconSize: 36,
                      buttonSize: 48,
                      hoverColor: ColorDark.defaultHover,
                      focusColor: ColorDark.defaultActive,
                      iconColor: ColorDark.text0,
                    ),
                    Obx(
                      () => CustomIconButton(
                        iconData: controller.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        onPressed: () {
                          if (controller.isPlaying.value) {
                            controller.videoPlayerController.pause();
                          } else {
                            controller.videoPlayerController.play();
                          }
                        },
                        iconSize: 36,
                        buttonSize: 48,
                        hoverColor: ColorDark.defaultHover,
                        focusColor: ColorDark.defaultActive,
                        iconColor: ColorDark.text0,
                      ),
                    ),
                    CustomIconButton(
                      iconData: Icons.chevron_right,
                      onPressed: () {
                        controller.scrollToMarker(controller.end.value);
                      },
                      iconSize: 36,
                      buttonSize: 48,
                      hoverColor: ColorDark.defaultHover,
                      focusColor: ColorDark.defaultActive,
                      iconColor: ColorDark.text0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: Obx(() => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _FormattedTimeText(
                                duration: controller.start.value,
                                color: ColorDark.tertiary),
                            _FormattedTimeText(
                                duration: controller.end.value,
                                color: ColorDark.tertiary),
                          ],
                        )),
                  ),
                  Expanded(
                      child: Center(
                    child: SliderTheme(
                      data: const SliderThemeData(
                        thumbColor: ColorDark.primary,
                        activeTrackColor: ColorDark.primaryActive,
                        inactiveTrackColor: ColorDark.primaryDisabled,
                      ),
                      child: Obx(() => Slider(
                            value: controller.playPosition.value.inMicroseconds
                                .toDouble(),
                            min: controller.savedStart.value.inMicroseconds
                                .toDouble(),
                            max: controller.savedEnd.value.inMicroseconds
                                .toDouble(),
                            onChanged: (value) async {
                              controller.playPosition.value =
                                  Duration(microseconds: value.round());
                              await controller.videoPlayerController.pause();
                              await controller.videoPlayerController.seekTo(
                                  Duration(microseconds: value.round()));
                            },
                          )),
                    ),
                  )),
                  SizedBox(
                    width: 100,
                    child: Obx(() => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _FormattedTimeText(
                                duration: controller.end.value -
                                    controller.start.value,
                                color: ColorDark.primary),
                            _FormattedTimeText(
                                duration: controller.playPosition.value,
                                color: ColorDark.secondary),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            LayoutBuilder(builder: (context, constraints) {
              controller.trimmerWidth =
                  constraints.maxWidth - 2 * DesignValues.smallPadding;
              return MouseRegion(
                child: Listener(
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) {
                      if (HardwareKeyboard.instance.isMetaPressed ||
                          HardwareKeyboard.instance.isControlPressed) {
                        if (event.scrollDelta.dy > 0) {
                          controller.zoomOut();
                        } else {
                          controller.zoomIn();
                        }
                      }
                    }
                  },
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(DesignValues.mediumBorderRadius),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 80,
                            color: ColorDark.bg2,
                            child: RawScrollbar(
                              controller: controller.scrollController,
                              thumbVisibility: true,
                              thickness: 8,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(DesignValues.mediumPadding),
                                child: SingleChildScrollView(
                                  controller: controller.scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Obx(
                                    () => SizedBox(
                                      width:
                                          controller.videoResourceWidth.value,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                DesignValues.smallBorderRadius),
                                            child: Container(
                                              color: ColorDark.primary,
                                              width: controller
                                                  .videoResourceWidth.value,
                                            ),
                                          ),
                                          Positioned(
                                            left:
                                                controller.startPosition.value,
                                            right: controller
                                                    .videoResourceWidth.value -
                                                controller.endPosition.value,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      DesignValues
                                                          .smallBorderRadius),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                        color:
                                                            ColorDark.yellow5,
                                                        width: 4),
                                                    bottom: BorderSide(
                                                        color:
                                                            ColorDark.yellow5,
                                                        width: 4),
                                                  ),
                                                  color:
                                                      ColorDark.primaryActive,
                                                ),
                                                height: 80 -
                                                    2 *
                                                        DesignValues
                                                            .mediumPadding,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onHorizontalDragUpdate:
                                                          controller
                                                              ._onDragLeft,
                                                      onHorizontalDragStart:
                                                          controller
                                                              ._onDragStart,
                                                      onHorizontalDragEnd:
                                                          controller._onDragEnd,
                                                      child:
                                                          _TrimmerDragHandler(),
                                                    ),
                                                    GestureDetector(
                                                      onHorizontalDragUpdate:
                                                          controller
                                                              ._onDragRight,
                                                      onHorizontalDragStart:
                                                          controller
                                                              ._onDragStart,
                                                      onHorizontalDragEnd:
                                                          controller._onDragEnd,
                                                      child:
                                                          _TrimmerDragHandler(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
          ],
        );
      },
    );
  }
}

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/custom_icon_button.dart';

import '../../../models/media_resource.dart';
import '../../design_tokens.dart';

const _scaleValueList = [
  50000, // 50ms
  100000,
  500000,
  1000000, // 1s
  5000000,
  10000000,
];

const double _stepWidth = 5.0;
const double _thumbBetweenDistance = 20.0;

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
    return Text(_getFormattedTime(duration),
        style: SemiTextStyles.smallENRegular
            .copyWith(color: color, overflow: TextOverflow.ellipsis));
  }
}

String _getFormattedTime(Duration duration) {
  final origString = duration.toString();
  return origString.substring(0, origString.length - 2);
}

final trimmerSavedStart = StateProvider<Duration>((ref) => Duration.zero);
final trimmerSavedEnd = StateProvider<Duration>((ref) => Duration.zero);

class VideoTrimmer extends HookConsumerWidget {
  const VideoTrimmer({super.key, required this.videoResource});

  final NormalVideoResource videoResource;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoController = useMemoized(
      () => VideoPlayerController.file(videoResource.file),
      [videoResource.file.path], // 重建依赖
    );
    final chewieController = useState<ChewieController?>(null);
    final isInitialized = useState(false);

    final isPlaying = useState(false);
    final playPosition = useState(Duration.zero);
    final cutStart = useState(Duration.zero);
    final cutEnd = useState(videoResource.duration);

    final scrollController = useScrollController();
    var trimmerWidth = 0.0;
    final stepValueIndex = useState(0);

    final videoResourceWidth = useState(0.0);
    final startPosition = useState(0.0);
    final endPosition = useState(0.0);
    final actualEndPosition = useState(0.0);
    final actualStartPosition = useState(0.0);

    // late int minimumStepIndex;
    final minimumStepIndex = useState(0);
    final lastStepValueIndex = useState(0);

    final changing = useState(false);

    useEffect(() {
      bool mounted = true;

      Future<void> initVideo() async {
        await videoController.initialize();
        if (!mounted) return;

        chewieController.value = ChewieController(
          videoPlayerController: videoController,
          autoPlay: false,
          looping: false,
          showControls: false,
        );

        isInitialized.value = true;
        videoController.addListener(() async {
          isPlaying.value = videoController.value.isPlaying;
          if (!changing.value) {
            final position = videoController.value.position;
            if (position < cutStart.value || position > cutEnd.value) {
              await videoController.pause();
              isPlaying.value = false;
              await videoController.seekTo(cutStart.value);
              playPosition.value = cutStart.value;
            } else {
              playPosition.value = position;
            }
          }
        });
      }

      void getDefaultStepValueIndex() {
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

      void initSize() {
        getDefaultStepValueIndex();
        videoResourceWidth.value = (videoResource.duration.inMicroseconds /
                        (_scaleValueList[stepValueIndex.value]) +
                    1)
                .round() *
            _stepWidth;
        endPosition.value = videoResourceWidth.value;
        actualEndPosition.value = videoResourceWidth.value;
        minimumStepIndex.value = stepValueIndex.value;
        lastStepValueIndex.value = stepValueIndex.value;
      }

      initVideo();
      initSize();

      return () {
        mounted = false;
        videoController.dispose();
        chewieController.value?.dispose();
      };
    }, [videoResource.file.path]);

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

    void updateSize() {
      videoResourceWidth.value = (videoResource.duration.inMicroseconds /
                      (_scaleValueList[stepValueIndex.value]) +
                  1)
              .round() *
          _stepWidth;
      double scrollFactor = 1;
      // print('stepValueIndex: ${stepValueIndex.value}');
      if (lastStepValueIndex.value > stepValueIndex.value) {
        // _zoomIn();
        final ration = stepValueIndex.value.isOdd ? 5 : 2;
        for (var i = 0;
            i < lastStepValueIndex.value - stepValueIndex.value;
            i++) {
          actualStartPosition.value = actualStartPosition.value * ration;
          startPosition.value =
              (actualStartPosition.value / _stepWidth).round() * _stepWidth;
          actualEndPosition.value = actualEndPosition.value * ration;
          endPosition.value =
              (actualEndPosition.value / _stepWidth).round() * _stepWidth;
          if (endPosition.value > videoResourceWidth.value) {
            endPosition.value = videoResourceWidth.value;
            actualEndPosition.value = videoResourceWidth.value;
          }
        }
        scrollFactor = (1 * ration).toDouble();
      } else if (lastStepValueIndex.value < stepValueIndex.value) {
        // _zoomOut();
        final ration = stepValueIndex.value.isOdd ? 2 : 5;
        for (var i = 0;
            i < stepValueIndex.value - lastStepValueIndex.value;
            i++) {
          actualStartPosition.value = actualStartPosition.value / ration;
          startPosition.value =
              (actualStartPosition.value / _stepWidth).round() * _stepWidth;
          actualEndPosition.value = actualEndPosition.value / ration;
          endPosition.value =
              (actualEndPosition.value / _stepWidth).round() * _stepWidth;
        }
        scrollFactor = 1 / ration;
      }
      if (endPosition.value - startPosition.value < _thumbBetweenDistance) {
        // 距离过近，向左或者向右扩展
        if (actualEndPosition.value + _thumbBetweenDistance <
            videoResourceWidth.value) {
          actualEndPosition.value =
              actualStartPosition.value + _thumbBetweenDistance;
          endPosition.value =
              (actualEndPosition.value / _stepWidth).round() * _stepWidth;
        } else if (actualStartPosition.value - _thumbBetweenDistance > 0) {
          actualStartPosition.value =
              actualEndPosition.value - _thumbBetweenDistance;
          startPosition.value =
              (actualStartPosition.value / _stepWidth).round() * _stepWidth;
        }
      }
      scrollController.jumpTo(scrollController.position.pixels * scrollFactor);
      // print(
      //     'start: ${startPosition.value}, end: ${endPosition.value}, width: $videoResourceWidth');
      lastStepValueIndex.value = stepValueIndex.value;
    }

    void zoomIn() {
      if (stepValueIndex.value > 0) {
        stepValueIndex.value--;
        updateSize();
      }
    }

    void zoomOut() {
      if (stepValueIndex.value < minimumStepIndex.value) {
        stepValueIndex.value++;
        updateSize();
      }
    }

    void edgeScroll(double position, bool increase, bool isLeft) {
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

    Future<void> onDragLeft(DragUpdateDetails details) async {
      actualStartPosition.value = (actualStartPosition.value + details.delta.dx)
          .clamp(0.0, endPosition.value - _thumbBetweenDistance);
      startPosition.value =
          (actualStartPosition.value / _stepWidth).round() * _stepWidth;
      cutStart.value = Duration(
          microseconds: (startPosition.value /
                  _stepWidth *
                  _scaleValueList[stepValueIndex.value])
              .round());
      playPosition.value = cutStart.value;
      await videoController.seekTo(cutStart.value);
      edgeScroll(startPosition.value, details.delta.dx > 0, true);
    }

    Future<void> onDragRight(DragUpdateDetails details) async {
      actualEndPosition.value = (actualEndPosition.value + details.delta.dx)
          .clamp(startPosition.value + _thumbBetweenDistance,
              videoResourceWidth.value);
      endPosition.value =
          (actualEndPosition.value / _stepWidth).round() * _stepWidth;
      cutEnd.value = Duration(
          microseconds: (endPosition.value /
                  _stepWidth *
                  _scaleValueList[stepValueIndex.value])
              .round());
      if (cutEnd.value > videoResource.duration) {
        cutEnd.value = videoResource.duration;
      }
      await videoController.seekTo(cutEnd.value);
      edgeScroll(endPosition.value, details.delta.dx > 0, false);
    }

    void onDragStart(DragStartDetails details) {
      changing.value = true;
    }

    Future<void> onDragEnd(DragEndDetails details) async {
      changing.value = false;
      playPosition.value = cutStart.value;
      ref.read(trimmerSavedStart.notifier).state = cutStart.value;
      ref.read(trimmerSavedEnd.notifier).state = cutEnd.value;
      await videoController.seekTo(cutStart.value);
    }

    return Column(
      children: [
        Expanded(
            child: ClipRRect(
          borderRadius:
              BorderRadius.all(Radius.circular(DesignValues.smallBorderRadius)),
          child: isInitialized.value
              ? Chewie(controller: chewieController.value!)
              : const Center(
                  child: CircularProgressIndicator(
                  color: ColorDark.primary,
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
                    scrollToMarker(cutStart.value);
                  },
                  iconSize: 36,
                  buttonSize: 48,
                  hoverColor: ColorDark.defaultHover,
                  focusColor: ColorDark.defaultActive,
                  iconColor: ColorDark.text0,
                ),
                CustomIconButton(
                  iconData: isPlaying.value ? Icons.pause : Icons.play_arrow,
                  onPressed: () {
                    if (isPlaying.value) {
                      videoController.pause();
                    } else {
                      videoController.play();
                    }
                  },
                  iconSize: 36,
                  buttonSize: 48,
                  hoverColor: ColorDark.defaultHover,
                  focusColor: ColorDark.defaultActive,
                  iconColor: ColorDark.text0,
                ),
                CustomIconButton(
                  iconData: Icons.chevron_right,
                  onPressed: () {
                    scrollToMarker(cutEnd.value);
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FormattedTimeText(
                        duration: cutStart.value, color: ColorDark.tertiary),
                    _FormattedTimeText(
                        duration: cutEnd.value, color: ColorDark.tertiary),
                  ],
                ),
              ),
              Expanded(
                  child: Center(
                child: SliderTheme(
                  data: const SliderThemeData(
                    thumbColor: ColorDark.primary,
                    activeTrackColor: ColorDark.primaryActive,
                    inactiveTrackColor: ColorDark.primaryDisabled,
                  ),
                  child: Slider(
                    value: playPosition.value.inMicroseconds.toDouble(),
                    // value: 29109050,
                    min: cutStart.value.inMicroseconds.toDouble(),
                    max: cutEnd.value.inMicroseconds.toDouble(),
                    onChanged: (value) async {
                      playPosition.value =
                          Duration(microseconds: value.round());
                      await videoController.pause();
                      await videoController
                          .seekTo(Duration(microseconds: value.round()));
                    },
                  ),
                ),
              )),
              SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FormattedTimeText(
                        duration: cutEnd.value - cutStart.value,
                        color: ColorDark.primary),
                    _FormattedTimeText(
                        duration: playPosition.value,
                        color: ColorDark.secondary),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: DesignValues.mediumPadding,
        ),
        LayoutBuilder(builder: (context, constraints) {
          trimmerWidth = constraints.maxWidth - 2 * DesignValues.smallPadding;
          return MouseRegion(
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  if (HardwareKeyboard.instance.isMetaPressed ||
                      HardwareKeyboard.instance.isControlPressed) {
                    if (event.scrollDelta.dy > 0) {
                      zoomOut();
                    } else {
                      zoomIn();
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
                          controller: scrollController,
                          thumbVisibility: true,
                          thickness: 8,
                          child: Padding(
                            padding: EdgeInsets.all(DesignValues.mediumPadding),
                            child: SingleChildScrollView(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: videoResourceWidth.value,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            DesignValues.smallBorderRadius),
                                        child: Container(
                                          color: ColorDark.primary,
                                          width: videoResourceWidth.value,
                                        ),
                                      ),
                                      Positioned(
                                        left: startPosition.value,
                                        right: videoResourceWidth.value -
                                            endPosition.value,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              DesignValues.smallBorderRadius),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    color: ColorDark.yellow5,
                                                    width: 4),
                                                bottom: BorderSide(
                                                    color: ColorDark.yellow5,
                                                    width: 4),
                                              ),
                                              color: ColorDark.primaryActive,
                                            ),
                                            height: 80 -
                                                2 * DesignValues.mediumPadding,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onHorizontalDragUpdate:
                                                      onDragLeft,
                                                  onHorizontalDragStart:
                                                      onDragStart,
                                                  onHorizontalDragEnd:
                                                      onDragEnd,
                                                  child: _TrimmerDragHandler(),
                                                ),
                                                GestureDetector(
                                                  onHorizontalDragUpdate:
                                                      onDragRight,
                                                  onHorizontalDragStart:
                                                      onDragStart,
                                                  onHorizontalDragEnd:
                                                      onDragEnd,
                                                  child: _TrimmerDragHandler(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
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
  }
}

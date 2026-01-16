import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/custom_icon_button.dart';

import '../../../models/media_resource.dart';
import '../../design_tokens.dart';

part 'video_trimmer.g.dart';

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

// final trimmerSavedStart = StateProvider<Duration>((ref) => Duration.zero);
// final trimmerSavedEnd = StateProvider<Duration>((ref) => Duration.zero);

class _VideoTrimmerState {
  final bool isInitialized;
  final bool isPlaying;
  final bool changing;

  final Duration playPosition;
  final Duration cutStart;
  final Duration cutEnd;

  final int stepValueIndex;
  final int minimumStepIndex;
  final int lastStepValueIndex;

  final double videoResourceWidth;
  final double startPosition;
  final double endPosition;
  final double actualStartPosition;
  final double actualEndPosition;

  const _VideoTrimmerState({
    required this.isInitialized,
    required this.isPlaying,
    required this.changing,
    required this.playPosition,
    required this.cutStart,
    required this.cutEnd,
    required this.stepValueIndex,
    required this.minimumStepIndex,
    required this.lastStepValueIndex,
    required this.videoResourceWidth,
    required this.startPosition,
    required this.endPosition,
    required this.actualStartPosition,
    required this.actualEndPosition,
  });

  _VideoTrimmerState copyWith({
    bool? isInitialized,
    bool? isPlaying,
    bool? changing,
    Duration? playPosition,
    Duration? cutStart,
    Duration? cutEnd,
    int? stepValueIndex,
    int? minimumStepIndex,
    int? lastStepValueIndex,
    double? videoResourceWidth,
    double? startPosition,
    double? endPosition,
    double? actualStartPosition,
    double? actualEndPosition,
  }) {
    return _VideoTrimmerState(
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      changing: changing ?? this.changing,
      playPosition: playPosition ?? this.playPosition,
      cutStart: cutStart ?? this.cutStart,
      cutEnd: cutEnd ?? this.cutEnd,
      stepValueIndex: stepValueIndex ?? this.stepValueIndex,
      minimumStepIndex: minimumStepIndex ?? this.minimumStepIndex,
      lastStepValueIndex: lastStepValueIndex ?? this.lastStepValueIndex,
      videoResourceWidth:
      videoResourceWidth ?? this.videoResourceWidth,
      startPosition: startPosition ?? this.startPosition,
      endPosition: endPosition ?? this.endPosition,
      actualStartPosition:
      actualStartPosition ?? this.actualStartPosition,
      actualEndPosition:
      actualEndPosition ?? this.actualEndPosition,
    );
  }
}

@riverpod
class _VideoTrimmerController extends _$VideoTrimmerController {
  late final VideoPlayerController videoController;
  late final ChewieController chewieController;
  final scrollController = ScrollController();

  double trimmerWidth = 0;

  @override
  _VideoTrimmerState build(NormalVideoResource videoResource) {
    videoController =
        VideoPlayerController.file(videoResource.file);

    _init(videoResource);

    ref.onDispose(() {
      scrollController.dispose();
      videoController.dispose();
      chewieController.dispose();
    });

    return _VideoTrimmerState(
      isInitialized: false,
      isPlaying: false,
      changing: false,
      playPosition: Duration.zero,
      cutStart: Duration.zero,
      cutEnd: videoResource.duration,
      stepValueIndex: 0,
      minimumStepIndex: 0,
      lastStepValueIndex: 0,
      videoResourceWidth: 0,
      startPosition: 0,
      endPosition: 0,
      actualStartPosition: 0,
      actualEndPosition: 0,
    );
  }

  Future<void> _init(NormalVideoResource video) async {
    await videoController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoController,
      autoPlay: false,
      looping: false,
      showControls: false,
    );

    _initScale(video);

    videoController.addListener(_onVideoTick);

    state = state.copyWith(isInitialized: true);
  }

  void _onVideoTick() async {
    final value = videoController.value;

    state = state.copyWith(isPlaying: value.isPlaying);

    if (state.changing) return;

    final pos = value.position;
    if (pos < state.cutStart || pos > state.cutEnd) {
      await videoController.pause();
      await videoController.seekTo(state.cutStart);
      state = state.copyWith(
        isPlaying: false,
        playPosition: state.cutStart,
      );
    } else {
      state = state.copyWith(playPosition: pos);
    }
  }

  void _initScale(NormalVideoResource video) {
    final duration = video.duration.inMicroseconds;
    int index = 0;

    if (duration < _scaleValueList.first * 50) {
      index = 0;
    } else if (duration > _scaleValueList.last * 50) {
      index = _scaleValueList.length - 1;
    } else {
      for (var i = 0; i < _scaleValueList.length - 1; i++) {
        if (duration >= _scaleValueList[i] * 50 &&
            duration < _scaleValueList[i + 1] * 50) {
          index = i;
          break;
        }
      }
    }

    final width =
        (duration / _scaleValueList[index] + 1).round() *
            _stepWidth;

    state = state.copyWith(
      stepValueIndex: index,
      minimumStepIndex: index,
      lastStepValueIndex: index,
      videoResourceWidth: width,
      endPosition: width,
      actualEndPosition: width,
    );
  }

  void setTrimmerWidth(double width) {
    trimmerWidth = width;
  }

  void zoomIn() {
    if (state.stepValueIndex > 0) {
      state = state.copyWith(
          stepValueIndex: state.stepValueIndex - 1);
      _updateScale();
    }
  }

  void zoomOut() {
    if (state.stepValueIndex < state.minimumStepIndex) {
      state = state.copyWith(
          stepValueIndex: state.stepValueIndex + 1);
      _updateScale();
    }
  }

  void _updateScale() {
    final videoWidth =
        (videoController.value.duration.inMicroseconds /
            _scaleValueList[state.stepValueIndex] +
            1)
            .round() *
            _stepWidth;

    state = state.copyWith(
      videoResourceWidth: videoWidth,
      lastStepValueIndex: state.stepValueIndex,
    );
  }

  Future<void> dragLeft(double dx) async {
    final newActual =
    (state.actualStartPosition + dx).clamp(
      0.0,
      state.endPosition - _thumbBetweenDistance,
    );

    final snapped =
        (newActual / _stepWidth).round() * _stepWidth;

    final cut = Duration(
        microseconds: (snapped /
            _stepWidth *
            _scaleValueList[state.stepValueIndex])
            .round());

    state = state.copyWith(
      actualStartPosition: newActual,
      startPosition: snapped,
      cutStart: cut,
      playPosition: cut,
    );

    await videoController.seekTo(cut);
  }

  Future<void> dragRight(double dx) async {
    final newActual =
    (state.actualEndPosition + dx).clamp(
      state.startPosition + _thumbBetweenDistance,
      state.videoResourceWidth,
    );

    final snapped =
        (newActual / _stepWidth).round() * _stepWidth;

    var cut = Duration(
        microseconds: (snapped /
            _stepWidth *
            _scaleValueList[state.stepValueIndex])
            .round());

    if (cut > videoController.value.duration) {
      cut = videoController.value.duration;
    }

    state = state.copyWith(
      actualEndPosition: newActual,
      endPosition: snapped,
      cutEnd: cut,
    );

    await videoController.seekTo(cut);
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
    // actualStartPosition.value = (actualStartPosition.value + details.delta.dx)
    //     .clamp(0.0, endPosition.value - _thumbBetweenDistance);
    state = state.copyWith(
      actualStartPosition: (state.actualStartPosition + details.delta.dx)
          .clamp(0.0, state.endPosition - _thumbBetweenDistance),
    );
    // startPosition.value =
    //     (actualStartPosition.value / _stepWidth).round() * _stepWidth;
    state = state.copyWith(
      startPosition: (state.actualStartPosition / _stepWidth).round() * _stepWidth,
    );
    // cutStart.value = Duration(
    //     microseconds: (startPosition.value /
    //         _stepWidth *
    //         _scaleValueList[stepValueIndex.value])
    //         .round());
    state = state.copyWith(cutStart: Duration(
          microseconds: (state.startPosition /
              _stepWidth *
              _scaleValueList[state.stepValueIndex])
              .round()));
    state = state.copyWith(playPosition: state.cutStart);
    await videoController.seekTo(state.cutStart);
    edgeScroll(state.startPosition, details.delta.dx > 0, true);
  }

  Future<void> onDragRight(DragUpdateDetails details) async {
    state = state.copyWith(
      actualEndPosition: (state.actualEndPosition + details.delta.dx)
          .clamp(state.startPosition + _thumbBetweenDistance,
          state.videoResourceWidth),
    );
    state = state.copyWith(
      endPosition: (state.actualEndPosition / _stepWidth).round() * _stepWidth,
    );
    state = state.copyWith(cutEnd: Duration(
        microseconds: (state.endPosition /
            _stepWidth *
            _scaleValueList[state.stepValueIndex])
            .round()));
    if (state.cutEnd > videoResource.duration) {
      state = state.copyWith(cutEnd: videoResource.duration);
    }
    await videoController.seekTo(state.cutEnd);
    edgeScroll(state.endPosition, details.delta.dx > 0, false);
  }

  void onDragStart(DragStartDetails details) {
    // changing.value = true;
    state = state.copyWith(changing: true);
  }

  Future<void> onDragEnd(DragEndDetails details) async {
    state = state.copyWith(changing: false);
    state = state.copyWith(playPosition: state.cutStart);
    ref.read(trimmerSavedStartProvider.notifier).state = state.cutStart;
    ref.read(trimmerSavedEndProvider.notifier).state = state.cutEnd;
    await videoController.seekTo(state.cutStart);
  }

  void scrollToMarker(Duration position) {
    final positionInMicroseconds = position.inMicroseconds;
    final positionInStep = positionInMicroseconds /
        _scaleValueList[state.stepValueIndex] *
        _stepWidth;
    var scrollPosition = positionInStep - trimmerWidth / 2;
    if (scrollPosition < 0) {
      scrollPosition = 0;
    } else if (scrollPosition > state.videoResourceWidth - trimmerWidth) {
      scrollPosition = scrollController.position.maxScrollExtent;
    }
    scrollController.jumpTo(scrollPosition);
  }

  void updatePlayPosition(Duration position) {
    state = state.copyWith(playPosition: position);
  }
}

@riverpod
class TrimmerSavedStart extends _$TrimmerSavedStart {
  @override
  Duration build() => Duration.zero;

  void set(Duration value) => state = value;
}

@riverpod
class TrimmerSavedEnd extends _$TrimmerSavedEnd {
  @override
  Duration build() => Duration.zero;

  void set(Duration value) => state = value;
}

class VideoTrimmer extends ConsumerWidget {
  final NormalVideoResource videoResource;

  const VideoTrimmer({super.key, required this.videoResource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state =
    ref.watch(_videoTrimmerControllerProvider(videoResource));
    final controller = ref.read(
        _videoTrimmerControllerProvider(videoResource).notifier);

    return Column(
      children: [
        Expanded(
            child: ClipRRect(
          borderRadius:
              BorderRadius.all(Radius.circular(DesignValues.smallBorderRadius)),
          child: state.isInitialized
              ? Chewie(controller: controller.chewieController)
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
                    // scrollToMarker(cutStart.value);
                    controller.scrollToMarker(state.cutStart);
                  },
                  iconSize: 36,
                  buttonSize: 48,
                  hoverColor: ColorDark.defaultHover,
                  focusColor: ColorDark.defaultActive,
                  iconColor: ColorDark.text0,
                ),
                CustomIconButton(
                  iconData: state.isPlaying ? Icons.pause : Icons.play_arrow,
                  onPressed: () {
                    if (state.isPlaying) {
                      // videoController.pause();
                      controller.videoController.pause();
                    } else {
                      controller.videoController.play();
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
                    controller.scrollToMarker(state.cutEnd);
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
                        duration: state.cutStart, color: ColorDark.tertiary),
                    _FormattedTimeText(
                        duration: state.cutEnd, color: ColorDark.tertiary),
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
                    value: state.playPosition.inMicroseconds.toDouble(),
                    min: state.cutStart.inMicroseconds.toDouble(),
                    max: state.cutEnd.inMicroseconds.toDouble(),
                    onChanged: (value) async {
                      // controller.playPosition =
                      //     Duration(microseconds: value.round());
                      controller.updatePlayPosition(
                          Duration(microseconds: value.round()));
                      await controller.videoController.pause();
                      await controller.videoController
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
                        duration: state.cutEnd - state.cutStart,
                        color: ColorDark.primary),
                    _FormattedTimeText(
                        duration: state.playPosition,
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
          // trimmerWidth = constraints.maxWidth - 2 * DesignValues.smallPadding;
          controller.setTrimmerWidth(constraints.maxWidth - 2 * DesignValues.smallPadding);
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
                            padding: EdgeInsets.all(DesignValues.mediumPadding),
                            child: SingleChildScrollView(
                                controller: controller.scrollController,
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: state.videoResourceWidth,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            DesignValues.smallBorderRadius),
                                        child: Container(
                                          color: ColorDark.primary,
                                          width: state.videoResourceWidth,
                                        ),
                                      ),
                                      Positioned(
                                        left: state.startPosition,
                                        right: state.videoResourceWidth -
                                            state.endPosition,
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
                                                      controller.onDragLeft,
                                                  onHorizontalDragStart:
                                                      controller.onDragStart,
                                                  onHorizontalDragEnd:
                                                      controller.onDragEnd,
                                                  child: _TrimmerDragHandler(),
                                                ),
                                                GestureDetector(
                                                  onHorizontalDragUpdate:
                                                      controller.onDragRight,
                                                  onHorizontalDragStart:
                                                      controller.onDragStart,
                                                  onHorizontalDragEnd:
                                                      controller.onDragEnd,
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

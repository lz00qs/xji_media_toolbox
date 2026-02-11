import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';
import 'package:xji_footage_toolbox/models/media_resource.model.dart';

import '../buttons/custom_icon_button.dart';
import '../design_tokens.dart';
import 'main_panel.dart';

part 'video_trimmer_panel.freezed.dart';

part 'video_trimmer_panel.g.dart';

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

@freezed
abstract class VideoTrimmerState with _$VideoTrimmerState {
  const factory VideoTrimmerState({
    @Default(false) bool isPlaying,
    @Default(false) bool isChanging,
    @Default(Duration.zero) Duration playPosition,
    @Default(Duration.zero) Duration cutStart,
    @Default(Duration.zero) Duration cutEnd,
    @Default(0) int stepValueIndex,
    @Default(0) int minimumStepIndex,
    @Default(0) int lastStepValueIndex,
    @Default(0.0) double videoWidth,
    @Default(0.0) double startPosition,
    @Default(0.0) double endPosition,
    @Default(0.0) double actualStartPosition,
    @Default(0.0) double actualEndPosition,
  }) = _VideoTrimmerState;
}

@riverpod
class VideoTrimmerStateNotifier extends _$VideoTrimmerStateNotifier {
  var trimmerWidth = 0.0;
  final scrollController = ScrollController();

  @override
  VideoTrimmerState build(
      MediaResource resource, VideoPlayerController videoPlayerController) {
    if (resource is! VideoResource) {
      return VideoTrimmerState();
    }

    var initialStepValueIndex = 0;
    final duration = resource.duration.inMicroseconds;
    const scale = 50;
    if (duration < _scaleValueList.first * scale) {
      initialStepValueIndex = 0;
    } else if (duration > _scaleValueList.last * scale) {
      initialStepValueIndex = _scaleValueList.length - 1;
    } else {
      for (var i = 0; i < _scaleValueList.length - 1; i++) {
        if (duration >= (_scaleValueList[i] * scale) &&
            duration < (_scaleValueList[i + 1] * 50)) {
          initialStepValueIndex = i;
          break;
        }
      }
    }

    final videoWidth =
        (duration / (_scaleValueList[initialStepValueIndex]) + 1).round() *
            _stepWidth;

    videoPlayerController.addListener(() async {
      state = state.copyWith(isPlaying: videoPlayerController.value.isPlaying);
      if (!state.isChanging) {
        final position = videoPlayerController.value.position;
        if (position < state.cutStart || position > state.cutEnd) {
          await videoPlayerController.pause();
          state = state.copyWith(isPlaying: false);
          await videoPlayerController.seekTo(state.cutStart);
          state = state.copyWith(playPosition: state.cutStart);
        } else {
          state = state.copyWith(playPosition: position);
        }
      }
    });

    return VideoTrimmerState(
        isPlaying: false,
        isChanging: false,
        playPosition: Duration.zero,
        cutStart: Duration.zero,
        cutEnd: resource.duration,
        stepValueIndex: initialStepValueIndex,
        minimumStepIndex: initialStepValueIndex,
        lastStepValueIndex: initialStepValueIndex,
        videoWidth: videoWidth,
        startPosition: 0,
        endPosition: videoWidth,
        actualStartPosition: 0,
        actualEndPosition: videoWidth);
  }

  void setTrimmerWidth(double width) {
    trimmerWidth = width;
  }

  void scrollToMarker(Duration position) {
    final positionInMicroseconds = position.inMicroseconds;
    final positionInStep = positionInMicroseconds /
        _scaleValueList[state.stepValueIndex] *
        _stepWidth;
    var scrollPosition = positionInStep - trimmerWidth / 2;
    if (scrollPosition < 0) {
      scrollPosition = 0;
    } else if (scrollPosition > state.videoWidth - trimmerWidth) {
      scrollPosition = scrollController.position.maxScrollExtent;
    }
    scrollController.jumpTo(scrollPosition);
  }

  void updatePlayPosition(Duration position) {
    state = state.copyWith(playPosition: position);
  }

  void _updateScale() {
    state = state.copyWith(
      videoWidth: ((resource as VideoResource).duration.inMicroseconds /
                      (_scaleValueList[state.stepValueIndex]) +
                  1)
              .round() *
          _stepWidth,
    );

    double scrollFactor = 1;
    const int zoomInRationOdd = 5;
    const int zoomInRationEven = 2;

    if (state.lastStepValueIndex > state.stepValueIndex) {
      final ration =
          state.stepValueIndex.isOdd ? zoomInRationOdd : zoomInRationEven;
      for (var i = 0;
          i < state.lastStepValueIndex - state.stepValueIndex;
          i++) {
        state = state.copyWith(
          actualStartPosition: state.actualStartPosition * ration,
          actualEndPosition: state.actualEndPosition * ration,
        );
        _updatePositions(state.cutEnd.inMicroseconds ==
            (resource as VideoResource).duration.inMicroseconds);
        if (state.endPosition > state.videoWidth) {
          state = state.copyWith(
            endPosition: state.videoWidth,
            actualEndPosition: state.videoWidth,
          );
        }
      }
      scrollFactor = ration.toDouble();
    } else if (state.lastStepValueIndex < state.stepValueIndex) {
      final ration =
          state.stepValueIndex.isOdd ? zoomInRationEven : zoomInRationOdd;
      for (var i = 0;
          i < state.stepValueIndex - state.lastStepValueIndex;
          i++) {
        state = state.copyWith(
          actualStartPosition: state.actualStartPosition / ration,
          actualEndPosition: state.actualEndPosition / ration,
        );
        _updatePositions(state.cutEnd.inMicroseconds ==
            (resource as VideoResource).duration.inMicroseconds);
      }
      scrollFactor = 1 / ration;
    }

    if (state.endPosition - state.startPosition < _thumbBetweenDistance) {
      if (state.actualEndPosition + _thumbBetweenDistance < state.videoWidth) {
        state = state.copyWith(
          actualEndPosition: state.actualStartPosition + _thumbBetweenDistance,
        );
        _updatePositions(state.cutEnd.inMicroseconds ==
            (resource as VideoResource).duration.inMicroseconds);
      } else if (state.actualStartPosition - _thumbBetweenDistance > 0) {
        state = state.copyWith(
          actualStartPosition: state.actualEndPosition - _thumbBetweenDistance,
        );
        _updatePositions(state.cutEnd.inMicroseconds ==
            (resource as VideoResource).duration.inMicroseconds);
      }
    }

    scrollController.jumpTo(
      (scrollController.position.pixels +
                  trimmerWidth / 2 -
                  DesignValues.mediumPadding) *
              scrollFactor -
          trimmerWidth / 2 +
          DesignValues.mediumPadding,
    );

    state = state.copyWith(lastStepValueIndex: state.stepValueIndex);
  }

  void _updatePositions(bool isEndFull) {
    if (kDebugMode) {
      print(
        'update positions, isEndFull: $isEndFull, actualStartPosition: ${state.actualStartPosition}, actualEndPosition: ${state.actualEndPosition}');
    }
    state = state.copyWith(
      startPosition:
          (state.actualStartPosition / _stepWidth).round() * _stepWidth,
      // endPosition: (state.actualEndPosition / _stepWidth).round() * _stepWidth,
      endPosition: isEndFull
          ? state.videoWidth
          : (state.actualEndPosition / _stepWidth).round() * _stepWidth,
    );
  }

  void zoomIn() {
    if (state.stepValueIndex > 0) {
      state = state.copyWith(stepValueIndex: state.stepValueIndex - 1);
      _updateScale();
    }
  }

  void zoomOut() {
    if (state.stepValueIndex < state.minimumStepIndex) {
      state = state.copyWith(stepValueIndex: state.stepValueIndex + 1);
      _updateScale();
    }
  }

  void edgeScroll(double position, bool increase, bool isLeft) {
    if (increase) {
      if (kDebugMode) {
        print(
            'scroll to right, position: $position, pixels: ${scrollController.position.pixels}, trimmerWidth: $trimmerWidth, videoWidth: ${state.videoWidth}');
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
    state = state.copyWith(
      actualStartPosition: (state.actualStartPosition + details.delta.dx)
          .clamp(0.0, state.endPosition - _thumbBetweenDistance),
    );
    state = state.copyWith(
      startPosition:
          (state.actualStartPosition / _stepWidth).round() * _stepWidth,
    );
    // cutStart.value = Duration(
    //     microseconds: (startPosition.value /
    //         _stepWidth *
    //         _scaleValueList[stepValueIndex.value])
    //         .round());
    state = state.copyWith(
        cutStart: Duration(
            microseconds: (state.startPosition /
                    _stepWidth *
                    _scaleValueList[state.stepValueIndex])
                .round()));
    state = state.copyWith(playPosition: state.cutStart);
    await videoPlayerController.seekTo(state.cutStart);
    edgeScroll(state.startPosition, details.delta.dx > 0, true);
  }

  Future<void> onDragRight(DragUpdateDetails details) async {
    state = state.copyWith(
      actualEndPosition: (state.actualEndPosition + details.delta.dx)
          .clamp(state.startPosition + _thumbBetweenDistance, state.videoWidth),
    );
    state = state.copyWith(
      endPosition: (state.actualEndPosition / _stepWidth).round() * _stepWidth,
    );
    state = state.copyWith(
        cutEnd: Duration(
            microseconds: (state.endPosition /
                    _stepWidth *
                    _scaleValueList[state.stepValueIndex])
                .round()));
    if (state.cutEnd > videoPlayerController.value.duration) {
      state = state.copyWith(cutEnd: videoPlayerController.value.duration);
    }
    await videoPlayerController.seekTo(state.cutEnd);
    edgeScroll(state.endPosition, details.delta.dx > 0, false);
  }

  void onDragStart(DragStartDetails details) {
    // changing.value = true;
    state = state.copyWith(isChanging: true);
  }

  Future<void> onDragEnd(DragEndDetails details) async {
    state = state.copyWith(isChanging: false);
    state = state.copyWith(playPosition: state.cutStart);
    await videoPlayerController.seekTo(state.cutStart);
  }
}

class _VideoTrimmer extends ConsumerWidget {
  final VideoResource videoResource;
  final ChewieController chewieController;
  final VideoPlayerController videoPlayerController;

  const _VideoTrimmer(
      {required this.videoResource,
      required this.chewieController,
      required this.videoPlayerController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref
        .watch(videoTrimmerStateProvider(videoResource, videoPlayerController));
    final notifier = ref.watch(
        videoTrimmerStateProvider(videoResource, videoPlayerController)
            .notifier);

    return Column(
      children: [
        Expanded(
            child: ClipRRect(
          borderRadius:
              BorderRadius.all(Radius.circular(DesignValues.smallBorderRadius)),
          child: Chewie(controller: chewieController),
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
                    notifier.scrollToMarker(state.cutStart);
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
                      notifier.videoPlayerController.pause();
                    } else {
                      notifier.videoPlayerController.play();
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
                    notifier.scrollToMarker(state.cutEnd);
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
                      notifier.updatePlayPosition(
                          Duration(microseconds: value.round()));
                      await notifier.videoPlayerController.pause();
                      await notifier.videoPlayerController
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
          notifier.setTrimmerWidth(
              constraints.maxWidth - 2 * DesignValues.smallPadding);
          return MouseRegion(
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  if (HardwareKeyboard.instance.isMetaPressed ||
                      HardwareKeyboard.instance.isControlPressed) {
                    if (event.scrollDelta.dy > 0) {
                      notifier.zoomOut();
                    } else {
                      notifier.zoomIn();
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
                          controller: notifier.scrollController,
                          thumbVisibility: true,
                          thickness: 8,
                          child: Padding(
                            padding: EdgeInsets.all(DesignValues.mediumPadding),
                            child: SingleChildScrollView(
                                controller: notifier.scrollController,
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: state.videoWidth,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            DesignValues.smallBorderRadius),
                                        child: Container(
                                          color: ColorDark.primary,
                                          width: state.videoWidth,
                                        ),
                                      ),
                                      Positioned(
                                        left: state.startPosition,
                                        right: state.videoWidth -
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
                                                      notifier.onDragLeft,
                                                  onHorizontalDragStart:
                                                      notifier.onDragStart,
                                                  onHorizontalDragEnd:
                                                      notifier.onDragEnd,
                                                  child: _TrimmerDragHandler(),
                                                ),
                                                GestureDetector(
                                                  onHorizontalDragUpdate:
                                                      notifier.onDragRight,
                                                  onHorizontalDragStart:
                                                      notifier.onDragStart,
                                                  onHorizontalDragEnd:
                                                      notifier.onDragEnd,
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

@freezed
abstract class _VideoTrimmerPanelState with _$VideoTrimmerPanelState {
  const factory _VideoTrimmerPanelState({
    @Default(null) ChewieController? chewieController,
    @Default(null) VideoPlayerController? videoPlayerController,
  }) = __VideoTrimmerPanelState;
}

@riverpod
class _VideoTrimmerPanelStateNotifier extends _$VideoTrimmerPanelStateNotifier {
  late final VideoPlayerController _videoController;
  late final ChewieController _chewieController;

  @override
  Future<_VideoTrimmerPanelState> build({
    required File videoFile,
  }) async {
    _videoController = VideoPlayerController.file(videoFile);
    await _videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      showControls: false,
    );
    ref.onDispose(() async {
      await _videoController.dispose();
      _chewieController.dispose();
    });
    return _VideoTrimmerPanelState(
        chewieController: _chewieController,
        videoPlayerController: _videoController);
  }
}

class VideoTrimmerPanel extends ConsumerWidget {
  final VideoResource resource;

  const VideoTrimmerPanel({super.key, required this.resource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state =
        ref.watch(_videoTrimmerPanelStateProvider(videoFile: resource.file));
    return state.when(
      data: (data) {
        // _VideoTrimmer(
        //   chewieController: data.chewieController!,
        //   videoResource: resource,
        //   videoPlayerController: data.videoPlayerController!,
        // );
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(DesignValues.smallPadding),
                  child: _VideoTrimmer(
                      videoResource: resource,
                      chewieController: data.chewieController!,
                      videoPlayerController: data.videoPlayerController!)),
            ),
            MainPanelSideBar(
              children: [
                SizedBox(
                  height: DesignValues.mediumPadding,
                ),
                CustomIconButton(
                    iconData: Icons.arrow_back_ios_new,
                    onPressed: () async {
                      // ref.read(mediaResourcesProvider.notifier).setIsEditing(false);
                    },
                    iconSize: DesignValues.mediumIconSize,
                    buttonSize: DesignValues.appBarHeight,
                    hoverColor: ColorDark.defaultHover,
                    focusColor: ColorDark.defaultActive,
                    iconColor: ColorDark.text0),
                SizedBox(
                  height: DesignValues.mediumPadding,
                ),
                CustomIconButton(
                    iconData: Icons.upload,
                    onPressed: () async {
                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return VideoExportDialog();
                      //     });
                    },
                    iconSize: DesignValues.mediumIconSize,
                    buttonSize: DesignValues.appBarHeight,
                    hoverColor: ColorDark.defaultHover,
                    focusColor: ColorDark.defaultActive,
                    iconColor: ColorDark.text0),
              ],
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
    );
  }
}

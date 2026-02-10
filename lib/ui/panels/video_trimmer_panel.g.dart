// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_trimmer_panel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VideoTrimmerStateNotifier)
final videoTrimmerStateProvider = VideoTrimmerStateNotifierFamily._();

final class VideoTrimmerStateNotifierProvider
    extends $NotifierProvider<VideoTrimmerStateNotifier, VideoTrimmerState> {
  VideoTrimmerStateNotifierProvider._(
      {required VideoTrimmerStateNotifierFamily super.from,
      required (
        MediaResource,
        VideoPlayerController,
      )
          super.argument})
      : super(
          retry: null,
          name: r'videoTrimmerStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$videoTrimmerStateNotifierHash();

  @override
  String toString() {
    return r'videoTrimmerStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  VideoTrimmerStateNotifier create() => VideoTrimmerStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VideoTrimmerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VideoTrimmerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VideoTrimmerStateNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$videoTrimmerStateNotifierHash() =>
    r'b3f35f7da106e22297ce73538cfe4acc797b5b7d';

final class VideoTrimmerStateNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            VideoTrimmerStateNotifier,
            VideoTrimmerState,
            VideoTrimmerState,
            VideoTrimmerState,
            (
              MediaResource,
              VideoPlayerController,
            )> {
  VideoTrimmerStateNotifierFamily._()
      : super(
          retry: null,
          name: r'videoTrimmerStateProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  VideoTrimmerStateNotifierProvider call(
    MediaResource resource,
    VideoPlayerController videoPlayerController,
  ) =>
      VideoTrimmerStateNotifierProvider._(argument: (
        resource,
        videoPlayerController,
      ), from: this);

  @override
  String toString() => r'videoTrimmerStateProvider';
}

abstract class _$VideoTrimmerStateNotifier
    extends $Notifier<VideoTrimmerState> {
  late final _$args = ref.$arg as (
    MediaResource,
    VideoPlayerController,
  );
  MediaResource get resource => _$args.$1;
  VideoPlayerController get videoPlayerController => _$args.$2;

  VideoTrimmerState build(
    MediaResource resource,
    VideoPlayerController videoPlayerController,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VideoTrimmerState, VideoTrimmerState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<VideoTrimmerState, VideoTrimmerState>,
        VideoTrimmerState,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args.$1,
              _$args.$2,
            ));
  }
}

@ProviderFor(_VideoTrimmerPanelStateNotifier)
final _videoTrimmerPanelStateProvider =
    _VideoTrimmerPanelStateNotifierFamily._();

final class _VideoTrimmerPanelStateNotifierProvider
    extends $AsyncNotifierProvider<_VideoTrimmerPanelStateNotifier,
        _VideoTrimmerPanelState> {
  _VideoTrimmerPanelStateNotifierProvider._(
      {required _VideoTrimmerPanelStateNotifierFamily super.from,
      required File super.argument})
      : super(
          retry: null,
          name: r'_videoTrimmerPanelStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_videoTrimmerPanelStateNotifierHash();

  @override
  String toString() {
    return r'_videoTrimmerPanelStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _VideoTrimmerPanelStateNotifier create() => _VideoTrimmerPanelStateNotifier();

  @override
  bool operator ==(Object other) {
    return other is _VideoTrimmerPanelStateNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_videoTrimmerPanelStateNotifierHash() =>
    r'9bd75805560ca9aeb475d928a62e35ebd3209ac2';

final class _VideoTrimmerPanelStateNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            _VideoTrimmerPanelStateNotifier,
            AsyncValue<_VideoTrimmerPanelState>,
            _VideoTrimmerPanelState,
            FutureOr<_VideoTrimmerPanelState>,
            File> {
  _VideoTrimmerPanelStateNotifierFamily._()
      : super(
          retry: null,
          name: r'_videoTrimmerPanelStateProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _VideoTrimmerPanelStateNotifierProvider call({
    required File videoFile,
  }) =>
      _VideoTrimmerPanelStateNotifierProvider._(
          argument: videoFile, from: this);

  @override
  String toString() => r'_videoTrimmerPanelStateProvider';
}

abstract class _$VideoTrimmerPanelStateNotifier
    extends $AsyncNotifier<_VideoTrimmerPanelState> {
  late final _$args = ref.$arg as File;
  File get videoFile => _$args;

  FutureOr<_VideoTrimmerPanelState> build({
    required File videoFile,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<_VideoTrimmerPanelState>, _VideoTrimmerPanelState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<_VideoTrimmerPanelState>,
            _VideoTrimmerPanelState>,
        AsyncValue<_VideoTrimmerPanelState>,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              videoFile: _$args,
            ));
  }
}

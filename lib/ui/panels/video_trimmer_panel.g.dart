// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_trimmer_panel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_VideoTrimmerNotifier)
final _videoTrimmerProvider = _VideoTrimmerNotifierFamily._();

final class _VideoTrimmerNotifierProvider
    extends $NotifierProvider<_VideoTrimmerNotifier, _VideoTrimmerState> {
  _VideoTrimmerNotifierProvider._(
      {required _VideoTrimmerNotifierFamily super.from,
      required (
        MediaResource,
        VideoPlayerController,
      )
          super.argument})
      : super(
          retry: null,
          name: r'_videoTrimmerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_videoTrimmerNotifierHash();

  @override
  String toString() {
    return r'_videoTrimmerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  _VideoTrimmerNotifier create() => _VideoTrimmerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_VideoTrimmerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_VideoTrimmerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _VideoTrimmerNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_videoTrimmerNotifierHash() =>
    r'7c38ee3867982b6e635f48cbdcee11ca34e0c3ee';

final class _VideoTrimmerNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            _VideoTrimmerNotifier,
            _VideoTrimmerState,
            _VideoTrimmerState,
            _VideoTrimmerState,
            (
              MediaResource,
              VideoPlayerController,
            )> {
  _VideoTrimmerNotifierFamily._()
      : super(
          retry: null,
          name: r'_videoTrimmerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _VideoTrimmerNotifierProvider call(
    MediaResource resource,
    VideoPlayerController videoPlayerController,
  ) =>
      _VideoTrimmerNotifierProvider._(argument: (
        resource,
        videoPlayerController,
      ), from: this);

  @override
  String toString() => r'_videoTrimmerProvider';
}

abstract class _$VideoTrimmerNotifier extends $Notifier<_VideoTrimmerState> {
  late final _$args = ref.$arg as (
    MediaResource,
    VideoPlayerController,
  );
  MediaResource get resource => _$args.$1;
  VideoPlayerController get videoPlayerController => _$args.$2;

  _VideoTrimmerState build(
    MediaResource resource,
    VideoPlayerController videoPlayerController,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<_VideoTrimmerState, _VideoTrimmerState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<_VideoTrimmerState, _VideoTrimmerState>,
        _VideoTrimmerState,
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

@ProviderFor(VideoCutNotifier)
final videoCutProvider = VideoCutNotifierProvider._();

final class VideoCutNotifierProvider
    extends $NotifierProvider<VideoCutNotifier, VideoCutState> {
  VideoCutNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'videoCutProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$videoCutNotifierHash();

  @$internal
  @override
  VideoCutNotifier create() => VideoCutNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VideoCutState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VideoCutState>(value),
    );
  }
}

String _$videoCutNotifierHash() => r'874f1e1a2ac72d262e1c630aabc5c8a3f953ef12';

abstract class _$VideoCutNotifier extends $Notifier<VideoCutState> {
  VideoCutState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VideoCutState, VideoCutState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<VideoCutState, VideoCutState>,
        VideoCutState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
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
    r'1d9c6873d30ede596c9eb970176ad5658e3c7a4d';

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

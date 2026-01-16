// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chewie_video_player_hook.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_ChewieVideoPlayerController)
final _chewieVideoPlayerControllerProvider =
    _ChewieVideoPlayerControllerFamily._();

final class _ChewieVideoPlayerControllerProvider extends $NotifierProvider<
    _ChewieVideoPlayerController, _ChewieVideoPlayerState> {
  _ChewieVideoPlayerControllerProvider._(
      {required _ChewieVideoPlayerControllerFamily super.from,
      required ({
        File videoFile,
        bool showControls,
      })
          super.argument})
      : super(
          retry: null,
          name: r'_chewieVideoPlayerControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_chewieVideoPlayerControllerHash();

  @override
  String toString() {
    return r'_chewieVideoPlayerControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  _ChewieVideoPlayerController create() => _ChewieVideoPlayerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_ChewieVideoPlayerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_ChewieVideoPlayerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _ChewieVideoPlayerControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_chewieVideoPlayerControllerHash() =>
    r'2b6ba62070bfb14f8b20d88a5378791208a812dc';

final class _ChewieVideoPlayerControllerFamily extends $Family
    with
        $ClassFamilyOverride<
            _ChewieVideoPlayerController,
            _ChewieVideoPlayerState,
            _ChewieVideoPlayerState,
            _ChewieVideoPlayerState,
            ({
              File videoFile,
              bool showControls,
            })> {
  _ChewieVideoPlayerControllerFamily._()
      : super(
          retry: null,
          name: r'_chewieVideoPlayerControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _ChewieVideoPlayerControllerProvider call({
    required File videoFile,
    required bool showControls,
  }) =>
      _ChewieVideoPlayerControllerProvider._(argument: (
        videoFile: videoFile,
        showControls: showControls,
      ), from: this);

  @override
  String toString() => r'_chewieVideoPlayerControllerProvider';
}

abstract class _$ChewieVideoPlayerController
    extends $Notifier<_ChewieVideoPlayerState> {
  late final _$args = ref.$arg as ({
    File videoFile,
    bool showControls,
  });
  File get videoFile => _$args.videoFile;
  bool get showControls => _$args.showControls;

  _ChewieVideoPlayerState build({
    required File videoFile,
    required bool showControls,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<_ChewieVideoPlayerState, _ChewieVideoPlayerState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<_ChewieVideoPlayerState, _ChewieVideoPlayerState>,
        _ChewieVideoPlayerState,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              videoFile: _$args.videoFile,
              showControls: _$args.showControls,
            ));
  }
}

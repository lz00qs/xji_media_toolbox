// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_player_panel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_VideoPlayerPanelStateNotifier)
final _videoPlayerPanelStateProvider = _VideoPlayerPanelStateNotifierFamily._();

final class _VideoPlayerPanelStateNotifierProvider
    extends $AsyncNotifierProvider<_VideoPlayerPanelStateNotifier,
        _VideoPlayerPanelState> {
  _VideoPlayerPanelStateNotifierProvider._(
      {required _VideoPlayerPanelStateNotifierFamily super.from,
      required File super.argument})
      : super(
          retry: null,
          name: r'_videoPlayerPanelStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_videoPlayerPanelStateNotifierHash();

  @override
  String toString() {
    return r'_videoPlayerPanelStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _VideoPlayerPanelStateNotifier create() => _VideoPlayerPanelStateNotifier();

  @override
  bool operator ==(Object other) {
    return other is _VideoPlayerPanelStateNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_videoPlayerPanelStateNotifierHash() =>
    r'a14b4508c65f2339b1f5a8e8f0d9ddd452d0bd6f';

final class _VideoPlayerPanelStateNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            _VideoPlayerPanelStateNotifier,
            AsyncValue<_VideoPlayerPanelState>,
            _VideoPlayerPanelState,
            FutureOr<_VideoPlayerPanelState>,
            File> {
  _VideoPlayerPanelStateNotifierFamily._()
      : super(
          retry: null,
          name: r'_videoPlayerPanelStateProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _VideoPlayerPanelStateNotifierProvider call({
    required File videoFile,
  }) =>
      _VideoPlayerPanelStateNotifierProvider._(argument: videoFile, from: this);

  @override
  String toString() => r'_videoPlayerPanelStateProvider';
}

abstract class _$VideoPlayerPanelStateNotifier
    extends $AsyncNotifier<_VideoPlayerPanelState> {
  late final _$args = ref.$arg as File;
  File get videoFile => _$args;

  FutureOr<_VideoPlayerPanelState> build({
    required File videoFile,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<_VideoPlayerPanelState>, _VideoPlayerPanelState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<_VideoPlayerPanelState>, _VideoPlayerPanelState>,
        AsyncValue<_VideoPlayerPanelState>,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              videoFile: _$args,
            ));
  }
}

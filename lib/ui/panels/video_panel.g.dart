// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_panel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VideoPanelState)
final videoPanelStateProvider = VideoPanelStateProvider._();

final class VideoPanelStateProvider
    extends $NotifierProvider<VideoPanelState, bool> {
  VideoPanelStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'videoPanelStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$videoPanelStateHash();

  @$internal
  @override
  VideoPanelState create() => VideoPanelState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$videoPanelStateHash() => r'29642c62d803de79e134777d09ac29ccff840a1a';

abstract class _$VideoPanelState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resizable_panel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_ResizablePanelNotifier)
final _resizablePanelProvider = _ResizablePanelNotifierProvider._();

final class _ResizablePanelNotifierProvider
    extends $NotifierProvider<_ResizablePanelNotifier, ResizablePanelState> {
  _ResizablePanelNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_resizablePanelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_resizablePanelNotifierHash();

  @$internal
  @override
  _ResizablePanelNotifier create() => _ResizablePanelNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResizablePanelState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResizablePanelState>(value),
    );
  }
}

String _$_resizablePanelNotifierHash() =>
    r'36e61ed024fd3ff7d87219f7b1d15c7119fe2443';

abstract class _$ResizablePanelNotifier extends $Notifier<ResizablePanelState> {
  ResizablePanelState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ResizablePanelState, ResizablePanelState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ResizablePanelState, ResizablePanelState>,
        ResizablePanelState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resizable_panel_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResizablePanelStateNotifier)
final resizablePanelStateProvider = ResizablePanelStateNotifierProvider._();

final class ResizablePanelStateNotifierProvider extends $NotifierProvider<
    ResizablePanelStateNotifier, ResizablePanelState> {
  ResizablePanelStateNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'resizablePanelStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$resizablePanelStateNotifierHash();

  @$internal
  @override
  ResizablePanelStateNotifier create() => ResizablePanelStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResizablePanelState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResizablePanelState>(value),
    );
  }
}

String _$resizablePanelStateNotifierHash() =>
    r'cb439237e7facb212200d2ddb12283d7dd864747';

abstract class _$ResizablePanelStateNotifier
    extends $Notifier<ResizablePanelState> {
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

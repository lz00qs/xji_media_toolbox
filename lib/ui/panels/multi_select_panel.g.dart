// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_select_panel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IsMergingNotifier)
final isMergingProvider = IsMergingNotifierProvider._();

final class IsMergingNotifierProvider
    extends $NotifierProvider<IsMergingNotifier, bool> {
  IsMergingNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isMergingProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isMergingNotifierHash();

  @$internal
  @override
  IsMergingNotifier create() => IsMergingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isMergingNotifierHash() => r'655243ec8939f295b3cd2a80b655077eb1682615';

abstract class _$IsMergingNotifier extends $Notifier<bool> {
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

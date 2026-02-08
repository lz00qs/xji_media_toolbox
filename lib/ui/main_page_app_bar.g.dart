// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_page_app_bar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_IsMaximizedState)
final _isMaximizedStateProvider = _IsMaximizedStateProvider._();

final class _IsMaximizedStateProvider
    extends $NotifierProvider<_IsMaximizedState, bool> {
  _IsMaximizedStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_isMaximizedStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_isMaximizedStateHash();

  @$internal
  @override
  _IsMaximizedState create() => _IsMaximizedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$_isMaximizedStateHash() => r'72d7b005546532928d7cc8b03fff8851a68ae710';

abstract class _$IsMaximizedState extends $Notifier<bool> {
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

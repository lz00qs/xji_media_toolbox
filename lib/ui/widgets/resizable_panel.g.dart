// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resizable_panel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_DraggingX)
final _draggingXProvider = _DraggingXProvider._();

final class _DraggingXProvider extends $NotifierProvider<_DraggingX, bool> {
  _DraggingXProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_draggingXProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_draggingXHash();

  @$internal
  @override
  _DraggingX create() => _DraggingX();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$_draggingXHash() => r'3a82872ce3a8fc577ac90230de0414b1b4349cab';

abstract class _$DraggingX extends $Notifier<bool> {
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

@ProviderFor(_DraggingY)
final _draggingYProvider = _DraggingYProvider._();

final class _DraggingYProvider extends $NotifierProvider<_DraggingY, bool> {
  _DraggingYProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_draggingYProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_draggingYHash();

  @$internal
  @override
  _DraggingY create() => _DraggingY();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$_draggingYHash() => r'4a59996c5421eabea02e65f63acf9e73623e5ef2';

abstract class _$DraggingY extends $Notifier<bool> {
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_panel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VideoPanelNotifier)
final videoPanelProvider = VideoPanelNotifierProvider._();

final class VideoPanelNotifierProvider
    extends $NotifierProvider<VideoPanelNotifier, bool> {
  VideoPanelNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'videoPanelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$videoPanelNotifierHash();

  @$internal
  @override
  VideoPanelNotifier create() => VideoPanelNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$videoPanelNotifierHash() =>
    r'd772dcb666c0f38aecfb71604416165b9dcf8dc8';

abstract class _$VideoPanelNotifier extends $Notifier<bool> {
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

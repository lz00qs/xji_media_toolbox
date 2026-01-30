// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_resources_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MediaResourcesNotifier)
final mediaResourcesProvider = MediaResourcesNotifierProvider._();

final class MediaResourcesNotifierProvider
    extends $NotifierProvider<MediaResourcesNotifier, MediaResources> {
  MediaResourcesNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'mediaResourcesProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$mediaResourcesNotifierHash();

  @$internal
  @override
  MediaResourcesNotifier create() => MediaResourcesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaResources value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaResources>(value),
    );
  }
}

String _$mediaResourcesNotifierHash() =>
    r'f6c726319f75ed4825c1c1c4db46c9021ca52996';

abstract class _$MediaResourcesNotifier extends $Notifier<MediaResources> {
  MediaResources build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MediaResources, MediaResources>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<MediaResources, MediaResources>,
        MediaResources,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

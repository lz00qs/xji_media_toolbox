// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_resources_state.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MediaResourcesStateNotifier)
final mediaResourcesStateProvider = MediaResourcesStateNotifierProvider._();

final class MediaResourcesStateNotifierProvider extends $NotifierProvider<
    MediaResourcesStateNotifier, MediaResourcesState> {
  MediaResourcesStateNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'mediaResourcesStateProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$mediaResourcesStateNotifierHash();

  @$internal
  @override
  MediaResourcesStateNotifier create() => MediaResourcesStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaResourcesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaResourcesState>(value),
    );
  }
}

String _$mediaResourcesStateNotifierHash() =>
    r'12a3aaca5d10c6ddb038b2f4716ffd110e65c1f7';

abstract class _$MediaResourcesStateNotifier
    extends $Notifier<MediaResourcesState> {
  MediaResourcesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MediaResourcesState, MediaResourcesState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<MediaResourcesState, MediaResourcesState>,
        MediaResourcesState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_resource_rename_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_MediaResourceRenameDialogController)
final _mediaResourceRenameDialogControllerProvider =
    _MediaResourceRenameDialogControllerFamily._();

final class _MediaResourceRenameDialogControllerProvider
    extends $NotifierProvider<_MediaResourceRenameDialogController,
        _RenameDialogState> {
  _MediaResourceRenameDialogControllerProvider._(
      {required _MediaResourceRenameDialogControllerFamily super.from,
      required MediaResource super.argument})
      : super(
          retry: null,
          name: r'_mediaResourceRenameDialogControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() =>
      _$_mediaResourceRenameDialogControllerHash();

  @override
  String toString() {
    return r'_mediaResourceRenameDialogControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _MediaResourceRenameDialogController create() =>
      _MediaResourceRenameDialogController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_RenameDialogState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_RenameDialogState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _MediaResourceRenameDialogControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_mediaResourceRenameDialogControllerHash() =>
    r'c5adf5a9442b0a2ed0d52fb1533ead33ca8d9088';

final class _MediaResourceRenameDialogControllerFamily extends $Family
    with
        $ClassFamilyOverride<
            _MediaResourceRenameDialogController,
            _RenameDialogState,
            _RenameDialogState,
            _RenameDialogState,
            MediaResource> {
  _MediaResourceRenameDialogControllerFamily._()
      : super(
          retry: null,
          name: r'_mediaResourceRenameDialogControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _MediaResourceRenameDialogControllerProvider call(
    MediaResource mediaResource,
  ) =>
      _MediaResourceRenameDialogControllerProvider._(
          argument: mediaResource, from: this);

  @override
  String toString() => r'_mediaResourceRenameDialogControllerProvider';
}

abstract class _$MediaResourceRenameDialogController
    extends $Notifier<_RenameDialogState> {
  late final _$args = ref.$arg as MediaResource;
  MediaResource get mediaResource => _$args;

  _RenameDialogState build(
    MediaResource mediaResource,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<_RenameDialogState, _RenameDialogState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<_RenameDialogState, _RenameDialogState>,
        _RenameDialogState,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_resource_rename_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_MediaResourceRenameDialogNotifier)
final _mediaResourceRenameDialogProvider =
    _MediaResourceRenameDialogNotifierFamily._();

final class _MediaResourceRenameDialogNotifierProvider
    extends $NotifierProvider<_MediaResourceRenameDialogNotifier,
        _RenameDialogState> {
  _MediaResourceRenameDialogNotifierProvider._(
      {required _MediaResourceRenameDialogNotifierFamily super.from,
      required MediaResource super.argument})
      : super(
          retry: null,
          name: r'_mediaResourceRenameDialogProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() =>
      _$_mediaResourceRenameDialogNotifierHash();

  @override
  String toString() {
    return r'_mediaResourceRenameDialogProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _MediaResourceRenameDialogNotifier create() =>
      _MediaResourceRenameDialogNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_RenameDialogState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_RenameDialogState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _MediaResourceRenameDialogNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_mediaResourceRenameDialogNotifierHash() =>
    r'3fa320549886d3ceaf35c79e40ac7ef3f6945f4f';

final class _MediaResourceRenameDialogNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            _MediaResourceRenameDialogNotifier,
            _RenameDialogState,
            _RenameDialogState,
            _RenameDialogState,
            MediaResource> {
  _MediaResourceRenameDialogNotifierFamily._()
      : super(
          retry: null,
          name: r'_mediaResourceRenameDialogProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _MediaResourceRenameDialogNotifierProvider call(
    MediaResource mediaResource,
  ) =>
      _MediaResourceRenameDialogNotifierProvider._(
          argument: mediaResource, from: this);

  @override
  String toString() => r'_mediaResourceRenameDialogProvider';
}

abstract class _$MediaResourceRenameDialogNotifier
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

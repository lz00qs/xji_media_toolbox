// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_export_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_VideoExportDialogController)
final _videoExportDialogControllerProvider =
    _VideoExportDialogControllerProvider._();

final class _VideoExportDialogControllerProvider extends $NotifierProvider<
    _VideoExportDialogController, _VideoExportDialogState> {
  _VideoExportDialogControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_videoExportDialogControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_videoExportDialogControllerHash();

  @$internal
  @override
  _VideoExportDialogController create() => _VideoExportDialogController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_VideoExportDialogState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_VideoExportDialogState>(value),
    );
  }
}

String _$_videoExportDialogControllerHash() =>
    r'6c6339197cb204df2477353c6607bc5e7dd31a2a';

abstract class _$VideoExportDialogController
    extends $Notifier<_VideoExportDialogState> {
  _VideoExportDialogState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<_VideoExportDialogState, _VideoExportDialogState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<_VideoExportDialogState, _VideoExportDialogState>,
        _VideoExportDialogState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

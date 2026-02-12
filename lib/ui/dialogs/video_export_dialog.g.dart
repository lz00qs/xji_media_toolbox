// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_export_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_VideoExportDialogNotifier)
final _videoExportDialogProvider = _VideoExportDialogNotifierFamily._();

final class _VideoExportDialogNotifierProvider extends $NotifierProvider<
    _VideoExportDialogNotifier, _VideoExportDialogState> {
  _VideoExportDialogNotifierProvider._(
      {required _VideoExportDialogNotifierFamily super.from,
      required (
        Settings,
        String,
      )
          super.argument})
      : super(
          retry: null,
          name: r'_videoExportDialogProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_videoExportDialogNotifierHash();

  @override
  String toString() {
    return r'_videoExportDialogProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  _VideoExportDialogNotifier create() => _VideoExportDialogNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_VideoExportDialogState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_VideoExportDialogState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _VideoExportDialogNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_videoExportDialogNotifierHash() =>
    r'3d92fced1cc2af8aa3a37a3bd00cff101b6797be';

final class _VideoExportDialogNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            _VideoExportDialogNotifier,
            _VideoExportDialogState,
            _VideoExportDialogState,
            _VideoExportDialogState,
            (
              Settings,
              String,
            )> {
  _VideoExportDialogNotifierFamily._()
      : super(
          retry: null,
          name: r'_videoExportDialogProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _VideoExportDialogNotifierProvider call(
    Settings settings,
    String defaultName,
  ) =>
      _VideoExportDialogNotifierProvider._(argument: (
        settings,
        defaultName,
      ), from: this);

  @override
  String toString() => r'_videoExportDialogProvider';
}

abstract class _$VideoExportDialogNotifier
    extends $Notifier<_VideoExportDialogState> {
  late final _$args = ref.$arg as (
    Settings,
    String,
  );
  Settings get settings => _$args.$1;
  String get defaultName => _$args.$2;

  _VideoExportDialogState build(
    Settings settings,
    String defaultName,
  );
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
    element.handleCreate(
        ref,
        () => build(
              _$args.$1,
              _$args.$2,
            ));
  }
}

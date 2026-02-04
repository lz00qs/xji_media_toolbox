// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_EditTranscodePresetDialogNotifier)
final _editTranscodePresetDialogProvider =
    _EditTranscodePresetDialogNotifierFamily._();

final class _EditTranscodePresetDialogNotifierProvider
    extends $NotifierProvider<_EditTranscodePresetDialogNotifier,
        TranscodePreset> {
  _EditTranscodePresetDialogNotifierProvider._(
      {required _EditTranscodePresetDialogNotifierFamily super.from,
      required TranscodePreset super.argument})
      : super(
          retry: null,
          name: r'_editTranscodePresetDialogProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() =>
      _$_editTranscodePresetDialogNotifierHash();

  @override
  String toString() {
    return r'_editTranscodePresetDialogProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _EditTranscodePresetDialogNotifier create() =>
      _EditTranscodePresetDialogNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TranscodePreset value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TranscodePreset>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _EditTranscodePresetDialogNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_editTranscodePresetDialogNotifierHash() =>
    r'9899cd26bd76181c9f6de7428d3b0b0fc31d3281';

final class _EditTranscodePresetDialogNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            _EditTranscodePresetDialogNotifier,
            TranscodePreset,
            TranscodePreset,
            TranscodePreset,
            TranscodePreset> {
  _EditTranscodePresetDialogNotifierFamily._()
      : super(
          retry: null,
          name: r'_editTranscodePresetDialogProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _EditTranscodePresetDialogNotifierProvider call(
    TranscodePreset preset,
  ) =>
      _EditTranscodePresetDialogNotifierProvider._(
          argument: preset, from: this);

  @override
  String toString() => r'_editTranscodePresetDialogProvider';
}

abstract class _$EditTranscodePresetDialogNotifier
    extends $Notifier<TranscodePreset> {
  late final _$args = ref.$arg as TranscodePreset;
  TranscodePreset get preset => _$args;

  TranscodePreset build(
    TranscodePreset preset,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TranscodePreset, TranscodePreset>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TranscodePreset, TranscodePreset>,
        TranscodePreset,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

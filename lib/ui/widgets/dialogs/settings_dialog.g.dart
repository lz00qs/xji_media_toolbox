// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_EditLutDialogNotifier)
final _editLutDialogProvider = _EditLutDialogNotifierFamily._();

final class _EditLutDialogNotifierProvider
    extends $NotifierProvider<_EditLutDialogNotifier, Lut> {
  _EditLutDialogNotifierProvider._(
      {required _EditLutDialogNotifierFamily super.from,
      required Lut super.argument})
      : super(
          retry: null,
          name: r'_editLutDialogProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_editLutDialogNotifierHash();

  @override
  String toString() {
    return r'_editLutDialogProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _EditLutDialogNotifier create() => _EditLutDialogNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Lut value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Lut>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _EditLutDialogNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_editLutDialogNotifierHash() =>
    r'e37dcfd98a1e2136ff6797a93361c3e9c6252f22';

final class _EditLutDialogNotifierFamily extends $Family
    with $ClassFamilyOverride<_EditLutDialogNotifier, Lut, Lut, Lut, Lut> {
  _EditLutDialogNotifierFamily._()
      : super(
          retry: null,
          name: r'_editLutDialogProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _EditLutDialogNotifierProvider call(
    Lut lut,
  ) =>
      _EditLutDialogNotifierProvider._(argument: lut, from: this);

  @override
  String toString() => r'_editLutDialogProvider';
}

abstract class _$EditLutDialogNotifier extends $Notifier<Lut> {
  late final _$args = ref.$arg as Lut;
  Lut get lut => _$args;

  Lut build(
    Lut lut,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Lut, Lut>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<Lut, Lut>, Lut, Object?, Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

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
    r'7e6279ebac1e19ea304f21296dca0479ab9aaa6b';

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

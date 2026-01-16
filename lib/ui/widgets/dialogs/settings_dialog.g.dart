// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_SettingsDialogController)
final _settingsDialogControllerProvider = _SettingsDialogControllerProvider._();

final class _SettingsDialogControllerProvider extends $NotifierProvider<
    _SettingsDialogController, _SettingsDialogUiState> {
  _SettingsDialogControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_settingsDialogControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_settingsDialogControllerHash();

  @$internal
  @override
  _SettingsDialogController create() => _SettingsDialogController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_SettingsDialogUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_SettingsDialogUiState>(value),
    );
  }
}

String _$_settingsDialogControllerHash() =>
    r'ee8b4539828c8022eb9b801563e11dcf31afbcae';

abstract class _$SettingsDialogController
    extends $Notifier<_SettingsDialogUiState> {
  _SettingsDialogUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<_SettingsDialogUiState, _SettingsDialogUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<_SettingsDialogUiState, _SettingsDialogUiState>,
        _SettingsDialogUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(_EditLutController)
final _editLutControllerProvider = _EditLutControllerFamily._();

final class _EditLutControllerProvider
    extends $NotifierProvider<_EditLutController, _EditLutState> {
  _EditLutControllerProvider._(
      {required _EditLutControllerFamily super.from,
      required Lut? super.argument})
      : super(
          retry: null,
          name: r'_editLutControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_editLutControllerHash();

  @override
  String toString() {
    return r'_editLutControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _EditLutController create() => _EditLutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_EditLutState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_EditLutState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _EditLutControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_editLutControllerHash() =>
    r'14ded9550d529eeca57ef1c0d1f491ee0ded0f97';

final class _EditLutControllerFamily extends $Family
    with
        $ClassFamilyOverride<_EditLutController, _EditLutState, _EditLutState,
            _EditLutState, Lut?> {
  _EditLutControllerFamily._()
      : super(
          retry: null,
          name: r'_editLutControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _EditLutControllerProvider call(
    Lut? lut,
  ) =>
      _EditLutControllerProvider._(argument: lut, from: this);

  @override
  String toString() => r'_editLutControllerProvider';
}

abstract class _$EditLutController extends $Notifier<_EditLutState> {
  late final _$args = ref.$arg as Lut?;
  Lut? get lut => _$args;

  _EditLutState build(
    Lut? lut,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<_EditLutState, _EditLutState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<_EditLutState, _EditLutState>,
        _EditLutState,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

@ProviderFor(_EditTranscodePresetController)
final _editTranscodePresetControllerProvider =
    _EditTranscodePresetControllerFamily._();

final class _EditTranscodePresetControllerProvider extends $NotifierProvider<
    _EditTranscodePresetController, _EditTranscodePresetState> {
  _EditTranscodePresetControllerProvider._(
      {required _EditTranscodePresetControllerFamily super.from,
      required TranscodePreset? super.argument})
      : super(
          retry: null,
          name: r'_editTranscodePresetControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_editTranscodePresetControllerHash();

  @override
  String toString() {
    return r'_editTranscodePresetControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _EditTranscodePresetController create() => _EditTranscodePresetController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_EditTranscodePresetState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_EditTranscodePresetState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _EditTranscodePresetControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_editTranscodePresetControllerHash() =>
    r'6ce593e3dbace22d8712c517e7d58aff197bcd7b';

final class _EditTranscodePresetControllerFamily extends $Family
    with
        $ClassFamilyOverride<
            _EditTranscodePresetController,
            _EditTranscodePresetState,
            _EditTranscodePresetState,
            _EditTranscodePresetState,
            TranscodePreset?> {
  _EditTranscodePresetControllerFamily._()
      : super(
          retry: null,
          name: r'_editTranscodePresetControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _EditTranscodePresetControllerProvider call(
    TranscodePreset? preset,
  ) =>
      _EditTranscodePresetControllerProvider._(argument: preset, from: this);

  @override
  String toString() => r'_editTranscodePresetControllerProvider';
}

abstract class _$EditTranscodePresetController
    extends $Notifier<_EditTranscodePresetState> {
  late final _$args = ref.$arg as TranscodePreset?;
  TranscodePreset? get preset => _$args;

  _EditTranscodePresetState build(
    TranscodePreset? preset,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<_EditTranscodePresetState, _EditTranscodePresetState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<_EditTranscodePresetState, _EditTranscodePresetState>,
        _EditTranscodePresetState,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsNotifier)
final settingsProvider = SettingsNotifierProvider._();

final class SettingsNotifierProvider
    extends $AsyncNotifierProvider<SettingsNotifier, Settings> {
  SettingsNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'settingsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$settingsNotifierHash();

  @$internal
  @override
  SettingsNotifier create() => SettingsNotifier();
}

String _$settingsNotifierHash() => r'3aa56d9d2b754acd00dd69d2ba2191e17ae49acd';

abstract class _$SettingsNotifier extends $AsyncNotifier<Settings> {
  FutureOr<Settings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Settings>, Settings>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Settings>, Settings>,
        AsyncValue<Settings>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

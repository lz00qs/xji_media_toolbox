// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_panel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VideoPanelNotifier)
final videoPanelProvider = VideoPanelNotifierFamily._();

final class VideoPanelNotifierProvider
    extends $NotifierProvider<VideoPanelNotifier, bool> {
  VideoPanelNotifierProvider._({
    required VideoPanelNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'videoPanelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$videoPanelNotifierHash();

  @override
  String toString() {
    return r'videoPanelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  VideoPanelNotifier create() => VideoPanelNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VideoPanelNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$videoPanelNotifierHash() =>
    r'e0d19e7c4a538a382191b33b6ab57447ba4f3133';

final class VideoPanelNotifierFamily extends $Family
    with $ClassFamilyOverride<VideoPanelNotifier, bool, bool, bool, String> {
  VideoPanelNotifierFamily._()
    : super(
        retry: null,
        name: r'videoPanelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VideoPanelNotifierProvider call(String videoPath) =>
      VideoPanelNotifierProvider._(argument: videoPath, from: this);

  @override
  String toString() => r'videoPanelProvider';
}

abstract class _$VideoPanelNotifier extends $Notifier<bool> {
  late final _$args = ref.$arg as String;
  String get videoPath => _$args;

  bool build(String videoPath);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

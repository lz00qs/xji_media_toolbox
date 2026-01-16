// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_trimmer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_VideoTrimmerController)
final _videoTrimmerControllerProvider = _VideoTrimmerControllerFamily._();

final class _VideoTrimmerControllerProvider
    extends $NotifierProvider<_VideoTrimmerController, _VideoTrimmerState> {
  _VideoTrimmerControllerProvider._(
      {required _VideoTrimmerControllerFamily super.from,
      required NormalVideoResource super.argument})
      : super(
          retry: null,
          name: r'_videoTrimmerControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_videoTrimmerControllerHash();

  @override
  String toString() {
    return r'_videoTrimmerControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _VideoTrimmerController create() => _VideoTrimmerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_VideoTrimmerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_VideoTrimmerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _VideoTrimmerControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_videoTrimmerControllerHash() =>
    r'99d7a75419fcb7752c5599aa140f006bd6a5944b';

final class _VideoTrimmerControllerFamily extends $Family
    with
        $ClassFamilyOverride<_VideoTrimmerController, _VideoTrimmerState,
            _VideoTrimmerState, _VideoTrimmerState, NormalVideoResource> {
  _VideoTrimmerControllerFamily._()
      : super(
          retry: null,
          name: r'_videoTrimmerControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _VideoTrimmerControllerProvider call(
    NormalVideoResource videoResource,
  ) =>
      _VideoTrimmerControllerProvider._(argument: videoResource, from: this);

  @override
  String toString() => r'_videoTrimmerControllerProvider';
}

abstract class _$VideoTrimmerController extends $Notifier<_VideoTrimmerState> {
  late final _$args = ref.$arg as NormalVideoResource;
  NormalVideoResource get videoResource => _$args;

  _VideoTrimmerState build(
    NormalVideoResource videoResource,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<_VideoTrimmerState, _VideoTrimmerState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<_VideoTrimmerState, _VideoTrimmerState>,
        _VideoTrimmerState,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

@ProviderFor(TrimmerSavedStart)
final trimmerSavedStartProvider = TrimmerSavedStartProvider._();

final class TrimmerSavedStartProvider
    extends $NotifierProvider<TrimmerSavedStart, Duration> {
  TrimmerSavedStartProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'trimmerSavedStartProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$trimmerSavedStartHash();

  @$internal
  @override
  TrimmerSavedStart create() => TrimmerSavedStart();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$trimmerSavedStartHash() => r'b8adf4def2bf0561534a50a8319e66be248d8949';

abstract class _$TrimmerSavedStart extends $Notifier<Duration> {
  Duration build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Duration, Duration>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Duration, Duration>, Duration, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(TrimmerSavedEnd)
final trimmerSavedEndProvider = TrimmerSavedEndProvider._();

final class TrimmerSavedEndProvider
    extends $NotifierProvider<TrimmerSavedEnd, Duration> {
  TrimmerSavedEndProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'trimmerSavedEndProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$trimmerSavedEndHash();

  @$internal
  @override
  TrimmerSavedEnd create() => TrimmerSavedEnd();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$trimmerSavedEndHash() => r'506a8526feb970c4314eb926d63a8f31f7e0b4b6';

abstract class _$TrimmerSavedEnd extends $Notifier<Duration> {
  Duration build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Duration, Duration>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Duration, Duration>, Duration, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

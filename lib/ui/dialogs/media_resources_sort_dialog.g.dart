// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_resources_sort_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_MediaResourcesSortDialogNotifier)
final _mediaResourcesSortDialogProvider =
    _MediaResourcesSortDialogNotifierFamily._();

final class _MediaResourcesSortDialogNotifierProvider
    extends $NotifierProvider<_MediaResourcesSortDialogNotifier, Sort> {
  _MediaResourcesSortDialogNotifierProvider._(
      {required _MediaResourcesSortDialogNotifierFamily super.from,
      required Sort super.argument})
      : super(
          retry: null,
          name: r'_mediaResourcesSortDialogProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() =>
      _$_mediaResourcesSortDialogNotifierHash();

  @override
  String toString() {
    return r'_mediaResourcesSortDialogProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _MediaResourcesSortDialogNotifier create() =>
      _MediaResourcesSortDialogNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Sort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Sort>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _MediaResourcesSortDialogNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_mediaResourcesSortDialogNotifierHash() =>
    r'841e7351a535dd5dfbaeb68d23914fa6b8cc8d6d';

final class _MediaResourcesSortDialogNotifierFamily extends $Family
    with
        $ClassFamilyOverride<_MediaResourcesSortDialogNotifier, Sort, Sort,
            Sort, Sort> {
  _MediaResourcesSortDialogNotifierFamily._()
      : super(
          retry: null,
          name: r'_mediaResourcesSortDialogProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _MediaResourcesSortDialogNotifierProvider call(
    Sort sort,
  ) =>
      _MediaResourcesSortDialogNotifierProvider._(argument: sort, from: this);

  @override
  String toString() => r'_mediaResourcesSortDialogProvider';
}

abstract class _$MediaResourcesSortDialogNotifier extends $Notifier<Sort> {
  late final _$args = ref.$arg as Sort;
  Sort get sort => _$args;

  Sort build(
    Sort sort,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Sort, Sort>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Sort, Sort>, Sort, Object?, Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

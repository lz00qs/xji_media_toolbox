// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_scheduler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskSchedulerNotifier)
final taskSchedulerProvider = TaskSchedulerNotifierProvider._();

final class TaskSchedulerNotifierProvider
    extends $NotifierProvider<TaskSchedulerNotifier, List<VideoTask>> {
  TaskSchedulerNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'taskSchedulerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$taskSchedulerNotifierHash();

  @$internal
  @override
  TaskSchedulerNotifier create() => TaskSchedulerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<VideoTask> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<VideoTask>>(value),
    );
  }
}

String _$taskSchedulerNotifierHash() =>
    r'1e2d2b9c2e7e17cb607cbd92c00a1470aa7eea23';

abstract class _$TaskSchedulerNotifier extends $Notifier<List<VideoTask>> {
  List<VideoTask> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<VideoTask>, List<VideoTask>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<VideoTask>, List<VideoTask>>,
        List<VideoTask>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

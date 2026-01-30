// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_manager_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskManager)
final taskManagerProvider = TaskManagerProvider._();

final class TaskManagerProvider
    extends $NotifierProvider<TaskManager, List<VideoTask>> {
  TaskManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'taskManagerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$taskManagerHash();

  @$internal
  @override
  TaskManager create() => TaskManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<VideoTask> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<VideoTask>>(value),
    );
  }
}

String _$taskManagerHash() => r'e6d58eab4b359cb48573759b79e7f7303063ed4a';

abstract class _$TaskManager extends $Notifier<List<VideoTask>> {
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

// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Tasks {
  List<VideoTask> get totalTasks;
  List<VideoTask> get waitingTasks;

  /// Create a copy of Tasks
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TasksCopyWith<Tasks> get copyWith =>
      _$TasksCopyWithImpl<Tasks>(this as Tasks, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Tasks &&
            const DeepCollectionEquality().equals(other.totalTasks, totalTasks) &&
            const DeepCollectionEquality()
                .equals(other.waitingTasks, waitingTasks));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(totalTasks),
      const DeepCollectionEquality().hash(waitingTasks));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Tasks(tasks: $totalTasks, waitingTasks: $waitingTasks)';
  }
}

/// @nodoc
abstract mixin class $TasksCopyWith<$Res> {
  factory $TasksCopyWith(Tasks value, $Res Function(Tasks) _then) =
      _$TasksCopyWithImpl;
  @useResult
  $Res call({List<VideoTask> tasks, List<VideoTask> waitingTasks});
}

/// @nodoc
class _$TasksCopyWithImpl<$Res> implements $TasksCopyWith<$Res> {
  _$TasksCopyWithImpl(this._self, this._then);

  final Tasks _self;
  final $Res Function(Tasks) _then;

  /// Create a copy of Tasks
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? waitingTasks = null,
  }) {
    return _then(Tasks(
      totalTasks: null == tasks
          ? _self.totalTasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<VideoTask>,
      waitingTasks: null == waitingTasks
          ? _self.waitingTasks
          : waitingTasks // ignore: cast_nullable_to_non_nullable
              as List<VideoTask>,
    ));
  }
}

// dart format on

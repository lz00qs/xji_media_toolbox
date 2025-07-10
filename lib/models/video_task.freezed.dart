// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoTask {
  String get name;
  VideoTaskStatus get status;
  VideoTaskType get type;
  List<String> get ffmpegArgs;
  Duration get duration;
  double get progress;
  File get outputFile;
  List<File> get tempFiles;
  File? get logFile;
  Duration get eta;
  Process? get process;

  /// Create a copy of VideoTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoTaskCopyWith<VideoTask> get copyWith =>
      _$VideoTaskCopyWithImpl<VideoTask>(this as VideoTask, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoTask &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.ffmpegArgs, ffmpegArgs) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.outputFile, outputFile) ||
                other.outputFile == outputFile) &&
            const DeepCollectionEquality().equals(other.tempFiles, tempFiles) &&
            (identical(other.logFile, logFile) || other.logFile == logFile) &&
            (identical(other.eta, eta) || other.eta == eta) &&
            (identical(other.process, process) || other.process == process));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      status,
      type,
      const DeepCollectionEquality().hash(ffmpegArgs),
      duration,
      progress,
      outputFile,
      const DeepCollectionEquality().hash(tempFiles),
      logFile,
      eta,
      process);

  @override
  String toString() {
    return 'VideoTask(name: $name, status: $status, type: $type, ffmpegArgs: $ffmpegArgs, duration: $duration, progress: $progress, outputFile: $outputFile, tempFiles: $tempFiles, logFile: $logFile, eta: $eta, process: $process)';
  }
}

/// @nodoc
abstract mixin class $VideoTaskCopyWith<$Res> {
  factory $VideoTaskCopyWith(VideoTask value, $Res Function(VideoTask) _then) =
      _$VideoTaskCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      VideoTaskStatus status,
      VideoTaskType type,
      List<String> ffmpegArgs,
      Duration duration,
      double progress,
      File outputFile,
      List<File> tempFiles,
      Duration eta,
      File? logFile,
      Process? process});
}

/// @nodoc
class _$VideoTaskCopyWithImpl<$Res> implements $VideoTaskCopyWith<$Res> {
  _$VideoTaskCopyWithImpl(this._self, this._then);

  final VideoTask _self;
  final $Res Function(VideoTask) _then;

  /// Create a copy of VideoTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? status = null,
    Object? type = null,
    Object? ffmpegArgs = null,
    Object? duration = null,
    Object? progress = null,
    Object? outputFile = null,
    Object? tempFiles = null,
    Object? eta = null,
    Object? logFile = freezed,
    Object? process = freezed,
  }) {
    return _then(VideoTask(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as VideoTaskStatus,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as VideoTaskType,
      ffmpegArgs: null == ffmpegArgs
          ? _self.ffmpegArgs
          : ffmpegArgs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      outputFile: null == outputFile
          ? _self.outputFile
          : outputFile // ignore: cast_nullable_to_non_nullable
              as File,
      tempFiles: null == tempFiles
          ? _self.tempFiles
          : tempFiles // ignore: cast_nullable_to_non_nullable
              as List<File>,
      eta: null == eta
          ? _self.eta
          : eta // ignore: cast_nullable_to_non_nullable
              as Duration,
      logFile: freezed == logFile
          ? _self.logFile
          : logFile // ignore: cast_nullable_to_non_nullable
              as File?,
      process: freezed == process
          ? _self.process
          : process // ignore: cast_nullable_to_non_nullable
              as Process?,
    ));
  }
}

/// Adds pattern-matching-related methods to [VideoTask].
extension VideoTaskPatterns on VideoTask {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }
}

// dart format on

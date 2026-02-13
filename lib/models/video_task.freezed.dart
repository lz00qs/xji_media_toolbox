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
  String get id;
  String get name;
  Duration get duration;
  VideoTaskType get type;
  VideoTaskStatus get status;
  double get progress;
  Duration get eta;
  List<String> get ffmpegArgs;
  String get outputPath;
  List<String> get tempFilePaths;
  String get logPath;

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
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.eta, eta) || other.eta == eta) &&
            const DeepCollectionEquality()
                .equals(other.ffmpegArgs, ffmpegArgs) &&
            (identical(other.outputPath, outputPath) ||
                other.outputPath == outputPath) &&
            const DeepCollectionEquality()
                .equals(other.tempFilePaths, tempFilePaths) &&
            (identical(other.logPath, logPath) || other.logPath == logPath));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      duration,
      type,
      status,
      progress,
      eta,
      const DeepCollectionEquality().hash(ffmpegArgs),
      outputPath,
      const DeepCollectionEquality().hash(tempFilePaths),
      logPath);

  @override
  String toString() {
    return 'VideoTask(id: $id, name: $name, duration: $duration, type: $type, status: $status, progress: $progress, eta: $eta, ffmpegArgs: $ffmpegArgs, outputPath: $outputPath, tempFilePaths: $tempFilePaths, logPath: $logPath)';
  }
}

/// @nodoc
abstract mixin class $VideoTaskCopyWith<$Res> {
  factory $VideoTaskCopyWith(VideoTask value, $Res Function(VideoTask) _then) =
      _$VideoTaskCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      Duration duration,
      VideoTaskType type,
      VideoTaskStatus status,
      double progress,
      Duration eta,
      List<String> ffmpegArgs,
      String outputPath,
      List<String> tempFilePaths,
      String logPath});
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
    Object? id = null,
    Object? name = null,
    Object? duration = null,
    Object? type = null,
    Object? status = null,
    Object? progress = null,
    Object? eta = null,
    Object? ffmpegArgs = null,
    Object? outputPath = null,
    Object? tempFilePaths = null,
    Object? logPath = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as VideoTaskType,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as VideoTaskStatus,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      eta: null == eta
          ? _self.eta
          : eta // ignore: cast_nullable_to_non_nullable
              as Duration,
      ffmpegArgs: null == ffmpegArgs
          ? _self.ffmpegArgs
          : ffmpegArgs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      outputPath: null == outputPath
          ? _self.outputPath
          : outputPath // ignore: cast_nullable_to_non_nullable
              as String,
      tempFilePaths: null == tempFilePaths
          ? _self.tempFilePaths
          : tempFilePaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      logPath: null == logPath
          ? _self.logPath
          : logPath // ignore: cast_nullable_to_non_nullable
              as String,
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_VideoTask value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoTask() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_VideoTask value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoTask():
        return $default(_that);
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_VideoTask value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoTask() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            Duration duration,
            VideoTaskType type,
            VideoTaskStatus status,
            double progress,
            Duration eta,
            List<String> ffmpegArgs,
            String outputPath,
            List<String> tempFilePaths,
            String logPath)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoTask() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.duration,
            _that.type,
            _that.status,
            _that.progress,
            _that.eta,
            _that.ffmpegArgs,
            _that.outputPath,
            _that.tempFilePaths,
            _that.logPath);
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
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            Duration duration,
            VideoTaskType type,
            VideoTaskStatus status,
            double progress,
            Duration eta,
            List<String> ffmpegArgs,
            String outputPath,
            List<String> tempFilePaths,
            String logPath)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoTask():
        return $default(
            _that.id,
            _that.name,
            _that.duration,
            _that.type,
            _that.status,
            _that.progress,
            _that.eta,
            _that.ffmpegArgs,
            _that.outputPath,
            _that.tempFilePaths,
            _that.logPath);
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String name,
            Duration duration,
            VideoTaskType type,
            VideoTaskStatus status,
            double progress,
            Duration eta,
            List<String> ffmpegArgs,
            String outputPath,
            List<String> tempFilePaths,
            String logPath)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoTask() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.duration,
            _that.type,
            _that.status,
            _that.progress,
            _that.eta,
            _that.ffmpegArgs,
            _that.outputPath,
            _that.tempFilePaths,
            _that.logPath);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _VideoTask implements VideoTask {
  const _VideoTask(
      {this.id = '',
      this.name = '',
      this.duration = Duration.zero,
      this.type = VideoTaskType.transcode,
      this.status = VideoTaskStatus.waiting,
      this.progress = 0.0,
      this.eta = Duration.zero,
      final List<String> ffmpegArgs = const [],
      this.outputPath = '',
      final List<String> tempFilePaths = const [],
      this.logPath = ''})
      : _ffmpegArgs = ffmpegArgs,
        _tempFilePaths = tempFilePaths;

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final Duration duration;
  @override
  @JsonKey()
  final VideoTaskType type;
  @override
  @JsonKey()
  final VideoTaskStatus status;
  @override
  @JsonKey()
  final double progress;
  @override
  @JsonKey()
  final Duration eta;
  final List<String> _ffmpegArgs;
  @override
  @JsonKey()
  List<String> get ffmpegArgs {
    if (_ffmpegArgs is EqualUnmodifiableListView) return _ffmpegArgs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ffmpegArgs);
  }

  @override
  @JsonKey()
  final String outputPath;
  final List<String> _tempFilePaths;
  @override
  @JsonKey()
  List<String> get tempFilePaths {
    if (_tempFilePaths is EqualUnmodifiableListView) return _tempFilePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tempFilePaths);
  }

  @override
  @JsonKey()
  final String logPath;

  /// Create a copy of VideoTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoTaskCopyWith<_VideoTask> get copyWith =>
      __$VideoTaskCopyWithImpl<_VideoTask>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoTask &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.eta, eta) || other.eta == eta) &&
            const DeepCollectionEquality()
                .equals(other._ffmpegArgs, _ffmpegArgs) &&
            (identical(other.outputPath, outputPath) ||
                other.outputPath == outputPath) &&
            const DeepCollectionEquality()
                .equals(other._tempFilePaths, _tempFilePaths) &&
            (identical(other.logPath, logPath) || other.logPath == logPath));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      duration,
      type,
      status,
      progress,
      eta,
      const DeepCollectionEquality().hash(_ffmpegArgs),
      outputPath,
      const DeepCollectionEquality().hash(_tempFilePaths),
      logPath);

  @override
  String toString() {
    return 'VideoTask(id: $id, name: $name, duration: $duration, type: $type, status: $status, progress: $progress, eta: $eta, ffmpegArgs: $ffmpegArgs, outputPath: $outputPath, tempFilePaths: $tempFilePaths, logPath: $logPath)';
  }
}

/// @nodoc
abstract mixin class _$VideoTaskCopyWith<$Res>
    implements $VideoTaskCopyWith<$Res> {
  factory _$VideoTaskCopyWith(
          _VideoTask value, $Res Function(_VideoTask) _then) =
      __$VideoTaskCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      Duration duration,
      VideoTaskType type,
      VideoTaskStatus status,
      double progress,
      Duration eta,
      List<String> ffmpegArgs,
      String outputPath,
      List<String> tempFilePaths,
      String logPath});
}

/// @nodoc
class __$VideoTaskCopyWithImpl<$Res> implements _$VideoTaskCopyWith<$Res> {
  __$VideoTaskCopyWithImpl(this._self, this._then);

  final _VideoTask _self;
  final $Res Function(_VideoTask) _then;

  /// Create a copy of VideoTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? duration = null,
    Object? type = null,
    Object? status = null,
    Object? progress = null,
    Object? eta = null,
    Object? ffmpegArgs = null,
    Object? outputPath = null,
    Object? tempFilePaths = null,
    Object? logPath = null,
  }) {
    return _then(_VideoTask(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as VideoTaskType,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as VideoTaskStatus,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      eta: null == eta
          ? _self.eta
          : eta // ignore: cast_nullable_to_non_nullable
              as Duration,
      ffmpegArgs: null == ffmpegArgs
          ? _self._ffmpegArgs
          : ffmpegArgs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      outputPath: null == outputPath
          ? _self.outputPath
          : outputPath // ignore: cast_nullable_to_non_nullable
              as String,
      tempFilePaths: null == tempFilePaths
          ? _self._tempFilePaths
          : tempFilePaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      logPath: null == logPath
          ? _self.logPath
          : logPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on

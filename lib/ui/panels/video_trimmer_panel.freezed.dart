// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_trimmer_panel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoTrimmerState implements DiagnosticableTreeMixin {
  bool get isPlaying;
  bool get isChanging;
  Duration get playPosition;
  Duration get cutStart;
  Duration get cutEnd;
  int get stepValueIndex;
  int get minimumStepIndex;
  int get lastStepValueIndex;
  double get videoWidth;
  double get startPosition;
  double get endPosition;
  double get actualStartPosition;
  double get actualEndPosition;

  /// Create a copy of _VideoTrimmerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoTrimmerStateCopyWith<_VideoTrimmerState> get copyWith =>
      __$VideoTrimmerStateCopyWithImpl<_VideoTrimmerState>(
          this as _VideoTrimmerState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', '_VideoTrimmerState'))
      ..add(DiagnosticsProperty('isPlaying', isPlaying))
      ..add(DiagnosticsProperty('isChanging', isChanging))
      ..add(DiagnosticsProperty('playPosition', playPosition))
      ..add(DiagnosticsProperty('cutStart', cutStart))
      ..add(DiagnosticsProperty('cutEnd', cutEnd))
      ..add(DiagnosticsProperty('stepValueIndex', stepValueIndex))
      ..add(DiagnosticsProperty('minimumStepIndex', minimumStepIndex))
      ..add(DiagnosticsProperty('lastStepValueIndex', lastStepValueIndex))
      ..add(DiagnosticsProperty('videoWidth', videoWidth))
      ..add(DiagnosticsProperty('startPosition', startPosition))
      ..add(DiagnosticsProperty('endPosition', endPosition))
      ..add(DiagnosticsProperty('actualStartPosition', actualStartPosition))
      ..add(DiagnosticsProperty('actualEndPosition', actualEndPosition));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoTrimmerState &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.isChanging, isChanging) ||
                other.isChanging == isChanging) &&
            (identical(other.playPosition, playPosition) ||
                other.playPosition == playPosition) &&
            (identical(other.cutStart, cutStart) ||
                other.cutStart == cutStart) &&
            (identical(other.cutEnd, cutEnd) || other.cutEnd == cutEnd) &&
            (identical(other.stepValueIndex, stepValueIndex) ||
                other.stepValueIndex == stepValueIndex) &&
            (identical(other.minimumStepIndex, minimumStepIndex) ||
                other.minimumStepIndex == minimumStepIndex) &&
            (identical(other.lastStepValueIndex, lastStepValueIndex) ||
                other.lastStepValueIndex == lastStepValueIndex) &&
            (identical(other.videoWidth, videoWidth) ||
                other.videoWidth == videoWidth) &&
            (identical(other.startPosition, startPosition) ||
                other.startPosition == startPosition) &&
            (identical(other.endPosition, endPosition) ||
                other.endPosition == endPosition) &&
            (identical(other.actualStartPosition, actualStartPosition) ||
                other.actualStartPosition == actualStartPosition) &&
            (identical(other.actualEndPosition, actualEndPosition) ||
                other.actualEndPosition == actualEndPosition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isPlaying,
      isChanging,
      playPosition,
      cutStart,
      cutEnd,
      stepValueIndex,
      minimumStepIndex,
      lastStepValueIndex,
      videoWidth,
      startPosition,
      endPosition,
      actualStartPosition,
      actualEndPosition);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_VideoTrimmerState(isPlaying: $isPlaying, isChanging: $isChanging, playPosition: $playPosition, cutStart: $cutStart, cutEnd: $cutEnd, stepValueIndex: $stepValueIndex, minimumStepIndex: $minimumStepIndex, lastStepValueIndex: $lastStepValueIndex, videoWidth: $videoWidth, startPosition: $startPosition, endPosition: $endPosition, actualStartPosition: $actualStartPosition, actualEndPosition: $actualEndPosition)';
  }
}

/// @nodoc
abstract mixin class _$VideoTrimmerStateCopyWith<$Res> {
  factory _$VideoTrimmerStateCopyWith(
          _VideoTrimmerState value, $Res Function(_VideoTrimmerState) _then) =
      __$VideoTrimmerStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isPlaying,
      bool isChanging,
      Duration playPosition,
      Duration cutStart,
      Duration cutEnd,
      int stepValueIndex,
      int minimumStepIndex,
      int lastStepValueIndex,
      double videoWidth,
      double startPosition,
      double endPosition,
      double actualStartPosition,
      double actualEndPosition});
}

/// @nodoc
class __$VideoTrimmerStateCopyWithImpl<$Res>
    implements _$VideoTrimmerStateCopyWith<$Res> {
  __$VideoTrimmerStateCopyWithImpl(this._self, this._then);

  final _VideoTrimmerState _self;
  final $Res Function(_VideoTrimmerState) _then;

  /// Create a copy of _VideoTrimmerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPlaying = null,
    Object? isChanging = null,
    Object? playPosition = null,
    Object? cutStart = null,
    Object? cutEnd = null,
    Object? stepValueIndex = null,
    Object? minimumStepIndex = null,
    Object? lastStepValueIndex = null,
    Object? videoWidth = null,
    Object? startPosition = null,
    Object? endPosition = null,
    Object? actualStartPosition = null,
    Object? actualEndPosition = null,
  }) {
    return _then(_self.copyWith(
      isPlaying: null == isPlaying
          ? _self.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      isChanging: null == isChanging
          ? _self.isChanging
          : isChanging // ignore: cast_nullable_to_non_nullable
              as bool,
      playPosition: null == playPosition
          ? _self.playPosition
          : playPosition // ignore: cast_nullable_to_non_nullable
              as Duration,
      cutStart: null == cutStart
          ? _self.cutStart
          : cutStart // ignore: cast_nullable_to_non_nullable
              as Duration,
      cutEnd: null == cutEnd
          ? _self.cutEnd
          : cutEnd // ignore: cast_nullable_to_non_nullable
              as Duration,
      stepValueIndex: null == stepValueIndex
          ? _self.stepValueIndex
          : stepValueIndex // ignore: cast_nullable_to_non_nullable
              as int,
      minimumStepIndex: null == minimumStepIndex
          ? _self.minimumStepIndex
          : minimumStepIndex // ignore: cast_nullable_to_non_nullable
              as int,
      lastStepValueIndex: null == lastStepValueIndex
          ? _self.lastStepValueIndex
          : lastStepValueIndex // ignore: cast_nullable_to_non_nullable
              as int,
      videoWidth: null == videoWidth
          ? _self.videoWidth
          : videoWidth // ignore: cast_nullable_to_non_nullable
              as double,
      startPosition: null == startPosition
          ? _self.startPosition
          : startPosition // ignore: cast_nullable_to_non_nullable
              as double,
      endPosition: null == endPosition
          ? _self.endPosition
          : endPosition // ignore: cast_nullable_to_non_nullable
              as double,
      actualStartPosition: null == actualStartPosition
          ? _self.actualStartPosition
          : actualStartPosition // ignore: cast_nullable_to_non_nullable
              as double,
      actualEndPosition: null == actualEndPosition
          ? _self.actualEndPosition
          : actualEndPosition // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [_VideoTrimmerState].
extension _VideoTrimmerStatePatterns on _VideoTrimmerState {
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
    TResult Function(__VideoTrimmerState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerState() when $default != null:
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
    TResult Function(__VideoTrimmerState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerState():
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
    TResult? Function(__VideoTrimmerState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerState() when $default != null:
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
            bool isPlaying,
            bool isChanging,
            Duration playPosition,
            Duration cutStart,
            Duration cutEnd,
            int stepValueIndex,
            int minimumStepIndex,
            int lastStepValueIndex,
            double videoWidth,
            double startPosition,
            double endPosition,
            double actualStartPosition,
            double actualEndPosition)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerState() when $default != null:
        return $default(
            _that.isPlaying,
            _that.isChanging,
            _that.playPosition,
            _that.cutStart,
            _that.cutEnd,
            _that.stepValueIndex,
            _that.minimumStepIndex,
            _that.lastStepValueIndex,
            _that.videoWidth,
            _that.startPosition,
            _that.endPosition,
            _that.actualStartPosition,
            _that.actualEndPosition);
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
            bool isPlaying,
            bool isChanging,
            Duration playPosition,
            Duration cutStart,
            Duration cutEnd,
            int stepValueIndex,
            int minimumStepIndex,
            int lastStepValueIndex,
            double videoWidth,
            double startPosition,
            double endPosition,
            double actualStartPosition,
            double actualEndPosition)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerState():
        return $default(
            _that.isPlaying,
            _that.isChanging,
            _that.playPosition,
            _that.cutStart,
            _that.cutEnd,
            _that.stepValueIndex,
            _that.minimumStepIndex,
            _that.lastStepValueIndex,
            _that.videoWidth,
            _that.startPosition,
            _that.endPosition,
            _that.actualStartPosition,
            _that.actualEndPosition);
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
            bool isPlaying,
            bool isChanging,
            Duration playPosition,
            Duration cutStart,
            Duration cutEnd,
            int stepValueIndex,
            int minimumStepIndex,
            int lastStepValueIndex,
            double videoWidth,
            double startPosition,
            double endPosition,
            double actualStartPosition,
            double actualEndPosition)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerState() when $default != null:
        return $default(
            _that.isPlaying,
            _that.isChanging,
            _that.playPosition,
            _that.cutStart,
            _that.cutEnd,
            _that.stepValueIndex,
            _that.minimumStepIndex,
            _that.lastStepValueIndex,
            _that.videoWidth,
            _that.startPosition,
            _that.endPosition,
            _that.actualStartPosition,
            _that.actualEndPosition);
      case _:
        return null;
    }
  }
}

/// @nodoc

class __VideoTrimmerState
    with DiagnosticableTreeMixin
    implements _VideoTrimmerState {
  const __VideoTrimmerState(
      {this.isPlaying = false,
      this.isChanging = false,
      this.playPosition = Duration.zero,
      this.cutStart = Duration.zero,
      this.cutEnd = Duration.zero,
      this.stepValueIndex = 0,
      this.minimumStepIndex = 0,
      this.lastStepValueIndex = 0,
      this.videoWidth = 0.0,
      this.startPosition = 0.0,
      this.endPosition = 0.0,
      this.actualStartPosition = 0.0,
      this.actualEndPosition = 0.0});

  @override
  @JsonKey()
  final bool isPlaying;
  @override
  @JsonKey()
  final bool isChanging;
  @override
  @JsonKey()
  final Duration playPosition;
  @override
  @JsonKey()
  final Duration cutStart;
  @override
  @JsonKey()
  final Duration cutEnd;
  @override
  @JsonKey()
  final int stepValueIndex;
  @override
  @JsonKey()
  final int minimumStepIndex;
  @override
  @JsonKey()
  final int lastStepValueIndex;
  @override
  @JsonKey()
  final double videoWidth;
  @override
  @JsonKey()
  final double startPosition;
  @override
  @JsonKey()
  final double endPosition;
  @override
  @JsonKey()
  final double actualStartPosition;
  @override
  @JsonKey()
  final double actualEndPosition;

  /// Create a copy of _VideoTrimmerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$_VideoTrimmerStateCopyWith<__VideoTrimmerState> get copyWith =>
      __$_VideoTrimmerStateCopyWithImpl<__VideoTrimmerState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', '_VideoTrimmerState'))
      ..add(DiagnosticsProperty('isPlaying', isPlaying))
      ..add(DiagnosticsProperty('isChanging', isChanging))
      ..add(DiagnosticsProperty('playPosition', playPosition))
      ..add(DiagnosticsProperty('cutStart', cutStart))
      ..add(DiagnosticsProperty('cutEnd', cutEnd))
      ..add(DiagnosticsProperty('stepValueIndex', stepValueIndex))
      ..add(DiagnosticsProperty('minimumStepIndex', minimumStepIndex))
      ..add(DiagnosticsProperty('lastStepValueIndex', lastStepValueIndex))
      ..add(DiagnosticsProperty('videoWidth', videoWidth))
      ..add(DiagnosticsProperty('startPosition', startPosition))
      ..add(DiagnosticsProperty('endPosition', endPosition))
      ..add(DiagnosticsProperty('actualStartPosition', actualStartPosition))
      ..add(DiagnosticsProperty('actualEndPosition', actualEndPosition));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is __VideoTrimmerState &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.isChanging, isChanging) ||
                other.isChanging == isChanging) &&
            (identical(other.playPosition, playPosition) ||
                other.playPosition == playPosition) &&
            (identical(other.cutStart, cutStart) ||
                other.cutStart == cutStart) &&
            (identical(other.cutEnd, cutEnd) || other.cutEnd == cutEnd) &&
            (identical(other.stepValueIndex, stepValueIndex) ||
                other.stepValueIndex == stepValueIndex) &&
            (identical(other.minimumStepIndex, minimumStepIndex) ||
                other.minimumStepIndex == minimumStepIndex) &&
            (identical(other.lastStepValueIndex, lastStepValueIndex) ||
                other.lastStepValueIndex == lastStepValueIndex) &&
            (identical(other.videoWidth, videoWidth) ||
                other.videoWidth == videoWidth) &&
            (identical(other.startPosition, startPosition) ||
                other.startPosition == startPosition) &&
            (identical(other.endPosition, endPosition) ||
                other.endPosition == endPosition) &&
            (identical(other.actualStartPosition, actualStartPosition) ||
                other.actualStartPosition == actualStartPosition) &&
            (identical(other.actualEndPosition, actualEndPosition) ||
                other.actualEndPosition == actualEndPosition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isPlaying,
      isChanging,
      playPosition,
      cutStart,
      cutEnd,
      stepValueIndex,
      minimumStepIndex,
      lastStepValueIndex,
      videoWidth,
      startPosition,
      endPosition,
      actualStartPosition,
      actualEndPosition);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_VideoTrimmerState(isPlaying: $isPlaying, isChanging: $isChanging, playPosition: $playPosition, cutStart: $cutStart, cutEnd: $cutEnd, stepValueIndex: $stepValueIndex, minimumStepIndex: $minimumStepIndex, lastStepValueIndex: $lastStepValueIndex, videoWidth: $videoWidth, startPosition: $startPosition, endPosition: $endPosition, actualStartPosition: $actualStartPosition, actualEndPosition: $actualEndPosition)';
  }
}

/// @nodoc
abstract mixin class _$_VideoTrimmerStateCopyWith<$Res>
    implements _$VideoTrimmerStateCopyWith<$Res> {
  factory _$_VideoTrimmerStateCopyWith(
          __VideoTrimmerState value, $Res Function(__VideoTrimmerState) _then) =
      __$_VideoTrimmerStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isPlaying,
      bool isChanging,
      Duration playPosition,
      Duration cutStart,
      Duration cutEnd,
      int stepValueIndex,
      int minimumStepIndex,
      int lastStepValueIndex,
      double videoWidth,
      double startPosition,
      double endPosition,
      double actualStartPosition,
      double actualEndPosition});
}

/// @nodoc
class __$_VideoTrimmerStateCopyWithImpl<$Res>
    implements _$_VideoTrimmerStateCopyWith<$Res> {
  __$_VideoTrimmerStateCopyWithImpl(this._self, this._then);

  final __VideoTrimmerState _self;
  final $Res Function(__VideoTrimmerState) _then;

  /// Create a copy of _VideoTrimmerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isPlaying = null,
    Object? isChanging = null,
    Object? playPosition = null,
    Object? cutStart = null,
    Object? cutEnd = null,
    Object? stepValueIndex = null,
    Object? minimumStepIndex = null,
    Object? lastStepValueIndex = null,
    Object? videoWidth = null,
    Object? startPosition = null,
    Object? endPosition = null,
    Object? actualStartPosition = null,
    Object? actualEndPosition = null,
  }) {
    return _then(__VideoTrimmerState(
      isPlaying: null == isPlaying
          ? _self.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      isChanging: null == isChanging
          ? _self.isChanging
          : isChanging // ignore: cast_nullable_to_non_nullable
              as bool,
      playPosition: null == playPosition
          ? _self.playPosition
          : playPosition // ignore: cast_nullable_to_non_nullable
              as Duration,
      cutStart: null == cutStart
          ? _self.cutStart
          : cutStart // ignore: cast_nullable_to_non_nullable
              as Duration,
      cutEnd: null == cutEnd
          ? _self.cutEnd
          : cutEnd // ignore: cast_nullable_to_non_nullable
              as Duration,
      stepValueIndex: null == stepValueIndex
          ? _self.stepValueIndex
          : stepValueIndex // ignore: cast_nullable_to_non_nullable
              as int,
      minimumStepIndex: null == minimumStepIndex
          ? _self.minimumStepIndex
          : minimumStepIndex // ignore: cast_nullable_to_non_nullable
              as int,
      lastStepValueIndex: null == lastStepValueIndex
          ? _self.lastStepValueIndex
          : lastStepValueIndex // ignore: cast_nullable_to_non_nullable
              as int,
      videoWidth: null == videoWidth
          ? _self.videoWidth
          : videoWidth // ignore: cast_nullable_to_non_nullable
              as double,
      startPosition: null == startPosition
          ? _self.startPosition
          : startPosition // ignore: cast_nullable_to_non_nullable
              as double,
      endPosition: null == endPosition
          ? _self.endPosition
          : endPosition // ignore: cast_nullable_to_non_nullable
              as double,
      actualStartPosition: null == actualStartPosition
          ? _self.actualStartPosition
          : actualStartPosition // ignore: cast_nullable_to_non_nullable
              as double,
      actualEndPosition: null == actualEndPosition
          ? _self.actualEndPosition
          : actualEndPosition // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$VideoCutState implements DiagnosticableTreeMixin {
  Duration get cutStart;
  Duration get cutEnd;

  /// Create a copy of VideoCutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoCutStateCopyWith<VideoCutState> get copyWith =>
      _$VideoCutStateCopyWithImpl<VideoCutState>(
          this as VideoCutState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'VideoCutState'))
      ..add(DiagnosticsProperty('cutStart', cutStart))
      ..add(DiagnosticsProperty('cutEnd', cutEnd));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoCutState &&
            (identical(other.cutStart, cutStart) ||
                other.cutStart == cutStart) &&
            (identical(other.cutEnd, cutEnd) || other.cutEnd == cutEnd));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cutStart, cutEnd);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoCutState(cutStart: $cutStart, cutEnd: $cutEnd)';
  }
}

/// @nodoc
abstract mixin class $VideoCutStateCopyWith<$Res> {
  factory $VideoCutStateCopyWith(
          VideoCutState value, $Res Function(VideoCutState) _then) =
      _$VideoCutStateCopyWithImpl;
  @useResult
  $Res call({Duration cutStart, Duration cutEnd});
}

/// @nodoc
class _$VideoCutStateCopyWithImpl<$Res>
    implements $VideoCutStateCopyWith<$Res> {
  _$VideoCutStateCopyWithImpl(this._self, this._then);

  final VideoCutState _self;
  final $Res Function(VideoCutState) _then;

  /// Create a copy of VideoCutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cutStart = null,
    Object? cutEnd = null,
  }) {
    return _then(_self.copyWith(
      cutStart: null == cutStart
          ? _self.cutStart
          : cutStart // ignore: cast_nullable_to_non_nullable
              as Duration,
      cutEnd: null == cutEnd
          ? _self.cutEnd
          : cutEnd // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// Adds pattern-matching-related methods to [VideoCutState].
extension VideoCutStatePatterns on VideoCutState {
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
    TResult Function(_VideoCutState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoCutState() when $default != null:
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
    TResult Function(_VideoCutState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoCutState():
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
    TResult? Function(_VideoCutState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoCutState() when $default != null:
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
    TResult Function(Duration cutStart, Duration cutEnd)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoCutState() when $default != null:
        return $default(_that.cutStart, _that.cutEnd);
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
    TResult Function(Duration cutStart, Duration cutEnd) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoCutState():
        return $default(_that.cutStart, _that.cutEnd);
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
    TResult? Function(Duration cutStart, Duration cutEnd)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoCutState() when $default != null:
        return $default(_that.cutStart, _that.cutEnd);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _VideoCutState with DiagnosticableTreeMixin implements VideoCutState {
  const _VideoCutState(
      {this.cutStart = Duration.zero, this.cutEnd = Duration.zero});

  @override
  @JsonKey()
  final Duration cutStart;
  @override
  @JsonKey()
  final Duration cutEnd;

  /// Create a copy of VideoCutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoCutStateCopyWith<_VideoCutState> get copyWith =>
      __$VideoCutStateCopyWithImpl<_VideoCutState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'VideoCutState'))
      ..add(DiagnosticsProperty('cutStart', cutStart))
      ..add(DiagnosticsProperty('cutEnd', cutEnd));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoCutState &&
            (identical(other.cutStart, cutStart) ||
                other.cutStart == cutStart) &&
            (identical(other.cutEnd, cutEnd) || other.cutEnd == cutEnd));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cutStart, cutEnd);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoCutState(cutStart: $cutStart, cutEnd: $cutEnd)';
  }
}

/// @nodoc
abstract mixin class _$VideoCutStateCopyWith<$Res>
    implements $VideoCutStateCopyWith<$Res> {
  factory _$VideoCutStateCopyWith(
          _VideoCutState value, $Res Function(_VideoCutState) _then) =
      __$VideoCutStateCopyWithImpl;
  @override
  @useResult
  $Res call({Duration cutStart, Duration cutEnd});
}

/// @nodoc
class __$VideoCutStateCopyWithImpl<$Res>
    implements _$VideoCutStateCopyWith<$Res> {
  __$VideoCutStateCopyWithImpl(this._self, this._then);

  final _VideoCutState _self;
  final $Res Function(_VideoCutState) _then;

  /// Create a copy of VideoCutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cutStart = null,
    Object? cutEnd = null,
  }) {
    return _then(_VideoCutState(
      cutStart: null == cutStart
          ? _self.cutStart
          : cutStart // ignore: cast_nullable_to_non_nullable
              as Duration,
      cutEnd: null == cutEnd
          ? _self.cutEnd
          : cutEnd // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc
mixin _$VideoTrimmerPanelState implements DiagnosticableTreeMixin {
  ChewieController? get chewieController;
  VideoPlayerController? get videoPlayerController;

  /// Create a copy of _VideoTrimmerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoTrimmerPanelStateCopyWith<_VideoTrimmerPanelState> get copyWith =>
      __$VideoTrimmerPanelStateCopyWithImpl<_VideoTrimmerPanelState>(
          this as _VideoTrimmerPanelState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', '_VideoTrimmerPanelState'))
      ..add(DiagnosticsProperty('chewieController', chewieController))
      ..add(
          DiagnosticsProperty('videoPlayerController', videoPlayerController));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoTrimmerPanelState &&
            (identical(other.chewieController, chewieController) ||
                other.chewieController == chewieController) &&
            (identical(other.videoPlayerController, videoPlayerController) ||
                other.videoPlayerController == videoPlayerController));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, chewieController, videoPlayerController);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_VideoTrimmerPanelState(chewieController: $chewieController, videoPlayerController: $videoPlayerController)';
  }
}

/// @nodoc
abstract mixin class _$VideoTrimmerPanelStateCopyWith<$Res> {
  factory _$VideoTrimmerPanelStateCopyWith(_VideoTrimmerPanelState value,
          $Res Function(_VideoTrimmerPanelState) _then) =
      __$VideoTrimmerPanelStateCopyWithImpl;
  @useResult
  $Res call(
      {ChewieController? chewieController,
      VideoPlayerController? videoPlayerController});
}

/// @nodoc
class __$VideoTrimmerPanelStateCopyWithImpl<$Res>
    implements _$VideoTrimmerPanelStateCopyWith<$Res> {
  __$VideoTrimmerPanelStateCopyWithImpl(this._self, this._then);

  final _VideoTrimmerPanelState _self;
  final $Res Function(_VideoTrimmerPanelState) _then;

  /// Create a copy of _VideoTrimmerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chewieController = freezed,
    Object? videoPlayerController = freezed,
  }) {
    return _then(_self.copyWith(
      chewieController: freezed == chewieController
          ? _self.chewieController
          : chewieController // ignore: cast_nullable_to_non_nullable
              as ChewieController?,
      videoPlayerController: freezed == videoPlayerController
          ? _self.videoPlayerController
          : videoPlayerController // ignore: cast_nullable_to_non_nullable
              as VideoPlayerController?,
    ));
  }
}

/// Adds pattern-matching-related methods to [_VideoTrimmerPanelState].
extension _VideoTrimmerPanelStatePatterns on _VideoTrimmerPanelState {
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
    TResult Function(__VideoTrimmerPanelState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerPanelState() when $default != null:
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
    TResult Function(__VideoTrimmerPanelState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerPanelState():
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
    TResult? Function(__VideoTrimmerPanelState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerPanelState() when $default != null:
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
    TResult Function(ChewieController? chewieController,
            VideoPlayerController? videoPlayerController)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerPanelState() when $default != null:
        return $default(_that.chewieController, _that.videoPlayerController);
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
    TResult Function(ChewieController? chewieController,
            VideoPlayerController? videoPlayerController)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerPanelState():
        return $default(_that.chewieController, _that.videoPlayerController);
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
    TResult? Function(ChewieController? chewieController,
            VideoPlayerController? videoPlayerController)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoTrimmerPanelState() when $default != null:
        return $default(_that.chewieController, _that.videoPlayerController);
      case _:
        return null;
    }
  }
}

/// @nodoc

class __VideoTrimmerPanelState
    with DiagnosticableTreeMixin
    implements _VideoTrimmerPanelState {
  const __VideoTrimmerPanelState(
      {this.chewieController = null, this.videoPlayerController = null});

  @override
  @JsonKey()
  final ChewieController? chewieController;
  @override
  @JsonKey()
  final VideoPlayerController? videoPlayerController;

  /// Create a copy of _VideoTrimmerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$_VideoTrimmerPanelStateCopyWith<__VideoTrimmerPanelState> get copyWith =>
      __$_VideoTrimmerPanelStateCopyWithImpl<__VideoTrimmerPanelState>(
          this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', '_VideoTrimmerPanelState'))
      ..add(DiagnosticsProperty('chewieController', chewieController))
      ..add(
          DiagnosticsProperty('videoPlayerController', videoPlayerController));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is __VideoTrimmerPanelState &&
            (identical(other.chewieController, chewieController) ||
                other.chewieController == chewieController) &&
            (identical(other.videoPlayerController, videoPlayerController) ||
                other.videoPlayerController == videoPlayerController));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, chewieController, videoPlayerController);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_VideoTrimmerPanelState(chewieController: $chewieController, videoPlayerController: $videoPlayerController)';
  }
}

/// @nodoc
abstract mixin class _$_VideoTrimmerPanelStateCopyWith<$Res>
    implements _$VideoTrimmerPanelStateCopyWith<$Res> {
  factory _$_VideoTrimmerPanelStateCopyWith(__VideoTrimmerPanelState value,
          $Res Function(__VideoTrimmerPanelState) _then) =
      __$_VideoTrimmerPanelStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ChewieController? chewieController,
      VideoPlayerController? videoPlayerController});
}

/// @nodoc
class __$_VideoTrimmerPanelStateCopyWithImpl<$Res>
    implements _$_VideoTrimmerPanelStateCopyWith<$Res> {
  __$_VideoTrimmerPanelStateCopyWithImpl(this._self, this._then);

  final __VideoTrimmerPanelState _self;
  final $Res Function(__VideoTrimmerPanelState) _then;

  /// Create a copy of _VideoTrimmerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? chewieController = freezed,
    Object? videoPlayerController = freezed,
  }) {
    return _then(__VideoTrimmerPanelState(
      chewieController: freezed == chewieController
          ? _self.chewieController
          : chewieController // ignore: cast_nullable_to_non_nullable
              as ChewieController?,
      videoPlayerController: freezed == videoPlayerController
          ? _self.videoPlayerController
          : videoPlayerController // ignore: cast_nullable_to_non_nullable
              as VideoPlayerController?,
    ));
  }
}

// dart format on

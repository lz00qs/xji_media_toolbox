// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resizable_panel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResizablePanelState {
  double get leftPanelWidth;
  double get topLeftHeight;
  bool get draggingX;
  bool get draggingY;

  /// Create a copy of ResizablePanelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResizablePanelStateCopyWith<ResizablePanelState> get copyWith =>
      _$ResizablePanelStateCopyWithImpl<ResizablePanelState>(
          this as ResizablePanelState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResizablePanelState &&
            (identical(other.leftPanelWidth, leftPanelWidth) ||
                other.leftPanelWidth == leftPanelWidth) &&
            (identical(other.topLeftHeight, topLeftHeight) ||
                other.topLeftHeight == topLeftHeight) &&
            (identical(other.draggingX, draggingX) ||
                other.draggingX == draggingX) &&
            (identical(other.draggingY, draggingY) ||
                other.draggingY == draggingY));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, leftPanelWidth, topLeftHeight, draggingX, draggingY);

  @override
  String toString() {
    return 'ResizablePanelState(leftPanelWidth: $leftPanelWidth, topLeftHeight: $topLeftHeight, draggingX: $draggingX, draggingY: $draggingY)';
  }
}

/// @nodoc
abstract mixin class $ResizablePanelStateCopyWith<$Res> {
  factory $ResizablePanelStateCopyWith(
          ResizablePanelState value, $Res Function(ResizablePanelState) _then) =
      _$ResizablePanelStateCopyWithImpl;
  @useResult
  $Res call(
      {double leftPanelWidth,
      double topLeftHeight,
      bool draggingX,
      bool draggingY});
}

/// @nodoc
class _$ResizablePanelStateCopyWithImpl<$Res>
    implements $ResizablePanelStateCopyWith<$Res> {
  _$ResizablePanelStateCopyWithImpl(this._self, this._then);

  final ResizablePanelState _self;
  final $Res Function(ResizablePanelState) _then;

  /// Create a copy of ResizablePanelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leftPanelWidth = null,
    Object? topLeftHeight = null,
    Object? draggingX = null,
    Object? draggingY = null,
  }) {
    return _then(_self.copyWith(
      leftPanelWidth: null == leftPanelWidth
          ? _self.leftPanelWidth
          : leftPanelWidth // ignore: cast_nullable_to_non_nullable
              as double,
      topLeftHeight: null == topLeftHeight
          ? _self.topLeftHeight
          : topLeftHeight // ignore: cast_nullable_to_non_nullable
              as double,
      draggingX: null == draggingX
          ? _self.draggingX
          : draggingX // ignore: cast_nullable_to_non_nullable
              as bool,
      draggingY: null == draggingY
          ? _self.draggingY
          : draggingY // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ResizablePanelState].
extension ResizablePanelStatePatterns on ResizablePanelState {
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
    TResult Function(_ResizablePanelState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResizablePanelState() when $default != null:
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
    TResult Function(_ResizablePanelState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResizablePanelState():
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
    TResult? Function(_ResizablePanelState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResizablePanelState() when $default != null:
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
    TResult Function(double leftPanelWidth, double topLeftHeight,
            bool draggingX, bool draggingY)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResizablePanelState() when $default != null:
        return $default(_that.leftPanelWidth, _that.topLeftHeight,
            _that.draggingX, _that.draggingY);
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
    TResult Function(double leftPanelWidth, double topLeftHeight,
            bool draggingX, bool draggingY)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResizablePanelState():
        return $default(_that.leftPanelWidth, _that.topLeftHeight,
            _that.draggingX, _that.draggingY);
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
    TResult? Function(double leftPanelWidth, double topLeftHeight,
            bool draggingX, bool draggingY)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResizablePanelState() when $default != null:
        return $default(_that.leftPanelWidth, _that.topLeftHeight,
            _that.draggingX, _that.draggingY);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ResizablePanelState implements ResizablePanelState {
  const _ResizablePanelState(
      {required this.leftPanelWidth,
      required this.topLeftHeight,
      required this.draggingX,
      required this.draggingY});

  @override
  final double leftPanelWidth;
  @override
  final double topLeftHeight;
  @override
  final bool draggingX;
  @override
  final bool draggingY;

  /// Create a copy of ResizablePanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResizablePanelStateCopyWith<_ResizablePanelState> get copyWith =>
      __$ResizablePanelStateCopyWithImpl<_ResizablePanelState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResizablePanelState &&
            (identical(other.leftPanelWidth, leftPanelWidth) ||
                other.leftPanelWidth == leftPanelWidth) &&
            (identical(other.topLeftHeight, topLeftHeight) ||
                other.topLeftHeight == topLeftHeight) &&
            (identical(other.draggingX, draggingX) ||
                other.draggingX == draggingX) &&
            (identical(other.draggingY, draggingY) ||
                other.draggingY == draggingY));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, leftPanelWidth, topLeftHeight, draggingX, draggingY);

  @override
  String toString() {
    return 'ResizablePanelState(leftPanelWidth: $leftPanelWidth, topLeftHeight: $topLeftHeight, draggingX: $draggingX, draggingY: $draggingY)';
  }
}

/// @nodoc
abstract mixin class _$ResizablePanelStateCopyWith<$Res>
    implements $ResizablePanelStateCopyWith<$Res> {
  factory _$ResizablePanelStateCopyWith(_ResizablePanelState value,
          $Res Function(_ResizablePanelState) _then) =
      __$ResizablePanelStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double leftPanelWidth,
      double topLeftHeight,
      bool draggingX,
      bool draggingY});
}

/// @nodoc
class __$ResizablePanelStateCopyWithImpl<$Res>
    implements _$ResizablePanelStateCopyWith<$Res> {
  __$ResizablePanelStateCopyWithImpl(this._self, this._then);

  final _ResizablePanelState _self;
  final $Res Function(_ResizablePanelState) _then;

  /// Create a copy of ResizablePanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? leftPanelWidth = null,
    Object? topLeftHeight = null,
    Object? draggingX = null,
    Object? draggingY = null,
  }) {
    return _then(_ResizablePanelState(
      leftPanelWidth: null == leftPanelWidth
          ? _self.leftPanelWidth
          : leftPanelWidth // ignore: cast_nullable_to_non_nullable
              as double,
      topLeftHeight: null == topLeftHeight
          ? _self.topLeftHeight
          : topLeftHeight // ignore: cast_nullable_to_non_nullable
              as double,
      draggingX: null == draggingX
          ? _self.draggingX
          : draggingX // ignore: cast_nullable_to_non_nullable
              as bool,
      draggingY: null == draggingY
          ? _self.draggingY
          : draggingY // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on

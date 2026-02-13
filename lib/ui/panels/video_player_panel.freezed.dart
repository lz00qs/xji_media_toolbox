// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_player_panel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoPlayerPanelState {
  ChewieController? get chewieController;

  /// Create a copy of _VideoPlayerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoPlayerPanelStateCopyWith<_VideoPlayerPanelState> get copyWith =>
      __$VideoPlayerPanelStateCopyWithImpl<_VideoPlayerPanelState>(
          this as _VideoPlayerPanelState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoPlayerPanelState &&
            (identical(other.chewieController, chewieController) ||
                other.chewieController == chewieController));
  }

  @override
  int get hashCode => Object.hash(runtimeType, chewieController);

  @override
  String toString() {
    return '_VideoPlayerPanelState(chewieController: $chewieController)';
  }
}

/// @nodoc
abstract mixin class _$VideoPlayerPanelStateCopyWith<$Res> {
  factory _$VideoPlayerPanelStateCopyWith(_VideoPlayerPanelState value,
          $Res Function(_VideoPlayerPanelState) _then) =
      __$VideoPlayerPanelStateCopyWithImpl;
  @useResult
  $Res call({ChewieController? chewieController});
}

/// @nodoc
class __$VideoPlayerPanelStateCopyWithImpl<$Res>
    implements _$VideoPlayerPanelStateCopyWith<$Res> {
  __$VideoPlayerPanelStateCopyWithImpl(this._self, this._then);

  final _VideoPlayerPanelState _self;
  final $Res Function(_VideoPlayerPanelState) _then;

  /// Create a copy of _VideoPlayerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chewieController = freezed,
  }) {
    return _then(_self.copyWith(
      chewieController: freezed == chewieController
          ? _self.chewieController
          : chewieController // ignore: cast_nullable_to_non_nullable
              as ChewieController?,
    ));
  }
}

/// Adds pattern-matching-related methods to [_VideoPlayerPanelState].
extension _VideoPlayerPanelStatePatterns on _VideoPlayerPanelState {
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
    TResult Function(__VideoPlayerPanelState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __VideoPlayerPanelState() when $default != null:
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
    TResult Function(__VideoPlayerPanelState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoPlayerPanelState():
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
    TResult? Function(__VideoPlayerPanelState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoPlayerPanelState() when $default != null:
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
    TResult Function(ChewieController? chewieController)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __VideoPlayerPanelState() when $default != null:
        return $default(_that.chewieController);
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
    TResult Function(ChewieController? chewieController) $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoPlayerPanelState():
        return $default(_that.chewieController);
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
    TResult? Function(ChewieController? chewieController)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case __VideoPlayerPanelState() when $default != null:
        return $default(_that.chewieController);
      case _:
        return null;
    }
  }
}

/// @nodoc

class __VideoPlayerPanelState implements _VideoPlayerPanelState {
  const __VideoPlayerPanelState({this.chewieController = null});

  @override
  @JsonKey()
  final ChewieController? chewieController;

  /// Create a copy of _VideoPlayerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$_VideoPlayerPanelStateCopyWith<__VideoPlayerPanelState> get copyWith =>
      __$_VideoPlayerPanelStateCopyWithImpl<__VideoPlayerPanelState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is __VideoPlayerPanelState &&
            (identical(other.chewieController, chewieController) ||
                other.chewieController == chewieController));
  }

  @override
  int get hashCode => Object.hash(runtimeType, chewieController);

  @override
  String toString() {
    return '_VideoPlayerPanelState(chewieController: $chewieController)';
  }
}

/// @nodoc
abstract mixin class _$_VideoPlayerPanelStateCopyWith<$Res>
    implements _$VideoPlayerPanelStateCopyWith<$Res> {
  factory _$_VideoPlayerPanelStateCopyWith(__VideoPlayerPanelState value,
          $Res Function(__VideoPlayerPanelState) _then) =
      __$_VideoPlayerPanelStateCopyWithImpl;
  @override
  @useResult
  $Res call({ChewieController? chewieController});
}

/// @nodoc
class __$_VideoPlayerPanelStateCopyWithImpl<$Res>
    implements _$_VideoPlayerPanelStateCopyWith<$Res> {
  __$_VideoPlayerPanelStateCopyWithImpl(this._self, this._then);

  final __VideoPlayerPanelState _self;
  final $Res Function(__VideoPlayerPanelState) _then;

  /// Create a copy of _VideoPlayerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? chewieController = freezed,
  }) {
    return _then(__VideoPlayerPanelState(
      chewieController: freezed == chewieController
          ? _self.chewieController
          : chewieController // ignore: cast_nullable_to_non_nullable
              as ChewieController?,
    ));
  }
}

// dart format on

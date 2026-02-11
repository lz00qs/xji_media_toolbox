// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_resource_rename_dialog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RenameDialogState {
// ignore: unused_element_parameter
  bool get isNewNameValid; // ignore: unused_element_parameter
  String get errorText;

  /// Create a copy of _RenameDialogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RenameDialogStateCopyWith<_RenameDialogState> get copyWith =>
      __$RenameDialogStateCopyWithImpl<_RenameDialogState>(
          this as _RenameDialogState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RenameDialogState &&
            (identical(other.isNewNameValid, isNewNameValid) ||
                other.isNewNameValid == isNewNameValid) &&
            (identical(other.errorText, errorText) ||
                other.errorText == errorText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isNewNameValid, errorText);

  @override
  String toString() {
    return '_RenameDialogState(isNewNameValid: $isNewNameValid, errorText: $errorText)';
  }
}

/// @nodoc
abstract mixin class _$RenameDialogStateCopyWith<$Res> {
  factory _$RenameDialogStateCopyWith(
          _RenameDialogState value, $Res Function(_RenameDialogState) _then) =
      __$RenameDialogStateCopyWithImpl;
  @useResult
  $Res call({bool isNewNameValid, String errorText});
}

/// @nodoc
class __$RenameDialogStateCopyWithImpl<$Res>
    implements _$RenameDialogStateCopyWith<$Res> {
  __$RenameDialogStateCopyWithImpl(this._self, this._then);

  final _RenameDialogState _self;
  final $Res Function(_RenameDialogState) _then;

  /// Create a copy of _RenameDialogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isNewNameValid = null,
    Object? errorText = null,
  }) {
    return _then(_self.copyWith(
      isNewNameValid: null == isNewNameValid
          ? _self.isNewNameValid
          : isNewNameValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errorText: null == errorText
          ? _self.errorText
          : errorText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [_RenameDialogState].
extension _RenameDialogStatePatterns on _RenameDialogState {
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
    TResult Function(__RenameDialogState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __RenameDialogState() when $default != null:
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
    TResult Function(__RenameDialogState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case __RenameDialogState():
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
    TResult? Function(__RenameDialogState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case __RenameDialogState() when $default != null:
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
    TResult Function(bool isNewNameValid, String errorText)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __RenameDialogState() when $default != null:
        return $default(_that.isNewNameValid, _that.errorText);
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
    TResult Function(bool isNewNameValid, String errorText) $default,
  ) {
    final _that = this;
    switch (_that) {
      case __RenameDialogState():
        return $default(_that.isNewNameValid, _that.errorText);
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
    TResult? Function(bool isNewNameValid, String errorText)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case __RenameDialogState() when $default != null:
        return $default(_that.isNewNameValid, _that.errorText);
      case _:
        return null;
    }
  }
}

/// @nodoc

class __RenameDialogState implements _RenameDialogState {
  const __RenameDialogState(
      {this.isNewNameValid = false, this.errorText = _fileExistErrorText});

// ignore: unused_element_parameter
  @override
  @JsonKey()
  final bool isNewNameValid;
// ignore: unused_element_parameter
  @override
  @JsonKey()
  final String errorText;

  /// Create a copy of _RenameDialogState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$_RenameDialogStateCopyWith<__RenameDialogState> get copyWith =>
      __$_RenameDialogStateCopyWithImpl<__RenameDialogState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is __RenameDialogState &&
            (identical(other.isNewNameValid, isNewNameValid) ||
                other.isNewNameValid == isNewNameValid) &&
            (identical(other.errorText, errorText) ||
                other.errorText == errorText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isNewNameValid, errorText);

  @override
  String toString() {
    return '_RenameDialogState(isNewNameValid: $isNewNameValid, errorText: $errorText)';
  }
}

/// @nodoc
abstract mixin class _$_RenameDialogStateCopyWith<$Res>
    implements _$RenameDialogStateCopyWith<$Res> {
  factory _$_RenameDialogStateCopyWith(
          __RenameDialogState value, $Res Function(__RenameDialogState) _then) =
      __$_RenameDialogStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool isNewNameValid, String errorText});
}

/// @nodoc
class __$_RenameDialogStateCopyWithImpl<$Res>
    implements _$_RenameDialogStateCopyWith<$Res> {
  __$_RenameDialogStateCopyWithImpl(this._self, this._then);

  final __RenameDialogState _self;
  final $Res Function(__RenameDialogState) _then;

  /// Create a copy of _RenameDialogState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isNewNameValid = null,
    Object? errorText = null,
  }) {
    return _then(__RenameDialogState(
      isNewNameValid: null == isNewNameValid
          ? _self.isNewNameValid
          : isNewNameValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errorText: null == errorText
          ? _self.errorText
          : errorText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on

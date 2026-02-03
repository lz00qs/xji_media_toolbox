// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lut.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lut {
  String get name;
  String get path;

  /// Create a copy of Lut
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LutCopyWith<Lut> get copyWith =>
      _$LutCopyWithImpl<Lut>(this as Lut, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Lut &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, path);

  @override
  String toString() {
    return 'Lut(name: $name, path: $path)';
  }
}

/// @nodoc
abstract mixin class $LutCopyWith<$Res> {
  factory $LutCopyWith(Lut value, $Res Function(Lut) _then) = _$LutCopyWithImpl;
  @useResult
  $Res call({String name, String path});
}

/// @nodoc
class _$LutCopyWithImpl<$Res> implements $LutCopyWith<$Res> {
  _$LutCopyWithImpl(this._self, this._then);

  final Lut _self;
  final $Res Function(Lut) _then;

  /// Create a copy of Lut
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [Lut].
extension LutPatterns on Lut {
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
    TResult Function(_Lut value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Lut() when $default != null:
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
    TResult Function(_Lut value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lut():
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
    TResult? Function(_Lut value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lut() when $default != null:
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
    TResult Function(String name, String path)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Lut() when $default != null:
        return $default(_that.name, _that.path);
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
    TResult Function(String name, String path) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lut():
        return $default(_that.name, _that.path);
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
    TResult? Function(String name, String path)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lut() when $default != null:
        return $default(_that.name, _that.path);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Lut implements Lut {
  const _Lut({this.name = 'Default', this.path = ''});

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String path;

  /// Create a copy of Lut
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LutCopyWith<_Lut> get copyWith =>
      __$LutCopyWithImpl<_Lut>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Lut &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, path);

  @override
  String toString() {
    return 'Lut(name: $name, path: $path)';
  }
}

/// @nodoc
abstract mixin class _$LutCopyWith<$Res> implements $LutCopyWith<$Res> {
  factory _$LutCopyWith(_Lut value, $Res Function(_Lut) _then) =
      __$LutCopyWithImpl;
  @override
  @useResult
  $Res call({String name, String path});
}

/// @nodoc
class __$LutCopyWithImpl<$Res> implements _$LutCopyWith<$Res> {
  __$LutCopyWithImpl(this._self, this._then);

  final _Lut _self;
  final $Res Function(_Lut) _then;

  /// Create a copy of Lut
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? path = null,
  }) {
    return _then(_Lut(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on

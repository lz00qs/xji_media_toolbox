// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcode_preset.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TranscodePreset {
  int get id;
  String get name;
  bool get useInputResolution;
  bool get useHevc;
  int get width;
  int get height;
  int get crf;
  FFmpegPreset get ffmpegPreset;
  int get lutId;

  /// Create a copy of TranscodePreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TranscodePresetCopyWith<TranscodePreset> get copyWith =>
      _$TranscodePresetCopyWithImpl<TranscodePreset>(
          this as TranscodePreset, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TranscodePreset &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.useInputResolution, useInputResolution) ||
                other.useInputResolution == useInputResolution) &&
            (identical(other.useHevc, useHevc) || other.useHevc == useHevc) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.crf, crf) || other.crf == crf) &&
            (identical(other.ffmpegPreset, ffmpegPreset) ||
                other.ffmpegPreset == ffmpegPreset) &&
            (identical(other.lutId, lutId) || other.lutId == lutId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, useInputResolution,
      useHevc, width, height, crf, ffmpegPreset, lutId);

  @override
  String toString() {
    return 'TranscodePreset(id: $id, name: $name, useInputResolution: $useInputResolution, useHevc: $useHevc, width: $width, height: $height, crf: $crf, ffmpegPreset: $ffmpegPreset, lutId: $lutId)';
  }
}

/// @nodoc
abstract mixin class $TranscodePresetCopyWith<$Res> {
  factory $TranscodePresetCopyWith(
          TranscodePreset value, $Res Function(TranscodePreset) _then) =
      _$TranscodePresetCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String name,
      bool useInputResolution,
      bool useHevc,
      int width,
      int height,
      int crf,
      FFmpegPreset ffmpegPreset,
      int lutId});
}

/// @nodoc
class _$TranscodePresetCopyWithImpl<$Res>
    implements $TranscodePresetCopyWith<$Res> {
  _$TranscodePresetCopyWithImpl(this._self, this._then);

  final TranscodePreset _self;
  final $Res Function(TranscodePreset) _then;

  /// Create a copy of TranscodePreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? useInputResolution = null,
    Object? useHevc = null,
    Object? width = null,
    Object? height = null,
    Object? crf = null,
    Object? ffmpegPreset = null,
    Object? lutId = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      useInputResolution: null == useInputResolution
          ? _self.useInputResolution
          : useInputResolution // ignore: cast_nullable_to_non_nullable
              as bool,
      useHevc: null == useHevc
          ? _self.useHevc
          : useHevc // ignore: cast_nullable_to_non_nullable
              as bool,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      crf: null == crf
          ? _self.crf
          : crf // ignore: cast_nullable_to_non_nullable
              as int,
      ffmpegPreset: null == ffmpegPreset
          ? _self.ffmpegPreset
          : ffmpegPreset // ignore: cast_nullable_to_non_nullable
              as FFmpegPreset,
      lutId: null == lutId
          ? _self.lutId
          : lutId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [TranscodePreset].
extension TranscodePresetPatterns on TranscodePreset {
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
    TResult Function(_TranscodePreset value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TranscodePreset() when $default != null:
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
    TResult Function(_TranscodePreset value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TranscodePreset():
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
    TResult? Function(_TranscodePreset value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TranscodePreset() when $default != null:
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
            int id,
            String name,
            bool useInputResolution,
            bool useHevc,
            int width,
            int height,
            int crf,
            FFmpegPreset ffmpegPreset,
            int lutId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TranscodePreset() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.useInputResolution,
            _that.useHevc,
            _that.width,
            _that.height,
            _that.crf,
            _that.ffmpegPreset,
            _that.lutId);
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
            int id,
            String name,
            bool useInputResolution,
            bool useHevc,
            int width,
            int height,
            int crf,
            FFmpegPreset ffmpegPreset,
            int lutId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TranscodePreset():
        return $default(
            _that.id,
            _that.name,
            _that.useInputResolution,
            _that.useHevc,
            _that.width,
            _that.height,
            _that.crf,
            _that.ffmpegPreset,
            _that.lutId);
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
            int id,
            String name,
            bool useInputResolution,
            bool useHevc,
            int width,
            int height,
            int crf,
            FFmpegPreset ffmpegPreset,
            int lutId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TranscodePreset() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.useInputResolution,
            _that.useHevc,
            _that.width,
            _that.height,
            _that.crf,
            _that.ffmpegPreset,
            _that.lutId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TranscodePreset implements TranscodePreset {
  const _TranscodePreset(
      {this.id = 0,
      this.name = 'Custom',
      this.useInputResolution = true,
      this.useHevc = true,
      this.width = 3840,
      this.height = 2160,
      this.crf = 22,
      this.ffmpegPreset = FFmpegPreset.medium,
      this.lutId = 0});

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final bool useInputResolution;
  @override
  @JsonKey()
  final bool useHevc;
  @override
  @JsonKey()
  final int width;
  @override
  @JsonKey()
  final int height;
  @override
  @JsonKey()
  final int crf;
  @override
  @JsonKey()
  final FFmpegPreset ffmpegPreset;
  @override
  @JsonKey()
  final int lutId;

  /// Create a copy of TranscodePreset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TranscodePresetCopyWith<_TranscodePreset> get copyWith =>
      __$TranscodePresetCopyWithImpl<_TranscodePreset>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TranscodePreset &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.useInputResolution, useInputResolution) ||
                other.useInputResolution == useInputResolution) &&
            (identical(other.useHevc, useHevc) || other.useHevc == useHevc) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.crf, crf) || other.crf == crf) &&
            (identical(other.ffmpegPreset, ffmpegPreset) ||
                other.ffmpegPreset == ffmpegPreset) &&
            (identical(other.lutId, lutId) || other.lutId == lutId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, useInputResolution,
      useHevc, width, height, crf, ffmpegPreset, lutId);

  @override
  String toString() {
    return 'TranscodePreset(id: $id, name: $name, useInputResolution: $useInputResolution, useHevc: $useHevc, width: $width, height: $height, crf: $crf, ffmpegPreset: $ffmpegPreset, lutId: $lutId)';
  }
}

/// @nodoc
abstract mixin class _$TranscodePresetCopyWith<$Res>
    implements $TranscodePresetCopyWith<$Res> {
  factory _$TranscodePresetCopyWith(
          _TranscodePreset value, $Res Function(_TranscodePreset) _then) =
      __$TranscodePresetCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      bool useInputResolution,
      bool useHevc,
      int width,
      int height,
      int crf,
      FFmpegPreset ffmpegPreset,
      int lutId});
}

/// @nodoc
class __$TranscodePresetCopyWithImpl<$Res>
    implements _$TranscodePresetCopyWith<$Res> {
  __$TranscodePresetCopyWithImpl(this._self, this._then);

  final _TranscodePreset _self;
  final $Res Function(_TranscodePreset) _then;

  /// Create a copy of TranscodePreset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? useInputResolution = null,
    Object? useHevc = null,
    Object? width = null,
    Object? height = null,
    Object? crf = null,
    Object? ffmpegPreset = null,
    Object? lutId = null,
  }) {
    return _then(_TranscodePreset(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      useInputResolution: null == useInputResolution
          ? _self.useInputResolution
          : useInputResolution // ignore: cast_nullable_to_non_nullable
              as bool,
      useHevc: null == useHevc
          ? _self.useHevc
          : useHevc // ignore: cast_nullable_to_non_nullable
              as bool,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      crf: null == crf
          ? _self.crf
          : crf // ignore: cast_nullable_to_non_nullable
              as int,
      ffmpegPreset: null == ffmpegPreset
          ? _self.ffmpegPreset
          : ffmpegPreset // ignore: cast_nullable_to_non_nullable
              as FFmpegPreset,
      lutId: null == lutId
          ? _self.lutId
          : lutId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on

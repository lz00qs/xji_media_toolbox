// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Settings {
  List<TranscodePreset> get transcodingPresets;
  List<Lut> get luts;
  int get defaultTranscodePresetId;
  int get cpuThreads;
  String get appVersion;
  SortType get sortType;
  bool get sortAsc;
  bool get isDebugMode;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SettingsCopyWith<Settings> get copyWith =>
      _$SettingsCopyWithImpl<Settings>(this as Settings, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Settings &&
            const DeepCollectionEquality()
                .equals(other.transcodingPresets, transcodingPresets) &&
            const DeepCollectionEquality().equals(other.luts, luts) &&
            (identical(
                    other.defaultTranscodePresetId, defaultTranscodePresetId) ||
                other.defaultTranscodePresetId == defaultTranscodePresetId) &&
            (identical(other.cpuThreads, cpuThreads) ||
                other.cpuThreads == cpuThreads) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.sortType, sortType) ||
                other.sortType == sortType) &&
            (identical(other.sortAsc, sortAsc) || other.sortAsc == sortAsc) &&
            (identical(other.isDebugMode, isDebugMode) ||
                other.isDebugMode == isDebugMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(transcodingPresets),
      const DeepCollectionEquality().hash(luts),
      defaultTranscodePresetId,
      cpuThreads,
      appVersion,
      sortType,
      sortAsc,
      isDebugMode);

  @override
  String toString() {
    return 'Settings(transcodingPresets: $transcodingPresets, luts: $luts, defaultTranscodePresetId: $defaultTranscodePresetId, cpuThreads: $cpuThreads, appVersion: $appVersion, sortType: $sortType, sortAsc: $sortAsc, isDebugMode: $isDebugMode)';
  }
}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res> {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) =
      _$SettingsCopyWithImpl;
  @useResult
  $Res call(
      {List<TranscodePreset> transcodingPresets,
      List<Lut> luts,
      int defaultTranscodePresetId,
      int cpuThreads,
      String appVersion,
      SortType sortType,
      bool sortAsc,
      bool isDebugMode});
}

/// @nodoc
class _$SettingsCopyWithImpl<$Res> implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._self, this._then);

  final Settings _self;
  final $Res Function(Settings) _then;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transcodingPresets = null,
    Object? luts = null,
    Object? defaultTranscodePresetId = null,
    Object? cpuThreads = null,
    Object? appVersion = null,
    Object? sortType = null,
    Object? sortAsc = null,
    Object? isDebugMode = null,
  }) {
    return _then(_self.copyWith(
      transcodingPresets: null == transcodingPresets
          ? _self.transcodingPresets
          : transcodingPresets // ignore: cast_nullable_to_non_nullable
              as List<TranscodePreset>,
      luts: null == luts
          ? _self.luts
          : luts // ignore: cast_nullable_to_non_nullable
              as List<Lut>,
      defaultTranscodePresetId: null == defaultTranscodePresetId
          ? _self.defaultTranscodePresetId
          : defaultTranscodePresetId // ignore: cast_nullable_to_non_nullable
              as int,
      cpuThreads: null == cpuThreads
          ? _self.cpuThreads
          : cpuThreads // ignore: cast_nullable_to_non_nullable
              as int,
      appVersion: null == appVersion
          ? _self.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      sortType: null == sortType
          ? _self.sortType
          : sortType // ignore: cast_nullable_to_non_nullable
              as SortType,
      sortAsc: null == sortAsc
          ? _self.sortAsc
          : sortAsc // ignore: cast_nullable_to_non_nullable
              as bool,
      isDebugMode: null == isDebugMode
          ? _self.isDebugMode
          : isDebugMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [Settings].
extension SettingsPatterns on Settings {
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
    TResult Function(_Settings value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Settings() when $default != null:
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
    TResult Function(_Settings value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Settings():
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
    TResult? Function(_Settings value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Settings() when $default != null:
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
            List<TranscodePreset> transcodingPresets,
            List<Lut> luts,
            int defaultTranscodePresetId,
            int cpuThreads,
            String appVersion,
            SortType sortType,
            bool sortAsc,
            bool isDebugMode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Settings() when $default != null:
        return $default(
            _that.transcodingPresets,
            _that.luts,
            _that.defaultTranscodePresetId,
            _that.cpuThreads,
            _that.appVersion,
            _that.sortType,
            _that.sortAsc,
            _that.isDebugMode);
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
            List<TranscodePreset> transcodingPresets,
            List<Lut> luts,
            int defaultTranscodePresetId,
            int cpuThreads,
            String appVersion,
            SortType sortType,
            bool sortAsc,
            bool isDebugMode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Settings():
        return $default(
            _that.transcodingPresets,
            _that.luts,
            _that.defaultTranscodePresetId,
            _that.cpuThreads,
            _that.appVersion,
            _that.sortType,
            _that.sortAsc,
            _that.isDebugMode);
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
            List<TranscodePreset> transcodingPresets,
            List<Lut> luts,
            int defaultTranscodePresetId,
            int cpuThreads,
            String appVersion,
            SortType sortType,
            bool sortAsc,
            bool isDebugMode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Settings() when $default != null:
        return $default(
            _that.transcodingPresets,
            _that.luts,
            _that.defaultTranscodePresetId,
            _that.cpuThreads,
            _that.appVersion,
            _that.sortType,
            _that.sortAsc,
            _that.isDebugMode);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Settings implements Settings {
  const _Settings(
      {final List<TranscodePreset> transcodingPresets =
          const <TranscodePreset>[],
      final List<Lut> luts = const <Lut>[],
      this.defaultTranscodePresetId = 0,
      this.cpuThreads = 1,
      this.appVersion = '0.0.0',
      this.sortType = SortType.name,
      this.sortAsc = true,
      this.isDebugMode = false})
      : _transcodingPresets = transcodingPresets,
        _luts = luts;

  final List<TranscodePreset> _transcodingPresets;
  @override
  @JsonKey()
  List<TranscodePreset> get transcodingPresets {
    if (_transcodingPresets is EqualUnmodifiableListView)
      return _transcodingPresets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transcodingPresets);
  }

  final List<Lut> _luts;
  @override
  @JsonKey()
  List<Lut> get luts {
    if (_luts is EqualUnmodifiableListView) return _luts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_luts);
  }

  @override
  @JsonKey()
  final int defaultTranscodePresetId;
  @override
  @JsonKey()
  final int cpuThreads;
  @override
  @JsonKey()
  final String appVersion;
  @override
  @JsonKey()
  final SortType sortType;
  @override
  @JsonKey()
  final bool sortAsc;
  @override
  @JsonKey()
  final bool isDebugMode;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SettingsCopyWith<_Settings> get copyWith =>
      __$SettingsCopyWithImpl<_Settings>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Settings &&
            const DeepCollectionEquality()
                .equals(other._transcodingPresets, _transcodingPresets) &&
            const DeepCollectionEquality().equals(other._luts, _luts) &&
            (identical(
                    other.defaultTranscodePresetId, defaultTranscodePresetId) ||
                other.defaultTranscodePresetId == defaultTranscodePresetId) &&
            (identical(other.cpuThreads, cpuThreads) ||
                other.cpuThreads == cpuThreads) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.sortType, sortType) ||
                other.sortType == sortType) &&
            (identical(other.sortAsc, sortAsc) || other.sortAsc == sortAsc) &&
            (identical(other.isDebugMode, isDebugMode) ||
                other.isDebugMode == isDebugMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_transcodingPresets),
      const DeepCollectionEquality().hash(_luts),
      defaultTranscodePresetId,
      cpuThreads,
      appVersion,
      sortType,
      sortAsc,
      isDebugMode);

  @override
  String toString() {
    return 'Settings(transcodingPresets: $transcodingPresets, luts: $luts, defaultTranscodePresetId: $defaultTranscodePresetId, cpuThreads: $cpuThreads, appVersion: $appVersion, sortType: $sortType, sortAsc: $sortAsc, isDebugMode: $isDebugMode)';
  }
}

/// @nodoc
abstract mixin class _$SettingsCopyWith<$Res>
    implements $SettingsCopyWith<$Res> {
  factory _$SettingsCopyWith(_Settings value, $Res Function(_Settings) _then) =
      __$SettingsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<TranscodePreset> transcodingPresets,
      List<Lut> luts,
      int defaultTranscodePresetId,
      int cpuThreads,
      String appVersion,
      SortType sortType,
      bool sortAsc,
      bool isDebugMode});
}

/// @nodoc
class __$SettingsCopyWithImpl<$Res> implements _$SettingsCopyWith<$Res> {
  __$SettingsCopyWithImpl(this._self, this._then);

  final _Settings _self;
  final $Res Function(_Settings) _then;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? transcodingPresets = null,
    Object? luts = null,
    Object? defaultTranscodePresetId = null,
    Object? cpuThreads = null,
    Object? appVersion = null,
    Object? sortType = null,
    Object? sortAsc = null,
    Object? isDebugMode = null,
  }) {
    return _then(_Settings(
      transcodingPresets: null == transcodingPresets
          ? _self._transcodingPresets
          : transcodingPresets // ignore: cast_nullable_to_non_nullable
              as List<TranscodePreset>,
      luts: null == luts
          ? _self._luts
          : luts // ignore: cast_nullable_to_non_nullable
              as List<Lut>,
      defaultTranscodePresetId: null == defaultTranscodePresetId
          ? _self.defaultTranscodePresetId
          : defaultTranscodePresetId // ignore: cast_nullable_to_non_nullable
              as int,
      cpuThreads: null == cpuThreads
          ? _self.cpuThreads
          : cpuThreads // ignore: cast_nullable_to_non_nullable
              as int,
      appVersion: null == appVersion
          ? _self.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      sortType: null == sortType
          ? _self.sortType
          : sortType // ignore: cast_nullable_to_non_nullable
              as SortType,
      sortAsc: null == sortAsc
          ? _self.sortAsc
          : sortAsc // ignore: cast_nullable_to_non_nullable
              as bool,
      isDebugMode: null == isDebugMode
          ? _self.isDebugMode
          : isDebugMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on

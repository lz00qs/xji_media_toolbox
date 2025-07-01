// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Settings {
  List<TranscodePreset> get transcodingPresets;
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
      defaultTranscodePresetId,
      cpuThreads,
      appVersion,
      sortType,
      sortAsc,
      isDebugMode);

  @override
  String toString() {
    return 'Settings(transcodingPresets: $transcodingPresets, defaultTranscodePresetId: $defaultTranscodePresetId, cpuThreads: $cpuThreads, appVersion: $appVersion, sortType: $sortType, sortAsc: $sortAsc, isDebugMode: $isDebugMode)';
  }
}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res> {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) =
      _$SettingsCopyWithImpl;
  @useResult
  $Res call(
      {List<TranscodePreset> transcodingPresets,
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
    Object? defaultTranscodePresetId = null,
    Object? cpuThreads = null,
    Object? appVersion = null,
    Object? sortType = null,
    Object? sortAsc = null,
    Object? isDebugMode = null,
  }) {
    return _then(Settings(
      transcodingPresets: null == transcodingPresets
          ? _self.transcodingPresets
          : transcodingPresets // ignore: cast_nullable_to_non_nullable
              as List<TranscodePreset>,
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

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Sort implements DiagnosticableTreeMixin {

 SortType get sortType; bool get sortAsc;
/// Create a copy of Sort
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SortCopyWith<Sort> get copyWith => _$SortCopyWithImpl<Sort>(this as Sort, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as Sort;
  properties
    ..add(DiagnosticsProperty('type', 'Sort'))
    ..add(DiagnosticsProperty('sortType', _this.sortType))..add(DiagnosticsProperty('sortAsc', _this.sortAsc));
}

@override
bool operator ==(Object other) {
  final _this = this as Sort;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sort&&(identical(other.sortType, _this.sortType) || other.sortType == _this.sortType)&&(identical(other.sortAsc, _this.sortAsc) || other.sortAsc == _this.sortAsc));
}


@override
int get hashCode {
  final _this = this as Sort;
  return Object.hash(runtimeType,_this.sortType,_this.sortAsc);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as Sort;
  return 'Sort(sortType: ${_this.sortType}, sortAsc: ${_this.sortAsc})';
}


}

/// @nodoc
abstract mixin class $SortCopyWith<$Res>  {
  factory $SortCopyWith(Sort value, $Res Function(Sort) _then) = _$SortCopyWithImpl;
@useResult
$Res call({
 SortType sortType, bool sortAsc
});




}
/// @nodoc
class _$SortCopyWithImpl<$Res>
    implements $SortCopyWith<$Res> {
  _$SortCopyWithImpl(this._self, this._then);

  final Sort _self;
  final $Res Function(Sort) _then;

/// Create a copy of Sort
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sortType = null,Object? sortAsc = null,}) {
  return _then(Sort(
sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,sortAsc: null == sortAsc ? _self.sortAsc : sortAsc // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Sort].
extension SortPatterns on Sort {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Sort value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Sort() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Sort value)  $default,){
final _that = this;
switch (_that) {
case _Sort():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Sort value)?  $default,){
final _that = this;
switch (_that) {
case _Sort() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SortType sortType,  bool sortAsc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sort() when $default != null:
return $default(_that.sortType,_that.sortAsc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SortType sortType,  bool sortAsc)  $default,) {final _that = this;
switch (_that) {
case _Sort():
return $default(_that.sortType,_that.sortAsc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SortType sortType,  bool sortAsc)?  $default,) {final _that = this;
switch (_that) {
case _Sort() when $default != null:
return $default(_that.sortType,_that.sortAsc);case _:
  return null;

}
}

}

/// @nodoc


class _Sort with DiagnosticableTreeMixin implements Sort {
  const _Sort({this.sortType = SortType.name, this.sortAsc = true});


@override@JsonKey() final  SortType sortType;
@override@JsonKey() final  bool sortAsc;

/// Create a copy of Sort
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SortCopyWith<_Sort> get copyWith => __$SortCopyWithImpl<_Sort>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'Sort'))
    ..add(DiagnosticsProperty('sortType', sortType))..add(DiagnosticsProperty('sortAsc', sortAsc));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sort&&(identical(other.sortType, sortType) || other.sortType == sortType)&&(identical(other.sortAsc, sortAsc) || other.sortAsc == sortAsc));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sortType,sortAsc);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'Sort(sortType: $sortType, sortAsc: $sortAsc)';
}


}

/// @nodoc
abstract mixin class _$SortCopyWith<$Res> implements $SortCopyWith<$Res> {
  factory _$SortCopyWith(_Sort value, $Res Function(_Sort) _then) = __$SortCopyWithImpl;
@override @useResult
$Res call({
 SortType sortType, bool sortAsc
});




}
/// @nodoc
class __$SortCopyWithImpl<$Res>
    implements _$SortCopyWith<$Res> {
  __$SortCopyWithImpl(this._self, this._then);

  final _Sort _self;
  final $Res Function(_Sort) _then;

/// Create a copy of Sort
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sortType = null,Object? sortAsc = null,}) {
  return _then(_Sort(
sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,sortAsc: null == sortAsc ? _self.sortAsc : sortAsc // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$Settings implements DiagnosticableTreeMixin {

 List<TranscodePreset> get transcodingPresets; List<Lut> get luts; int get defaultTranscodePresetId; int get cpuThreads; String get appVersion; Sort get sort; bool get isDebugMode; bool get exportCmdOnly;
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCopyWith<Settings> get copyWith => _$SettingsCopyWithImpl<Settings>(this as Settings, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as Settings;
  properties
    ..add(DiagnosticsProperty('type', 'Settings'))
    ..add(DiagnosticsProperty('transcodingPresets', _this.transcodingPresets))..add(DiagnosticsProperty('luts', _this.luts))..add(DiagnosticsProperty('defaultTranscodePresetId', _this.defaultTranscodePresetId))..add(DiagnosticsProperty('cpuThreads', _this.cpuThreads))..add(DiagnosticsProperty('appVersion', _this.appVersion))..add(DiagnosticsProperty('sort', _this.sort))..add(DiagnosticsProperty('isDebugMode', _this.isDebugMode))..add(DiagnosticsProperty('exportCmdOnly', _this.exportCmdOnly));
}

@override
bool operator ==(Object other) {
  final _this = this as Settings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settings&&const DeepCollectionEquality().equals(other.transcodingPresets, _this.transcodingPresets)&&const DeepCollectionEquality().equals(other.luts, _this.luts)&&(identical(other.defaultTranscodePresetId, _this.defaultTranscodePresetId) || other.defaultTranscodePresetId == _this.defaultTranscodePresetId)&&(identical(other.cpuThreads, _this.cpuThreads) || other.cpuThreads == _this.cpuThreads)&&(identical(other.appVersion, _this.appVersion) || other.appVersion == _this.appVersion)&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.isDebugMode, _this.isDebugMode) || other.isDebugMode == _this.isDebugMode)&&(identical(other.exportCmdOnly, _this.exportCmdOnly) || other.exportCmdOnly == _this.exportCmdOnly));
}


@override
int get hashCode {
  final _this = this as Settings;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.transcodingPresets),const DeepCollectionEquality().hash(_this.luts),_this.defaultTranscodePresetId,_this.cpuThreads,_this.appVersion,_this.sort,_this.isDebugMode,_this.exportCmdOnly);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as Settings;
  return 'Settings(transcodingPresets: ${_this.transcodingPresets}, luts: ${_this.luts}, defaultTranscodePresetId: ${_this.defaultTranscodePresetId}, cpuThreads: ${_this.cpuThreads}, appVersion: ${_this.appVersion}, sort: ${_this.sort}, isDebugMode: ${_this.isDebugMode}, exportCmdOnly: ${_this.exportCmdOnly})';
}


}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res>  {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) = _$SettingsCopyWithImpl;
@useResult
$Res call({
 List<TranscodePreset> transcodingPresets, List<Lut> luts, int defaultTranscodePresetId, int cpuThreads, String appVersion, Sort sort, bool isDebugMode, bool exportCmdOnly
});


$SortCopyWith<$Res> get sort;

}
/// @nodoc
class _$SettingsCopyWithImpl<$Res>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._self, this._then);

  final Settings _self;
  final $Res Function(Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transcodingPresets = null,Object? luts = null,Object? defaultTranscodePresetId = null,Object? cpuThreads = null,Object? appVersion = null,Object? sort = null,Object? isDebugMode = null,Object? exportCmdOnly = null,}) {
  return _then(Settings(
transcodingPresets: null == transcodingPresets ? _self.transcodingPresets : transcodingPresets // ignore: cast_nullable_to_non_nullable
as List<TranscodePreset>,luts: null == luts ? _self.luts : luts // ignore: cast_nullable_to_non_nullable
as List<Lut>,defaultTranscodePresetId: null == defaultTranscodePresetId ? _self.defaultTranscodePresetId : defaultTranscodePresetId // ignore: cast_nullable_to_non_nullable
as int,cpuThreads: null == cpuThreads ? _self.cpuThreads : cpuThreads // ignore: cast_nullable_to_non_nullable
as int,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as Sort,isDebugMode: null == isDebugMode ? _self.isDebugMode : isDebugMode // ignore: cast_nullable_to_non_nullable
as bool,exportCmdOnly: null == exportCmdOnly ? _self.exportCmdOnly : exportCmdOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SortCopyWith<$Res> get sort {

  return $SortCopyWith<$Res>(_self.sort, (value) {
    return _then(_self.copyWith(sort: value));
  });
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settings value)  $default,){
final _that = this;
switch (_that) {
case _Settings():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settings value)?  $default,){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TranscodePreset> transcodingPresets,  List<Lut> luts,  int defaultTranscodePresetId,  int cpuThreads,  String appVersion,  Sort sort,  bool isDebugMode,  bool exportCmdOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.transcodingPresets,_that.luts,_that.defaultTranscodePresetId,_that.cpuThreads,_that.appVersion,_that.sort,_that.isDebugMode,_that.exportCmdOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TranscodePreset> transcodingPresets,  List<Lut> luts,  int defaultTranscodePresetId,  int cpuThreads,  String appVersion,  Sort sort,  bool isDebugMode,  bool exportCmdOnly)  $default,) {final _that = this;
switch (_that) {
case _Settings():
return $default(_that.transcodingPresets,_that.luts,_that.defaultTranscodePresetId,_that.cpuThreads,_that.appVersion,_that.sort,_that.isDebugMode,_that.exportCmdOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TranscodePreset> transcodingPresets,  List<Lut> luts,  int defaultTranscodePresetId,  int cpuThreads,  String appVersion,  Sort sort,  bool isDebugMode,  bool exportCmdOnly)?  $default,) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.transcodingPresets,_that.luts,_that.defaultTranscodePresetId,_that.cpuThreads,_that.appVersion,_that.sort,_that.isDebugMode,_that.exportCmdOnly);case _:
  return null;

}
}

}

/// @nodoc


class _Settings with DiagnosticableTreeMixin implements Settings {
  const _Settings({ List<TranscodePreset> transcodingPresets = const <TranscodePreset>[],  List<Lut> luts = const <Lut>[], this.defaultTranscodePresetId = 0, this.cpuThreads = 1, this.appVersion = '0.0.0', this.sort = const Sort(), this.isDebugMode = kDebugMode, this.exportCmdOnly = false}): _transcodingPresets = transcodingPresets,_luts = luts;


 final  List<TranscodePreset> _transcodingPresets;
@override@JsonKey() List<TranscodePreset> get transcodingPresets {
  if (_transcodingPresets is EqualUnmodifiableListView) return _transcodingPresets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transcodingPresets);
}

 final  List<Lut> _luts;
@override@JsonKey() List<Lut> get luts {
  if (_luts is EqualUnmodifiableListView) return _luts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_luts);
}

@override@JsonKey() final  int defaultTranscodePresetId;
@override@JsonKey() final  int cpuThreads;
@override@JsonKey() final  String appVersion;
@override@JsonKey() final  Sort sort;
@override@JsonKey() final  bool isDebugMode;
@override@JsonKey() final  bool exportCmdOnly;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCopyWith<_Settings> get copyWith => __$SettingsCopyWithImpl<_Settings>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'Settings'))
    ..add(DiagnosticsProperty('transcodingPresets', transcodingPresets))..add(DiagnosticsProperty('luts', luts))..add(DiagnosticsProperty('defaultTranscodePresetId', defaultTranscodePresetId))..add(DiagnosticsProperty('cpuThreads', cpuThreads))..add(DiagnosticsProperty('appVersion', appVersion))..add(DiagnosticsProperty('sort', sort))..add(DiagnosticsProperty('isDebugMode', isDebugMode))..add(DiagnosticsProperty('exportCmdOnly', exportCmdOnly));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settings&&const DeepCollectionEquality().equals(other.transcodingPresets, _transcodingPresets)&&const DeepCollectionEquality().equals(other.luts, _luts)&&(identical(other.defaultTranscodePresetId, defaultTranscodePresetId) || other.defaultTranscodePresetId == defaultTranscodePresetId)&&(identical(other.cpuThreads, cpuThreads) || other.cpuThreads == cpuThreads)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.isDebugMode, isDebugMode) || other.isDebugMode == isDebugMode)&&(identical(other.exportCmdOnly, exportCmdOnly) || other.exportCmdOnly == exportCmdOnly));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_transcodingPresets),const DeepCollectionEquality().hash(_luts),defaultTranscodePresetId,cpuThreads,appVersion,sort,isDebugMode,exportCmdOnly);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'Settings(transcodingPresets: $transcodingPresets, luts: $luts, defaultTranscodePresetId: $defaultTranscodePresetId, cpuThreads: $cpuThreads, appVersion: $appVersion, sort: $sort, isDebugMode: $isDebugMode, exportCmdOnly: $exportCmdOnly)';
}


}

/// @nodoc
abstract mixin class _$SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$SettingsCopyWith(_Settings value, $Res Function(_Settings) _then) = __$SettingsCopyWithImpl;
@override @useResult
$Res call({
 List<TranscodePreset> transcodingPresets, List<Lut> luts, int defaultTranscodePresetId, int cpuThreads, String appVersion, Sort sort, bool isDebugMode, bool exportCmdOnly
});


@override $SortCopyWith<$Res> get sort;

}
/// @nodoc
class __$SettingsCopyWithImpl<$Res>
    implements _$SettingsCopyWith<$Res> {
  __$SettingsCopyWithImpl(this._self, this._then);

  final _Settings _self;
  final $Res Function(_Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transcodingPresets = null,Object? luts = null,Object? defaultTranscodePresetId = null,Object? cpuThreads = null,Object? appVersion = null,Object? sort = null,Object? isDebugMode = null,Object? exportCmdOnly = null,}) {
  return _then(_Settings(
transcodingPresets: null == transcodingPresets ? _self._transcodingPresets : transcodingPresets // ignore: cast_nullable_to_non_nullable
as List<TranscodePreset>,luts: null == luts ? _self._luts : luts // ignore: cast_nullable_to_non_nullable
as List<Lut>,defaultTranscodePresetId: null == defaultTranscodePresetId ? _self.defaultTranscodePresetId : defaultTranscodePresetId // ignore: cast_nullable_to_non_nullable
as int,cpuThreads: null == cpuThreads ? _self.cpuThreads : cpuThreads // ignore: cast_nullable_to_non_nullable
as int,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as Sort,isDebugMode: null == isDebugMode ? _self.isDebugMode : isDebugMode // ignore: cast_nullable_to_non_nullable
as bool,exportCmdOnly: null == exportCmdOnly ? _self.exportCmdOnly : exportCmdOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SortCopyWith<$Res> get sort {

  return $SortCopyWith<$Res>(_self.sort, (value) {
    return _then(_self.copyWith(sort: value));
  });
}
}

// dart format on

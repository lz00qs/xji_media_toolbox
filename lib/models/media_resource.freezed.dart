// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_resource.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaResources {
  bool get isLoading;
  List<MediaResource> get resources;
  int get currentIndex;
  double get loadProgress;
  dynamic get resourcesPath;
  set resourcesPath(dynamic value);

  /// Create a copy of MediaResources
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaResourcesCopyWith<MediaResources> get copyWith =>
      _$MediaResourcesCopyWithImpl<MediaResources>(
          this as MediaResources, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaResources &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other.resources, resources) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.loadProgress, loadProgress) ||
                other.loadProgress == loadProgress) &&
            const DeepCollectionEquality()
                .equals(other.resourcesPath, resourcesPath));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(resources),
      currentIndex,
      loadProgress,
      const DeepCollectionEquality().hash(resourcesPath));

  @override
  String toString() {
    return 'MediaResources(isLoading: $isLoading, resources: $resources, currentIndex: $currentIndex, loadProgress: $loadProgress, resourcesPath: $resourcesPath)';
  }
}

/// @nodoc
abstract mixin class $MediaResourcesCopyWith<$Res> {
  factory $MediaResourcesCopyWith(
          MediaResources value, $Res Function(MediaResources) _then) =
      _$MediaResourcesCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      List<MediaResource> resources,
      int currentIndex,
      double loadProgress});
}

/// @nodoc
class _$MediaResourcesCopyWithImpl<$Res>
    implements $MediaResourcesCopyWith<$Res> {
  _$MediaResourcesCopyWithImpl(this._self, this._then);

  final MediaResources _self;
  final $Res Function(MediaResources) _then;

  /// Create a copy of MediaResources
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? resources = null,
    Object? currentIndex = null,
    Object? loadProgress = null,
  }) {
    return _then(MediaResources(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      resources: null == resources
          ? _self.resources
          : resources // ignore: cast_nullable_to_non_nullable
              as List<MediaResource>,
      currentIndex: null == currentIndex
          ? _self.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      loadProgress: null == loadProgress
          ? _self.loadProgress
          : loadProgress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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
  bool get isMultipleSelection;
  int get currentAebIndex;
  List<MediaResource> get selectedResources;
  dynamic get resourcesPath;
  set resourcesPath(dynamic value);
  bool get isEditing;

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
            (identical(other.isMultipleSelection, isMultipleSelection) ||
                other.isMultipleSelection == isMultipleSelection) &&
            (identical(other.currentAebIndex, currentAebIndex) ||
                other.currentAebIndex == currentAebIndex) &&
            const DeepCollectionEquality()
                .equals(other.selectedResources, selectedResources) &&
            const DeepCollectionEquality()
                .equals(other.resourcesPath, resourcesPath) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(resources),
      currentIndex,
      loadProgress,
      isMultipleSelection,
      currentAebIndex,
      const DeepCollectionEquality().hash(selectedResources),
      const DeepCollectionEquality().hash(resourcesPath),
      isEditing);

  @override
  String toString() {
    return 'MediaResources(isLoading: $isLoading, resources: $resources, currentIndex: $currentIndex, loadProgress: $loadProgress, isMultipleSelection: $isMultipleSelection, currentAebIndex: $currentAebIndex, selectedResources: $selectedResources, resourcesPath: $resourcesPath, isEditing: $isEditing)';
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
      double loadProgress,
      bool isMultipleSelection,
      List<MediaResource> selectedResources,
      int currentAebIndex,
      bool isEditing});
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
    Object? isMultipleSelection = null,
    Object? selectedResources = null,
    Object? currentAebIndex = null,
    Object? isEditing = null,
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
      isMultipleSelection: null == isMultipleSelection
          ? _self.isMultipleSelection
          : isMultipleSelection // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedResources: null == selectedResources
          ? _self.selectedResources
          : selectedResources // ignore: cast_nullable_to_non_nullable
              as List<MediaResource>,
      currentAebIndex: null == currentAebIndex
          ? _self.currentAebIndex
          : currentAebIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isEditing: null == isEditing
          ? _self.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MediaResources].
extension MediaResourcesPatterns on MediaResources {
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
  TResult maybeMap<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
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
  TResult map<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
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
  TResult? mapOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
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
  TResult maybeWhen<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
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
  TResult when<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
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
  TResult? whenOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }
}

// dart format on

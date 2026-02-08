// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_resources_state.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaResourcesState {
  bool get isLoading;
  List<MediaResource> get resources;
  int get currentIndex;
  int get aebIndex;
  double get loadProgress;
  bool get isMultipleSelection;
  List<MediaResource> get selectedResources;
  String get resourcesPath;

  /// Create a copy of MediaResourcesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaResourcesStateCopyWith<MediaResourcesState> get copyWith =>
      _$MediaResourcesStateCopyWithImpl<MediaResourcesState>(
          this as MediaResourcesState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaResourcesState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other.resources, resources) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.aebIndex, aebIndex) ||
                other.aebIndex == aebIndex) &&
            (identical(other.loadProgress, loadProgress) ||
                other.loadProgress == loadProgress) &&
            (identical(other.isMultipleSelection, isMultipleSelection) ||
                other.isMultipleSelection == isMultipleSelection) &&
            const DeepCollectionEquality()
                .equals(other.selectedResources, selectedResources) &&
            (identical(other.resourcesPath, resourcesPath) ||
                other.resourcesPath == resourcesPath));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(resources),
      currentIndex,
      aebIndex,
      loadProgress,
      isMultipleSelection,
      const DeepCollectionEquality().hash(selectedResources),
      resourcesPath);

  @override
  String toString() {
    return 'MediaResourcesState(isLoading: $isLoading, resources: $resources, currentIndex: $currentIndex, aebIndex: $aebIndex, loadProgress: $loadProgress, isMultipleSelection: $isMultipleSelection, selectedResources: $selectedResources, resourcesPath: $resourcesPath)';
  }
}

/// @nodoc
abstract mixin class $MediaResourcesStateCopyWith<$Res> {
  factory $MediaResourcesStateCopyWith(
          MediaResourcesState value, $Res Function(MediaResourcesState) _then) =
      _$MediaResourcesStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      List<MediaResource> resources,
      int currentIndex,
      int aebIndex,
      double loadProgress,
      bool isMultipleSelection,
      List<MediaResource> selectedResources,
      String resourcesPath});
}

/// @nodoc
class _$MediaResourcesStateCopyWithImpl<$Res>
    implements $MediaResourcesStateCopyWith<$Res> {
  _$MediaResourcesStateCopyWithImpl(this._self, this._then);

  final MediaResourcesState _self;
  final $Res Function(MediaResourcesState) _then;

  /// Create a copy of MediaResourcesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? resources = null,
    Object? currentIndex = null,
    Object? aebIndex = null,
    Object? loadProgress = null,
    Object? isMultipleSelection = null,
    Object? selectedResources = null,
    Object? resourcesPath = null,
  }) {
    return _then(_self.copyWith(
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
      aebIndex: null == aebIndex
          ? _self.aebIndex
          : aebIndex // ignore: cast_nullable_to_non_nullable
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
      resourcesPath: null == resourcesPath
          ? _self.resourcesPath
          : resourcesPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [MediaResourcesState].
extension MediaResourcesStatePatterns on MediaResourcesState {
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
    TResult Function(_MediaResourcesState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaResourcesState() when $default != null:
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
    TResult Function(_MediaResourcesState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaResourcesState():
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
    TResult? Function(_MediaResourcesState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaResourcesState() when $default != null:
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
            bool isLoading,
            List<MediaResource> resources,
            int currentIndex,
            int aebIndex,
            double loadProgress,
            bool isMultipleSelection,
            List<MediaResource> selectedResources,
            String resourcesPath)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaResourcesState() when $default != null:
        return $default(
            _that.isLoading,
            _that.resources,
            _that.currentIndex,
            _that.aebIndex,
            _that.loadProgress,
            _that.isMultipleSelection,
            _that.selectedResources,
            _that.resourcesPath);
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
            bool isLoading,
            List<MediaResource> resources,
            int currentIndex,
            int aebIndex,
            double loadProgress,
            bool isMultipleSelection,
            List<MediaResource> selectedResources,
            String resourcesPath)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaResourcesState():
        return $default(
            _that.isLoading,
            _that.resources,
            _that.currentIndex,
            _that.aebIndex,
            _that.loadProgress,
            _that.isMultipleSelection,
            _that.selectedResources,
            _that.resourcesPath);
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
            bool isLoading,
            List<MediaResource> resources,
            int currentIndex,
            int aebIndex,
            double loadProgress,
            bool isMultipleSelection,
            List<MediaResource> selectedResources,
            String resourcesPath)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaResourcesState() when $default != null:
        return $default(
            _that.isLoading,
            _that.resources,
            _that.currentIndex,
            _that.aebIndex,
            _that.loadProgress,
            _that.isMultipleSelection,
            _that.selectedResources,
            _that.resourcesPath);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MediaResourcesState implements MediaResourcesState {
  const _MediaResourcesState(
      {this.isLoading = false,
      final List<MediaResource> resources = const <MediaResource>[],
      this.currentIndex = 0,
      this.aebIndex = 0,
      this.loadProgress = 0.0,
      this.isMultipleSelection = false,
      final List<MediaResource> selectedResources = const <MediaResource>[],
      this.resourcesPath = ""})
      : _resources = resources,
        _selectedResources = selectedResources;

  @override
  @JsonKey()
  final bool isLoading;
  final List<MediaResource> _resources;
  @override
  @JsonKey()
  List<MediaResource> get resources {
    if (_resources is EqualUnmodifiableListView) return _resources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resources);
  }

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final int aebIndex;
  @override
  @JsonKey()
  final double loadProgress;
  @override
  @JsonKey()
  final bool isMultipleSelection;
  final List<MediaResource> _selectedResources;
  @override
  @JsonKey()
  List<MediaResource> get selectedResources {
    if (_selectedResources is EqualUnmodifiableListView)
      return _selectedResources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedResources);
  }

  @override
  @JsonKey()
  final String resourcesPath;

  /// Create a copy of MediaResourcesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MediaResourcesStateCopyWith<_MediaResourcesState> get copyWith =>
      __$MediaResourcesStateCopyWithImpl<_MediaResourcesState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MediaResourcesState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._resources, _resources) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.aebIndex, aebIndex) ||
                other.aebIndex == aebIndex) &&
            (identical(other.loadProgress, loadProgress) ||
                other.loadProgress == loadProgress) &&
            (identical(other.isMultipleSelection, isMultipleSelection) ||
                other.isMultipleSelection == isMultipleSelection) &&
            const DeepCollectionEquality()
                .equals(other._selectedResources, _selectedResources) &&
            (identical(other.resourcesPath, resourcesPath) ||
                other.resourcesPath == resourcesPath));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_resources),
      currentIndex,
      aebIndex,
      loadProgress,
      isMultipleSelection,
      const DeepCollectionEquality().hash(_selectedResources),
      resourcesPath);

  @override
  String toString() {
    return 'MediaResourcesState(isLoading: $isLoading, resources: $resources, currentIndex: $currentIndex, aebIndex: $aebIndex, loadProgress: $loadProgress, isMultipleSelection: $isMultipleSelection, selectedResources: $selectedResources, resourcesPath: $resourcesPath)';
  }
}

/// @nodoc
abstract mixin class _$MediaResourcesStateCopyWith<$Res>
    implements $MediaResourcesStateCopyWith<$Res> {
  factory _$MediaResourcesStateCopyWith(_MediaResourcesState value,
          $Res Function(_MediaResourcesState) _then) =
      __$MediaResourcesStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<MediaResource> resources,
      int currentIndex,
      int aebIndex,
      double loadProgress,
      bool isMultipleSelection,
      List<MediaResource> selectedResources,
      String resourcesPath});
}

/// @nodoc
class __$MediaResourcesStateCopyWithImpl<$Res>
    implements _$MediaResourcesStateCopyWith<$Res> {
  __$MediaResourcesStateCopyWithImpl(this._self, this._then);

  final _MediaResourcesState _self;
  final $Res Function(_MediaResourcesState) _then;

  /// Create a copy of MediaResourcesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? resources = null,
    Object? currentIndex = null,
    Object? aebIndex = null,
    Object? loadProgress = null,
    Object? isMultipleSelection = null,
    Object? selectedResources = null,
    Object? resourcesPath = null,
  }) {
    return _then(_MediaResourcesState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      resources: null == resources
          ? _self._resources
          : resources // ignore: cast_nullable_to_non_nullable
              as List<MediaResource>,
      currentIndex: null == currentIndex
          ? _self.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      aebIndex: null == aebIndex
          ? _self.aebIndex
          : aebIndex // ignore: cast_nullable_to_non_nullable
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
          ? _self._selectedResources
          : selectedResources // ignore: cast_nullable_to_non_nullable
              as List<MediaResource>,
      resourcesPath: null == resourcesPath
          ? _self.resourcesPath
          : resourcesPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on

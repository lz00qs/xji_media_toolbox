// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_resource.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaResource {
  String get name;
  File get file;
  int get width;
  int get height;
  int get sizeInBytes;
  DateTime get creationTime;
  int get sequence;
  String get thumbFile;
  bool get hide;

  /// Create a copy of MediaResource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaResourceCopyWith<MediaResource> get copyWith =>
      _$MediaResourceCopyWithImpl<MediaResource>(
          this as MediaResource, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaResource &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.sizeInBytes, sizeInBytes) ||
                other.sizeInBytes == sizeInBytes) &&
            (identical(other.creationTime, creationTime) ||
                other.creationTime == creationTime) &&
            (identical(other.sequence, sequence) ||
                other.sequence == sequence) &&
            (identical(other.thumbFile, thumbFile) ||
                other.thumbFile == thumbFile) &&
            (identical(other.hide, hide) || other.hide == hide));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, file, width, height,
      sizeInBytes, creationTime, sequence, thumbFile, hide);

  @override
  String toString() {
    return 'MediaResource(name: $name, file: $file, width: $width, height: $height, sizeInBytes: $sizeInBytes, creationTime: $creationTime, sequence: $sequence, thumbFile: $thumbFile, hide: $hide)';
  }
}

/// @nodoc
abstract mixin class $MediaResourceCopyWith<$Res> {
  factory $MediaResourceCopyWith(
          MediaResource value, $Res Function(MediaResource) _then) =
      _$MediaResourceCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      File file,
      int width,
      int height,
      int sizeInBytes,
      DateTime creationTime,
      int sequence,
      String thumbFile,
      bool hide});
}

/// @nodoc
class _$MediaResourceCopyWithImpl<$Res>
    implements $MediaResourceCopyWith<$Res> {
  _$MediaResourceCopyWithImpl(this._self, this._then);

  final MediaResource _self;
  final $Res Function(MediaResource) _then;

  /// Create a copy of MediaResource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? file = null,
    Object? width = null,
    Object? height = null,
    Object? sizeInBytes = null,
    Object? creationTime = null,
    Object? sequence = null,
    Object? thumbFile = null,
    Object? hide = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      file: null == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as File,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      sizeInBytes: null == sizeInBytes
          ? _self.sizeInBytes
          : sizeInBytes // ignore: cast_nullable_to_non_nullable
              as int,
      creationTime: null == creationTime
          ? _self.creationTime
          : creationTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sequence: null == sequence
          ? _self.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int,
      thumbFile: null == thumbFile
          ? _self.thumbFile
          : thumbFile // ignore: cast_nullable_to_non_nullable
              as String,
      hide: null == hide
          ? _self.hide
          : hide // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MediaResource].
extension MediaResourcePatterns on MediaResource {
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
    TResult Function(PhotoResource value)? photo,
    TResult Function(AebPhotoResource value)? aebPhoto,
    TResult Function(VideoResource value)? video,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case PhotoResource() when photo != null:
        return photo(_that);
      case AebPhotoResource() when aebPhoto != null:
        return aebPhoto(_that);
      case VideoResource() when video != null:
        return video(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(PhotoResource value) photo,
    required TResult Function(AebPhotoResource value) aebPhoto,
    required TResult Function(VideoResource value) video,
  }) {
    final _that = this;
    switch (_that) {
      case PhotoResource():
        return photo(_that);
      case AebPhotoResource():
        return aebPhoto(_that);
      case VideoResource():
        return video(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PhotoResource value)? photo,
    TResult? Function(AebPhotoResource value)? aebPhoto,
    TResult? Function(VideoResource value)? video,
  }) {
    final _that = this;
    switch (_that) {
      case PhotoResource() when photo != null:
        return photo(_that);
      case AebPhotoResource() when aebPhoto != null:
        return aebPhoto(_that);
      case VideoResource() when video != null:
        return video(_that);
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
    TResult Function(
            String name,
            File file,
            int width,
            int height,
            int sizeInBytes,
            DateTime creationTime,
            int sequence,
            String thumbFile,
            bool hide)?
        photo,
    TResult Function(
            String name,
            File file,
            int width,
            int height,
            int sizeInBytes,
            DateTime creationTime,
            int sequence,
            String thumbFile,
            bool hide,
            int evBias)?
        aebPhoto,
    TResult Function(
            String name,
            File file,
            int width,
            int height,
            int sizeInBytes,
            DateTime creationTime,
            int sequence,
            String thumbFile,
            bool hide,
            Duration duration)?
        video,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case PhotoResource() when photo != null:
        return photo(
            _that.name,
            _that.file,
            _that.width,
            _that.height,
            _that.sizeInBytes,
            _that.creationTime,
            _that.sequence,
            _that.thumbFile,
            _that.hide);
      case AebPhotoResource() when aebPhoto != null:
        return aebPhoto(
            _that.name,
            _that.file,
            _that.width,
            _that.height,
            _that.sizeInBytes,
            _that.creationTime,
            _that.sequence,
            _that.thumbFile,
            _that.hide,
            _that.evBias);
      case VideoResource() when video != null:
        return video(
            _that.name,
            _that.file,
            _that.width,
            _that.height,
            _that.sizeInBytes,
            _that.creationTime,
            _that.sequence,
            _that.thumbFile,
            _that.hide,
            _that.duration);
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
  TResult when<TResult extends Object?>({
    required TResult Function(
            String name,
            File file,
            int width,
            int height,
            int sizeInBytes,
            DateTime creationTime,
            int sequence,
            String thumbFile,
            bool hide)
        photo,
    required TResult Function(
            String name,
            File file,
            int width,
            int height,
            int sizeInBytes,
            DateTime creationTime,
            int sequence,
            String thumbFile,
            bool hide,
            int evBias)
        aebPhoto,
    required TResult Function(
            String name,
            File file,
            int width,
            int height,
            int sizeInBytes,
            DateTime creationTime,
            int sequence,
            String thumbFile,
            bool hide,
            Duration duration)
        video,
  }) {
    final _that = this;
    switch (_that) {
      case PhotoResource():
        return photo(
            _that.name,
            _that.file,
            _that.width,
            _that.height,
            _that.sizeInBytes,
            _that.creationTime,
            _that.sequence,
            _that.thumbFile,
            _that.hide);
      case AebPhotoResource():
        return aebPhoto(
            _that.name,
            _that.file,
            _that.width,
            _that.height,
            _that.sizeInBytes,
            _that.creationTime,
            _that.sequence,
            _that.thumbFile,
            _that.hide,
            _that.evBias);
      case VideoResource():
        return video(
            _that.name,
            _that.file,
            _that.width,
            _that.height,
            _that.sizeInBytes,
            _that.creationTime,
            _that.sequence,
            _that.thumbFile,
            _that.hide,
            _that.duration);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String name,
            File file,
            int width,
            int height,
            int sizeInBytes,
            DateTime creationTime,
            int sequence,
            String thumbFile,
            bool hide)?
        photo,
    TResult? Function(
            String name,
            File file,
            int width,
            int height,
            int sizeInBytes,
            DateTime creationTime,
            int sequence,
            String thumbFile,
            bool hide,
            int evBias)?
        aebPhoto,
    TResult? Function(
            String name,
            File file,
            int width,
            int height,
            int sizeInBytes,
            DateTime creationTime,
            int sequence,
            String thumbFile,
            bool hide,
            Duration duration)?
        video,
  }) {
    final _that = this;
    switch (_that) {
      case PhotoResource() when photo != null:
        return photo(
            _that.name,
            _that.file,
            _that.width,
            _that.height,
            _that.sizeInBytes,
            _that.creationTime,
            _that.sequence,
            _that.thumbFile,
            _that.hide);
      case AebPhotoResource() when aebPhoto != null:
        return aebPhoto(
            _that.name,
            _that.file,
            _that.width,
            _that.height,
            _that.sizeInBytes,
            _that.creationTime,
            _that.sequence,
            _that.thumbFile,
            _that.hide,
            _that.evBias);
      case VideoResource() when video != null:
        return video(
            _that.name,
            _that.file,
            _that.width,
            _that.height,
            _that.sizeInBytes,
            _that.creationTime,
            _that.sequence,
            _that.thumbFile,
            _that.hide,
            _that.duration);
      case _:
        return null;
    }
  }
}

/// @nodoc

class PhotoResource extends MediaResource {
  const PhotoResource(
      {required this.name,
      required this.file,
      required this.width,
      required this.height,
      required this.sizeInBytes,
      required this.creationTime,
      required this.sequence,
      required this.thumbFile,
      this.hide = false})
      : super._();

  @override
  final String name;
  @override
  final File file;
  @override
  final int width;
  @override
  final int height;
  @override
  final int sizeInBytes;
  @override
  final DateTime creationTime;
  @override
  final int sequence;
  @override
  final String thumbFile;
  @override
  @JsonKey()
  final bool hide;

  /// Create a copy of MediaResource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PhotoResourceCopyWith<PhotoResource> get copyWith =>
      _$PhotoResourceCopyWithImpl<PhotoResource>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PhotoResource &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.sizeInBytes, sizeInBytes) ||
                other.sizeInBytes == sizeInBytes) &&
            (identical(other.creationTime, creationTime) ||
                other.creationTime == creationTime) &&
            (identical(other.sequence, sequence) ||
                other.sequence == sequence) &&
            (identical(other.thumbFile, thumbFile) ||
                other.thumbFile == thumbFile) &&
            (identical(other.hide, hide) || other.hide == hide));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, file, width, height,
      sizeInBytes, creationTime, sequence, thumbFile, hide);

  @override
  String toString() {
    return 'MediaResource.photo(name: $name, file: $file, width: $width, height: $height, sizeInBytes: $sizeInBytes, creationTime: $creationTime, sequence: $sequence, thumbFile: $thumbFile, hide: $hide)';
  }
}

/// @nodoc
abstract mixin class $PhotoResourceCopyWith<$Res>
    implements $MediaResourceCopyWith<$Res> {
  factory $PhotoResourceCopyWith(
          PhotoResource value, $Res Function(PhotoResource) _then) =
      _$PhotoResourceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      File file,
      int width,
      int height,
      int sizeInBytes,
      DateTime creationTime,
      int sequence,
      String thumbFile,
      bool hide});
}

/// @nodoc
class _$PhotoResourceCopyWithImpl<$Res>
    implements $PhotoResourceCopyWith<$Res> {
  _$PhotoResourceCopyWithImpl(this._self, this._then);

  final PhotoResource _self;
  final $Res Function(PhotoResource) _then;

  /// Create a copy of MediaResource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? file = null,
    Object? width = null,
    Object? height = null,
    Object? sizeInBytes = null,
    Object? creationTime = null,
    Object? sequence = null,
    Object? thumbFile = null,
    Object? hide = null,
  }) {
    return _then(PhotoResource(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      file: null == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as File,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      sizeInBytes: null == sizeInBytes
          ? _self.sizeInBytes
          : sizeInBytes // ignore: cast_nullable_to_non_nullable
              as int,
      creationTime: null == creationTime
          ? _self.creationTime
          : creationTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sequence: null == sequence
          ? _self.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int,
      thumbFile: null == thumbFile
          ? _self.thumbFile
          : thumbFile // ignore: cast_nullable_to_non_nullable
              as String,
      hide: null == hide
          ? _self.hide
          : hide // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class AebPhotoResource extends MediaResource {
  const AebPhotoResource(
      {required this.name,
      required this.file,
      required this.width,
      required this.height,
      required this.sizeInBytes,
      required this.creationTime,
      required this.sequence,
      required this.thumbFile,
      this.hide = false,
      required this.evBias})
      : super._();

  @override
  final String name;
  @override
  final File file;
  @override
  final int width;
  @override
  final int height;
  @override
  final int sizeInBytes;
  @override
  final DateTime creationTime;
  @override
  final int sequence;
  @override
  final String thumbFile;
  @override
  @JsonKey()
  final bool hide;

  /// aeb 特有
  final int evBias;

  /// Create a copy of MediaResource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AebPhotoResourceCopyWith<AebPhotoResource> get copyWith =>
      _$AebPhotoResourceCopyWithImpl<AebPhotoResource>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AebPhotoResource &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.sizeInBytes, sizeInBytes) ||
                other.sizeInBytes == sizeInBytes) &&
            (identical(other.creationTime, creationTime) ||
                other.creationTime == creationTime) &&
            (identical(other.sequence, sequence) ||
                other.sequence == sequence) &&
            (identical(other.thumbFile, thumbFile) ||
                other.thumbFile == thumbFile) &&
            (identical(other.hide, hide) || other.hide == hide) &&
            (identical(other.evBias, evBias) || other.evBias == evBias));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, file, width, height,
      sizeInBytes, creationTime, sequence, thumbFile, hide, evBias);

  @override
  String toString() {
    return 'MediaResource.aebPhoto(name: $name, file: $file, width: $width, height: $height, sizeInBytes: $sizeInBytes, creationTime: $creationTime, sequence: $sequence, thumbFile: $thumbFile, hide: $hide, evBias: $evBias)';
  }
}

/// @nodoc
abstract mixin class $AebPhotoResourceCopyWith<$Res>
    implements $MediaResourceCopyWith<$Res> {
  factory $AebPhotoResourceCopyWith(
          AebPhotoResource value, $Res Function(AebPhotoResource) _then) =
      _$AebPhotoResourceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      File file,
      int width,
      int height,
      int sizeInBytes,
      DateTime creationTime,
      int sequence,
      String thumbFile,
      bool hide,
      int evBias});
}

/// @nodoc
class _$AebPhotoResourceCopyWithImpl<$Res>
    implements $AebPhotoResourceCopyWith<$Res> {
  _$AebPhotoResourceCopyWithImpl(this._self, this._then);

  final AebPhotoResource _self;
  final $Res Function(AebPhotoResource) _then;

  /// Create a copy of MediaResource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? file = null,
    Object? width = null,
    Object? height = null,
    Object? sizeInBytes = null,
    Object? creationTime = null,
    Object? sequence = null,
    Object? thumbFile = null,
    Object? hide = null,
    Object? evBias = null,
  }) {
    return _then(AebPhotoResource(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      file: null == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as File,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      sizeInBytes: null == sizeInBytes
          ? _self.sizeInBytes
          : sizeInBytes // ignore: cast_nullable_to_non_nullable
              as int,
      creationTime: null == creationTime
          ? _self.creationTime
          : creationTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sequence: null == sequence
          ? _self.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int,
      thumbFile: null == thumbFile
          ? _self.thumbFile
          : thumbFile // ignore: cast_nullable_to_non_nullable
              as String,
      hide: null == hide
          ? _self.hide
          : hide // ignore: cast_nullable_to_non_nullable
              as bool,
      evBias: null == evBias
          ? _self.evBias
          : evBias // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class VideoResource extends MediaResource {
  const VideoResource(
      {required this.name,
      required this.file,
      required this.width,
      required this.height,
      required this.sizeInBytes,
      required this.creationTime,
      required this.sequence,
      required this.thumbFile,
      this.hide = false,
      required this.duration})
      : super._();

  @override
  final String name;
  @override
  final File file;
  @override
  final int width;
  @override
  final int height;
  @override
  final int sizeInBytes;
  @override
  final DateTime creationTime;
  @override
  final int sequence;
  @override
  final String thumbFile;
  @override
  @JsonKey()
  final bool hide;

  /// video 特有
  final Duration duration;

  /// Create a copy of MediaResource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoResourceCopyWith<VideoResource> get copyWith =>
      _$VideoResourceCopyWithImpl<VideoResource>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoResource &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.sizeInBytes, sizeInBytes) ||
                other.sizeInBytes == sizeInBytes) &&
            (identical(other.creationTime, creationTime) ||
                other.creationTime == creationTime) &&
            (identical(other.sequence, sequence) ||
                other.sequence == sequence) &&
            (identical(other.thumbFile, thumbFile) ||
                other.thumbFile == thumbFile) &&
            (identical(other.hide, hide) || other.hide == hide) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, file, width, height,
      sizeInBytes, creationTime, sequence, thumbFile, hide, duration);

  @override
  String toString() {
    return 'MediaResource.video(name: $name, file: $file, width: $width, height: $height, sizeInBytes: $sizeInBytes, creationTime: $creationTime, sequence: $sequence, thumbFile: $thumbFile, hide: $hide, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $VideoResourceCopyWith<$Res>
    implements $MediaResourceCopyWith<$Res> {
  factory $VideoResourceCopyWith(
          VideoResource value, $Res Function(VideoResource) _then) =
      _$VideoResourceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      File file,
      int width,
      int height,
      int sizeInBytes,
      DateTime creationTime,
      int sequence,
      String thumbFile,
      bool hide,
      Duration duration});
}

/// @nodoc
class _$VideoResourceCopyWithImpl<$Res>
    implements $VideoResourceCopyWith<$Res> {
  _$VideoResourceCopyWithImpl(this._self, this._then);

  final VideoResource _self;
  final $Res Function(VideoResource) _then;

  /// Create a copy of MediaResource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? file = null,
    Object? width = null,
    Object? height = null,
    Object? sizeInBytes = null,
    Object? creationTime = null,
    Object? sequence = null,
    Object? thumbFile = null,
    Object? hide = null,
    Object? duration = null,
  }) {
    return _then(VideoResource(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      file: null == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as File,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      sizeInBytes: null == sizeInBytes
          ? _self.sizeInBytes
          : sizeInBytes // ignore: cast_nullable_to_non_nullable
              as int,
      creationTime: null == creationTime
          ? _self.creationTime
          : creationTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sequence: null == sequence
          ? _self.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int,
      thumbFile: null == thumbFile
          ? _self.thumbFile
          : thumbFile // ignore: cast_nullable_to_non_nullable
              as String,
      hide: null == hide
          ? _self.hide
          : hide // ignore: cast_nullable_to_non_nullable
              as bool,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

// dart format on

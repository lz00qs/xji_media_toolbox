import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_resource.freezed.dart';

abstract class MediaResource {
  final bool isVideo;
  final String name;
  final File file;
  final int width;
  final int height;
  final int sizeInBytes;
  final DateTime creationTime;
  final int sequence;
  final isAeb = false;
  File? thumbFile;
  final Map<int, List<String>> errors = {};
  bool hide = false;

  MediaResource(
      {required this.isVideo,
      required this.name,
      required this.file,
      required this.width,
      required this.height,
      required this.sizeInBytes,
      required this.creationTime,
      required this.sequence});

  @override
  bool operator ==(Object other) {
    return file.path == (other as MediaResource).file.path;
  }

  @override
  int get hashCode => Object.hashAll([file.path]);

  MediaResource copyWith({
    bool? isVideo,
    String? name,
    File? file,
    int? width,
    int? height,
    int? sizeInBytes,
    DateTime? creationTime,
    int? sequence,
    bool? isAeb,
    File? thumbFile,
    Map<int, List<String>>? errors,
    bool? hide,
  });
}

class NormalPhotoResource extends MediaResource {
  NormalPhotoResource(
      {required super.name,
      required super.file,
      required super.width,
      required super.height,
      required super.sizeInBytes,
      required super.creationTime,
      required super.sequence})
      : super(isVideo: false);

  @override
  NormalPhotoResource copyWith({
    bool? isVideo,
    String? name,
    File? file,
    int? width,
    int? height,
    int? sizeInBytes,
    DateTime? creationTime,
    int? sequence,
    bool? isAeb,
    File? thumbFile,
    Map<int, List<String>>? errors,
    bool? hide,
  }) {
    return NormalPhotoResource(
      name: name ?? this.name,
      file: file ?? this.file,
      width: width ?? this.width,
      height: height ?? this.height,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      creationTime: creationTime ?? this.creationTime,
      sequence: sequence ?? this.sequence,
    )..thumbFile = thumbFile ?? this.thumbFile;
  }
}

class AebPhotoResource extends MediaResource {
  final String evBias;
  final List<AebPhotoResource> aebResources = [];

  @override
  get isAeb => true;

  AebPhotoResource(
      {required super.name,
      required super.file,
      required super.width,
      required super.height,
      required super.sizeInBytes,
      required super.creationTime,
      required super.sequence,
      required this.evBias})
      : super(isVideo: false);

  @override
  AebPhotoResource copyWith({
    bool? isVideo,
    String? name,
    File? file,
    int? width,
    int? height,
    int? sizeInBytes,
    DateTime? creationTime,
    int? sequence,
    bool? isAeb,
    File? thumbFile,
    Map<int, List<String>>? errors,
    bool? hide,
    String? evBias,
    List<AebPhotoResource>? aebResources,
  }) {
    return AebPhotoResource(
      name: name ?? this.name,
      file: file ?? this.file,
      width: width ?? this.width,
      height: height ?? this.height,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      creationTime: creationTime ?? this.creationTime,
      sequence: sequence ?? this.sequence,
      evBias: evBias ?? this.evBias,
    )
      ..aebResources.addAll(aebResources ?? this.aebResources)
      ..thumbFile = thumbFile ?? this.thumbFile;
  }
}

class NormalVideoResource extends MediaResource {
  final double frameRate;
  final Duration duration;
  final bool isHevc;

  NormalVideoResource(
      {required super.name,
      required super.file,
      required super.width,
      required super.height,
      required super.sizeInBytes,
      required super.creationTime,
      required super.sequence,
      required this.frameRate, // fps
      required this.duration,
      required this.isHevc})
      : super(isVideo: true);

  @override
  NormalVideoResource copyWith({
    bool? isVideo,
    String? name,
    File? file,
    int? width,
    int? height,
    int? sizeInBytes,
    DateTime? creationTime,
    int? sequence,
    bool? isAeb,
    File? thumbFile,
    Map<int, List<String>>? errors,
    bool? hide,
    double? frameRate,
    Duration? duration,
    bool? isHevc,
  }) {
    return NormalVideoResource(
      name: name ?? this.name,
      file: file ?? this.file,
      width: width ?? this.width,
      height: height ?? this.height,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      creationTime: creationTime ?? this.creationTime,
      sequence: sequence ?? this.sequence,
      frameRate: frameRate ?? this.frameRate,
      duration: duration ?? this.duration,
      isHevc: isHevc ?? this.isHevc,
    )..thumbFile = thumbFile ?? this.thumbFile;
  }
}

@freezed
abstract class MediaResources with _$MediaResources {
  const factory MediaResources({
    @Default(false) bool isLoading,
    @Default(false) bool isMerging,
    @Default(<MediaResource>[]) List<MediaResource> resources,
    @Default(0) int currentIndex,
    @Default(0.0) double loadProgress,
    @Default(false) bool isMultipleSelection,
    @Default(<MediaResource>[]) List<MediaResource> selectedResources,
    @Default(0) int currentAebIndex,
    @Default("") String resourcesPath,
    @Default(false) bool isEditing,
  }) = _MediaResources;
}

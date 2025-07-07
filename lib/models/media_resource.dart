import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
}

class AebPhotoResource extends NormalPhotoResource {
  final String evBias;
  final List<MediaResource> aebResources = [];

  @override
  get isAeb => true;

  AebPhotoResource({
    required super.name,
    required super.file,
    required super.width,
    required super.height,
    required super.sizeInBytes,
    required super.creationTime,
    required super.sequence,
    required this.evBias,
  });
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
}

@freezed
class MediaResources with _$MediaResources {
  MediaResources({
    required this.isLoading,
    required this.resources,
    required this.currentIndex,
    required this.loadProgress,
    required this.isMultipleSelection,
  });

  @override
  final bool isLoading;
  @override
  final List<MediaResource> resources;
  @override
  final int currentIndex;
  @override
  final double loadProgress;
  @override
  final bool isMultipleSelection;

  @override
  var resourcesPath = "";

  factory MediaResources.initial() {
    return MediaResources(
      isLoading: false,
      resources: [],
      currentIndex: 0,
      loadProgress: 0,
      isMultipleSelection: false,
    );
  }
}

final mediaResourcesProvider =
    StateNotifierProvider<MediaResourceProvider, MediaResources>(
        (ref) => MediaResourceProvider());

class MediaResourceProvider extends StateNotifier<MediaResources> {
  MediaResourceProvider() : super(MediaResources.initial());

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setResources(List<MediaResource> resources) {
    state = state.copyWith(resources: resources);
  }

  void setCurrentIndex(int currentIndex) {
    state = state.copyWith(currentIndex: currentIndex);
  }

  void setLoadProgress(double loadProgress) {
    state = state.copyWith(loadProgress: loadProgress);
  }

  void removeResource(int index) {
    state = state.copyWith(resources: state.resources..removeAt(index));
  }

  void setIsMultipleSelection(bool isMultipleSelection) {
    state = state.copyWith(isMultipleSelection: isMultipleSelection);
  }
}

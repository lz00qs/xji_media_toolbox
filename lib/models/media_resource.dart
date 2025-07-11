import 'dart:ffi';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/settings.dart';

import '../utils/media_resources_utils.dart';

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
class MediaResources with _$MediaResources {
  MediaResources({
    required this.isLoading,
    required this.resources,
    required this.currentIndex,
    required this.loadProgress,
    required this.isMultipleSelection,
    required this.selectedResources,
    required this.currentAebIndex,
    required this.isEditing,
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
  final int currentAebIndex;

  @override
  final List<MediaResource> selectedResources;

  @override
  var resourcesPath = "";

  @override
  final bool isEditing;

  factory MediaResources.initial() {
    return MediaResources(
      isLoading: false,
      resources: [],
      currentIndex: 0,
      loadProgress: 0,
      isMultipleSelection: false,
      selectedResources: [],
      currentAebIndex: 0,
      isEditing: false,
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
    if (state.currentIndex == currentIndex) {
      return;
    }
    state = state.copyWith(
        currentIndex: currentIndex, currentAebIndex: 0, isEditing: false);
  }

  void increaseCurrentIndex() {
    if (state.currentIndex < state.resources.length - 1) {
      state = state.copyWith(
          currentIndex: state.currentIndex + 1, currentAebIndex: 0);
    }
  }

  void decreaseCurrentIndex() {
    if (state.currentIndex > 0) {
      state = state.copyWith(
          currentIndex: state.currentIndex - 1, currentAebIndex: 0);
    }
  }

  void setCurrentAebIndex(int currentAebIndex) {
    state = state.copyWith(currentAebIndex: currentAebIndex);
  }

  void increaseCurrentAebIndex() {
    if (state.resources[state.currentIndex] is AebPhotoResource) {
      if (state.currentAebIndex <
          (state.resources[state.currentIndex] as AebPhotoResource)
                  .aebResources
                  .length -
              1) {
        state = state.copyWith(currentAebIndex: state.currentAebIndex + 1);
      }
    }
  }

  void decreaseCurrentAebIndex() {
    if (state.currentAebIndex > 0) {
      state = state.copyWith(currentAebIndex: state.currentAebIndex - 1);
    }
  }

  void setLoadProgress(double loadProgress) {
    state = state.copyWith(loadProgress: loadProgress);
  }

  void removeResource({required MediaResource resource}) {
    if (resource.isAeb) {
      final aebResource = resource as AebPhotoResource;
      for (final aebResource in aebResource.aebResources) {
        if (deleteMediaResource(mediaResource: aebResource) != 0) {
          return;
        }
      }
    } else {
      if (deleteMediaResource(mediaResource: resource) != 0) {
        return;
      }
    }
    if (state.resources.indexOf(resource) == state.currentIndex) {
      if (state.currentIndex == state.resources.length - 1) {
        state = state.copyWith(currentIndex: state.currentIndex - 1);
      }
    }
    state = state.copyWith(
        resources: state.resources..remove(resource),
        selectedResources: state.selectedResources..remove(resource));
  }

  void renameResource(
      {required MediaResource resource, required String newName}) {
    switch (resource) {
      case NormalPhotoResource():
      case NormalVideoResource():
        final newFile =
            renameMediaResource(mediaResource: resource, newName: newName);
        if (newFile == null) {
          return;
        }
        state = state.copyWith(resources: [
          ...state.resources.map((element) => element.name == resource.name
              ? (resource.isVideo
                  ? element.copyWith(name: newName, file: newFile)
                  : element.copyWith(
                      name: newName, file: newFile, thumbFile: newFile))
              : element)
        ]);
        break;
      case AebPhotoResource():
        final aebParentResource = state.resources[state.currentIndex];
        final aebResource = (aebParentResource as AebPhotoResource)
            .aebResources[state.currentAebIndex];
        final newFile =
            renameMediaResource(mediaResource: aebResource, newName: newName);
        if (newFile == null) {
          return;
        }

        late MediaResource newMediaResource;
        if (aebParentResource.name == resource.name) {
          newMediaResource = aebParentResource
              .copyWith(name: newName, thumbFile: newFile, aebResources: [
            ...aebParentResource.aebResources.map((element) =>
                element.name == aebResource.name
                    ? element.copyWith(
                        name: newName, file: newFile, thumbFile: newFile)
                    : element)
          ]);
        } else {
          newMediaResource = aebParentResource.copyWith(aebResources: [
            ...aebParentResource.aebResources.map((element) =>
                element.name == aebResource.name
                    ? element.copyWith(
                        name: newName, file: newFile, thumbFile: newFile)
                    : element)
          ]);
        }
        state = state.copyWith(resources: [
          ...state.resources.map((element) =>
              element.name == aebParentResource.name
                  ? newMediaResource
                  : element)
        ]);
        break;
    }
  }

  void addAebSuffixToCurrentAebFilesName() {
    var aebResource = state.resources[state.currentIndex] as AebPhotoResource;
    final oldName = aebResource.name;
    aebResource = addSuffixToAebFilesName(aebResource: aebResource);
    state = state.copyWith(resources: [
      ...state.resources
          .map((element) => element.name == oldName ? aebResource : element)
    ]);
  }

  void setIsMultipleSelection(bool isMultipleSelection) {
    state = state.copyWith(isMultipleSelection: isMultipleSelection);
  }

  void toggleIsMultipleSelection() {
    state = state.copyWith(isMultipleSelection: !state.isMultipleSelection);
  }

  void addSelectedResource(MediaResource resource) {
    state = state.copyWith(
        selectedResources: state.selectedResources..add(resource));
  }

  void removeSelectedResource(MediaResource resource) {
    state = state.copyWith(
        selectedResources: state.selectedResources..remove(resource));
  }

  void reorderSelectedResources(
      {required int oldIndex, required int newIndex}) {
    if (oldIndex < newIndex) newIndex -= 1;
    final updated = [...(state.selectedResources)];
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    state = state.copyWith(selectedResources: updated);
  }

  void clearSelectedResources() {
    state = state.copyWith(selectedResources: []);
  }

  void setIsEditing(bool isEditing) {
    state = state.copyWith(isEditing: isEditing);
  }

  // sorAsc: true -> asc, false -> desc
  void sortResources({required SortType sortType, required bool sortAsc}) {
    switch (sortType) {
      case SortType.name:
        final newList = state.resources.map((e) => e).toList();
        newList.sort((a, b) =>
            sortAsc ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        state = state.copyWith(resources: newList, currentIndex: 0);
        break;
      case SortType.date:
        final newList = state.resources.map((e) => e).toList();
        newList.sort((a, b) => sortAsc
            ? a.creationTime.compareTo(b.creationTime)
            : b.creationTime.compareTo(a.creationTime));
        state = state.copyWith(resources: newList, currentIndex: 0);
        break;
      case SortType.size:
        final newList = state.resources.map((e) => e).toList();
        newList.sort((a, b) => sortAsc
            ? a.sizeInBytes.compareTo(b.sizeInBytes)
            : b.sizeInBytes.compareTo(a.sizeInBytes));
        state = state.copyWith(resources: newList, currentIndex: 0);
        break;
      case SortType.sequence:
        final newList = state.resources.map((e) => e).toList();
        newList.sort((a, b) => sortAsc
            ? a.sequence.compareTo(b.sequence)
            : b.sequence.compareTo(a.sequence));
        state = state.copyWith(resources: newList, currentIndex: 0);
        break;
    }
  }
}

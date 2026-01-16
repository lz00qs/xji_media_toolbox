import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/media_resource.dart';
import '../models/settings.dart';
import '../utils/media_resources_utils.dart';

part 'media_resources_provider.g.dart';

@riverpod
class MediaResourcesNotifier extends _$MediaResourcesNotifier {
  @override
  MediaResources build() {
    return MediaResources();
  }

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

  void setIsMerging(bool isMerging) {
    state = state.copyWith(isMerging: isMerging);
  }
}

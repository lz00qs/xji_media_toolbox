import 'package:freezed_annotation/freezed_annotation.dart';

import 'media_resource.model.dart';

part 'media_resources_state.model.freezed.dart';

@freezed
abstract class MediaResourcesState with _$MediaResourcesState {
  const factory MediaResourcesState({
    @Default(false) bool isLoading,
    @Default(<MediaResource>[]) List<MediaResource> resources,
    @Default(0) int currentResourceIndex,
    @Default(0) int currentAebIndex,
    @Default(0.0) double loadProgress,
    @Default(false) bool isMultipleSelection,
    @Default(<MediaResource>[]) List<MediaResource> selectedResources,
    @Default("") String resourcesPath,
  }) = _MediaResourcesState;
}

import 'dart:async';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/utils/logger.dart';

import '../constants.dart';
import '../models/media_resource.model.dart';
import '../models/media_resources_state.model.dart';
import '../models/settings.model.dart';
import '../services/media_analyzer.dart';
import '../utils/toast.dart';

part 'media_resources_state.notifier.g.dart';

final stopwatch = Stopwatch();
var _mediaResourcesCount = 0;
var _processedMediaResourcesCount = 0;

@Riverpod(keepAlive: true)
class MediaResourcesStateNotifier extends _$MediaResourcesStateNotifier {
  MediaResourcesStateNotifier({MediaAnalyzer? analyzer})
    : _analyzer = analyzer ?? MediaAnalyzer();

  final MediaAnalyzer _analyzer;

  @override
  MediaResourcesState build() {
    return MediaResourcesState();
  }

  void toggleIsMultipleSelection() {
    state = state.copyWith(isMultipleSelection: !state.isMultipleSelection);
  }

  void _clearState() {
    state = MediaResourcesState();
    _mediaResourcesCount = 0;
    _processedMediaResourcesCount = 0;
  }

  Future<void> loadMediaResourcesFromDir(
    String resourcesPath,
    bool isDebugMode,
    int cpuThreads,
    Sort sort,
  ) async {
    _clearState();
    state = state.copyWith(isLoading: true, resourcesPath: resourcesPath);
    final mediaResourcesDir = Directory(resourcesPath);
    if (!mediaResourcesDir.existsSync()) {
      _clearState();
      return;
    }
    if (isDebugMode) {
      await Logger.enableFileOutput('$resourcesPath/$logFolderName');
    }

    stopwatch.reset();
    stopwatch.start();

    _analyzer.prepareThumbnailFolder(resourcesPath);

    final classified = _analyzer.classifyMediaResources(
      mediaResourcesDir.listSync(),
    );
    _mediaResourcesCount = classified.total;

    Logger.debug('classifyTime: ${stopwatch.elapsedMilliseconds}ms');

    final photos = classified.photos;
    var processedPhotos = <MediaResource>[];
    final videos = classified.videos;
    var processedVideos = <MediaResource>[];

    Logger.debug('photos: ${photos.length}');
    Logger.debug('videos: ${videos.length}');

    processedPhotos = await _multiThreadProcess(
      mediaResourceFiles: photos,
      processFunc: _analyzer.processPhoto,
      cpuThreads: cpuThreads,
    );
    processedPhotos.sort((a, b) => a.name.compareTo(b.name));
    processedPhotos = _analyzer.groupAebFootage(processedPhotos);
    Logger.debug('processedPhotos: ${processedPhotos.length}');
    Logger.debug('Photo processTime: ${stopwatch.elapsedMilliseconds}ms');

    processedVideos = await _multiThreadProcess(
      mediaResourceFiles: videos,
      processFunc: _analyzer.processVideo,
      cpuThreads: cpuThreads,
    );
    Logger.debug('processedVideos: ${processedVideos.length}');
    Logger.debug('Video processTime: ${stopwatch.elapsedMilliseconds}ms');

    final mediaResources = [...processedPhotos, ...processedVideos];

    final sortType = sort.sortType;
    final sortAsc = sort.sortAsc;

    switch (sortType) {
      case SortType.name:
        mediaResources.sort(
          (a, b) =>
              sortAsc ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
        break;
      case SortType.date:
        mediaResources.sort(
          (a, b) => sortAsc
              ? a.creationTime.compareTo(b.creationTime)
              : b.creationTime.compareTo(a.creationTime),
        );
        break;
      case SortType.size:
        mediaResources.sort(
          (a, b) => sortAsc
              ? a.sizeInBytes.compareTo(b.sizeInBytes)
              : b.sizeInBytes.compareTo(a.sizeInBytes),
        );
        break;
      case SortType.sequence:
        mediaResources.sort(
          (a, b) => sortAsc
              ? a.sequence.compareTo(b.sequence)
              : b.sequence.compareTo(a.sequence),
        );
        break;
    }

    Logger.debug("sortTime: ${stopwatch.elapsedMilliseconds}ms");
    stopwatch.stop();

    state = state.copyWith(resources: mediaResources, isLoading: false);
  }

  void setCurrentResourceIndex(int index) {
    if (index < state.resources.length) {
      state = state.copyWith(currentResourceIndex: index);
      if (state.resources[index] is AebPhotoResource) {
        state = state.copyWith(currentAebIndex: 0);
      }
    }
  }

  void increaseCurrentResourceIndex() {
    if (state.currentResourceIndex < state.resources.length - 1) {
      setCurrentResourceIndex(state.currentResourceIndex + 1);
    }
  }

  void decreaseCurrentResourceIndex() {
    if (state.currentResourceIndex > 0) {
      setCurrentResourceIndex(state.currentResourceIndex - 1);
    }
  }

  void setCurrentAebIndex(int index) {
    if (state.resources[state.currentResourceIndex] is AebPhotoResource) {
      if (index <
          (state.resources[state.currentResourceIndex] as AebPhotoResource)
              .aebResources
              .length) {
        state = state.copyWith(currentAebIndex: index);
      }
    }
  }

  void increaseCurrentAebIndex() {
    if (state.resources[state.currentResourceIndex] is AebPhotoResource) {
      if (state.currentAebIndex <
          (state.resources[state.currentResourceIndex] as AebPhotoResource)
                  .aebResources
                  .length -
              1) {
        setCurrentAebIndex(state.currentAebIndex + 1);
      }
    }
  }

  void decreaseCurrentAebIndex() {
    if (state.resources[state.currentResourceIndex] is AebPhotoResource) {
      if (state.currentAebIndex > 0) {
        setCurrentAebIndex(state.currentAebIndex - 1);
      }
    }
  }

  void clearSelectedResources() {
    state = state.copyWith(selectedResources: []);
  }

  void addSelectedResource(MediaResource mediaResource) {
    state = state.copyWith(
      selectedResources: [...state.selectedResources, mediaResource],
    );
  }

  void removeSelectedResource(MediaResource mediaResource) {
    state = state.copyWith(
      selectedResources: state.selectedResources
          .where((e) => e != mediaResource)
          .toList(),
    );
  }

  void sortMediaResources(Sort sort) {
    final resources = state.resources.toList();

    switch (sort.sortType) {
      case SortType.name:
        resources.sort(
          (a, b) => sort.sortAsc
              ? a.name.compareTo(b.name)
              : b.name.compareTo(a.name),
        );
        break;
      case SortType.date:
        resources.sort(
          (a, b) => sort.sortAsc
              ? a.creationTime.compareTo(b.creationTime)
              : b.creationTime.compareTo(a.creationTime),
        );
        break;
      case SortType.size:
        resources.sort(
          (a, b) => sort.sortAsc
              ? a.sizeInBytes.compareTo(b.sizeInBytes)
              : b.sizeInBytes.compareTo(a.sizeInBytes),
        );
        break;
      case SortType.sequence:
        resources.sort(
          (a, b) => sort.sortAsc
              ? a.sequence.compareTo(b.sequence)
              : b.sequence.compareTo(a.sequence),
        );
        break;
    }
    state = state.copyWith(resources: resources);
  }

  Future<List<MediaResource>> _multiThreadProcess({
    required List<File> mediaResourceFiles,
    required Future<MediaResource?> Function(File mediaResourceFile)
    processFunc,
    required int cpuThreads,
  }) async {
    final mediaResources = <MediaResource>[];
    final pool = _Pool(cpuThreads);
    final tasks = mediaResourceFiles.map((file) {
      return pool.run(() async {
        final mediaResource = await processFunc(file);
        if (mediaResource != null) {
          mediaResources.add(mediaResource);
          _processedMediaResourcesCount++;
          state = state.copyWith(
            loadProgress: _processedMediaResourcesCount / _mediaResourcesCount,
          );
          Logger.debug(
            '${file.uri.pathSegments.last} processed | loadProgress: ${_processedMediaResourcesCount / _mediaResourcesCount}',
          );
        }
      });
    });

    await Future.wait(tasks);

    return mediaResources;
  }

  void reorderSelectedResources({
    required int oldIndex,
    required int newIndex,
  }) {
    final updated = [...(state.selectedResources)];
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    state = state.copyWith(selectedResources: updated);
  }

  Future<void> _deleteResource(MediaResource mediaResource) async {
    final mediaResourceIndex = state.resources.indexOf(mediaResource);
    if (mediaResourceIndex != -1) {
      if (mediaResourceIndex == state.currentResourceIndex) {
        if (mediaResourceIndex != 0 &&
            (mediaResourceIndex == state.resources.length - 1)) {
          setCurrentResourceIndex(state.currentResourceIndex - 1);
        }
      }
      state = state.copyWith(
        resources: state.resources.where((e) => e != mediaResource).toList(),
      );
      switch (mediaResource) {
        case PhotoResource():
        case VideoResource():
          try {
            await mediaResource.file.delete();
          } catch (e) {
            Logger.error(
              'Delete media resource ${mediaResource.file.uri.pathSegments.last} failed: $e',
            );
            Toast.error(
              'Delete media resource ${mediaResource.file.uri.pathSegments.last} failed: $e',
            );
          }
          if (mediaResource is VideoResource) {
            try {
              await mediaResource.thumbFile.delete();
            } catch (e) {
              Logger.error(
                'Delete media resource thumbnail ${mediaResource.thumbFile.uri.pathSegments.last} failed: $e',
              );
              Toast.error(
                'Delete media resource thumbnail ${mediaResource.thumbFile.uri.pathSegments.last} failed: $e',
              );
            }
          }
          break;
        case AebPhotoResource():
          for (final aebResource in mediaResource.aebResources) {
            try {
              await aebResource.file.delete();
            } catch (e) {
              Logger.error(
                'Delete media resource ${aebResource.file.uri.pathSegments.last} failed: $e',
              );
              Toast.error(
                'Delete media resource ${aebResource.file.uri.pathSegments.last} failed: $e',
              );
            }
          }
          break;
      }
    }
  }

  Future<void> deleteCurrentMediaResource() async {
    if (state.currentResourceIndex != -1) {
      await _deleteResource(state.resources[state.currentResourceIndex]);
    }
  }

  Future<void> deleteSelectedMediaResources() async {
    for (final mediaResource in state.selectedResources) {
      await _deleteResource(mediaResource);
    }
  }

  Future<void> _renameResource(
    MediaResource mediaResource,
    String newName,
  ) async {
    final mediaResourceIndex = state.resources.indexOf(mediaResource);
    if (mediaResourceIndex != -1) {
      final ext = mediaResource.file.path.split('.').last;
      switch (mediaResource) {
        case PhotoResource():
        case VideoResource():
          try {
            await mediaResource.file.rename(
              '${mediaResource.file.parent.path}/$newName.$ext',
            );
            state = state.copyWith(
              resources: [
                ...state.resources.sublist(0, mediaResourceIndex),
                mediaResource.copyWith(
                  name: '$newName.$ext',
                  file: File('${mediaResource.file.parent.path}/$newName.$ext'),
                  thumbFile: (mediaResource is PhotoResource)
                      ? File('${mediaResource.file.parent.path}/$newName.$ext')
                      : mediaResource.thumbFile,
                ),
                ...state.resources.sublist(mediaResourceIndex + 1),
              ],
            );
          } catch (e) {
            Logger.error(
              'Rename media resource ${mediaResource.file.uri.pathSegments.last} to $newName failed: $e',
            );
            Toast.error(
              'Rename media resource ${mediaResource.file.uri.pathSegments.last} to $newName failed: $e',
            );
          }
          break;
        case AebPhotoResource():
          final List<AebPhotoResource> newAebResources = [];
          for (final aebResource in mediaResource.aebResources) {
            try {
              final aebNewName = '${newName}_AEB_${aebResource.evBias}';
              await aebResource.file.rename(
                '${aebResource.file.parent.path}/$aebNewName.$ext',
              );
              newAebResources.add(
                aebResource.copyWith(
                  name: '$aebNewName.$ext',
                  file: File(
                    '${aebResource.file.parent.path}/$aebNewName.$ext',
                  ),
                  thumbFile: File(
                    '${aebResource.file.parent.path}/$aebNewName.$ext',
                  ),
                ),
              );
            } catch (e) {
              Logger.error(
                'Rename media resource ${aebResource.file.uri.pathSegments.last} to $newName failed: $e',
              );
              Toast.error(
                'Rename media resource ${aebResource.file.uri.pathSegments.last} to $newName failed: $e',
              );
            }
          }
          state = state.copyWith(
            resources: [
              ...state.resources.sublist(0, mediaResourceIndex),
              newAebResources.first.copyWith(aebResources: newAebResources),
              ...state.resources.sublist(mediaResourceIndex + 1),
            ],
          );
          break;
      }
    }
  }

  Future<void> renameCurrentMediaResource(String newName) async {
    if (state.currentResourceIndex != -1) {
      await _renameResource(
        state.resources[state.currentResourceIndex],
        newName,
      );
    }
  }

  Future<void> addAebSuffixToCurrentAebFilesName() async {
    if (state.currentResourceIndex != -1) {
      final mediaResource = state.resources[state.currentResourceIndex];
      if (mediaResource is AebPhotoResource) {
        await renameCurrentMediaResource(
          mediaResource.name.substring(0, mediaResource.name.lastIndexOf('.')),
        );
      }
    }
  }
}

class _Pool {
  _Pool(int max) : max = max < 1 ? 1 : max;

  final int max;
  int _running = 0;
  final _queue = <Future<void> Function()>[];

  Future<T> run<T>(Future<T> Function() task) {
    final completer = Completer<T>();
    _queue.add(() async {
      try {
        completer.complete(await task());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      } finally {
        _running--;
        _next();
      }
    });
    _next();
    return completer.future;
  }

  void _next() {
    if (_running >= max || _queue.isEmpty) return;
    _running++;
    _queue.removeAt(0)();
  }
}

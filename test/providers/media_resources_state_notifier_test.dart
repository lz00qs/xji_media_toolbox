import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:xji_footage_toolbox/models/media_resource.model.dart';
import 'package:xji_footage_toolbox/models/media_resources_state.model.dart';
import 'package:xji_footage_toolbox/models/settings.model.dart';
import 'package:xji_footage_toolbox/providers/media_resources_state.notifier.dart';
import 'package:xji_footage_toolbox/services/file_trash_service.dart';

import '../helpers/media_fixtures.dart';
import '../helpers/test_environment.dart';

void main() {
  late Directory temporaryDirectory;
  late List<String> errors;

  Future<File> createFile(String name) async {
    final file = File(p.join(temporaryDirectory.path, name));
    await file.writeAsString('fixture');
    return file;
  }

  setUp(() async {
    temporaryDirectory = await createTestDirectory('media-state-test');
    errors = [];
  });

  tearDown(() => deleteTestDirectory(temporaryDirectory));

  test('uses the injected initial state and toggles multiple selection', () {
    final initial = MediaResourcesState(
      resources: [photoFixture()],
      resourcesPath: '/fixtures',
    );
    final container = _container(initial, errors);
    addTearDown(container.dispose);
    final notifier = container.read(mediaResourcesStateProvider.notifier);

    expect(container.read(mediaResourcesStateProvider), initial);
    notifier.toggleIsMultipleSelection();
    expect(
      container.read(mediaResourcesStateProvider).isMultipleSelection,
      isTrue,
    );
    notifier.toggleIsMultipleSelection();
    expect(
      container.read(mediaResourcesStateProvider).isMultipleSelection,
      isFalse,
    );
  });

  test('navigates resources within bounds and resets the AEB index', () {
    final members = [
      aebPhotoFixture(name: '0.JPG', evBias: '0'),
      aebPhotoFixture(name: '1.JPG', evBias: '-0.7'),
    ];
    final aeb = members.first.copyWith(aebResources: members);
    final initial = MediaResourcesState(
      resources: [photoFixture(), aeb, videoFixture()],
      currentAebIndex: 1,
    );
    final container = _container(initial, errors);
    addTearDown(container.dispose);
    final notifier = container.read(mediaResourcesStateProvider.notifier);

    notifier.setCurrentResourceIndex(-1);
    expect(container.read(mediaResourcesStateProvider).currentResourceIndex, 0);
    notifier.setCurrentResourceIndex(1);
    expect(container.read(mediaResourcesStateProvider).currentResourceIndex, 1);
    expect(container.read(mediaResourcesStateProvider).currentAebIndex, 0);
    notifier.increaseCurrentResourceIndex();
    notifier.increaseCurrentResourceIndex();
    expect(container.read(mediaResourcesStateProvider).currentResourceIndex, 2);
    notifier.decreaseCurrentResourceIndex();
    expect(container.read(mediaResourcesStateProvider).currentResourceIndex, 1);
    notifier.setCurrentResourceIndex(99);
    expect(container.read(mediaResourcesStateProvider).currentResourceIndex, 1);
  });

  test('navigates AEB members safely and ignores invalid indices', () {
    final members = [
      aebPhotoFixture(name: '0.JPG', evBias: '0'),
      aebPhotoFixture(name: '1.JPG', evBias: '-0.7'),
      aebPhotoFixture(name: '2.JPG', evBias: '+0.7'),
    ];
    final initial = MediaResourcesState(
      resources: [members.first.copyWith(aebResources: members)],
    );
    final container = _container(initial, errors);
    addTearDown(container.dispose);
    final notifier = container.read(mediaResourcesStateProvider.notifier);

    notifier.setCurrentAebIndex(-1);
    notifier.increaseCurrentAebIndex();
    notifier.increaseCurrentAebIndex();
    notifier.increaseCurrentAebIndex();
    expect(container.read(mediaResourcesStateProvider).currentAebIndex, 2);
    notifier.decreaseCurrentAebIndex();
    notifier.setCurrentAebIndex(99);
    expect(container.read(mediaResourcesStateProvider).currentAebIndex, 1);

    final emptyContainer = _container(const MediaResourcesState(), errors);
    addTearDown(emptyContainer.dispose);
    final emptyNotifier = emptyContainer.read(
      mediaResourcesStateProvider.notifier,
    );
    expect(() => emptyNotifier.setCurrentAebIndex(0), returnsNormally);
    expect(() => emptyNotifier.increaseCurrentAebIndex(), returnsNormally);
  });

  test('adds, removes, clears, and reorders selected resources', () {
    final first = photoFixture(name: 'a.JPG');
    final second = videoFixture(name: 'b.MP4');
    final third = photoFixture(name: 'c.JPG');
    final container = _container(const MediaResourcesState(), errors);
    addTearDown(container.dispose);
    final notifier = container.read(mediaResourcesStateProvider.notifier);

    notifier.addSelectedResource(first);
    notifier.addSelectedResource(second);
    notifier.addSelectedResource(third);
    notifier.reorderSelectedResources(oldIndex: 0, newIndex: 2);
    expect(container.read(mediaResourcesStateProvider).selectedResources, [
      second,
      third,
      first,
    ]);
    notifier.removeSelectedResource(third);
    expect(container.read(mediaResourcesStateProvider).selectedResources, [
      second,
      first,
    ]);
    notifier.clearSelectedResources();
    expect(
      container.read(mediaResourcesStateProvider).selectedResources,
      isEmpty,
    );
  });

  test('sorts resources by every supported key in both directions', () {
    final alpha = photoFixture(
      name: 'a.JPG',
      sizeInBytes: 300,
      sequence: 2,
      creationTime: DateTime(2024, 1, 3),
    );
    final bravo = photoFixture(
      name: 'b.JPG',
      sizeInBytes: 100,
      sequence: 3,
      creationTime: DateTime(2024, 1, 1),
    );
    final charlie = photoFixture(
      name: 'c.JPG',
      sizeInBytes: 200,
      sequence: 1,
      creationTime: DateTime(2024, 1, 2),
    );
    final container = _container(
      MediaResourcesState(resources: [charlie, alpha, bravo]),
      errors,
    );
    addTearDown(container.dispose);
    final notifier = container.read(mediaResourcesStateProvider.notifier);

    final expectedAscending = {
      SortType.name: [alpha, bravo, charlie],
      SortType.date: [bravo, charlie, alpha],
      SortType.size: [bravo, charlie, alpha],
      SortType.sequence: [charlie, alpha, bravo],
    };
    for (final entry in expectedAscending.entries) {
      notifier.sortMediaResources(Sort(sortType: entry.key));
      expect(
        container.read(mediaResourcesStateProvider).resources,
        entry.value,
      );
      notifier.sortMediaResources(Sort(sortType: entry.key, sortAsc: false));
      expect(
        container.read(mediaResourcesStateProvider).resources,
        entry.value.reversed,
      );
    }
  });

  test(
    'moves photo and video files to trash and keeps state consistent',
    () async {
      final photoFile = await createFile('photo.JPG');
      final videoFile = await createFile('video.MP4');
      final thumbFile = await createFile('video.thumb.JPG');
      final photo = photoFixture(file: photoFile);
      final video = videoFixture(file: videoFile, thumbFile: thumbFile);
      final container = _container(
        MediaResourcesState(
          resources: [photo, video],
          currentResourceIndex: 1,
          selectedResources: [photo, video],
        ),
        errors,
      );
      addTearDown(container.dispose);
      final notifier = container.read(mediaResourcesStateProvider.notifier);

      await notifier.deleteCurrentMediaResource();
      var state = container.read(mediaResourcesStateProvider);
      expect(state.resources, [photo]);
      expect(state.selectedResources, [photo]);
      expect(state.currentResourceIndex, 0);
      expect(await videoFile.exists(), isFalse);
      expect(await thumbFile.exists(), isFalse);

      await notifier.deleteSelectedMediaResources();
      state = container.read(mediaResourcesStateProvider);
      expect(state.resources, isEmpty);
      expect(state.selectedResources, isEmpty);
      expect(await photoFile.exists(), isFalse);
      expect(errors, isEmpty);
    },
  );

  test(
    'adjusts the current index when deleting a selected resource before it',
    () async {
      final files = [
        await createFile('a.JPG'),
        await createFile('b.JPG'),
        await createFile('c.JPG'),
      ];
      final resources = files.indexed
          .map(
            (entry) =>
                photoFixture(file: entry.$2, name: p.basename(entry.$2.path)),
          )
          .toList();
      final container = _container(
        MediaResourcesState(
          resources: resources,
          currentResourceIndex: 2,
          selectedResources: [resources.first],
        ),
        errors,
      );
      addTearDown(container.dispose);

      await container
          .read(mediaResourcesStateProvider.notifier)
          .deleteSelectedMediaResources();
      final state = container.read(mediaResourcesStateProvider);

      expect(state.resources, [resources[1], resources[2]]);
      expect(state.currentResourceIndex, 1);
      expect(state.resources[state.currentResourceIndex], resources[2]);
    },
  );

  test(
    'moves every AEB member to trash and handles an orphan AEB frame',
    () async {
      final memberFiles = [
        await createFile('0.JPG'),
        await createFile('1.JPG'),
      ];
      final members = [
        aebPhotoFixture(file: memberFiles[0], name: '0.JPG', evBias: '0'),
        aebPhotoFixture(file: memberFiles[1], name: '1.JPG', evBias: '-0.7'),
      ];
      final group = members.first.copyWith(aebResources: members);
      final orphanFile = await createFile('orphan.JPG');
      final orphan = aebPhotoFixture(file: orphanFile, name: 'orphan.JPG');
      final container = _container(
        MediaResourcesState(
          resources: [group, orphan],
          selectedResources: [group, orphan],
        ),
        errors,
      );
      addTearDown(container.dispose);

      await container
          .read(mediaResourcesStateProvider.notifier)
          .deleteSelectedMediaResources();

      for (final file in [...memberFiles, orphanFile]) {
        expect(await file.exists(), isFalse);
      }
      expect(container.read(mediaResourcesStateProvider).resources, isEmpty);
    },
  );

  test('keeps a resource in state when moving it to trash fails', () async {
    final file = await createFile('cannot-trash.JPG');
    final resource = photoFixture(file: file, name: p.basename(file.path));
    final trashService = _FakeFileTrashService(failingPaths: {file.path});
    final container = _container(
      MediaResourcesState(resources: [resource], selectedResources: [resource]),
      errors,
      fileTrashService: trashService,
    );
    addTearDown(container.dispose);

    await container
        .read(mediaResourcesStateProvider.notifier)
        .deleteCurrentMediaResource();

    final state = container.read(mediaResourcesStateProvider);
    expect(state.resources, [resource]);
    expect(state.selectedResources, [resource]);
    expect(await file.exists(), isTrue);
    expect(trashService.movedPaths, [file.path]);
    expect(errors.single, contains('Move media resource'));
  });

  test('keeps unmoved AEB members visible after a partial failure', () async {
    final firstFile = await createFile('partial-0.JPG');
    final secondFile = await createFile('partial-1.JPG');
    final members = [
      aebPhotoFixture(file: firstFile, name: 'partial-0.JPG', evBias: '0'),
      aebPhotoFixture(file: secondFile, name: 'partial-1.JPG', evBias: '-0.7'),
    ];
    final group = members.first.copyWith(aebResources: members);
    final container = _container(
      MediaResourcesState(resources: [group], selectedResources: [group]),
      errors,
      fileTrashService: _FakeFileTrashService(failingPaths: {secondFile.path}),
    );
    addTearDown(container.dispose);

    await container
        .read(mediaResourcesStateProvider.notifier)
        .deleteCurrentMediaResource();

    final state = container.read(mediaResourcesStateProvider);
    final remaining = state.resources.single as AebPhotoResource;
    expect(await firstFile.exists(), isFalse);
    expect(await secondFile.exists(), isTrue);
    expect(remaining.file.path, secondFile.path);
    expect(remaining.aebResources.map((item) => item.file.path), [
      secondFile.path,
    ]);
    expect(state.selectedResources, [remaining]);
    expect(errors, hasLength(1));
  });

  test(
    'renames photos and videos while preserving video thumbnail paths',
    () async {
      final photoFile = await createFile('old.JPG');
      final photo = photoFixture(file: photoFile, name: 'old.JPG');
      final container = _container(
        MediaResourcesState(resources: [photo]),
        errors,
      );
      addTearDown(container.dispose);
      final notifier = container.read(mediaResourcesStateProvider.notifier);

      await notifier.renameCurrentMediaResource('new');
      var renamed = container
          .read(mediaResourcesStateProvider)
          .resources
          .single;
      expect(renamed.name, 'new.JPG');
      expect(renamed.file.path, p.join(temporaryDirectory.path, 'new.JPG'));
      expect(renamed.thumbFile.path, renamed.file.path);
      expect(await renamed.file.exists(), isTrue);

      final videoFile = await createFile('old.MP4');
      final thumb = await createFile('thumb.JPG');
      final video = videoFixture(
        file: videoFile,
        thumbFile: thumb,
        name: 'old.MP4',
      );
      final videoContainer = _container(
        MediaResourcesState(resources: [video]),
        errors,
      );
      addTearDown(videoContainer.dispose);
      await videoContainer
          .read(mediaResourcesStateProvider.notifier)
          .renameCurrentMediaResource('new-video');
      renamed = videoContainer
          .read(mediaResourcesStateProvider)
          .resources
          .single;
      expect(renamed.name, 'new-video.MP4');
      expect(renamed.thumbFile.path, thumb.path);
    },
  );

  test(
    'renames grouped and orphan AEB resources with exposure suffixes',
    () async {
      final firstFile = await createFile('first.JPG');
      final secondFile = await createFile('second.JPG');
      final members = [
        aebPhotoFixture(file: firstFile, name: 'first.JPG', evBias: '0'),
        aebPhotoFixture(file: secondFile, name: 'second.JPG', evBias: '-0.7'),
      ];
      final group = members.first.copyWith(aebResources: members);
      final container = _container(
        MediaResourcesState(resources: [group]),
        errors,
      );
      addTearDown(container.dispose);

      await container
          .read(mediaResourcesStateProvider.notifier)
          .renameCurrentMediaResource('bracket');
      final renamed =
          container.read(mediaResourcesStateProvider).resources.single
              as AebPhotoResource;
      expect(renamed.aebResources.map((item) => item.name), [
        'bracket_AEB_0.JPG',
        'bracket_AEB_-0.7.JPG',
      ]);
      for (final member in renamed.aebResources) {
        expect(await member.file.exists(), isTrue);
      }

      final orphanFile = await createFile('single.JPG');
      final orphanContainer = _container(
        MediaResourcesState(
          resources: [aebPhotoFixture(file: orphanFile, name: 'single.JPG')],
        ),
        errors,
      );
      addTearDown(orphanContainer.dispose);
      await orphanContainer
          .read(mediaResourcesStateProvider.notifier)
          .renameCurrentMediaResource('single-bracket');
      final orphan =
          orphanContainer.read(mediaResourcesStateProvider).resources.single
              as AebPhotoResource;
      expect(orphan.name, 'single-bracket_AEB_0.JPG');
      expect(orphan.aebResources, hasLength(1));
    },
  );

  test(
    'reports file failures without throwing and resets for a missing directory',
    () async {
      final missing = photoFixture(
        file: File(p.join(temporaryDirectory.path, 'missing.JPG')),
        name: 'missing.JPG',
      );
      final container = _container(
        MediaResourcesState(resources: [missing]),
        errors,
      );
      addTearDown(container.dispose);
      final notifier = container.read(mediaResourcesStateProvider.notifier);

      await notifier.renameCurrentMediaResource('new');
      expect(container.read(mediaResourcesStateProvider).resources, [missing]);
      expect(errors.single, contains('Rename media resource'));

      await notifier.loadMediaResourcesFromDir(
        p.join(temporaryDirectory.path, 'does-not-exist'),
        false,
        1,
        const Sort(),
      );
      expect(
        container.read(mediaResourcesStateProvider),
        const MediaResourcesState(),
      );
    },
  );
}

ProviderContainer _container(
  MediaResourcesState initialState,
  List<String> errors, {
  FileTrashService? fileTrashService,
}) {
  return ProviderContainer(
    overrides: [
      mediaResourcesStateProvider.overrideWith(
        () => MediaResourcesStateNotifier(
          initialState: initialState,
          fileTrashService: fileTrashService ?? _FakeFileTrashService(),
          showError: errors.add,
        ),
      ),
    ],
  );
}

final class _FakeFileTrashService implements FileTrashService {
  _FakeFileTrashService({this.failingPaths = const {}});

  final Set<String> failingPaths;
  final List<String> movedPaths = [];

  @override
  Future<void> moveFileToTrash(File file) async {
    movedPaths.add(file.path);
    if (failingPaths.contains(file.path)) {
      throw FileSystemException('Fixture trash failure', file.path);
    }
    await file.rename('${file.path}.trashed');
  }
}

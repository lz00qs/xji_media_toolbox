import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:xji_footage_toolbox/models/lut.model.dart';
import 'package:xji_footage_toolbox/models/transcode_preset.model.dart';
import 'package:xji_footage_toolbox/storage/settings_store.dart';

import '../helpers/test_environment.dart';

void main() {
  late Directory temporaryDirectory;

  setUp(() async {
    temporaryDirectory = await createTestDirectory('settings-store-test');
  });

  tearDown(() => deleteTestDirectory(temporaryDirectory));

  test('opens an empty store with immutable snapshots', () async {
    final store = await SettingsStore.open(directory: temporaryDirectory);
    final snapshot = store.snapshot;

    expect(snapshot.transcodingPresets, isEmpty);
    expect(snapshot.luts, isEmpty);
    expect(store.nextLutId, 1);
    expect(
      () => snapshot.luts.add(const Lut(name: 'Unexpected')),
      throwsUnsupportedError,
    );
  });

  test('persists every preset field and LUT with stable IDs', () async {
    final store = await SettingsStore.open(directory: temporaryDirectory);
    final lut = await store.putLut(
      const Lut(name: 'Film', path: '/tmp/film.cube'),
    );
    final preset = await store.putTranscodePreset(
      TranscodePreset(
        name: 'Delivery',
        useInputResolution: false,
        useHevc: false,
        width: 1920,
        height: 1080,
        crf: 18,
        ffmpegPreset: FFmpegPreset.slow,
        lutId: lut.id,
      ),
    );

    expect(lut.id, 1);
    expect(preset.id, 1);

    final reopened = await SettingsStore.open(directory: temporaryDirectory);
    expect(reopened.snapshot.luts, [lut]);
    expect(reopened.snapshot.transcodingPresets, [preset]);
  });

  test(
    'updates records in place and advances IDs past explicit values',
    () async {
      final store = await SettingsStore.open(directory: temporaryDirectory);
      final explicitPreset = await store.putTranscodePreset(
        const TranscodePreset(id: 9, name: 'Explicit'),
      );
      final explicitLut = await store.putLut(
        const Lut(id: 12, name: 'Explicit LUT', path: '/tmp/explicit.cube'),
      );

      final generatedPreset = await store.putTranscodePreset(
        const TranscodePreset(name: 'Generated'),
      );
      final generatedLut = await store.putLut(
        const Lut(name: 'Generated LUT', path: '/tmp/generated.cube'),
      );
      await store.putTranscodePreset(explicitPreset.copyWith(name: 'Updated'));
      await store.putLut(explicitLut.copyWith(name: 'Updated LUT'));

      expect(generatedPreset.id, 10);
      expect(generatedLut.id, 13);
      expect(store.snapshot.transcodingPresets, [
        explicitPreset.copyWith(name: 'Updated'),
        generatedPreset,
      ]);
      expect(store.snapshot.luts, [
        explicitLut.copyWith(name: 'Updated LUT'),
        generatedLut,
      ]);
    },
  );

  test('removes presets without reusing their IDs', () async {
    final store = await SettingsStore.open(directory: temporaryDirectory);
    final first = await store.putTranscodePreset(
      const TranscodePreset(name: 'First'),
    );
    final second = await store.putTranscodePreset(
      const TranscodePreset(name: 'Second'),
    );

    final snapshot = await store.removeTranscodePreset(first.id);
    final third = await store.putTranscodePreset(
      const TranscodePreset(name: 'Third'),
    );

    expect(snapshot.transcodingPresets, [second]);
    expect(third.id, 3);
  });

  test(
    'removing a LUT clears all preset references in the same snapshot',
    () async {
      final store = await SettingsStore.open(directory: temporaryDirectory);
      final lut = await store.putLut(
        const Lut(name: 'Film', path: '/tmp/film.cube'),
      );
      await store.putTranscodePreset(
        TranscodePreset(name: 'Delivery', lutId: lut.id),
      );
      await store.putTranscodePreset(
        TranscodePreset(name: 'Archive', lutId: lut.id),
      );

      final snapshot = await store.removeLut(lut.id);

      expect(snapshot.luts, isEmpty);
      expect(snapshot.transcodingPresets.map((preset) => preset.lutId), [0, 0]);
    },
  );

  test('successful commits leave neither temporary nor backup files', () async {
    final store = await SettingsStore.open(directory: temporaryDirectory);
    await store.putTranscodePreset(const TranscodePreset(name: 'Delivery'));

    final storagePath = p.join(
      temporaryDirectory.path,
      SettingsStore.storageFileName,
    );
    expect(await File(storagePath).exists(), isTrue);
    expect(await File('$storagePath.tmp').exists(), isFalse);
    expect(await File('$storagePath.bak').exists(), isFalse);
  });

  test('recovers from a backup when the primary file is missing', () async {
    final store = await SettingsStore.open(directory: temporaryDirectory);
    final preset = await store.putTranscodePreset(
      const TranscodePreset(name: 'Delivery'),
    );
    final storageFile = _storageFile(temporaryDirectory);
    await storageFile.rename('${storageFile.path}.bak');

    final recovered = await SettingsStore.open(directory: temporaryDirectory);

    expect(recovered.snapshot.transcodingPresets, [preset]);
  });

  test(
    'recovers from a valid backup when the primary file is malformed',
    () async {
      final store = await SettingsStore.open(directory: temporaryDirectory);
      final preset = await store.putTranscodePreset(
        const TranscodePreset(name: 'Delivery'),
      );
      final storageFile = _storageFile(temporaryDirectory);
      await storageFile.copy('${storageFile.path}.bak');
      await storageFile.writeAsString('{not-json');

      final recovered = await SettingsStore.open(directory: temporaryDirectory);

      expect(recovered.snapshot.transcodingPresets, [preset]);
    },
  );

  test('throws when both primary and backup files are malformed', () async {
    final storageFile = _storageFile(temporaryDirectory);
    await storageFile.writeAsString('{bad-primary');
    await File('${storageFile.path}.bak').writeAsString('{bad-backup');

    expect(
      () => SettingsStore.open(directory: temporaryDirectory),
      throwsFormatException,
    );
  });

  test('rejects unsupported schemas without overwriting data', () async {
    final storageFile = _storageFile(temporaryDirectory);
    const contents = '{"schemaVersion": 99}';
    await storageFile.writeAsString(contents);

    expect(
      () => SettingsStore.open(directory: temporaryDirectory),
      throwsFormatException,
    );
    expect(await storageFile.readAsString(), contents);
  });

  test('rejects invalid roots, lists, fields, enum values, and IDs', () async {
    final invalidDocuments = <Object>[
      <Object>[],
      {'schemaVersion': 1},
      _document(presets: ['not-an-object']),
      _document(presets: [_preset(id: 1)..['width'] = '3840']),
      _document(presets: [_preset(id: 1)..['ffmpegPreset'] = 'turbo']),
      _document(presets: [_preset(id: 0)]),
      _document(presets: [_preset(id: 1), _preset(id: 1)]),
      _document(
        luts: [
          {'id': -1, 'name': 'Film', 'path': '/tmp/film.cube'},
        ],
      ),
    ];

    for (var index = 0; index < invalidDocuments.length; index++) {
      final caseDirectory = Directory(
        p.join(temporaryDirectory.path, 'invalid-$index'),
      );
      await caseDirectory.create();
      await _storageFile(
        caseDirectory,
      ).writeAsString(jsonEncode(invalidDocuments[index]));

      expect(
        () => SettingsStore.open(directory: caseDirectory),
        throwsFormatException,
        reason: 'invalid document $index should be rejected',
      );
    }
  });

  test(
    'repairs missing or stale next-ID counters from stored records',
    () async {
      final storageFile = _storageFile(temporaryDirectory);
      await storageFile.writeAsString(
        jsonEncode(
          _document(
            nextPresetId: null,
            nextLutId: 2,
            presets: [_preset(id: 7)],
            luts: [
              {'id': 4, 'name': 'Film', 'path': '/tmp/film.cube'},
            ],
          ),
        ),
      );

      final store = await SettingsStore.open(directory: temporaryDirectory);
      final preset = await store.putTranscodePreset(
        const TranscodePreset(name: 'Next'),
      );
      final lut = await store.putLut(
        const Lut(name: 'Next LUT', path: '/tmp/next.cube'),
      );

      expect(preset.id, 8);
      expect(lut.id, 5);
    },
  );
}

File _storageFile(Directory directory) {
  return File(p.join(directory.path, SettingsStore.storageFileName));
}

Map<String, Object?> _document({
  Object? nextPresetId = 1,
  Object? nextLutId = 1,
  List<Object?> presets = const [],
  List<Object?> luts = const [],
}) {
  return {
    'schemaVersion': SettingsStore.currentSchemaVersion,
    'nextTranscodePresetId': nextPresetId,
    'nextLutId': nextLutId,
    'transcodingPresets': presets,
    'luts': luts,
  };
}

Map<String, Object?> _preset({required int id}) {
  return {
    'id': id,
    'name': 'Preset $id',
    'useInputResolution': true,
    'useHevc': true,
    'width': 3840,
    'height': 2160,
    'crf': 22,
    'ffmpegPreset': 'medium',
    'lutId': 0,
  };
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:xji_footage_toolbox/models/lut.model.dart';
import 'package:xji_footage_toolbox/models/transcode_preset.model.dart';
import 'package:xji_footage_toolbox/storage/settings_store.dart';

void main() {
  late Directory temporaryDirectory;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'xji-settings-store-test-',
    );
  });

  tearDown(() async {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('persists presets and LUTs with stable IDs', () async {
    final store = await SettingsStore.open(directory: temporaryDirectory);

    final lut = await store.putLut(
      const Lut(name: 'Film', path: '/tmp/film.cube'),
    );
    final preset = await store.putTranscodePreset(
      TranscodePreset(
        name: 'Delivery',
        ffmpegPreset: FFmpegPreset.slow,
        lutId: lut.id,
      ),
    );

    expect(lut.id, 1);
    expect(preset.id, 1);

    final reopened = await SettingsStore.open(directory: temporaryDirectory);
    expect(reopened.snapshot.luts, [lut]);
    expect(reopened.snapshot.transcodingPresets, [preset]);

    final nextPreset = await reopened.putTranscodePreset(
      const TranscodePreset(name: 'Archive'),
    );
    expect(nextPreset.id, 2);

    await reopened.putTranscodePreset(preset.copyWith(name: 'Updated'));
    expect(reopened.snapshot.transcodingPresets.map((item) => item.id), [1, 2]);
  });

  test('removing a LUT clears references in the same snapshot', () async {
    final store = await SettingsStore.open(directory: temporaryDirectory);
    final lut = await store.putLut(
      const Lut(name: 'Film', path: '/tmp/film.cube'),
    );
    await store.putTranscodePreset(
      TranscodePreset(name: 'Delivery', lutId: lut.id),
    );

    final snapshot = await store.removeLut(lut.id);

    expect(snapshot.luts, isEmpty);
    expect(snapshot.transcodingPresets.single.lutId, 0);
  });

  test('recovers from a backup when the primary file is missing', () async {
    final store = await SettingsStore.open(directory: temporaryDirectory);
    final preset = await store.putTranscodePreset(
      const TranscodePreset(name: 'Delivery'),
    );
    final storageFile = File(
      p.join(temporaryDirectory.path, SettingsStore.storageFileName),
    );
    await storageFile.rename('${storageFile.path}.bak');

    final recovered = await SettingsStore.open(directory: temporaryDirectory);

    expect(recovered.snapshot.transcodingPresets, [preset]);
  });

  test('rejects unsupported schemas without overwriting data', () async {
    final storageFile = File(
      p.join(temporaryDirectory.path, SettingsStore.storageFileName),
    );
    await storageFile.writeAsString('{"schemaVersion": 99}');

    expect(
      () => SettingsStore.open(directory: temporaryDirectory),
      throwsFormatException,
    );
  });
}

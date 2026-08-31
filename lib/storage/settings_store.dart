import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/lut.model.dart';
import '../models/transcode_preset.model.dart';

final class SettingsStoreSnapshot {
  SettingsStoreSnapshot({
    required List<TranscodePreset> transcodingPresets,
    required List<Lut> luts,
  }) : transcodingPresets = List.unmodifiable(transcodingPresets),
       luts = List.unmodifiable(luts);

  final List<TranscodePreset> transcodingPresets;
  final List<Lut> luts;
}

final class SettingsStore {
  SettingsStore._(this._file, this._data);

  static const int currentSchemaVersion = 1;
  static const String storageDirectoryName = 'xji-media-toolbox';
  static const String storageFileName = 'settings.json';

  final File _file;
  _SettingsStoreData _data;

  static Future<SettingsStore> open({Directory? directory}) async {
    final storageDirectory =
        directory ??
        Directory(
          p.join(
            (await getApplicationSupportDirectory()).path,
            storageDirectoryName,
          ),
        );
    await storageDirectory.create(recursive: true);

    final file = File(p.join(storageDirectory.path, storageFileName));
    final data = await _readData(file);
    return SettingsStore._(file, data);
  }

  SettingsStoreSnapshot get snapshot => SettingsStoreSnapshot(
    transcodingPresets: _data.transcodingPresets,
    luts: _data.luts,
  );

  int get nextLutId => _data.nextLutId;

  Future<TranscodePreset> putTranscodePreset(TranscodePreset preset) async {
    final id = preset.id > 0 ? preset.id : _data.nextTranscodePresetId;
    final storedPreset = preset.copyWith(id: id);
    final presetExists = _data.transcodingPresets.any(
      (existing) => existing.id == id,
    );
    final presets = presetExists
        ? _data.transcodingPresets
              .map((existing) => existing.id == id ? storedPreset : existing)
              .toList()
        : [..._data.transcodingPresets, storedPreset];
    final nextData = _data.copyWith(
      nextTranscodePresetId: _nextId(_data.nextTranscodePresetId, id),
      transcodingPresets: presets,
    );
    await _commit(nextData);
    return storedPreset;
  }

  Future<SettingsStoreSnapshot> removeTranscodePreset(int id) async {
    final nextData = _data.copyWith(
      transcodingPresets: _data.transcodingPresets
          .where((preset) => preset.id != id)
          .toList(),
    );
    await _commit(nextData);
    return snapshot;
  }

  Future<Lut> putLut(Lut lut) async {
    final id = lut.id > 0 ? lut.id : _data.nextLutId;
    final storedLut = lut.copyWith(id: id);
    final lutExists = _data.luts.any((existing) => existing.id == id);
    final luts = lutExists
        ? _data.luts
              .map((existing) => existing.id == id ? storedLut : existing)
              .toList()
        : [..._data.luts, storedLut];
    final nextData = _data.copyWith(
      nextLutId: _nextId(_data.nextLutId, id),
      luts: luts,
    );
    await _commit(nextData);
    return storedLut;
  }

  Future<SettingsStoreSnapshot> removeLut(int id) async {
    final nextData = _data.copyWith(
      transcodingPresets: _data.transcodingPresets
          .map(
            (preset) => preset.lutId == id ? preset.copyWith(lutId: 0) : preset,
          )
          .toList(),
      luts: _data.luts.where((lut) => lut.id != id).toList(),
    );
    await _commit(nextData);
    return snapshot;
  }

  Future<void> _commit(_SettingsStoreData nextData) async {
    await _writeAtomically(_file, jsonEncode(nextData.toJson()));
    _data = nextData;
  }

  static int _nextId(int currentNextId, int storedId) {
    final candidate = storedId + 1;
    return candidate > currentNextId ? candidate : currentNextId;
  }

  static Future<_SettingsStoreData> _readData(File file) async {
    if (!await file.exists()) {
      final backup = File('${file.path}.bak');
      if (!await backup.exists()) return _SettingsStoreData.empty();
      return _decode(await backup.readAsString());
    }

    try {
      return _decode(await file.readAsString());
    } on FormatException {
      final backup = File('${file.path}.bak');
      if (!await backup.exists()) rethrow;
      return _decode(await backup.readAsString());
    }
  }

  static _SettingsStoreData _decode(String contents) {
    final decoded = jsonDecode(contents);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Settings storage root must be an object.');
    }
    return _SettingsStoreData.fromJson(decoded);
  }

  static Future<void> _writeAtomically(File file, String contents) async {
    await file.parent.create(recursive: true);
    final temporary = File('${file.path}.tmp');
    final backup = File('${file.path}.bak');

    if (await temporary.exists()) await temporary.delete();
    await temporary.writeAsString(contents, flush: true);

    if (await backup.exists()) await backup.delete();
    if (await file.exists()) await file.rename(backup.path);

    try {
      await temporary.rename(file.path);
      if (await backup.exists()) await backup.delete();
    } catch (_) {
      if (!await file.exists() && await backup.exists()) {
        await backup.rename(file.path);
      }
      rethrow;
    }
  }
}

final class _SettingsStoreData {
  const _SettingsStoreData({
    required this.nextTranscodePresetId,
    required this.nextLutId,
    required this.transcodingPresets,
    required this.luts,
  });

  factory _SettingsStoreData.empty() => const _SettingsStoreData(
    nextTranscodePresetId: 1,
    nextLutId: 1,
    transcodingPresets: [],
    luts: [],
  );

  factory _SettingsStoreData.fromJson(Map<String, dynamic> json) {
    final schemaVersion = json['schemaVersion'];
    if (schemaVersion != SettingsStore.currentSchemaVersion) {
      throw FormatException(
        'Unsupported settings storage schema: $schemaVersion.',
      );
    }

    final presets = _readObjectList(
      json,
      'transcodingPresets',
    ).map(_transcodePresetFromJson).toList();
    final luts = _readObjectList(json, 'luts').map(_lutFromJson).toList();
    _validateIds(presets.map((preset) => preset.id), 'transcoding preset');
    _validateIds(luts.map((lut) => lut.id), 'LUT');

    return _SettingsStoreData(
      nextTranscodePresetId: _readNextId(
        json['nextTranscodePresetId'],
        presets.map((preset) => preset.id),
      ),
      nextLutId: _readNextId(json['nextLutId'], luts.map((lut) => lut.id)),
      transcodingPresets: presets,
      luts: luts,
    );
  }

  final int nextTranscodePresetId;
  final int nextLutId;
  final List<TranscodePreset> transcodingPresets;
  final List<Lut> luts;

  _SettingsStoreData copyWith({
    int? nextTranscodePresetId,
    int? nextLutId,
    List<TranscodePreset>? transcodingPresets,
    List<Lut>? luts,
  }) {
    return _SettingsStoreData(
      nextTranscodePresetId:
          nextTranscodePresetId ?? this.nextTranscodePresetId,
      nextLutId: nextLutId ?? this.nextLutId,
      transcodingPresets: transcodingPresets ?? this.transcodingPresets,
      luts: luts ?? this.luts,
    );
  }

  Map<String, dynamic> toJson() => {
    'schemaVersion': SettingsStore.currentSchemaVersion,
    'nextTranscodePresetId': nextTranscodePresetId,
    'nextLutId': nextLutId,
    'transcodingPresets': transcodingPresets
        .map(_transcodePresetToJson)
        .toList(),
    'luts': luts.map(_lutToJson).toList(),
  };

  static List<Map<String, dynamic>> _readObjectList(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = json[key];
    if (value is! List) {
      throw FormatException('$key must be a list.');
    }
    return value.map((item) {
      if (item is! Map<String, dynamic>) {
        throw FormatException('$key must contain only objects.');
      }
      return item;
    }).toList();
  }

  static int _readNextId(Object? value, Iterable<int> ids) {
    final maxId = ids.fold(0, (maximum, id) => id > maximum ? id : maximum);
    if (value is! int || value <= maxId) return maxId + 1;
    return value;
  }

  static void _validateIds(Iterable<int> ids, String type) {
    final seen = <int>{};
    for (final id in ids) {
      if (id <= 0 || !seen.add(id)) {
        throw FormatException('Invalid or duplicate $type ID: $id.');
      }
    }
  }
}

Map<String, dynamic> _transcodePresetToJson(TranscodePreset preset) => {
  'id': preset.id,
  'name': preset.name,
  'useInputResolution': preset.useInputResolution,
  'useHevc': preset.useHevc,
  'width': preset.width,
  'height': preset.height,
  'crf': preset.crf,
  'ffmpegPreset': preset.ffmpegPreset.name,
  'lutId': preset.lutId,
};

TranscodePreset _transcodePresetFromJson(Map<String, dynamic> json) {
  final ffmpegPresetName = _readString(json, 'ffmpegPreset');
  final ffmpegPreset = FFmpegPreset.values
      .where((preset) => preset.name == ffmpegPresetName)
      .firstOrNull;
  if (ffmpegPreset == null) {
    throw FormatException('Unknown FFmpeg preset: $ffmpegPresetName.');
  }

  return TranscodePreset(
    id: _readInt(json, 'id'),
    name: _readString(json, 'name'),
    useInputResolution: _readBool(json, 'useInputResolution'),
    useHevc: _readBool(json, 'useHevc'),
    width: _readInt(json, 'width'),
    height: _readInt(json, 'height'),
    crf: _readInt(json, 'crf'),
    ffmpegPreset: ffmpegPreset,
    lutId: _readInt(json, 'lutId'),
  );
}

Map<String, dynamic> _lutToJson(Lut lut) => {
  'id': lut.id,
  'name': lut.name,
  'path': lut.path,
};

Lut _lutFromJson(Map<String, dynamic> json) => Lut(
  id: _readInt(json, 'id'),
  name: _readString(json, 'name'),
  path: _readString(json, 'path'),
);

int _readInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! int) throw FormatException('$key must be an integer.');
  return value;
}

String _readString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String) throw FormatException('$key must be a string.');
  return value;
}

bool _readBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! bool) throw FormatException('$key must be a boolean.');
  return value;
}

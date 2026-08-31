import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:xji_footage_toolbox/storage/settings_store.dart';
import 'package:xji_footage_toolbox/utils/logger.dart';
import 'package:xji_footage_toolbox/utils/toast.dart';

import '../constants.dart';
import '../models/lut.model.dart';
import '../models/settings.model.dart';
import '../models/transcode_preset.model.dart';

part 'settings.notifier.g.dart';

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  late final SettingsStore _settingsStore;
  late final SharedPreferences _prefs;

  @override
  Settings build() {
    return Settings();
  }

  Future<void> initSettings() async {
    _settingsStore = await SettingsStore.open();
    var snapshot = _settingsStore.snapshot;
    var transcodingPresets = snapshot.transcodingPresets;
    if (transcodingPresets.isEmpty) {
      await _settingsStore.putTranscodePreset(TranscodePreset(name: 'Default'));
      snapshot = _settingsStore.snapshot;
      transcodingPresets = snapshot.transcodingPresets;
    }

    _prefs = await SharedPreferences.getInstance();
    var defaultTranscodePresetId =
        _prefs.getInt(defaultTranscodePresetIndexPrefKey) ??
        transcodingPresets.first.id;
    // 检查默认预设是否存在
    var defaultTranscodePresetIdValid = false;
    for (var preset in transcodingPresets) {
      if (preset.id == defaultTranscodePresetId) {
        defaultTranscodePresetIdValid = true;
        break;
      }
    }
    if (!defaultTranscodePresetIdValid) {
      defaultTranscodePresetId = transcodingPresets.first.id;
    }

    final exportCmdOnly = _prefs.getBool(exportCmdOnlyPrefKey) ?? false;
    final sortType = SortType.values[_prefs.getInt(sortTypePrefKey) ?? 0];
    final sortAsc = _prefs.getBool(sortOderPrefKey) ?? true;
    final cpuThreads = Platform.numberOfProcessors;
    final appVersion = await PackageInfo.fromPlatform();

    state = Settings(
      transcodingPresets: transcodingPresets,
      defaultTranscodePresetId: defaultTranscodePresetId,
      luts: snapshot.luts,
      sort: Sort(sortType: sortType, sortAsc: sortAsc),
      cpuThreads: cpuThreads,
      appVersion: appVersion.version,
      exportCmdOnly: exportCmdOnly,
    );
  }

  bool _transcodePresetExists(int id) {
    return state.transcodingPresets.any((preset) => preset.id == id);
  }

  void setDefaultTranscodePreset(int id) {
    // 检查 id 是否存在
    if (!_transcodePresetExists(id)) {
      Logger.warn('Transcode Preset not found: $id');
      Toast.error('Transcode Preset not found');
      return;
    }
    state = state.copyWith(defaultTranscodePresetId: id);
    _prefs.setInt(defaultTranscodePresetIndexPrefKey, id);
  }

  Future<void> addTranscodePreset(TranscodePreset preset) async {
    final storedPreset = await _tryStorageOperation(
      'Failed to save Transcode Preset',
      () => _settingsStore.putTranscodePreset(preset),
    );
    if (storedPreset == null) return;
    state = state.copyWith(
      transcodingPresets: [...state.transcodingPresets, storedPreset],
    );
  }

  Future<void> removeTranscodePreset(int id) async {
    // 检查 id 是否存在
    if (!_transcodePresetExists(id)) {
      Logger.warn('Transcode Preset not found: $id');
      Toast.error('Transcode Preset not found');
      return;
    }

    if (state.transcodingPresets.length == 1) {
      Logger.warn('Cannot delete the last Transcode Preset: $id');
      Toast.error('Cannot delete the last Transcode Preset');
      return;
    }

    final snapshot = await _tryStorageOperation(
      'Failed to delete Transcode Preset',
      () => _settingsStore.removeTranscodePreset(id),
    );
    if (snapshot == null) return;
    state = state.copyWith(transcodingPresets: snapshot.transcodingPresets);

    if (state.defaultTranscodePresetId == id) {
      setDefaultTranscodePreset(state.transcodingPresets.first.id);
    }
  }

  Future<void> updateTranscodePreset(TranscodePreset preset) async {
    final storedPreset = await _tryStorageOperation(
      'Failed to update Transcode Preset',
      () => _settingsStore.putTranscodePreset(preset),
    );
    if (storedPreset == null) return;
    state = state.copyWith(
      transcodingPresets: state.transcodingPresets
          .map((item) => item.id == storedPreset.id ? storedPreset : item)
          .toList(),
    );
  }

  bool _lutExists(int id) {
    return state.luts.any((lut) => lut.id == id);
  }

  Future<void> addLut(Lut lut) async {
    final id = _settingsStore.nextLutId;
    final srcFile = File(lut.path);
    if (!await srcFile.exists()) {
      Logger.warn('LUT file not found: ${lut.path}');
      Toast.error('LUT file not found');
      return;
    }

    // Application Support
    final baseDir = await getApplicationSupportDirectory();

    // luts/user
    final targetDir = Directory(p.join(baseDir.path, 'luts', 'user'));
    await targetDir.create(recursive: true);

    final targetFile = File(p.join(targetDir.path, '$id.cube'));

    try {
      await srcFile.copy(targetFile.path);
      final storedLut = await _settingsStore.putLut(
        lut.copyWith(id: id, path: targetFile.path),
      );
      state = state.copyWith(luts: [...state.luts, storedLut]);
    } catch (error, stackTrace) {
      if (await targetFile.exists()) await targetFile.delete();
      Logger.error('Failed to save LUT', error, stackTrace);
      Toast.error('Failed to save LUT');
    }
  }

  Future<void> removeLut(int lutId) async {
    // 检查 id 是否存在
    if (!_lutExists(lutId)) {
      Logger.warn('LUT not found: $lutId');
      Toast.error('LUT not found');
      return;
    }
    final lut = state.luts.firstWhere((item) => item.id == lutId);
    final snapshot = await _tryStorageOperation(
      'Failed to delete LUT',
      () => _settingsStore.removeLut(lutId),
    );
    if (snapshot == null) return;
    state = state.copyWith(
      transcodingPresets: snapshot.transcodingPresets,
      luts: snapshot.luts,
    );

    // 删除文件
    final lutFile = File(lut.path);
    try {
      if (await lutFile.exists()) await lutFile.delete();
    } catch (error, stackTrace) {
      Logger.warn('Failed to delete LUT file: ${lut.path}');
      Logger.error('LUT file deletion error', error, stackTrace);
      Toast.warning('LUT metadata deleted, but its file could not be removed');
    }
  }

  Future<void> updateLut(Lut lut) async {
    final storedLut = await _tryStorageOperation(
      'Failed to update LUT',
      () => _settingsStore.putLut(lut),
    );
    if (storedLut == null) return;
    state = state.copyWith(
      luts: state.luts
          .map((item) => item.id == storedLut.id ? storedLut : item)
          .toList(),
    );
  }

  Future<T?> _tryStorageOperation<T>(
    String errorMessage,
    Future<T> Function() operation,
  ) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      Logger.error(errorMessage, error, stackTrace);
      Toast.error(errorMessage);
      return null;
    }
  }

  void setIsDebugMode(bool value) {
    Logger.setLogLevel(value ? LogLevel.debug : LogLevel.info);
    state = state.copyWith(isDebugMode: value);
  }

  void setSort(Sort sort) {
    state = state.copyWith(sort: sort);
    _prefs.setInt(sortTypePrefKey, sort.sortType.index);
    _prefs.setBool(sortOderPrefKey, sort.sortAsc);
  }

  void setExportCmdOnly(bool value) {
    state = state.copyWith(exportCmdOnly: value);
    _prefs.setBool(exportCmdOnlyPrefKey, value);
  }
}

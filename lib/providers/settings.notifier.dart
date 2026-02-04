import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xji_footage_toolbox/storage/transcode_preset.mapper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:xji_footage_toolbox/utils/log.dart';
import 'package:xji_footage_toolbox/utils/toast.dart';

import '../constants.dart';
import '../models/lut.model.dart';
import '../models/settings.model.dart';
import '../models/transcode_preset.model.dart';
import '../storage/lut.mapper.dart';

part 'settings.notifier.g.dart';

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  late final ObjectBox _objectBox;
  late final SharedPreferences _prefs;

  @override
  Settings build() {
    return Settings();
  }

  Future<void> initSettings() async {
    _objectBox = ObjectBox.instance;
    var transcodingPresets = _objectBox.transcodePresetBox.getAll();
    if (transcodingPresets.isEmpty) {
      final defaultPreset = TranscodePreset(name: 'Default');
      _objectBox.transcodePresetBox.put(defaultPreset.toEntity());
      transcodingPresets = _objectBox.transcodePresetBox.getAll();
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

    var luts = _objectBox.lutBox.getAll().map((e) => e.toModel()).toList();

    final sortType = SortType.values[_prefs.getInt(sortTypePrefKey) ?? 0];
    final sortAsc = _prefs.getBool(sortOderPrefKey) ?? true;
    final cpuThreads = Platform.numberOfProcessors;
    final appVersion = await PackageInfo.fromPlatform();

    state = Settings(
      transcodingPresets: transcodingPresets.map((e) => e.toModel()).toList(),
      defaultTranscodePresetId: defaultTranscodePresetId,
      luts: luts,
      sortType: sortType,
      sortAsc: sortAsc,
      cpuThreads: cpuThreads,
      appVersion: appVersion.version,
    );
  }

  bool _transcodePresetExists(int id) {
    return state.transcodingPresets.any((preset) => preset.id == id);
  }

  void setDefaultTranscodePreset(int id) {
    // 检查 id 是否存在
    if (!_transcodePresetExists(id)) {
      Log.severe('Transcode Preset not found: $id');
      Toast.error('Transcode Preset not found');
      return;
    }
    state = state.copyWith(defaultTranscodePresetId: id);
    _prefs.setInt(defaultTranscodePresetIndexPrefKey, id);
  }

  void addTranscodePreset(TranscodePreset preset) {
    _objectBox.transcodePresetBox.put(preset.toEntity());
    state = state.copyWith(
      transcodingPresets: [...state.transcodingPresets, preset],
    );
  }

  void removeTranscodePreset(int id) {
    // 检查 id 是否存在
    if (!_transcodePresetExists(id)) {
      Log.severe('Transcode Preset not found: $id');
      Toast.error('Transcode Preset not found');
      return;
    }

    if (state.transcodingPresets.length == 1) {
      Log.severe('Cannot delete the last Transcode Preset: $id');
      Toast.error('Cannot delete the last Transcode Preset');
      return;
    }

    _objectBox.transcodePresetBox.remove(id);
    state = state.copyWith(
      transcodingPresets: state.transcodingPresets
          .where((element) => element.id != id)
          .toList(),
    );

    if (state.defaultTranscodePresetId == id) {
      setDefaultTranscodePreset(state.transcodingPresets.first.id);
    }
  }

  void updateTranscodePreset(TranscodePreset preset) {
    final id = _objectBox.transcodePresetBox.put(preset.toEntity());
    preset = preset.copyWith(id: id);
    state = state.copyWith(
      transcodingPresets: state.transcodingPresets
          .map((p) => p.id == preset.id ? preset : p)
          .toList(),
    );
  }

  bool _lutExists(int id) {
    return state.luts.any((lut) => lut.id == id);
  }

  Future<void> addLut(Lut lut) async {
    final id = _objectBox.lutBox.put(lut.toEntity());
    var oLut = _objectBox.lutBox.get(id);
    if (oLut == null) {
      Log.severe('LUT not found: $id');
      Toast.error('LUT not found');
      return;
    }
    final srcFile = File(lut.path);
    if (!srcFile.existsSync()) {
      Log.severe('LUT file not found: ${lut.path}');
      Toast.error('LUT file not found');
      _objectBox.lutBox.remove(id);
      return;
    }

    // Application Support
    final baseDir = await getApplicationSupportDirectory();

    // luts/user
    final targetDir = Directory(
      p.join(baseDir.path, 'luts', 'user'),
    );
    await targetDir.create(recursive: true);

    var targetFile =
        File(p.join(targetDir.path, "${oLut.id}_${oLut.name}.cube"));

    targetFile = await srcFile.copy(targetFile.path);

    if (!targetFile.existsSync()) {
      Log.severe('LUT file copy failed: ${targetFile.path}');
      Toast.error('LUT file copy failed');
      _objectBox.lutBox.remove(id);
      return;
    }

    oLut.path = targetFile.path;
    _objectBox.lutBox.put(oLut);

    state = state.copyWith(
      luts: [...state.luts, oLut.toModel()],
    );
  }

  void removeLut(int lutId) {
    // 检查 id 是否存在
    if (!_lutExists(lutId)) {
      Log.severe('LUT not found: $lutId');
      Toast.error('LUT not found');
      return;
    }
    final lut = _objectBox.lutBox.get(lutId);
    if (lut == null) {
      Log.severe('LUT not found: $lutId');
      Toast.error('LUT not found');
      return;
    }
    _objectBox.lutBox.remove(lutId);

    state = state.copyWith(
      luts: state.luts.where((element) => element.id != lutId).toList(),
    );

    // 遍历 preset 中的 lutId ，如果等于 id ，则设置为 0 nonelut
    for (var preset in state.transcodingPresets) {
      if (preset.lutId == lutId) {
        updateTranscodePreset(preset.copyWith(lutId: 0));
      }
    }

    // 删除文件
    final lutFile = File(lut.path);
    if (lutFile.existsSync()) {
      lutFile.deleteSync();
    }
  }

  void updateLut(Lut lut) {
    _objectBox.lutBox.put(lut.toEntity());
    state = state.copyWith(
      luts: state.luts.map((p) => p.id == lut.id ? lut : p).toList(),
    );
  }

  void setIsDebugMode(bool value) {
    Log.isDebug = value;
    state = state.copyWith(isDebugMode: value);
  }
}

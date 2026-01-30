
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';
import '../constants.dart';
import '../service/log_service.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  late final ObjectBox _objectBox;
  late final SharedPreferences _prefs;


  @override
  Future<Settings> build() async {
    _objectBox = ObjectBox.instance;
    var transcodingPresets = _objectBox.transcodePresetBox.getAll();
    if (transcodingPresets.isEmpty) {
      final defaultPreset = TranscodePreset()..name = 'Default';
      _objectBox.transcodePresetBox.put(defaultPreset);
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



    var luts = _objectBox.lutBox.getAll();
    final sortType = SortType.values[_prefs.getInt(sortTypePrefKey)?? 0];
    final sortAsc = _prefs.getBool(sortOderPrefKey)?? true;
    final cpuThreads = Platform.numberOfProcessors;
    final appVersion = await PackageInfo.fromPlatform();
    return Settings(
      transcodingPresets: transcodingPresets,
      luts: luts,
      defaultTranscodePresetId: defaultTranscodePresetId,
      cpuThreads: cpuThreads,
      appVersion: appVersion.version,
      sortType: sortType,
      sortAsc: sortAsc,
      isDebugMode: false,
    );
  }

  void addTranscodePreset(TranscodePreset preset) {
    _objectBox.transcodePresetBox.put(preset);
    if (state.value?.transcodingPresets.isEmpty ?? true) {
      state = state.whenData((settings) => settings.copyWith(
          transcodingPresets: [...settings.transcodingPresets, preset],
          defaultTranscodePresetId: preset.id));
    } else {
      state = state.whenData((settings) => settings.copyWith(
            transcodingPresets: [...settings.transcodingPresets, preset],
          ));
    }
  }

  void removeTranscodePreset(TranscodePreset preset) {
    _objectBox.transcodePresetBox.remove(preset.id);
    state = state.whenData((settings) => settings.copyWith(
        transcodingPresets:
            settings.transcodingPresets.where((p) => p.id != preset.id).toList()));
  }

  void updateTranscodePreset(TranscodePreset preset) {
    _objectBox.transcodePresetBox.put(preset);
    state = state.whenData((settings) => settings.copyWith(
        transcodingPresets: settings.transcodingPresets
            .map((p) => p.id == preset.id ? preset : p)
            .toList()));
  }

  void addLut(Lut lut) async {
    final id = _objectBox.lutBox.put(lut);
    final oLut = _objectBox.lutBox.get(id);
    if (oLut == null) {
      LogService.warning('Add lut failed, id: $id, name: ${lut.name}');
      _objectBox.lutBox.remove(id);
      return;
    }
    final srcFile = File(lut.path);
    if (!srcFile.existsSync()) {
      LogService.warning('Add lut failed, id: $id, name: ${lut.name}, path: ${lut.path} not exists');
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

    var targetFile = File(p.join(targetDir.path, "${oLut.id}_${oLut.name}.cube"));

    targetFile = await srcFile.copy(targetFile.path);

    if (!targetFile.existsSync()) {
      LogService.warning('Add lut failed, id: $id, name: ${lut.name}, copy to ${targetFile.path} failed');
      _objectBox.lutBox.remove(id);
      return;
    }

    oLut.path = targetFile.path;
    _objectBox.lutBox.put(oLut);
    state = state.whenData((settings) => settings.copyWith(
          luts: [...settings.luts, oLut],
        ));
  }

  void removeLut(int id) async {
    final oLut = _objectBox.lutBox.get(id);
    if (oLut == null) {
      LogService.warning('Remove lut failed, id: $id');
      return;
    }
    _objectBox.lutBox.remove(id);
    // 遍历 preset 中的 lutId ，如果等于 id ，则设置为 0
    for (var preset in state.value?.transcodingPresets ?? []) {
      if (preset.lutId == id) {
        preset.lutId = 0;
        _objectBox.transcodePresetBox.put(preset);
      }
    }
    // 删除文件
    final lutFile = File(oLut.path);
    if (lutFile.existsSync()) {
      lutFile.deleteSync();
    }
    state = state.whenData((settings) => settings.copyWith(
      luts: settings.luts.where((element) => element.id != id).toList(),
    ));
  }

  void updateLut(Lut lut) async {
    _objectBox.lutBox.put(lut);
    state = state.whenData((settings) => settings.copyWith(
      luts: settings.luts.map((e) => e.id== lut.id? lut : e).toList(),
    ));
  }

  void setDefaultTranscodePreset(int id) async {
    _prefs.setInt(defaultTranscodePresetIndexPrefKey, id);
    state = state.whenData((settings) => settings.copyWith(
      defaultTranscodePresetId: id,
    ));
  }

  void setSortType(SortType type) async {
    _prefs.setInt(sortTypePrefKey, type.index);
    state = state.whenData((settings) => settings.copyWith(
      sortType: type,
    ));
  }

  void setSortAsc(bool asc) async {
    _prefs.setBool(sortOderPrefKey, asc);
    state = state.whenData((settings) => settings.copyWith(
      sortAsc: asc,
    ));
  }

  void setIsDebugMode(bool debugMode) async {
    state = state.whenData((settings) => settings.copyWith(
      isDebugMode: debugMode,
    ));
  }
}

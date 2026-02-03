import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xji_footage_toolbox/storage/transcode_preset.mapper.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants.dart';
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

  Future<void>initSettings()async {
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

    final sortType = SortType.values[_prefs.getInt(sortTypePrefKey)?? 0];
    final sortAsc = _prefs.getBool(sortOderPrefKey)?? true;
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
}

import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:objectbox/objectbox.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../objectbox.dart';

part 'settings.freezed.dart';

enum FFmpegPreset {
  ultrafast,
  superfast,
  veryfast,
  faster,
  fast,
  medium,
  slow,
  slower,
  veryslow,
}

@Entity()
class TranscodePreset {
  @Id()
  int id = 0;
  String name = 'Custom';
  bool useInputResolution = true;
  bool useHevc = true;
  int width = 3840;
  int height = 2160;
  int crf = 22;
  int ffmpegPreset = FFmpegPreset.medium.index;
}

enum SortType { name, date, size, sequence }

@freezed
class Settings with _$Settings {
  @override
  final List<TranscodePreset> transcodingPresets;
  @override
  final int defaultTranscodePresetId;
  @override
  final int cpuThreads;
  @override
  final String appVersion;
  @override
  final SortType sortType;
  @override
  final bool sortAsc;
  @override
  final bool isDebugMode;

  Settings({
    required this.transcodingPresets,
    required this.defaultTranscodePresetId,
    required this.cpuThreads,
    required this.appVersion,
    required this.sortType,
    required this.sortAsc,
    required this.isDebugMode,
  });

  factory Settings.initial() {
    return Settings(
      transcodingPresets: [],
      defaultTranscodePresetId: 0,
      cpuThreads: 1,
      appVersion: '0.0.0',
      sortType: SortType.name,
      sortAsc: true,
      isDebugMode: false,
    );
  }
}

final settingsProvider =
StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings.initial());
  late final ObjectBox objectBox;
  late final SharedPreferences prefs;

  Future<void> loadSettings() async {
    objectBox = ObjectBox.instance;
    var transcodingPresets = objectBox.transcodePresetBox.getAll();
    if (transcodingPresets.isEmpty) {
      final defaultPreset = TranscodePreset()..name = 'Default';
      objectBox.transcodePresetBox.put(defaultPreset);
      transcodingPresets = objectBox.transcodePresetBox.getAll();
    }
    prefs = await SharedPreferences.getInstance();
    var defaultTranscodePresetId =
        prefs.getInt(defaultTranscodePresetIndexPrefKey) ??
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
    final sortType = SortType.values[prefs.getInt(sortTypePrefKey)?? 0];
    final sortAsc = prefs.getBool(sortOderPrefKey)?? true;
    final cpuThreads = Platform.numberOfProcessors;
    final appVersion = await PackageInfo.fromPlatform();
    state = state.copyWith(
      transcodingPresets: transcodingPresets,
      defaultTranscodePresetId: defaultTranscodePresetId,
      cpuThreads: cpuThreads,
      appVersion: appVersion.version,
      sortType: sortType,
      sortAsc: sortAsc,
    );
  }

  void saveSettings() async {
    objectBox.transcodePresetBox.removeAll();
    objectBox.transcodePresetBox.putMany(state.transcodingPresets);
    prefs.setInt(
        defaultTranscodePresetIndexPrefKey, state.defaultTranscodePresetId);
    prefs.setInt(sortTypePrefKey, state.sortType.index);
    prefs.setBool(sortOderPrefKey, state.sortAsc);
  }

  void addTranscodePreset(TranscodePreset preset) async {
    objectBox.transcodePresetBox.put(preset);
    state = state.copyWith(
      transcodingPresets: [...state.transcodingPresets, preset],
    );
  }

  void removeTranscodePreset(int id) async {
    objectBox.transcodePresetBox.remove(id);
    state = state.copyWith(
      transcodingPresets: state.transcodingPresets.where((element) => element.id != id).toList(),
    );
  }

  void updateTranscodePreset(TranscodePreset preset) async {
    objectBox.transcodePresetBox.put(preset);
    state = state.copyWith(
      transcodingPresets: state.transcodingPresets.map((e) => e.id== preset.id? preset : e).toList(),
    );
  }

  void setDefaultTranscodePreset(int id) async {
    prefs.setInt(defaultTranscodePresetIndexPrefKey, id);
    state = state.copyWith(
      defaultTranscodePresetId: id,
    );
  }

  void setSortType(SortType type) async {
    prefs.setInt(sortTypePrefKey, type.index);
    state = state.copyWith(
      sortType: type,
    );
  }

  void setSortAsc(bool asc) async {
    prefs.setBool(sortOderPrefKey, asc);
    state = state.copyWith(
      sortAsc: asc,
    );
  }

  void setIsDebugMode(bool debugMode) async {
    state = state.copyWith(
      isDebugMode: debugMode,
    );
  }
}
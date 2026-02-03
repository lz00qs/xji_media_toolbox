import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xji_footage_toolbox/models/lut.model.dart';
import 'package:xji_footage_toolbox/models/transcode_preset.model.dart';

part 'settings.model.freezed.dart';

enum SortType { name, date, size, sequence }

@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    @Default(<TranscodePreset>[]) List<TranscodePreset> transcodingPresets,
    @Default(<Lut>[]) List<Lut> luts,
    @Default(0) int defaultTranscodePresetId,
    @Default(1) int cpuThreads,
    @Default('0.0.0') String appVersion,
    @Default(SortType.name) SortType sortType,
    @Default(true) bool sortAsc,
    @Default(false) bool isDebugMode,
  }) = _Settings;
}
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xji_footage_toolbox/models/lut.model.dart';
import 'package:xji_footage_toolbox/models/transcode_preset.model.dart';

part 'settings.model.freezed.dart';

enum SortType { name, date, size, sequence }

@freezed
abstract class Sort with _$Sort {
  const factory Sort({
    @Default(SortType.name) SortType sortType,
    @Default(true) bool sortAsc,
  }) = _Sort;
}

@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    @Default(<TranscodePreset>[]) List<TranscodePreset> transcodingPresets,
    @Default(<Lut>[]) List<Lut> luts,
    @Default(0) int defaultTranscodePresetId,
    @Default(1) int cpuThreads,
    @Default('0.0.0') String appVersion,
    @Default(Sort()) Sort sort,
    @Default(kDebugMode) bool isDebugMode,
  }) = _Settings;
}

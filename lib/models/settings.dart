import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

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
  int lutId = 0;
}

@Entity()
class Lut {
  @Id()
  int id = 0;
  String name = 'Default';
  String path = '';
}

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

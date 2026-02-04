import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcode_preset.model.freezed.dart';

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

@freezed
abstract class TranscodePreset with _$TranscodePreset {
  const factory TranscodePreset({
    @Default(0) int id,
    @Default('Custom') String name,
    @Default(true) bool useInputResolution,
    @Default(true) bool useHevc,
    @Default(3840) int width,
    @Default(2160) int height,
    @Default(22) int crf,
    @Default(FFmpegPreset.medium) FFmpegPreset ffmpegPreset,
    @Default(0) int lutId,
  }) = _TranscodePreset;
}

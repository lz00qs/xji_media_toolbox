import '../models/transcode_preset.model.dart';
import 'transcode_preset.entity.dart';

extension TranscodePresetMapper on TranscodePresetEntity {
  TranscodePreset toModel() => TranscodePreset(
        name: name,
        useInputResolution: useInputResolution,
        useHevc: useHevc,
        width: width,
        height: height,
        crf: crf,
        ffmpegPreset: FFmpegPreset.values[ffmpegPreset],
        lutId: lutId,
      );
}

extension TranscodePresetEntityMapper on TranscodePreset {
  TranscodePresetEntity toEntity() => TranscodePresetEntity(
        name: name,
        useInputResolution: useInputResolution,
        useHevc: useHevc,
        width: width,
        height: height,
        crf: crf,
        ffmpegPreset: ffmpegPreset.index,
        lutId: lutId,
      );
}

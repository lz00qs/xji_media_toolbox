import 'package:objectbox/objectbox.dart';

import '../models/transcode_preset.model.dart';

@Entity()
class TranscodePresetEntity {
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

  TranscodePresetEntity({
    this.id = 0,
    required this.name,
    required this.useInputResolution,
    required this.useHevc,
    required this.width,
    required this.height,
    required this.crf,
    required this.ffmpegPreset,
    required this.lutId,
  });
}
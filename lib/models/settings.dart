import 'package:objectbox/objectbox.dart';

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
class ExportPreset {
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

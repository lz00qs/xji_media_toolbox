import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TransCodePreset {
  @Id()
  int id = 0;
  String name = 'Custom';
  bool useInputResolution = true;
  bool useHevc = true;
  int width = 3840;
  int height = 2160;
  int crf = 22;
}

class Settings {
  final RxList<TransCodePreset> transCodingPresets = <TransCodePreset>[].obs;
  final defaultTransCodePresetIndex = 0.obs;
}

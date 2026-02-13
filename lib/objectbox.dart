import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:xji_footage_toolbox/storage/lut.entity.dart';
import 'package:xji_footage_toolbox/storage/transcode_preset.entity.dart';
import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {
  late final Store store;
  static ObjectBox? _instance;
  late final Box<TranscodePresetEntity> transcodePresetBox;
  late final Box<LutEntity> lutBox;

  ObjectBox._create(this.store) {
    transcodePresetBox = Box<TranscodePresetEntity>(store);
    lutBox = Box<LutEntity>(store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "xji-media-toolbox"));
    final objectBox = ObjectBox._create(store);
    _instance = objectBox;
    return objectBox;
  }

  static ObjectBox get instance {
    if (_instance == null) {
      throw Exception(
          "ObjectBox not initialized. Call ObjectBox.create() first.");
    }
    return _instance!;
  }
}

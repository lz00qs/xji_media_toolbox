// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
//
// import 'models/settings.dart';
// import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`
//
// class ObjectBox {
//   /// The Store of this app.
//   late final Store store;
//   late final Box<TranscodePreset> transcodePresetBox;
//   late final Box<Lut> lutBox;
//   static ObjectBox? _instance;
//
//   ObjectBox._create(this.store) {
//     transcodePresetBox = Box<TranscodePreset>(store);
//     lutBox = Box<Lut>(store);
//   }
//
//   /// Create an instance of ObjectBox to use throughout the app.
//   static Future<ObjectBox> create() async {
//     final docsDir = await getApplicationDocumentsDirectory();
//     // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
//     final store =
//         await openStore(directory: p.join(docsDir.path, "objectbox-test"));
//     final objectbox = ObjectBox._create(store);
//     _instance = objectbox;
//     return objectbox;
//   }
//
//   static ObjectBox get instance {
//     if (_instance == null) {
//       throw Exception(
//           "ObjectBox not initialized. Call ObjectBox.create() first.");
//     }
//     return _instance!;
//   }
// }

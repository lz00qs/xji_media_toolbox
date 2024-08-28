import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/settings.dart';
import '../objectbox.dart';

class GlobalSettingsController extends GetxController {
  late final ObjectBox objectBox;
  final RxList<ExportPreset> transCodingPresets = <ExportPreset>[].obs;
  final defaultTransCodePresetIndex = 0.obs;

  Future<void> loadSettings() async {
    objectBox = await ObjectBox.create();
    final transCodePresets = objectBox.transCodePresetBox.getAll();
    if (transCodePresets.isEmpty) {
      final defaultPreset = ExportPreset()..name = 'Default';
      objectBox.transCodePresetBox.put(defaultPreset);
      transCodePresets.add(defaultPreset);
    }
    transCodingPresets.addAll(transCodePresets);

    final prefs = await SharedPreferences.getInstance();
    defaultTransCodePresetIndex.value =
        prefs.getInt(defaultTransCodePresetIndexPrefKey) ?? 0;
    if (defaultTransCodePresetIndex.value >= transCodingPresets.length) {
      defaultTransCodePresetIndex.value = 0;
    }
  }

  Future<void> saveSettings() async {
    objectBox.transCodePresetBox.removeAll();
    objectBox.transCodePresetBox.putMany(transCodingPresets);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(
        defaultTransCodePresetIndexPrefKey, defaultTransCodePresetIndex.value);
  }
}

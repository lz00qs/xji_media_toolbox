import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/settings.dart';
import '../objectbox.dart';

enum SortType { name, date, size, sequence }

class GlobalSettingsController extends GetxController {
  late final ObjectBox objectBox;
  final RxList<ExportPreset> transCodingPresets = <ExportPreset>[].obs;
  final defaultTransCodePresetId = 0.obs;
  var cpuThreads = 1;
  var appVersion = '0.0.0';
  var ffmpegParentDir = '';
  final sortType = SortType.name.obs;
  final sortAsc = true.obs;

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
    defaultTransCodePresetId.value =
        prefs.getInt(defaultTransCodePresetIndexPrefKey) == null
            ? 0
            : transCodePresets.isEmpty
                ? 0
                : transCodePresets.first.id;
    sortType.value = SortType.values[prefs.getInt(sortTypePrefKey) ?? 0];
    sortAsc.value = prefs.getBool(sortOderPrefKey) ?? true;
  }

  Future<void> saveSettings() async {
    objectBox.transCodePresetBox.removeAll();
    objectBox.transCodePresetBox.putMany(transCodingPresets);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(
        defaultTransCodePresetIndexPrefKey, defaultTransCodePresetId.value);
    prefs.setInt(sortTypePrefKey, sortType.value.index);
    prefs.setBool(sortOderPrefKey, sortAsc.value);
  }
}

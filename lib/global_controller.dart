// ignore: unused_import
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xji_footage_toolbox/settings.dart';
import 'package:xji_footage_toolbox/video_processing.dart';

import 'footage.dart';
import 'objectbox.dart';

const String defaultTransCodePresetIndexPrefKey = 'defaultTransCodePresetIndex';

class GlobalController extends GetxController {
  static const String settingsStoreKey = 'settings';
  final hasFFmpeg = false.obs;
  final isFootageListView = false.obs;
  Directory? footageDir;
  final List<Footage> footageList = <Footage>[].obs;
  final currentFootageIndex = 0.obs;
  final thumbnailWidth = 100.0.obs;
  final isLoadingFootage = false.obs;
  final galleryListScrollController = ItemScrollController();
  final galleryListScrollListener = ItemPositionsListener.create();
  final appBarHeight = 30.0.obs;
  final topButtonPadding = 5.0.obs;
  final topButtonSize = 20.0.obs;
  final galleryFocusNode = FocusNode();
  final deleteDialogFocusNode = FocusNode();
  final renameAebDialogFocusNode = FocusNode();
  final currentAebIndex = 0.obs;
  final aebListScrollController = ItemScrollController();
  final aebListScrollListener = ItemPositionsListener.create();
  final isEditingVideo = false.obs;
  final videoProcessingTasks = <VideoProcess>[].obs;
  final settings = Settings();
  late final ObjectBox objectBox;

  Future<void> loadSettings() async {
    objectBox = await ObjectBox.create();
    final transCodePresets = objectBox.transCodePresetBox.getAll();
    if (transCodePresets.isEmpty) {
      final defaultPreset = ExportPreset()..name = 'Default';
      objectBox.transCodePresetBox.put(defaultPreset);
      transCodePresets.add(defaultPreset);
    }
    settings.transCodingPresets.addAll(transCodePresets);

    final prefs = await SharedPreferences.getInstance();
    settings.defaultTransCodePresetIndex.value =
        prefs.getInt(defaultTransCodePresetIndexPrefKey) ?? 0;
    if (settings.defaultTransCodePresetIndex.value >=
        settings.transCodingPresets.length) {
      settings.defaultTransCodePresetIndex.value = 0;
    }
  }

  Future<void> saveSettings() async {
    objectBox.transCodePresetBox.removeAll();
    objectBox.transCodePresetBox.putMany(settings.transCodingPresets);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(defaultTransCodePresetIndexPrefKey,
        settings.defaultTransCodePresetIndex.value);
  }

  void resetData() {
    footageDir = null;
    footageList.clear();
    currentFootageIndex.value = 0;
  }

  void resetGalleryData() {
    currentFootageIndex.value = 0;
  }

  void deleteCurrentFootage() {
    final footage = footageList[currentFootageIndex.value];
    if (footageList.length == 1) {
      resetData();
      _deleteFootage(footage);
      return;
    }
    if (footageList.length == (currentFootageIndex.value + 1)) {
      currentFootageIndex.value -= 1;
      footageList.removeAt(currentFootageIndex.value + 1);
      _deleteFootage(footage);
    } else {
      footageList.removeAt(currentFootageIndex.value);
      _deleteFootage(footage);
    }
  }

  void renameCurrentAebFiles() {
    // final footage = footageList[currentFootageIndex.value];
    for (var i = 0;
        i < footageList[currentFootageIndex.value].aebFiles.length;
        i++) {
      var evBias = '';
      switch (i) {
        case 0:
          evBias = '0.0';
          break;
        case 1:
          evBias = '-0.7';
          break;
        case 2:
          evBias = '+0.7';
          break;
        case 3:
          evBias = '-1.3';
          break;
        case 4:
          evBias = '+1.3';
          break;
        case 5:
          evBias = '-2.0';
          break;
        case 6:
          evBias = '+2.0';
          break;
        default:
          evBias = '0.0';
      }
      final suffix =
          '_AEB_${footageList[currentFootageIndex.value].sequence}_$evBias';
      final oldFile = footageList[currentFootageIndex.value].aebFiles[i];
      final formatter = DateFormat('yyyyMMddHHmmss');
      final formatted =
          formatter.format(footageList[currentFootageIndex.value].time);
      final sequenceStr = (footageList[currentFootageIndex.value].sequence + i)
          .toString()
          .padLeft(4, '0');
      final newPath =
          '${footageDir?.path}/DJI_${formatted}_${sequenceStr}_D$suffix.JPG';
      final newFile = File(newPath);
      try {
        oldFile.renameSync(newFile.path);
        footageList[currentFootageIndex.value].aebFiles[i] = newFile;
        if (i == 0) {
          footageList[currentFootageIndex.value].file = newFile;
          footageList[currentFootageIndex.value].name.value =
              newFile.uri.pathSegments.last;
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error renaming file: ${oldFile.path}');
      }
    }
  }

  void _deleteFootage(Footage footage) {
    if (footage.isAeb) {
      for (var file in footage.aebFiles) {
        try {
          file.deleteSync();
        } catch (e) {
          Fluttertoast.showToast(msg: 'Error deleting file: ${file.path}');
        }
      }
    } else {
      try {
        footage.file.deleteSync();
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'Error deleting file: ${footage.file.path}');
      }
    }
  }
}

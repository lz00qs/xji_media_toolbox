// ignore: unused_import
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'footage.dart';

class GlobalController extends GetxController {
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
  final currentAebIndex = 0.obs;
  final aebListScrollController = ItemScrollController();
  final aebListScrollListener = ItemPositionsListener.create();

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

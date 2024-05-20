import 'dart:io';

import 'package:flutter/material.dart';
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

  void resetData() {
    footageDir = null;
    footageList.clear();
    currentFootageIndex.value = 0;
  }

  void resetGalleryData() {
    currentFootageIndex.value = 0;
  }

  void deleteCurrentFootage() {
    if (footageList.length == 1) {
      resetData();
      return;
    }
    if (footageList.length == (currentFootageIndex.value + 1)) {
      currentFootageIndex.value -= 1;
      footageList.removeAt(currentFootageIndex.value + 1);
    } else {
      footageList.removeAt(currentFootageIndex.value);
    }
  }
}

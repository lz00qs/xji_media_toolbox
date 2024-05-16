import 'dart:io';

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

  void resetData() {
    footageDir = null;
    footageList.clear();
    currentFootageIndex.value = 0;
  }

  void resetGalleryData() {
    currentFootageIndex.value = 0;
  }
}

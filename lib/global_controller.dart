import 'dart:io';

import 'package:get/get.dart';

import 'footage.dart';

class GlobalController extends GetxController {
  final hasFFmpeg = false.obs;
  final isFootageListView = false.obs;
  Directory? footageDir;
  final List<Footage> footageList = <Footage>[].obs;
}

import 'dart:io';

import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_focus_nodes_controller.dart';

import '../models/media_resource.dart';
import '../ui/widgets/media_resources_list_panel_widget.dart';

class GlobalMediaResourcesController extends GetxController {
  Directory? _mediaResourceDir;
  final RxList<MediaResource> mediaResources = <MediaResource>[].obs;
  final _currentMediaIndex = 0.obs;
  final Rx<MediaResource?> currentMediaResource = null.obs;
  final isLoadingMediaResources = false.obs;

  Directory? get mediaResourceDir => _mediaResourceDir;

  set mediaResourceDir(Directory? value) {
    _mediaResourceDir = value;
    loadMediaResources();
  }

  RxInt get currentMediaIndex => _currentMediaIndex;

  void setCurrentMediaIndex(int index) {
    if (index < 0 || index >= mediaResources.length) {
      return;
    }
    _currentMediaIndex.value = index;
    currentMediaResource.value = mediaResources[index];
  }

  @override
  void onInit() {
    super.onInit();
    Get.put(MediaResourcesListPanelController());
    Get.put(GlobalFocusNodesController());
  }

  Future<void> loadMediaResources() async {
    if (_mediaResourceDir == null) {
      return;
    }
    update();
  }
}

import 'dart:io';

import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_focus_nodes_controller.dart';
import 'package:xji_footage_toolbox/ui/widgets/aeb_photo_viewer_widget.dart';

import '../models/media_resource.dart';
import '../ui/widgets/media_resources_list_panel_widget.dart';
import 'global_tasks_controller.dart';

class GlobalMediaResourcesController extends GetxController {
  Directory? _mediaResourceDir;
  final RxList<MediaResource> mediaResources = <MediaResource>[].obs;
  final currentMediaIndex = 0.obs;
  final isLoadingMediaResources = false.obs;
  final isEditingMediaResources = false.obs;

  Directory? get mediaResourceDir => _mediaResourceDir;

  set mediaResourceDir(Directory? value) {
    _mediaResourceDir = value;
    mediaResources.clear();
    loadMediaResources();
  }

  @override
  void onInit() {
    super.onInit();
    Get.put(MediaResourcesListPanelController());
    Get.put(GlobalFocusNodesController());
    Get.put(AebPhotoViewerController());
    Get.put(GlobalTasksController());
  }

  Future<void> loadMediaResources() async {
    if (_mediaResourceDir == null) {
      return;
    }
    update();
  }
}

import 'dart:io';

import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_focus_nodes_controller.dart';
import 'package:xji_footage_toolbox/ui/widgets/aeb_photo_viewer_widget.dart';

import '../models/media_resource.dart';
import '../ui/widgets/media_resources_list_panel_widget.dart';
import '../ui/widgets/multi_select_panel.dart';
import '../ui/widgets/video_merger_widget.dart';
import 'global_tasks_controller.dart';

class GlobalMediaResourcesController extends GetxController {
  Directory? _mediaResourceDir;
  final RxList<MediaResource> mediaResources = <MediaResource>[].obs;
  final currentMediaIndex = 0.obs;
  final isLoadingMediaResources = false.obs;
  final isEditingMediaResources = false.obs;

  Directory? get mediaResourceDir => _mediaResourceDir;

  final isMultipleSelection = false.obs;
  final selectedIndexList = <int>[].obs;

  set mediaResourceDir(Directory? value) {
    _mediaResourceDir = value;
    mediaResources.clear();
    loadMediaResources();
  }

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => MediaResourcesListPanelController());
    Get.lazyPut(() => GlobalFocusNodesController());
    Get.lazyPut(() => AebPhotoViewerController());
    Get.lazyPut(() => GlobalTasksController());
    Get.lazyPut(() => VideoMergerController());
    Get.lazyPut(() => MultiSelectPanelController());
  }

  Future<void> loadMediaResources() async {
    if (_mediaResourceDir == null) {
      return;
    }
    update();
  }
}

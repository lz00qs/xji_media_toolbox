import 'dart:io';

import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_focus_nodes_controller.dart';

import '../models/media_resource.dart';
import '../new_ui/aeb_photo_view.dart';
import '../new_ui/media_resources_list_panel.dart';
import '../new_ui/multi_select_panel.dart';
import '../ui/pages/loading_media_resources_page.dart';
import '../ui/widgets/panels/views/video_merger_view.dart';
import 'global_tasks_controller.dart';

class GlobalMediaResourcesController extends GetxController {
  Directory? _mediaResourceDir;
  final RxList<MediaResource> mediaResources = <MediaResource>[].obs;
  final currentMediaIndex = 0.obs;
  final isEditingMediaResources = false.obs;

  Directory? get mediaResourceDir => _mediaResourceDir;

  final isMultipleSelection = false.obs;
  final RxSet<int> selectedIndexList = <int>{}.obs;

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
    Get.lazyPut(() => AebPhotoViewController());
    Get.lazyPut(() => GlobalTasksController());
    Get.lazyPut(() => VideoMergerController());
    Get.lazyPut(() => MultiSelectPanelController());
    Get.lazyPut(() => LoadingMediaResourcesController());
  }

  Future<void> loadMediaResources() async {
    if (_mediaResourceDir == null) {
      return;
    }
    update();
  }
}

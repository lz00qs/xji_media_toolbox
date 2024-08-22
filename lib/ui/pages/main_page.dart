import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/widgets/load_media_resources_icon_button_widget.dart';
import 'package:xji_footage_toolbox/ui/widgets/media_resources_list_panel_widget.dart';

import '../../controllers/global_media_resources_controller.dart';
import '../widgets/media_resource_info_panel_widget.dart';
import '../widgets/resizable_triple_panel_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    return Scaffold(
      body: Obx(() => ResizableTriplePanelWidget(
            topLeftPanel: globalMediaResourcesController.mediaResources.isEmpty
                ? const Center(
                    child: LoadMediaResourcesIconButtonWidget(),
                  )
                : const MediaResourcesListPanelWidget(),
            bottomLeftPanel:
                globalMediaResourcesController.mediaResources.isEmpty
                    ? const SizedBox()
                    : MediaResourceInfoPanelWidget(
                        mediaResource:
                            globalMediaResourcesController.mediaResources[
                                globalMediaResourcesController
                                    .currentMediaIndex.value]),
            rightPanel: Text('Right Panel'),
          )),
    );
  }
}

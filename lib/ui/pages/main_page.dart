import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// import 'package:xji_footage_toolbox/controllers/global_focus_nodes_controller.dart';
// import 'package:xji_footage_toolbox/controllers/global_media_resources_controller.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

// import 'package:xji_footage_toolbox/ui/widgets/views/media_resource_info_panel.dart';

// import '../widgets/views/aeb_photo_view.dart';
// import '../main_panel.dart';
import '../widgets/buttons/main_panel_button.dart';

// import '../widgets/views/multi_select_panel.dart';
import '../../utils/media_resources_utils.dart';
// import '../widgets/views/media_resources_list_panel.dart';

final _mediaResourcesListPanelFocusNode = FocusNode();
final _dialogFocusNode = FocusNode();

class _MainPageEmpty extends StatelessWidget {
  const _MainPageEmpty();

  @override
  Widget build(BuildContext context) {
    var onPressed = false;
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: ColorDark.bg0,
      child: Center(
        child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return MainPanelButton(
              iconData: Icons.folder_open,
              onPressed: () async {
                if (onPressed) {
                  return;
                }
                onPressed = true;
                await openMediaResourcesFolder(ref: ref);
                onPressed = false;
              });
        }),
      ),
    );
  }
}

class _MainPageNotEmpty extends StatelessWidget {
  final MediaResource mediaResource;
  final bool isMultipleSelection;

  const _MainPageNotEmpty(
      {required this.mediaResource, required this.isMultipleSelection});

  @override
  Widget build(BuildContext context) {
    // final AebPhotoViewController aebPhotoViewController = Get.find();
    // aebPhotoViewController.currentAebIndex.value = 0;
    // return ResizableTriplePanel(
    //     topLeftPanel: const MediaResourcesListPanel(),
    //     bottomLeftPanel: MediaResourceInfoPanel(mediaResource: mediaResource),
    //     rightPanel: isMultipleSelection
    //         ? const MultiSelectPanel()
    //         : MainPanel(mediaResource: mediaResource));
    // return ResizableTriplePanel(topLeftPanel: topLeftPanel, bottomLeftPanel: bottomLeftPanel, rightPanel: rightPanel)
    throw UnimplementedError();
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  void _increaseCurrentMediaIndex() {
    // final GlobalMediaResourcesController globalMediaResourcesController =
    //     Get.find();
    // final MediaResourcesListPanelController mediaResourcesListPanelController =
    //     Get.find();
    // if (globalMediaResourcesController.currentMediaIndex <
    //     globalMediaResourcesController.mediaResources.length - 1) {
    //   globalMediaResourcesController.currentMediaIndex.value += 1;
    //   mediaResourcesListPanelController.scrollToIndex(
    //       globalMediaResourcesController.currentMediaIndex.value, true);
    // }
  }

  void _decreaseCurrentMediaIndex() {
    // final GlobalMediaResourcesController globalMediaResourcesController =
    //     Get.find();
    // final MediaResourcesListPanelController mediaResourcesListPanelController =
    //     Get.find();
    // if (globalMediaResourcesController.currentMediaIndex > 0) {
    //   globalMediaResourcesController.currentMediaIndex.value -= 1;
    //   mediaResourcesListPanelController.scrollToIndex(
    //       globalMediaResourcesController.currentMediaIndex.value, false);
    // }
  }

  void _increaseCurrentAebIndex() {
    // final AebPhotoViewController aebPhotoViewController = Get.find();
    // final GlobalMediaResourcesController globalMediaResourcesController =
    //     Get.find();
    // if (globalMediaResourcesController
    //     .mediaResources[globalMediaResourcesController.currentMediaIndex.value]
    //     .isAeb) {
    //   if (aebPhotoViewController.currentAebIndex <
    //       (globalMediaResourcesController.mediaResources[
    //                   globalMediaResourcesController
    //                       .currentMediaIndex.value] as AebPhotoResource)
    //               .aebResources
    //               .length -
    //           1) {
    //     aebPhotoViewController.currentAebIndex.value += 1;
    //   }
    // }
  }

  void _decreaseCurrentAebIndex() {
    // final AebPhotoViewController aebPhotoViewController = Get.find();
    // final GlobalMediaResourcesController globalMediaResourcesController =
    //     Get.find();
    // if (globalMediaResourcesController
    //     .mediaResources[globalMediaResourcesController.currentMediaIndex.value]
    //     .isAeb) {
    //   if (aebPhotoViewController.currentAebIndex > 0) {
    //     aebPhotoViewController.currentAebIndex.value -= 1;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _mediaResourcesListPanelFocusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowUp:
              _decreaseCurrentMediaIndex();
              break;
            case LogicalKeyboardKey.arrowDown:
              _increaseCurrentMediaIndex();
              break;
            case LogicalKeyboardKey.arrowLeft:
              _decreaseCurrentAebIndex();
              break;
            case LogicalKeyboardKey.arrowRight:
              _increaseCurrentAebIndex();
              break;
          }
        }
      },
      child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final resources = ref
            .watch(mediaResourcesProvider.select((state) => state.resources));
        final currentIndex = ref.watch(
            mediaResourcesProvider.select((state) => state.currentIndex));
        final isMultipleSelection = ref.watch(mediaResourcesProvider
            .select((state) => state.isMultipleSelection));
        if (resources.isEmpty) {
          return const _MainPageEmpty();
        } else {
          return _MainPageNotEmpty(
              mediaResource: resources[currentIndex],
              isMultipleSelection: isMultipleSelection);
        }
      }),
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

import '../../providers/media_resources_state.notifier.dart';
import '../../providers/settings.notifier.dart';
import '../widgets/buttons/main_panel_button.dart';
import '../widgets/panels/media_resources_list_panel.dart';
import '../widgets/resizable_panel.dart';
import 'loading_media_resources_page.dart';

// import 'package:xji_footage_toolbox/ui/widgets/views/media_resource_info_panel.dart';
// import 'package:xji_footage_toolbox/ui/widgets/views/media_resources_list_panel.dart';
// import '../../providers/media_resources_provider.dart';
// import '../widgets/buttons/main_panel_button.dart';
// import '../../utils/media_resources_utils.dart';
// import '../widgets/views/main_panel.dart';
// import '../widgets/views/multi_select_panel.dart';

final _mediaResourcesListPanelFocusNode = FocusNode();

class _MainPageEmpty extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaResourcesNotifier =
        ref.watch(mediaResourcesStateProvider.notifier);
    var onPressed = false;
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: ColorDark.bg0,
      child: Center(
        child: MainPanelButton(
            iconData: Icons.folder_open,
            onPressed: () async {
              if (onPressed) {
                return;
              }
              onPressed = true;
              final selectedDirectory =
                  await FilePicker.platform.getDirectoryPath();
              if (selectedDirectory != null) {
                await mediaResourcesNotifier
                    .loadMediaResourcesFromDir(selectedDirectory, false,
                        ref.watch(settingsProvider).cpuThreads, ref.watch(settingsProvider).sort);
              }
              onPressed = false;
            }),
      ),
    );
  }
}

class _MainPageNotEmpty extends ConsumerWidget {
  const _MainPageNotEmpty();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResizablePanel(
      mediaResourcesListPanel: MediaResourcesListPanel(),
      mediaResourceInfoPanel: SizedBox(),
      // mediaResourceInfoPanel: MediaResourceInfoPanel(),
      mainPanel: SizedBox(),
      // mainPanel: ref.watch(mediaResourcesProvider
      //     .select((state) => state.isMultipleSelection))
      //     ? MultiSelectPanel()
      //     : MainPanel(),
    );
  }
}

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaResourcesState = ref.watch(mediaResourcesStateProvider);
    return mediaResourcesState.isLoading
        ? LoadingMediaResourcesPage()
        : mediaResourcesState.resources.isEmpty
            ? _MainPageEmpty()
            : _MainPageNotEmpty();
  }
}

// class MainPage extends StatelessWidget {
//   final WidgetRef mainRef;
//
//   const MainPage({super.key, required this.mainRef});
//
//   void _increaseCurrentMediaIndex() {
//     final currentIndex = mainRef.watch(
//         mediaResourcesProvider.select((state) => state.currentIndex));
//     final resourcesLength = mainRef.watch(mediaResourcesProvider
//         .select((state) => state.resources.length));
//     if (currentIndex < resourcesLength - 1) {
//       mainRef.read(mediaResourcesProvider.notifier).increaseCurrentIndex();
//       mediaResourcesListScrollToIndex(currentIndex + 1, true);
//     }
//   }
//
//   void _decreaseCurrentMediaIndex() {
//     final currentIndex = mainRef.watch(
//         mediaResourcesProvider.select((state) => state.currentIndex));
//     if (currentIndex > 0) {
//       mainRef.read(mediaResourcesProvider.notifier).decreaseCurrentIndex();
//       mediaResourcesListScrollToIndex(currentIndex - 1, false);
//     }
//   }
//
//   void _increaseCurrentAebIndex() {
//     final currentIndex = mainRef.watch(
//         mediaResourcesProvider.select((state) => state.currentIndex));
//     final resource = mainRef.watch(mediaResourcesProvider
//         .select((state) => state.resources[currentIndex]));
//     if (resource.isAeb == true) {
//       mainRef.read(mediaResourcesProvider.notifier).increaseCurrentAebIndex();
//     }
//   }
//
//   void _decreaseCurrentAebIndex() {
//     final currentIndex = mainRef.watch(
//         mediaResourcesProvider.select((state) => state.currentIndex));
//     final resource = mainRef.watch(mediaResourcesProvider
//         .select((state) => state.resources[currentIndex]));
//     if (resource.isAeb == true) {
//       final currentAebIndex = mainRef.watch(mediaResourcesProvider
//           .select((state) => state.currentAebIndex));
//       if (currentAebIndex > 0) {
//         mainRef
//             .read(mediaResourcesProvider.notifier)
//             .decreaseCurrentAebIndex();
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FocusScope(
//         canRequestFocus: true,
//         autofocus: true,
//         child: KeyboardListener(
//             focusNode: _mediaResourcesListPanelFocusNode,
//             autofocus: true,
//             onKeyEvent: (event) {
//               if (event is KeyDownEvent || event is KeyRepeatEvent) {
//                 switch (event.logicalKey) {
//                   case LogicalKeyboardKey.arrowUp:
//                     _decreaseCurrentMediaIndex();
//                     break;
//                   case LogicalKeyboardKey.arrowDown:
//                     _increaseCurrentMediaIndex();
//                     break;
//                   case LogicalKeyboardKey.arrowLeft:
//                     _decreaseCurrentAebIndex();
//                     break;
//                   case LogicalKeyboardKey.arrowRight:
//                     _increaseCurrentAebIndex();
//                     break;
//                 }
//               }
//             },
//             child: Consumer(
//                 builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                   final resourcesIsEmpty = ref.watch(mediaResourcesProvider
//                       .select((state) => state.resources.isEmpty));
//                   if (resourcesIsEmpty) {
//                     return _MainPageEmpty(ref: mainRef);
//                   } else {
//                     return const _MainPageNotEmpty();
//                   }
//                 })));
//   }
// }

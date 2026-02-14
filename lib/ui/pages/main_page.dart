import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';
import 'package:xji_footage_toolbox/ui/panels/multi_select_panel.dart';

import '../../models/media_resource.model.dart';
import '../../providers/media_resources_state.notifier.dart';
import '../../providers/settings.notifier.dart';
import '../buttons/main_panel_button.dart';
import '../panels/main_panel.dart';
import '../panels/media_resource_info_panel.dart';
import '../panels/media_resources_list_panel.dart';
import '../resizable_panel.dart';
import 'loading_media_resources_page.dart';

final _mainPageNotEmptyFocusNode = FocusNode();

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
                await mediaResourcesNotifier.loadMediaResourcesFromDir(
                    selectedDirectory,
                    false,
                    ref.watch(settingsProvider).cpuThreads,
                    ref.watch(settingsProvider).sort);
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
    final currentMediaResource = ref.watch(mediaResourcesStateProvider.select(
        (s) => s.resources.length > s.currentResourceIndex
            ? s.resources[s.currentResourceIndex]
            : null));
    AebPhotoResource? currentAebResource;
    if (currentMediaResource is AebPhotoResource) {
      currentAebResource = ref.watch(mediaResourcesStateProvider.select((s) =>
          currentMediaResource.aebResources.length > s.currentAebIndex
              ? currentMediaResource.aebResources[s.currentAebIndex]
              : null));
    }
    final isMultipleSelection = ref.watch(
        mediaResourcesStateProvider.select((s) => s.isMultipleSelection));
    return FocusScope(
        canRequestFocus: true,
        autofocus: true,
        child: KeyboardListener(
            focusNode: _mainPageNotEmptyFocusNode,
            autofocus: true,
            onKeyEvent: (event) {
              if (event is KeyDownEvent || event is KeyRepeatEvent) {
                switch (event.logicalKey) {
                  case LogicalKeyboardKey.arrowUp:
                    ref
                        .read(mediaResourcesStateProvider.notifier)
                        .decreaseCurrentResourceIndex();
                    mediaResourcesListScrollToIndex(ref.watch(mediaResourcesStateProvider.select((s) => s.currentResourceIndex)), false);
                    break;
                  case LogicalKeyboardKey.arrowDown:
                    ref
                        .read(mediaResourcesStateProvider.notifier)
                        .increaseCurrentResourceIndex();
                    mediaResourcesListScrollToIndex(ref.watch(mediaResourcesStateProvider.select((s) => s.currentResourceIndex)), true);
                    break;
                  case LogicalKeyboardKey.arrowLeft:
                    ref
                        .read(mediaResourcesStateProvider.notifier)
                        .decreaseCurrentAebIndex();
                    break;
                  case LogicalKeyboardKey.arrowRight:
                    ref
                        .read(mediaResourcesStateProvider.notifier)
                        .increaseCurrentAebIndex();
                    break;
                }
              }
            },
            child: ResizablePanel(
              mediaResourcesListPanel: MediaResourcesListPanel(),
              mediaResourceInfoPanel: currentMediaResource != null
                  ? MediaResourceInfoPanel(
                      mediaResource: currentAebResource ?? currentMediaResource)
                  : SizedBox(),
              mainPanel: currentMediaResource != null
                  ? isMultipleSelection
                      ? MultiSelectPanel()
                      : MainPanel(resource: currentMediaResource)
                  : SizedBox(),
            )));
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

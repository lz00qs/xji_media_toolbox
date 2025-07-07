import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';
import 'package:xji_footage_toolbox/ui/widgets/resizable_panel.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/media_resources_list_panel.dart';
import '../widgets/buttons/main_panel_button.dart';
import '../../utils/media_resources_utils.dart';

final _mediaResourcesListPanelFocusNode = FocusNode();
final _dialogFocusNode = FocusNode();

class _MainPageEmpty extends StatelessWidget {
  final WidgetRef ref;

  const _MainPageEmpty({required this.ref});

  @override
  Widget build(BuildContext context) {
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
              await openMediaResourcesFolder(ref: ref);
              onPressed = false;
            }),
      ),
    );
  }
}

class _MainPageNotEmpty extends StatelessWidget {
  const _MainPageNotEmpty();

  @override
  Widget build(BuildContext context) {
    return ResizablePanel();
  }
}

class MainPage extends StatelessWidget {
  final WidgetRef ref;

  const MainPage({super.key, required this.ref});

  void _increaseCurrentMediaIndex() {
    final currentIndex =
        ref.watch(mediaResourcesProvider.select((state) => state.currentIndex));
    final resources =
        ref.watch(mediaResourcesProvider.select((state) => state.resources));
    if (currentIndex < resources.length - 1) {
      ref
          .read(mediaResourcesProvider.notifier)
          .setCurrentIndex(currentIndex + 1);
      mediaResourcesListScrollToIndex(currentIndex + 1, true);
    }
  }

  void _decreaseCurrentMediaIndex() {
    final currentIndex =
        ref.watch(mediaResourcesProvider.select((state) => state.currentIndex));
    if (currentIndex > 0) {
      ref
          .read(mediaResourcesProvider.notifier)
          .setCurrentIndex(currentIndex - 1);
      mediaResourcesListScrollToIndex(currentIndex - 1, false);
    }
  }

  void _increaseCurrentAebIndex() {
    final currentIndex =
        ref.watch(mediaResourcesProvider.select((state) => state.currentIndex));
    final resource = ref.watch(mediaResourcesProvider
        .select((state) => state.resources[currentIndex]));
    if (resource.isAeb) {
      final aebResource = resource as AebPhotoResource;
      final currentAebIndex = ref.watch(
          mediaResourcesProvider.select((state) => state.currentAebIndex));
      if (currentAebIndex < aebResource.aebResources.length - 1) {
        ref
            .read(mediaResourcesProvider.notifier)
            .setCurrentAebIndex(currentAebIndex + 1);
      }
    }
  }

  void _decreaseCurrentAebIndex() {
    final currentIndex =
        ref.watch(mediaResourcesProvider.select((state) => state.currentIndex));
    final resource = ref.watch(mediaResourcesProvider
        .select((state) => state.resources[currentIndex]));
    if (resource.isAeb) {
      final currentAebIndex = ref.watch(
          mediaResourcesProvider.select((state) => state.currentAebIndex));
      if (currentAebIndex > 0) {
        ref
            .read(mediaResourcesProvider.notifier)
            .setCurrentAebIndex(currentAebIndex - 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
        canRequestFocus: true,
        autofocus: true,
        child: KeyboardListener(
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
          child: Builder(builder: (BuildContext context) {
            final resources = ref.watch(
                mediaResourcesProvider.select((state) => state.resources));
            if (resources.isEmpty) {
              return _MainPageEmpty(ref: ref);
            } else {
              return _MainPageNotEmpty();
            }
          }),
        ));
  }
}

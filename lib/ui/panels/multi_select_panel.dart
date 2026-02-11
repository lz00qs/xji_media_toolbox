import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/models/media_resource.model.dart';
import 'package:xji_footage_toolbox/providers/media_resources_state.notifier.dart';
import 'package:xji_footage_toolbox/ui/panels/video_merger_panel.dart';
import '../buttons/main_panel_button.dart';
import '../design_tokens.dart';
import '../dialogs/media_resource_delete_dialog.dart';

part 'multi_select_panel.g.dart';

class _DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var isPressed = false;
    return MainPanelButton(
        iconData: Icons.delete,
        onPressed: () async {
          if (isPressed) {
            return;
          }
          isPressed = true;
          onPressed();
          isPressed = false;
        });
  }
}

class _MergeVideoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _MergeVideoButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var isPressed = false;
    return MainPanelButton(
        iconData: Icons.merge_type,
        onPressed: () async {
          if (isPressed) {
            return;
          }
          isPressed = true;
          onPressed();
          isPressed = false;
        });
  }
}

@riverpod
class IsMergingNotifier extends _$IsMergingNotifier {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}

class MultiSelectPanel extends ConsumerWidget {
  const MultiSelectPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final containPhotos = ref.watch(mediaResourcesStateProvider.select(
        (state) => state.selectedResources
            .any((element) => element is! VideoResource)));
    final selectedResourcesIsEmpty = ref.watch(mediaResourcesStateProvider
        .select((state) => state.selectedResources.isEmpty));
    return Center(
      child: selectedResourcesIsEmpty
          ? Text('Select some resources first!',
              style: SemiTextStyles.header4ENRegular
                  .copyWith(color: ColorDark.text0))
          : containPhotos
              ? _DeleteButton(onPressed: () async {
                  final result = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) =>
                          MediaResourceDeleteDialog(
                            mediaResourcesLength: ref
                                .watch(mediaResourcesStateProvider)
                                .selectedResources
                                .length,
                          ));
                  if (result == true) {
                    await ref
                        .read(mediaResourcesStateProvider.notifier)
                        .deleteSelectedMediaResources();
                  }
                })
              : ref.watch(isMergingProvider)
                  ? VideoMergerPanel()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _DeleteButton(onPressed: () async {
                          final result = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) =>
                                  MediaResourceDeleteDialog(
                                    mediaResourcesLength: ref
                                        .watch(mediaResourcesStateProvider)
                                        .selectedResources
                                        .length,
                                  ));
                          if (result == true) {
                            await ref
                                .read(mediaResourcesStateProvider.notifier)
                                .deleteSelectedMediaResources();
                          }
                        }),
                        const SizedBox(
                          width: 64,
                        ),
                        _MergeVideoButton(onPressed: () {
                          ref.read(isMergingProvider.notifier).toggle();
                        })
                      ],
                    ),
    );
  }
}

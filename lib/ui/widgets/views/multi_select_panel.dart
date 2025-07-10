import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/video_merger_panel.dart';
import '../../../models/media_resource.dart';
import '../../design_tokens.dart';
import '../buttons/main_panel_button.dart';
import '../dialogs/media_resource_delete_dialog.dart';

class MultiSelectPanelController extends GetxController {
  final isMerging = false.obs;
}

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

final isMergingStateProvider = StateProvider<bool>((ref) => false);

class MultiSelectPanel extends ConsumerWidget {
  const MultiSelectPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final containPhotos = ref.watch(mediaResourcesProvider.select((state) =>
        state.selectedResources.any((element) => element.isVideo == false)));
    final selectedResourcesIsEmpty = ref.watch(mediaResourcesProvider
        .select((state) => state.selectedResources.isEmpty));
    return Center(
      child: selectedResourcesIsEmpty
          ? Text('Select some resources first!',
              style: SemiTextStyles.header4ENRegular
                  .copyWith(color: ColorDark.text0))
          : containPhotos
              ? _DeleteButton(onPressed: () async {
                  await Get.dialog(const MediaResourceDeleteDialog());
                })
              : ref.watch(isMergingStateProvider) == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _DeleteButton(onPressed: () async {
                          await Get.dialog(const MediaResourceDeleteDialog());
                        }),
                        const SizedBox(
                          width: 64,
                        ),
                        _MergeVideoButton(onPressed: () {
                          ref.read(isMergingStateProvider.notifier).state =
                              true;
                        })
                      ],
                    )
                  : VideoMergerPanel(),
    );
  }
}

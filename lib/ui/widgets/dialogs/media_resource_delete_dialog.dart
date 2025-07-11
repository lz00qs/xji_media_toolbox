import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/custom_dual_option_dialog.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';


class _ConfirmText extends StatelessWidget {
  final String text;

  const _ConfirmText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style:
            SemiTextStyles.header5ENRegular.copyWith(color: ColorDark.text0));
  }
}

class MediaResourceDeleteDialog extends ConsumerWidget {
  const MediaResourceDeleteDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMultipleSelection = ref.watch(
        mediaResourcesProvider.select((state) => state.isMultipleSelection));
    final mediaResourcesLength = ref.watch(
        mediaResourcesProvider.select((state) => state.resources.length));
    final mediaResources =
        ref.watch(mediaResourcesProvider.select((state) => state.resources));
    return CustomDualOptionDialog(
        width: 400,
        height: 240,
        title: 'Delete',
        option1: 'Delete',
        option2: 'Cancel',
        onOption1Pressed: () {
          if (mediaResourcesLength != 0) {
            if (isMultipleSelection) {
              for (int i = ref.watch(mediaResourcesProvider
                          .select((state) => state.selectedResources.length)) -
                      1;
                  i >= 0;
                  i--) {
                final mediaResource = ref.watch(mediaResourcesProvider
                    .select((state) => state.selectedResources[i]));
                ref
                    .read(mediaResourcesProvider.notifier)
                    .removeResource(resource: mediaResource);
              }
              ref
                  .read(mediaResourcesProvider.notifier)
                  .clearSelectedResources();
            } else {
              final currentIndex = ref.watch(
                  mediaResourcesProvider.select((state) => state.currentIndex));
              final mediaResource = mediaResources[currentIndex];
              ref
                  .read(mediaResourcesProvider.notifier)
                  .removeResource(resource: mediaResource);
            }
          }
          Navigator.of(context).pop();
        },
        onOption2Pressed: () {
          Navigator.of(context).pop();
        },
        child: isMultipleSelection
            ? _ConfirmText(
                text: 'Are you sure you want to delete these '
                    '${ref.watch(mediaResourcesProvider.select((state) => state.resources.length))} '
                    'media resources?')
            : const _ConfirmText(
                text: 'Are you sure you want to delete this media resource?'));
  }
}

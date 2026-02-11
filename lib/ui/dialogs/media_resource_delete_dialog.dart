import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

import 'dual_option_dialog.dart';

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
  final int mediaResourcesLength;

  const MediaResourceDeleteDialog({super.key, required this.mediaResourcesLength});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMultipleSelection = mediaResourcesLength > 1;
    return DualOptionDialog(
        width: 400,
        height: 240,
        title: 'Delete',
        option1: 'Cancel',
        option2: 'Delete',
        onOption1Pressed: () {
          Navigator.of(context).pop(false);
        },
        onOption2Pressed: () {
          Navigator.of(context).pop(true);
        },
        child: isMultipleSelection
            ? _ConfirmText(
                text: 'Are you sure you want to delete these '
                    '$mediaResourcesLength'
                    'media resources?')
            : const _ConfirmText(
                text: 'Are you sure you want to delete this media resource?'));
  }
}

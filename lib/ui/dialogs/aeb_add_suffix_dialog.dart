import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design_tokens.dart';
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

class AebAddSuffixDialog extends ConsumerWidget {
  const AebAddSuffixDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DualOptionDialog(
        width: 400,
        height: 240,
        title: 'Add AEB Suffix',
        option1: 'Cancel',
        option2: 'Add',
        onOption1Pressed: () {
          Navigator.of(context).pop(false);
        },
        onOption2Pressed: () {
          Navigator.of(context).pop(true);
        },
        child: const _ConfirmText(
            text:
                'Are you sure you want to add AEB suffix to these AEB media resources?'));
  }
}

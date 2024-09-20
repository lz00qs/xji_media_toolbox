import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/utils/media_resources_utils.dart';

import '../../../controllers/global_media_resources_controller.dart';
import '../../design_tokens.dart';
import 'custom_dual_option_dialog.dart';

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

class AddAebSuffixDialog extends StatelessWidget {
  const AddAebSuffixDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDualOptionDialog(
        width: 400,
        height: 240,
        title: 'Add AEB Suffix',
        option1: 'Cancel',
        option2: 'Add',
        onOption1Pressed: () {
          Get.back();
        },
        onOption2Pressed: () {
          addSuffixToCurrentAebFilesName();
          Get.back();
        },
        child: const _ConfirmText(
            text:
                'Are you sure you want to add AEB suffix to these AEB media resources?'));
  }
}

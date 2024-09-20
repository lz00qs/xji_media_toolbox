import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_media_resources_controller.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/custom_dual_option_dialog.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

import '../../../utils/media_resources_utils.dart';

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

class MediaResourceDeleteDialog extends StatelessWidget {
  const MediaResourceDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalMediaResourcesController globalMediaResourcesController =
        Get.find();
    return CustomDualOptionDialog(
        width: 400,
        height: 240,
        title: 'Delete',
        option1: 'Delete',
        option2: 'Cancel',
        onOption1Pressed: () {
          if (globalMediaResourcesController.isMultipleSelection.value) {
            for (int i =
                    globalMediaResourcesController.selectedIndexList.length - 1;
                i >= 0;
                i--) {
              deleteMediaResource(
                  globalMediaResourcesController.selectedIndexList[i]);
            }
            globalMediaResourcesController.selectedIndexList.clear();
          } else {
            deleteMediaResource(
                globalMediaResourcesController.currentMediaIndex.value);
          }
          Get.back();
        },
        onOption2Pressed: () {
          Get.back();
        },
        child: globalMediaResourcesController.isMultipleSelection.value
            ? _ConfirmText(
                text: 'Are you sure you want to delete these '
                    '${globalMediaResourcesController.selectedIndexList.length} '
                    'media resources?')
            : const _ConfirmText(
                text: 'Are you sure you want to delete this media resource?'));
  }
}

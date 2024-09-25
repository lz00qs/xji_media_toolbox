import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/aeb_photo_view.dart';
import 'package:xji_footage_toolbox/utils/media_resources_utils.dart';

import '../../../controllers/global_media_resources_controller.dart';
import '../../design_tokens.dart';
import 'custom_dual_option_dialog.dart';

class MediaResourceRenameDialog extends StatelessWidget {
  const MediaResourceRenameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalMediaResourcesController globalMediaResourcesController =
        Get.find();
    final mediaResource = globalMediaResourcesController
        .mediaResources[globalMediaResourcesController.currentMediaIndex.value];
    final fileNameTextEditingController = TextEditingController();
    if (mediaResource.isAeb) {
      final AebPhotoViewController aebPhotoViewController = Get.find();
      final fileName = (mediaResource as AebPhotoResource)
          .aebResources[aebPhotoViewController.currentAebIndex.value]
          .name;
      fileNameTextEditingController.text =
          fileName.substring(0, fileName.lastIndexOf('.'));
    } else {
      fileNameTextEditingController.text = globalMediaResourcesController
          .mediaResources[
              globalMediaResourcesController.currentMediaIndex.value]
          .name
          .split('.')
          .first;
    }
    final isNewNameValid = false.obs;
    var newName = globalMediaResourcesController
        .mediaResources[globalMediaResourcesController.currentMediaIndex.value]
        .name;
    return Obx(() => CustomDualOptionDialog(
        width: 400,
        height: 240,
        title: 'Rename',
        option1: 'Rename',
        option2: 'Cancel',
        disableOption1: !isNewNameValid.value,
        onOption1Pressed: () {
          renameMediaResource(
              globalMediaResourcesController.currentMediaIndex.value,
              '$newName.${mediaResource.file.path.split('.').last}');
          Get.back();
        },
        onOption2Pressed: () {
          Get.back();
        },
        child: SizedBox(
          height: 72,
          child: Theme(
              data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                      selectionColor: ColorDark.blue5.withOpacity(0.8))),
              child: Obx(() => TextField(
                    cursorColor: ColorDark.text1,
                    controller: fileNameTextEditingController,
                    style: SemiTextStyles.header5ENRegular
                        .copyWith(color: ColorDark.text0),
                    decoration: dialogInputDecoration.copyWith(
                        suffix: Text(
                          '.${mediaResource.file.path.split('.').last}',
                          style: SemiTextStyles.header5ENRegular
                              .copyWith(color: ColorDark.text1),
                        ),
                        errorText:
                            isNewNameValid.value ? null : 'File already exists',
                        errorMaxLines: 3),
                    onChanged: (value) {
                      newName = value;
                      isNewNameValid.value = !isFileExist(
                          '${globalMediaResourcesController.mediaResources[globalMediaResourcesController.currentMediaIndex.value].file.parent.path}'
                          '/$newName.${globalMediaResourcesController.mediaResources[globalMediaResourcesController.currentMediaIndex.value].file.path.split('.').last}');
                    },
                  ))),
        )));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_settings_controller.dart';

import '../../../controllers/global_media_resources_controller.dart';
import '../../design_tokens.dart';
import 'custom_dual_option_dialog.dart';

class MediaResourcesSortDialog extends StatelessWidget {
  const MediaResourcesSortDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalMediaResourcesController globalMediaResourcesController =
        Get.find();
    final GlobalSettingsController globalSettingsController = Get.find();
    return CustomDualOptionDialog(
        width: 400,
        height: 320,
        title: 'Sort',
        option1: '',
        disableOption1: true,
        option2: 'OK',
        onOption1Pressed: () {},
        onOption2Pressed: () async {
          switch (globalSettingsController.sortType.value) {
            case SortType.name:
              globalMediaResourcesController.mediaResources.sort((a, b) =>
                  globalSettingsController.sortAsc.value
                      ? a.name.compareTo(b.name)
                      : b.name.compareTo(a.name));
              break;
            case SortType.date:
              globalMediaResourcesController.mediaResources.sort((a, b) =>
                  globalSettingsController.sortAsc.value
                      ? a.creationTime.compareTo(b.creationTime)
                      : b.creationTime.compareTo(a.creationTime));
              break;
            case SortType.size:
              globalMediaResourcesController.mediaResources.sort((a, b) =>
                  globalSettingsController.sortAsc.value
                      ? a.sizeInBytes.compareTo(b.sizeInBytes)
                      : b.sizeInBytes.compareTo(a.sizeInBytes));
              break;
            case SortType.sequence:
              globalMediaResourcesController.mediaResources.sort((a, b) =>
                  globalSettingsController.sortAsc.value
                      ? a.sequence.compareTo(b.sequence)
                      : b.sequence.compareTo(a.sequence));
              break;
          }
          await globalSettingsController.saveSettings();
          Get.back();
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Sort type:',
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text1)),
                  const Spacer(),
                  Obx(() => DropdownButton<SortType>(
                        value: globalSettingsController.sortType.value,
                        focusColor: ColorDark.defaultActive,
                        dropdownColor: ColorDark.bg2,
                        style: SemiTextStyles.header5ENRegular
                            .copyWith(color: ColorDark.text0),
                        items: SortType.values
                            .map((e) => DropdownMenuItem<SortType>(
                                value: e, child: Text(e.name)))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            globalSettingsController.sortType.value = value;
                          }
                        },
                      )),
                ],
              ),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              Row(
                children: [
                  Text('Sort order:',
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text1)),
                  const Spacer(),
                  Obx(() => DropdownButton<bool>(
                        value: globalSettingsController.sortAsc.value,
                        focusColor: ColorDark.defaultActive,
                        dropdownColor: ColorDark.bg2,
                        style: SemiTextStyles.header5ENRegular
                            .copyWith(color: ColorDark.text0),
                        items: const [
                          DropdownMenuItem<bool>(
                              value: true, child: Text('Ascending')),
                          DropdownMenuItem<bool>(
                              value: false, child: Text('Descending'))
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            globalSettingsController.sortAsc.value = value;
                          }
                        },
                      )),
                ],
              ),
            ]));
  }
}

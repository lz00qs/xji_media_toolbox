import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_settings_controller.dart';
import 'package:xji_footage_toolbox/models/settings.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/custom_dual_option_dialog.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/custom_icon_button.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

class _PresetItemButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const _PresetItemButton({required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
        iconData: iconData,
        onPressed: onPressed,
        iconSize: DesignValues.mediumIconSize,
        buttonSize: 36,
        hoverColor: ColorDark.defaultHover,
        focusColor: ColorDark.defaultActive,
        iconColor: ColorDark.text0);
  }
}

class _PresetItem extends StatelessWidget {
  final ExportPreset preset;
  final int index;

  const _PresetItem({required this.preset, required this.index});

  @override
  Widget build(BuildContext context) {
    final GlobalSettingsController settingsController = Get.find();
    return SizedBox(
      height: 37,
      child: Row(
        children: [
          Expanded(
              child: Column(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() => _PresetItemButton(
                      iconData:
                          settingsController.defaultTransCodePresetId.value ==
                                  preset.id
                              ? Icons.check_box_outlined
                              : Icons.check_box_outline_blank,
                      onPressed: () {
                        settingsController.defaultTransCodePresetId.value =
                            preset.id;
                      })),
                  Expanded(
                      child: Text(preset.name,
                          style: SemiTextStyles.header5ENRegular.copyWith(
                              color: ColorDark.text0,
                              overflow: TextOverflow.ellipsis))),
                  _PresetItemButton(
                      iconData: Icons.edit,
                      onPressed: () {
                        Get.dialog(_EditTranscodePresetDialog(
                          preset: preset,
                        )).then((value) async {
                          if (value != null) {
                            settingsController.transCodingPresets[index] =
                                value;
                            await settingsController.saveSettings();
                          }
                        });
                      }),
                  SizedBox(
                    width: DesignValues.mediumPadding,
                  ),
                  _PresetItemButton(
                      iconData: Icons.delete,
                      onPressed: () {
                        Get.dialog(_PresetDeleteDialog(id: preset.id));
                      }),
                ],
              )),
              const Divider(
                color: ColorDark.border,
                thickness: 1,
                height: 1,
              ),
            ],
          )),
          SizedBox(
            width: DesignValues.smallPadding,
          ),
        ],
      ),
    );
  }
}

class _PresetDeleteDialog extends StatelessWidget {
  final int id;

  const _PresetDeleteDialog({required this.id});

  @override
  Widget build(BuildContext context) {
    final GlobalSettingsController settingsController = Get.find();
    return CustomDualOptionDialog(
        width: 400,
        height: 240,
        title: 'Delete',
        option1: 'Delete',
        option2: 'Cancel',
        onOption1Pressed: () async {
          settingsController.transCodingPresets
              .removeWhere((element) => element.id == id);
          await settingsController.saveSettings();
          Get.back();
        },
        onOption2Pressed: () {
          Get.back();
        },
        child: Text('Are you sure you want to delete this preset?',
            style: SemiTextStyles.header5ENRegular
                .copyWith(color: ColorDark.text0)));
  }
}

bool _isPresetParametersValid(String name, int width, int height, int crf) {
  return name.isNotEmpty && width > 0 && height > 0 && crf > 0 && crf < 52;
}

class _EditTranscodePresetDialog extends StatelessWidget {
  final nameController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final crfController = TextEditingController();
  final name = ''.obs;
  final width = 0.obs;
  final height = 0.obs;
  final crf = 22.obs;
  final useHevc = false.obs;
  final useInputResolution = false.obs;
  final selectedFFmpegPreset = FFmpegPreset.medium.index.obs;
  final ExportPreset? preset;

  _EditTranscodePresetDialog({required this.preset}) {
    final isNew = preset == null;
    late final ExportPreset editingPreset;
    if (isNew) {
      editingPreset = ExportPreset();
    } else {
      editingPreset = preset!;
    }
    nameController.text = editingPreset.name;
    widthController.text = editingPreset.width.toString();
    heightController.text = editingPreset.height.toString();
    crfController.text = editingPreset.crf.toString();
    name.value = editingPreset.name;
    width.value = editingPreset.width;
    height.value = editingPreset.height;
    crf.value = editingPreset.crf;
    useHevc.value = editingPreset.useHevc;
    useInputResolution.value = editingPreset.useInputResolution;
    selectedFFmpegPreset.value = editingPreset.ffmpegPreset;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomDualOptionDialog(
        width: 480,
        height: 680,
        title: preset == null ? 'Add Preset' : 'Edit Preset',
        option1: 'Cancel',
        option2: preset == null ? 'Add' : 'Save',
        disableOption2: !_isPresetParametersValid(
            name.value, width.value, height.value, crf.value),
        onOption1Pressed: () {
          Get.back();
        },
        onOption2Pressed: () {
          final newPreset = ExportPreset()
            ..id = preset?.id ?? 0
            ..name = nameController.text
            ..width = width.value
            ..height = height.value
            ..crf = crf.value
            ..useHevc = useHevc.value
            ..useInputResolution = useInputResolution.value
            ..ffmpegPreset = selectedFFmpegPreset.value;
          Get.back(result: newPreset);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preset name',
              style: SemiTextStyles.header5ENRegular
                  .copyWith(color: ColorDark.text1),
            ),
            SizedBox(
              height: 72,
              child: Theme(
                  data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                          selectionColor: ColorDark.blue5.withOpacity(0.8))),
                  child: Obx(() => TextField(
                    cursorColor: ColorDark.text1,
                    controller: nameController,
                    style: SemiTextStyles.header5ENRegular
                        .copyWith(color: ColorDark.text0),
                    decoration: dialogInputDecoration.copyWith(
                        errorText:
                            name.value.isEmpty ? 'Name is required' : null),
                    onChanged: (value) {
                      nameController.text = value;
                      name.value = value;
                    },
                  ))),
            ),
            SizedBox(
              height: DesignValues.smallPadding,
            ),
            Obx(() => CustomDialogCheckBoxWithText(
                text: 'Use Input Resolution',
                value: useInputResolution.value,
                onPressed: () {
                  useInputResolution.value = !useInputResolution.value;
                })),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            Obx(() {
              if (useInputResolution.value) {
                return const SizedBox();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Width',
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text1),
                    ),
                    SizedBox(
                      height: 72,
                      child: Theme(
                          data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                  selectionColor: ColorDark.blue5.withOpacity(0.8))),
                          child: Obx(() => TextField(
                            cursorColor: ColorDark.text1,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: widthController,
                            style: SemiTextStyles.header5ENRegular
                                .copyWith(color: ColorDark.text0),
                            decoration: dialogInputDecoration.copyWith(
                                errorText: width.value == 0
                                    ? 'Width cannot be 0'
                                    : null),
                            onChanged: (value) {
                              try {
                                width.value = int.parse(value);
                              } catch (e) {
                                width.value = 0;
                              }
                              widthController.text = width.value.toString();
                            },
                          ))),
                    ),
                    Text(
                      'Height',
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text1),
                    ),
                    SizedBox(
                      height: 72,
                      child: Theme(
                          data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                  selectionColor: ColorDark.blue5.withOpacity(0.8))),
                          child: Obx(() => TextField(
                            cursorColor: ColorDark.text1,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: heightController,
                            style: SemiTextStyles.header5ENRegular
                                .copyWith(color: ColorDark.text0),
                            decoration: dialogInputDecoration.copyWith(
                                errorText: height.value == 0
                                    ? 'Height cannot be 0'
                                    : null),
                            onChanged: (value) {
                              try {
                                height.value = int.parse(value);
                              } catch (e) {
                                height.value = 0;
                              }
                              heightController.text = height.value.toString();
                            },
                          ))),
                    ),
                  ],
                );
              }
            }),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CRF',
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text1),
                ),
                SizedBox(
                  height: 72,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          textSelectionTheme: TextSelectionThemeData(
                              selectionColor: ColorDark.blue5.withOpacity(0.8))),
                      child: Obx(() => TextField(
                        cursorColor: ColorDark.text1,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: crfController,
                        style: SemiTextStyles.header5ENRegular
                            .copyWith(color: ColorDark.text0),
                        decoration: dialogInputDecoration.copyWith(
                            errorText: (crf.value > 0 && crf.value < 52)
                                ? null
                                : 'CRF must be between 0 and 51, higher is lower quality.',
                            errorMaxLines: 3),
                        onChanged: (value) {
                          try {
                            crf.value = int.parse(value);
                          } catch (e) {
                            crf.value = 0;
                          }
                          crfController.text = crf.value.toString();
                        },
                      ))),
                ),
              ],
            ),
            SizedBox(
              width: DesignValues.smallPadding,
            ),
            Obx(() => CustomDialogCheckBoxWithText(
                text: 'Use H.265',
                value: useHevc.value,
                onPressed: () {
                  useHevc.value = !useHevc.value;
                })),
            SizedBox(
              height: DesignValues.smallPadding,
            ),
            Row(
              children: [
                Text(
                  "FFmpeg Preset:",
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text1),
                ),
                const Spacer(),
                Obx(() => DropdownButton<FFmpegPreset>(
                      value: FFmpegPreset.values[selectedFFmpegPreset.value],
                      focusColor: ColorDark.defaultActive,
                      dropdownColor: ColorDark.bg2,
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text0),
                      items: FFmpegPreset.values
                          .map((e) => DropdownMenuItem<FFmpegPreset>(
                                value: e,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedFFmpegPreset.value = value.index;
                        }
                      },
                    )),
              ],
            )
          ],
        )));
  }
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final outputPresetScrollController = ScrollController();
    final settingsController = Get.find<GlobalSettingsController>();
    return CustomDualOptionDialog(
      width: 480,
      height: 640,
      title: 'Settings',
      option1: '',
      option2: 'Close',
      onOption1Pressed: () {},
      onOption2Pressed: () {
        Get.back();
      },
      disableOption1: true,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Output Presets',
                style: SemiTextStyles.header4ENRegular
                    .copyWith(color: ColorDark.text0),
              ),
              SizedBox(
                width: DesignValues.smallPadding,
              ),
              CustomIconButton(
                  iconData: Icons.add_circle_outline,
                  onPressed: () {
                    Get.dialog(_EditTranscodePresetDialog(
                      preset: null,
                    )).then((value) async {
                      if (value != null) {
                        settingsController.transCodingPresets.add(value);
                        await settingsController.saveSettings();
                      }
                    });
                  },
                  iconSize: DesignValues.mediumIconSize,
                  buttonSize: 28,
                  hoverColor: ColorDark.defaultHover,
                  focusColor: ColorDark.defaultActive,
                  iconColor: ColorDark.text0)
            ],
          ),
          SizedBox(
            height: DesignValues.ultraSmallPadding,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(DesignValues.smallBorderRadius),
            child: Container(
              color: ColorDark.bg3,
              height: 200,
              child: Padding(
                padding: EdgeInsets.only(
                    top: DesignValues.ultraSmallPadding,
                    bottom: DesignValues.ultraSmallPadding,
                    left: DesignValues.ultraSmallPadding),
                child: RawScrollbar(
                  thickness: DesignValues.smallPadding,
                  trackVisibility: false,
                  thumbVisibility: true,
                  radius: Radius.circular(DesignValues.smallBorderRadius),
                  controller: outputPresetScrollController,
                  child: Obx(() {
                    final settingsController =
                        Get.find<GlobalSettingsController>();
                    return ListView.builder(
                        controller: outputPresetScrollController,
                        itemCount: settingsController.transCodingPresets.length,
                        itemBuilder: (context, index) {
                          return _PresetItem(
                            preset:
                                settingsController.transCodingPresets[index],
                            index: index,
                          );
                        });
                  }),
                ),
              ),
            ),
          ),
          SizedBox(
            height: DesignValues.largePadding,
          ),
          Row(
            children: [
              Text('Version:',
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text1)),
              const Spacer(),
              Text(settingsController.appVersion,
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text0)),
            ],
          ),
          SizedBox(
            height: DesignValues.mediumPadding,
          ),
          Row(
            children: [
              Text('Author:',
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text1)),
              const Spacer(),
              Text('lz00qs',
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text0)),
            ],
          ),
        ],
      ),
    );
  }
}

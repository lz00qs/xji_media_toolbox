import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/settings.dart';

class EditTranscodePresetController extends GetxController {
  final nameController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final crfController = TextEditingController();
  final width = 0.obs;
  final height = 0.obs;
  final crf = 22.obs;
  final useHevc = false.obs;
  final useInputResolution = false.obs;
  final selectedFFmpegPreset = FFmpegPreset.medium.obs;

  void initController(ExportPreset? preset) {
    final isNew = preset == null;
    late final ExportPreset editingPreset;
    if (isNew) {
      editingPreset = ExportPreset();
    } else {
      editingPreset = preset;
    }
    nameController.text = editingPreset.name;
    widthController.text = editingPreset.width.toString();
    heightController.text = editingPreset.height.toString();
    crfController.text = editingPreset.crf.toString();
    width.value = editingPreset.width;
    height.value = editingPreset.height;
    crf.value = editingPreset.crf;
    useHevc.value = editingPreset.useHevc;
    useInputResolution.value = editingPreset.useInputResolution;
    selectedFFmpegPreset.value = editingPreset.preset;
  }
}

class EditTranscodePresetDialog extends GetView<EditTranscodePresetController> {
  final ExportPreset? preset;

  const EditTranscodePresetDialog({super.key, this.preset});

  @override
  Widget build(BuildContext context) {
    final dropdownFocusNode = FocusNode();
    controller.initController(preset);
    return AlertDialog(
      title: Text(preset == null ? 'Add Preset' : 'Edit Preset'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: controller.nameController,
          decoration: const InputDecoration(labelText: 'Name'),
          onChanged: (value) {
            controller.nameController.text = value;
          },
        ),
        Row(
          children: [
            const Text('Use HEVC'),
            Obx(() => Checkbox(
                  value: controller.useHevc.value,
                  onChanged: (value) {
                    controller.useHevc.value = value ?? false;
                  },
                ))
          ],
        ),
        Obx(() => TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  labelText: 'CRF',
                  hintText: 'Constant Rate Factor',
                  errorText: (controller.crf.value > 0 &&
                          controller.crf.value < 52)
                      ? null
                      : 'CRF must be between 0 and 51, higher is lower quality, 22 is default for x264, 28 is default for x265.',
                  errorMaxLines: 3),
              controller: controller.crfController,
              onChanged: (value) {
                try {
                  controller.crf.value = int.parse(value);
                } catch (e) {
                  controller.crf.value = 0;
                }
                controller.crfController.text = controller.crf.value.toString();
              },
            )),
        Row(
          children: [
            const Text('Use Input Resolution'),
            Obx(() => Checkbox(
                  value: controller.useInputResolution.value,
                  onChanged: (value) {
                    controller.useInputResolution.value = value ?? false;
                  },
                ))
          ],
        ),
        Obx(() {
          if (controller.useInputResolution.value) {
            return const SizedBox();
          } else {
            return Column(
              children: [
                Obx(() => TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          labelText: 'Width',
                          errorText: controller.width.value == 0
                              ? 'Width cannot be 0'
                              : null),
                      controller: controller.widthController,
                      onChanged: (value) {
                        try {
                          controller.width.value = int.parse(value);
                        } catch (e) {
                          controller.width.value = 0;
                        }
                        controller.widthController.text =
                            controller.width.value.toString();
                      },
                    )),
                Obx(() => TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          labelText: 'Height',
                          errorText: controller.height.value == 0
                              ? 'Height cannot be 0'
                              : null),
                      controller: controller.heightController,
                      onChanged: (value) {
                        try {
                          controller.height.value = int.parse(value);
                        } catch (e) {
                          controller.height.value = 0;
                        }
                        controller.heightController.text =
                            controller.height.value.toString();
                      },
                    )),
              ],
            );
          }
        }),
        Row(
          children: [
            const Text("preset:"),
            const SizedBox(
              width: 5,
            ),
            Obx(() => DropdownButton<FFmpegPreset>(
              focusNode: dropdownFocusNode,
              value: controller.selectedFFmpegPreset.value,
              items: FFmpegPreset.values
                  .map((e) => DropdownMenuItem<FFmpegPreset>(
                value: e,
                child: Text(e.name),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedFFmpegPreset.value = value;
                }
                dropdownFocusNode.unfocus();
              },
            )),
          ],
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            // controller.dispose();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final newPreset = ExportPreset()
              ..name = controller.nameController.text
              ..width = controller.width.value
              ..height = controller.height.value
              ..crf = controller.crf.value
              ..useHevc = controller.useHevc.value
              ..useInputResolution = controller.useInputResolution.value
              ..preset = controller.selectedFFmpegPreset.value;
            Get.back(result: newPreset);
            // controller.dispose();
          },
          child: Text(preset == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}

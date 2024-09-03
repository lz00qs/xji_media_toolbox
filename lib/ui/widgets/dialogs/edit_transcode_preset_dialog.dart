import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/global_focus_nodes_controller.dart';
import '../../../models/settings.dart';

class EditTranscodePresetDialog extends StatelessWidget {
  final nameController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final crfController = TextEditingController();
  final width = 0.obs;
  final height = 0.obs;
  final crf = 22.obs;
  final useHevc = false.obs;
  final useInputResolution = false.obs;
  final selectedFFmpegPreset = FFmpegPreset.medium.index.obs;
  final ExportPreset? preset;

  EditTranscodePresetDialog({super.key, required this.preset}) {
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
    width.value = editingPreset.width;
    height.value = editingPreset.height;
    crf.value = editingPreset.crf;
    useHevc.value = editingPreset.useHevc;
    useInputResolution.value = editingPreset.useInputResolution;
    selectedFFmpegPreset.value = editingPreset.ffmpegPreset;
  }

  @override
  Widget build(BuildContext context) {
    final globalFocusNodesController = Get.find<GlobalFocusNodesController>();
    return Focus(
        focusNode: globalFocusNodesController.dialogFocusNode,
        autofocus: true,
        child: AlertDialog(
          title: Text(preset == null ? 'Add Preset' : 'Edit Preset'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  nameController.text = value;
                },
              ),
              Row(
                children: [
                  const Text('Use HEVC'),
                  Obx(() => Checkbox(
                        value: useHevc.value,
                        onChanged: (value) {
                          useHevc.value = value ?? false;
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
                        errorText: (crf.value > 0 && crf.value < 52)
                            ? null
                            : 'CRF must be between 0 and 51, higher is lower quality, 22 is default for x264, 28 is default for x265.',
                        errorMaxLines: 3),
                    controller: crfController,
                    onChanged: (value) {
                      try {
                        crf.value = int.parse(value);
                      } catch (e) {
                        crf.value = 0;
                      }
                      crfController.text = crf.value.toString();
                    },
                  )),
              Row(
                children: [
                  const Text('Use Input Resolution'),
                  Obx(() => Checkbox(
                        value: useInputResolution.value,
                        onChanged: (value) {
                          useInputResolution.value = value ?? false;
                        },
                      ))
                ],
              ),
              Obx(() {
                if (useInputResolution.value) {
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
                                errorText: width.value == 0
                                    ? 'Width cannot be 0'
                                    : null),
                            controller: widthController,
                            onChanged: (value) {
                              try {
                                width.value = int.parse(value);
                              } catch (e) {
                                width.value = 0;
                              }
                              widthController.text = width.value.toString();
                            },
                          )),
                      Obx(() => TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                labelText: 'Height',
                                errorText: height.value == 0
                                    ? 'Height cannot be 0'
                                    : null),
                            controller: heightController,
                            onChanged: (value) {
                              try {
                                height.value = int.parse(value);
                              } catch (e) {
                                height.value = 0;
                              }
                              heightController.text = height.value.toString();
                            },
                          )),
                    ],
                  );
                }
              }),
              Row(
                children: [
                  const Text("FFmpeg Preset:"),
                  const SizedBox(
                    width: 5,
                  ),
                  Obx(() => DropdownButton<FFmpegPreset>(
                        value: FFmpegPreset.values[selectedFFmpegPreset.value],
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
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                globalFocusNodesController.mediaResourcesListPanelFocusNode
                    .requestFocus();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                final newPreset = ExportPreset()
                  ..name = nameController.text
                  ..width = width.value
                  ..height = height.value
                  ..crf = crf.value
                  ..useHevc = useHevc.value
                  ..useInputResolution = useInputResolution.value
                  ..ffmpegPreset = selectedFFmpegPreset.value;
                Get.back(result: newPreset);
                globalFocusNodesController.mediaResourcesListPanelFocusNode
                    .requestFocus();
              },
              child: Text(preset == null ? 'Add' : 'Save',
                  style: const TextStyle(color: Colors.blue)),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/widget/edit_transcode_preset_dialog.dart';

import 'global_controller.dart';

class SettingsPage extends GetView<GlobalController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EditTranscodePresetController());
    // final controller = Get.find<GlobalController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.saveSettings();
            Get.back();
          },
        ),
        leadingWidth: 200.0,
      ),
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text('Export Preset'),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    const dialog = EditTranscodePresetDialog();
                    Get.dialog(dialog).then((value) {
                      if (value != null) {
                        controller.settings.transCodingPresets.add(value);
                        controller.saveSettings();
                      }
                    });
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          Obx(() => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.settings.transCodingPresets.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Obx(
                        () => Checkbox(
                          value: index ==
                              controller
                                  .settings.defaultTransCodePresetIndex.value,
                          onChanged: (value) {
                            if (value != null && value) {
                              controller.settings.defaultTransCodePresetIndex
                                  .value = index;
                              controller.saveSettings();
                            }
                          },
                        ),
                      ),
                      title: Text(
                          controller.settings.transCodingPresets[index].name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              final dialog = EditTranscodePresetDialog(
                                  preset: controller
                                      .settings.transCodingPresets[index]);
                              Get.dialog(dialog).then((value) {
                                if (value != null) {
                                  value.id = controller
                                      .settings.transCodingPresets[index].id;
                                  controller.settings
                                      .transCodingPresets[index] = value;
                                  controller.saveSettings();
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              Get.dialog(AlertDialog(
                                title: const Text('Delete Preset'),
                                content: const Text(
                                    'Are you sure you want to delete this preset?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (controller
                                              .settings
                                              .defaultTransCodePresetIndex
                                              .value ==
                                          index) {
                                        controller
                                            .settings
                                            .defaultTransCodePresetIndex
                                            .value = 0;
                                      }
                                      controller.settings.transCodingPresets
                                          .removeAt(index);
                                      controller.saveSettings();
                                      Get.back();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ));
                            },
                          ),
                        ],
                      ));
                },
              )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_settings_controller.dart';
import 'package:xji_footage_toolbox/ui/widgets/edit_transcode_preset_dialog.dart';

class SettingsPage extends GetView<GlobalSettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await controller.saveSettings();
            Get.back();
          },
        ),
        leadingWidth: 200.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Export Preset'),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Get.dialog(EditTranscodePresetDialog(
                        preset: null,
                      )).then((value) {
                        if (value != null) {
                          controller.transCodingPresets.add(value);
                          controller.saveSettings();
                        }
                      });
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
          Obx(() => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.transCodingPresets.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Obx(
                        () => Checkbox(
                          value: index ==
                              controller.defaultTransCodePresetIndex.value,
                          onChanged: (value) async {
                            if (value != null && value) {
                              controller.defaultTransCodePresetIndex.value =
                                  index;
                              await controller.saveSettings();
                            }
                          },
                        ),
                      ),
                      title: Text(controller.transCodingPresets[index].name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final transcodePreset = await Get.dialog(
                                  EditTranscodePresetDialog(
                                      preset: controller
                                          .transCodingPresets[index]));
                              if (transcodePreset != null) {
                                controller.transCodingPresets[index] =
                                    transcodePreset;
                                await controller.saveSettings();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              controller.transCodingPresets.removeAt(index);
                              await controller.saveSettings();
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

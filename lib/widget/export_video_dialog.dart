import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_controller.dart';
import '../settings_page.dart';
import '../utils.dart';
import '../video_processing.dart';

class ExportVideoDialogController extends GetxController {
  final useSameDirectory = true.obs;
  final useSameResolution = false.obs;
  final selectedDirectory = ''.obs;
  final outputFileName = ''.obs;
  final outputFileNameController = TextEditingController();
  final transcodePreset = 0.obs;

  void resetValues() {
    useSameDirectory.value = true;
    selectedDirectory.value = '';
  }

  String getDefaultOutputFileName(String originalFileName) {
    // 分割文件名和扩展名
    final lastDotIndex = originalFileName.lastIndexOf('.');
    final baseName = originalFileName.substring(0, lastDotIndex);
    final extension = originalFileName.substring(lastDotIndex);
    // 构建新的文件名
    return '${baseName}_OUTPUT$extension';
  }
}

class ExportVideoDialog extends GetView<ExportVideoDialogController> {
  const ExportVideoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final globalController = Get.find<GlobalController>();
    final isOutputPathValid = (!(controller.useSameDirectory.value
            ? isFileExist(
                '${globalController.footageDir!.path}/${controller.outputFileName.value}')
            : isFileExist(
                '${controller.selectedDirectory.value}/${controller.outputFileName.value}')))
        .obs;
    controller.outputFileName.value = controller.getDefaultOutputFileName(
        globalController.footageList[globalController.currentFootageIndex.value]
            .name.value);
    controller.outputFileNameController.text = controller.outputFileName.value;

    controller.transcodePreset.value = globalController
        .settings
        .transCodingPresets[
            globalController.settings.defaultTransCodePresetIndex.value]
        .id;

    final dropdownFocusNode = FocusNode();

    return AlertDialog(
      title: const Text('Export video'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('Use the same directory as the input file:'),
              Obx(() => Checkbox(
                    value: controller.useSameDirectory.value,
                    onChanged: (value) {
                      controller.useSameDirectory.value = value!;
                    },
                  ))
            ]),
            Obx(() => controller.useSameDirectory.value
                ? const SizedBox()
                : Column(
                    children: [
                      Row(
                        children: [
                          const Text('Select a output directory:'),
                          IconButton(
                            icon: const Icon(Icons.folder_open),
                            onPressed: () async {
                              final result =
                                  await FilePicker.platform.getDirectoryPath();
                              if (result != null) {
                                controller.selectedDirectory.value = result;
                              }
                            },
                          ),
                        ],
                      ),
                      Obx(() => Text(
                            controller.selectedDirectory.value,
                            style: const TextStyle(overflow: TextOverflow.clip),
                          )),
                    ],
                  )),
            Obx(() => TextField(
                  controller: controller.outputFileNameController,
                  decoration: InputDecoration(
                      labelText: 'Output file name',
                      errorText: controller.outputFileName.value.isEmpty
                          ? 'Output file name cannot be empty'
                          : isFileExist(controller.useSameDirectory.value
                                  ? '${globalController.footageDir!.path}/${controller.outputFileName.value}'
                                  : '${controller.selectedDirectory.value}/${controller.outputFileName.value}')
                              ? 'File already exists'
                              : null),
                  onChanged: (value) {
                    controller.outputFileName.value = value;
                    isOutputPathValid.value = !(controller
                            .useSameDirectory.value
                        ? isFileExist(
                            '${globalController.footageDir!.path}/${controller.outputFileName.value}')
                        : isFileExist(
                            '${controller.selectedDirectory.value}/${controller.outputFileName.value}'));
                  },
                )),
            Obx(() => globalController.isEditingVideo.value
                ? Row(children: [
                    const Text('Use the same resolution as the input file:'),
                    Obx(() => Checkbox(
                          value: controller.useSameResolution.value,
                          onChanged: (value) {
                            controller.useSameResolution.value = value!;
                          },
                        ))
                  ])
                : const SizedBox()),
            Obx(() => globalController.isEditingVideo.value &&
                    controller.useSameResolution.value
                ? const SizedBox()
                : Row(
                    children: [
                      const Text("Export preset:"),
                      const SizedBox(
                        width: 5,
                      ),
                      Obx(() => DropdownButton<int>(
                            focusNode: dropdownFocusNode,
                            value: controller.transcodePreset.value,
                            items: globalController.settings.transCodingPresets
                                .map((e) => DropdownMenuItem<int>(
                                      value: e.id,
                                      child: Text(e.name),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.transcodePreset.value = value;
                              }
                              dropdownFocusNode.unfocus();
                            },
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Get.to(() => const SettingsPage());
                        },
                      )
                    ],
                  )),
            Obx(() {
              final preset = globalController.settings.transCodingPresets
                  .firstWhere((element) =>
                      element.id == controller.transcodePreset.value);
              return globalController.isEditingVideo.value &&
                      controller.useSameResolution.value
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        preset.useInputResolution
                            ? const Text("Output resolution: Same as input")
                            : Text(
                                "Output resolution: ${preset.width}x${preset.height}"),
                        Text("Output preset: ${preset.preset.toString().split('.').last}"),
                        Text("Output CRF: ${preset.crf}"),
                        Text(
                            "Output codec: ${preset.useHevc ? 'HEVC' : 'H.264'}"),
                      ],
                    );
            })
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
            onPressed: () {
              if (isOutputPathValid.value) {
                final footage = globalController
                    .footageList[globalController.currentFootageIndex.value];
                final inputFilePath = footage.file.path;
                final outputFilePath = controller.useSameDirectory.value
                    ? '${globalController.footageDir!.path}/${controller.outputFileName.value}'
                    : '${controller.selectedDirectory.value}/${controller.outputFileName.value}';
                final preset = globalController.settings.transCodingPresets
                    .firstWhere((element) =>
                        element.id == controller.transcodePreset.value);
                final inputFileName = inputFilePath.split('/').last;
                final outputFileName = outputFilePath.split('/').last;
                final process = VideoProcess(
                    name: 'Transcode $inputFileName to $outputFileName',
                    type: VideoProcessingType.transcode,
                    duration: footage.duration,);
                globalController.videoProcessingTasks.add(process);
                process.start([
                  '-i',
                  inputFilePath,
                  '-c:v',
                  preset.useHevc ? 'libx265' : 'libx264',
                  preset.useHevc ? '-tag:v' : '',
                  preset.useHevc ? 'hvc1' : '',
                  '-crf',
                  preset.crf.toString(),
                  '-preset',
                  preset.preset.toString().split('.').last,
                  '-vf',
                  'scale=${preset.width}:${preset.height}',
                  outputFilePath,
                ]);
                Get.back();
              }
            },
            child: Obx(() => isOutputPathValid.value
                ? const Text('Export')
                : const Text(
                    'Export',
                    style: TextStyle(color: Colors.grey),
                  ))),
      ],
    );
  }
}

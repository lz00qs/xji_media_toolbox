import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_media_resources_controller.dart';
import 'package:xji_footage_toolbox/controllers/global_settings_controller.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/models/settings.dart';
import 'package:xji_footage_toolbox/models/video_process.dart';
import 'package:xji_footage_toolbox/ui/pages/settings_page.dart';
import 'package:xji_footage_toolbox/utils/media_resources_utils.dart';

import '../../../controllers/global_focus_nodes_controller.dart';
import '../../../controllers/global_tasks_controller.dart';
import '../panels/views/video_trimmer_view.dart';

String _getDefaultOutputFileName(String originalFileName) {
  final lastDotIndex = originalFileName.lastIndexOf('.');
  final baseName = originalFileName.substring(0, lastDotIndex);
  return '${baseName}_OUTPUT';
}

class ExportVideoDialog extends StatelessWidget {
  final NormalVideoResource videoResource;
  final GlobalMediaResourcesController globalMediaResourcesController =
      Get.find<GlobalMediaResourcesController>();
  final GlobalSettingsController globalSettingsController =
      Get.find<GlobalSettingsController>();
  final globalFocusNodesController = Get.find<GlobalFocusNodesController>();

  final GlobalTasksController globalTasksController =
      Get.find<GlobalTasksController>();

  ExportVideoDialog({super.key, required this.videoResource});

  @override
  Widget build(BuildContext context) {
    final useSameDirectory = true.obs;
    final selectedDirectory = ''.obs;
    final outputFileName = _getDefaultOutputFileName(videoResource.name).obs;
    final isOutputPathValid = (!isFileExist(
            '${videoResource.file.parent.path}/${outputFileName.value}.MP4'))
        .obs;
    final useInputEncodeSettings = false.obs;
    final transCodePresetIndex =
        globalSettingsController.defaultTransCodePresetId.value.obs;

    final outputFileNameTextEditingController = TextEditingController();
    final videoTrimStart = const Duration(seconds: 0).obs;
    final videoTrimEnd = videoResource.duration.obs;
    final trimDuration = videoResource.duration.obs;

    if (globalMediaResourcesController.isEditingMediaResources.value) {
      final videoTrimmerController = Get.find<VideoTrimmerController>();
      videoTrimStart.value =
          videoTrimmerController.videoPlayerStartPosition.value;
      videoTrimEnd.value = videoTrimmerController.videoPlayerEndPosition.value;
      trimDuration.value = videoTrimmerController.videoPlayerEndPosition.value -
          videoTrimmerController.videoPlayerStartPosition.value;
    }

    return Focus(
        focusNode: globalFocusNodesController.dialogFocusNode,
        autofocus: true,
        child: AlertDialog(
            title: const Text('Export Video'),
            content: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Text(
                              'Use the same directory as the source video'),
                          Obx(() => Checkbox(
                              value: useSameDirectory.value,
                              onChanged: (value) {
                                useSameDirectory.value = value!;
                              })),
                        ],
                      ),
                      Obx(() => useSameDirectory.value
                          ? const SizedBox()
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('Select a output directory'),
                                    IconButton(
                                        onPressed: () async {
                                          final result = await FilePicker
                                              .platform
                                              .getDirectoryPath();
                                          if (result != null) {
                                            selectedDirectory.value = result;
                                          }
                                        },
                                        icon: const Icon(Icons.folder_open))
                                  ],
                                ),
                                Obx(() => Text(
                                      selectedDirectory.value,
                                      style: const TextStyle(
                                          overflow: TextOverflow.clip),
                                    ))
                              ],
                            )),
                      Obx(() => TextField(
                            controller: outputFileNameTextEditingController
                              ..text = outputFileName.value,
                            decoration: InputDecoration(
                                labelText: 'Output File Name',
                                errorText: outputFileName.value.isEmpty
                                    ? 'Output file name cannot be empty'
                                    : isOutputPathValid.value
                                        ? null
                                        : 'Output file already exists',
                                suffixText: '.MP4'),
                            onChanged: (value) {
                              outputFileName.value = value;
                              isOutputPathValid.value = !isFileExist(
                                  '${useSameDirectory.value ? videoResource.file.parent.path : selectedDirectory.value}'
                                  '/${outputFileName.value}.MP4');
                            },
                          )),
                      Row(
                        children: [
                          const Text(
                              'Use the same encoding settings as the source video'),
                          Obx(() => Checkbox(
                              value: useInputEncodeSettings.value,
                              onChanged: (value) {
                                useInputEncodeSettings.value = value!;
                              })),
                        ],
                      ),
                      Obx(() => useInputEncodeSettings.value
                          ? const SizedBox()
                          : Row(
                              children: [
                                const Text('Export Preset'),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Obx(() => DropdownButton<int>(
                                        value: transCodePresetIndex.value,
                                        focusColor: Colors.transparent,
                                        items: globalSettingsController
                                            .transCodingPresets
                                            .map((e) => DropdownMenuItem<int>(
                                                  value: e.id,
                                                  child: Text(e.name),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          transCodePresetIndex.value = value!;
                                        },
                                      )),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Get.to(() => const SettingsPage());
                                    },
                                    icon: const Icon(Icons.settings))
                              ],
                            )),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() {
                        final preset = globalSettingsController
                            .transCodingPresets
                            .firstWhere((element) =>
                                element.id == transCodePresetIndex.value);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            useInputEncodeSettings.value
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Output resolution: ${videoResource.width}x${videoResource.height}'),
                                      Text(
                                          'Output codec: ${videoResource.isHevc ? 'HEVC' : 'H.264'}'),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Output resolution: ${preset.width}x${preset.height}'),
                                      Text(
                                          "Output FFmpeg preset: ${FFmpegPreset.values[preset.ffmpegPreset].toString().split('.').last}"),
                                      Text('Output CRF: ${preset.crf}'),
                                      Text(
                                          'Output codec: ${preset.useHevc ? 'HEVC' : 'H.264'}'),
                                    ],
                                  ),
                            globalMediaResourcesController
                                    .isEditingMediaResources.value
                                ? Text(
                                    'Output Duration: ${getFormattedTime(trimDuration.value)}')
                                : Text(
                                    'Output Duration: ${getFormattedTime(videoResource.duration)}'),
                          ],
                        );
                      })
                    ])),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                  onPressed: () {
                    final outputFilePath =
                        '${useSameDirectory.value ? videoResource.file.parent.path : selectedDirectory.value}/${outputFileName.value}.MP4';
                    final preset = globalSettingsController.transCodingPresets
                        .firstWhere((element) =>
                            element.id == transCodePresetIndex.value);
                    final process = VideoProcess(
                      name: globalMediaResourcesController
                              .isEditingMediaResources.value
                          ? 'Trim $outputFileName.MP4'
                          : 'Transcode $outputFileName.MP4',
                      type: globalMediaResourcesController
                              .isEditingMediaResources.value
                          ? VideoProcessType.trim
                          : VideoProcessType.transcode,
                      duration: (globalMediaResourcesController
                                  .isEditingMediaResources.value
                              ? trimDuration.value.inSeconds
                              : videoResource.duration.inSeconds)
                          .toDouble(),
                    );
                    globalTasksController.videoProcessingTasks.add(process);
                    final List<String> ffmpegArgs = [];
                    ffmpegArgs.add('-i');
                    ffmpegArgs.add(videoResource.file.path);
                    ffmpegArgs.add('-c:v');
                    if (useInputEncodeSettings.value == false) {
                      ffmpegArgs.add(preset.useHevc ? 'libx265' : 'libx264');
                      if (preset.useHevc) {
                        ffmpegArgs.add('-tag:v');
                        ffmpegArgs.add('hvc1');
                      }
                      ffmpegArgs.add('-crf');
                      ffmpegArgs.add(preset.crf.toString());
                      ffmpegArgs.add('-preset');
                      ffmpegArgs.add(FFmpegPreset.values[preset.ffmpegPreset]
                          .toString()
                          .split('.')
                          .last);
                      ffmpegArgs.add('-vf');
                      ffmpegArgs.add('scale=${preset.width}:${preset.height}');
                    } else {
                      ffmpegArgs.add('copy');
                    }

                    if (globalMediaResourcesController
                            .isEditingMediaResources.value ==
                        true) {
                      ffmpegArgs.add('-ss');
                      ffmpegArgs.add(videoTrimStart.value.toString());
                      ffmpegArgs.add('-to');
                      ffmpegArgs.add(videoTrimEnd.value.toString());
                    }
                    ffmpegArgs.add(outputFilePath);
                    process.start(ffmpegArgs);
                    Get.back();
                  },
                  child: Obx(() => isOutputPathValid.value
                      ? const Text('Export',
                          style: TextStyle(color: Colors.blue))
                      : const Text('Export',
                          style: TextStyle(color: Colors.grey))))
            ]));
  }
}

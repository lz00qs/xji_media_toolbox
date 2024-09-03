import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';

import '../../../controllers/global_focus_nodes_controller.dart';
import '../../../controllers/global_media_resources_controller.dart';
import '../../../controllers/global_settings_controller.dart';
import '../../../controllers/global_tasks_controller.dart';
import '../../../models/settings.dart';
import '../../../models/video_process.dart';
import '../../../utils/media_resources_utils.dart';
import '../../pages/settings_page.dart';
import '../panels/views/video_trimmer_view.dart';

String _getDefaultOutputFileName(List<NormalVideoResource> videoResources) {
  final firstLastDotIndex = videoResources.first.name.lastIndexOf('.');
  final firstBaseName =
      videoResources.first.name.substring(0, firstLastDotIndex);
  final firstSequenceNumber = videoResources.first.sequence;
  final lastSequenceNumber = videoResources.last.sequence;
  return '${firstBaseName}_Trim_${firstSequenceNumber}_$lastSequenceNumber';
}

String _get4DigitRandomString() {
  final random = Random();
  return random.nextInt(10000).toString().padLeft(4, '0');
}

enum _MergeError {
  none,
  differentResolution,
  differentCodec,
  differentFrameRate,
}

_MergeError _isMergeable(List<NormalVideoResource> videoResources) {
  final firstVideo = videoResources.first;
  for (final video in videoResources) {
    if (video.width != firstVideo.width || video.height != firstVideo.height) {
      return _MergeError.differentResolution;
    }
    if (video.isHevc != firstVideo.isHevc) {
      return _MergeError.differentCodec;
    }
    if (video.frameRate != firstVideo.frameRate) {
      return _MergeError.differentFrameRate;
    }
  }
  return _MergeError.none;
}

class ExportMergedVideoDialog extends StatelessWidget {
  final List<NormalVideoResource> videoResources;
  final GlobalMediaResourcesController globalMediaResourcesController =
      Get.find<GlobalMediaResourcesController>();
  final GlobalSettingsController globalSettingsController =
      Get.find<GlobalSettingsController>();
  final globalFocusNodesController = Get.find<GlobalFocusNodesController>();

  final GlobalTasksController globalTasksController =
      Get.find<GlobalTasksController>();

  ExportMergedVideoDialog({super.key, required this.videoResources});

  @override
  Widget build(BuildContext context) {
    final useSameDirectory = true.obs;
    final selectedDirectory = ''.obs;
    final outputFileName = _getDefaultOutputFileName(videoResources).obs;
    final isOutputPathValid = (!isFileExist(
            '${videoResources.first.file.parent.path}/${outputFileName.value}.MP4'))
        .obs;
    final useInputEncodeSettings = false.obs;
    final transCodePresetIndex =
        globalSettingsController.defaultTransCodePresetId.value.obs;

    final outputFileNameTextEditingController = TextEditingController();

    final totalDuration = videoResources.fold(const Duration(),
        (previousValue, element) => previousValue + element.duration);

    final isMergeable = _isMergeable(videoResources);

    switch (isMergeable) {
      case _MergeError.none:
        return Focus(
            focusNode: globalFocusNodesController.dialogFocusNode,
            autofocus: true,
            child: AlertDialog(
                title: const Text('Export Merged Video'),
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
                                                selectedDirectory.value =
                                                    result;
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
                                      '${useSameDirectory.value ? videoResources.first.file.parent.path : selectedDirectory.value}'
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
                                                .map((e) =>
                                                    DropdownMenuItem<int>(
                                                      value: e.id,
                                                      child: Text(e.name),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              transCodePresetIndex.value =
                                                  value!;
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
                                              'Output resolution: ${videoResources.first.width}x${videoResources.first.height}'),
                                          Text(
                                              'Output codec: ${videoResources.first.isHevc ? 'HEVC' : 'H.264'}'),
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
                                Text(
                                    'Output Duration: ${getFormattedTime(totalDuration)}'),
                                const Text('Input Files List:'),
                                for (final video in videoResources)
                                  Text(video.name),
                              ],
                            );
                          })
                        ])),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                      onPressed: () async {
                        Get.back();
                        final outputFilePath =
                            '${useSameDirectory.value ? videoResources.first.file.parent.path : selectedDirectory.value}/${outputFileName.value}.MP4';
                        final preset = globalSettingsController
                            .transCodingPresets
                            .firstWhere((element) =>
                                element.id == transCodePresetIndex.value);
                        final process = VideoProcess(
                          name: 'Merge $outputFileName.MP4',
                          type: VideoProcessType.merge,
                          duration: totalDuration.inSeconds.toDouble(),
                        );
                        globalTasksController.videoProcessingTasks.add(process);
                        final List<String> ffmpegArgs = [];
                        final inputFilesTxtPath =
                            '${videoResources.first.file.parent.path}/.${outputFileName.value}_${_get4DigitRandomString()}.txt';
                        final inputFilesTxtFile = File(inputFilesTxtPath);
                        if (inputFilesTxtFile.existsSync()) {
                          inputFilesTxtFile.deleteSync();
                        }
                        inputFilesTxtFile.writeAsStringSync(videoResources
                            .map((e) => 'file \'${e.file.path}\'')
                            .join('\n'));
                        ffmpegArgs.add('-f');
                        ffmpegArgs.add('concat');
                        ffmpegArgs.add('-safe');
                        ffmpegArgs.add('0');
                        ffmpegArgs.add('-i');
                        ffmpegArgs.add(inputFilesTxtPath);
                        ffmpegArgs.add('-c:v');
                        if (useInputEncodeSettings.value == false) {
                          ffmpegArgs
                              .add(preset.useHevc ? 'libx265' : 'libx264');
                          if (preset.useHevc) {
                            ffmpegArgs.add('-tag:v');
                            ffmpegArgs.add('hvc1');
                          }
                          ffmpegArgs.add('-crf');
                          ffmpegArgs.add(preset.crf.toString());
                          ffmpegArgs.add('-preset');
                          ffmpegArgs.add(FFmpegPreset
                              .values[preset.ffmpegPreset]
                              .toString()
                              .split('.')
                              .last);
                          ffmpegArgs.add('-vf');
                          ffmpegArgs
                              .add('scale=${preset.width}:${preset.height}');
                        } else {
                          ffmpegArgs.add('copy');
                        }
                        ffmpegArgs.add(outputFilePath);
                        for (final arg in ffmpegArgs) {
                          if (kDebugMode) {
                            print(arg);
                          }
                        }
                        await process.start(ffmpegArgs, needDeleteFilePaths: [
                          inputFilesTxtPath,
                        ]);
                        // inputFilesTxtFile.deleteSync();
                      },
                      child: Obx(() => isOutputPathValid.value
                          ? const Text('Export',
                              style: TextStyle(color: Colors.blue))
                          : const Text('Export',
                              style: TextStyle(color: Colors.grey))))
                ]));
      case _MergeError.differentResolution:
        return const _ExportMergedVideoErrorDialog(
            errorMessages:
                'The videos have different resolutions, please make sure all videos have the same resolution.');
      case _MergeError.differentCodec:
        return const _ExportMergedVideoErrorDialog(
            errorMessages:
                'The videos have different codecs, please make sure all videos have the same codec.');
      case _MergeError.differentFrameRate:
        return const _ExportMergedVideoErrorDialog(
            errorMessages:
                'The videos have different frame rates, please make sure all videos have the same frame rate.');
    }
  }
}

class _ExportMergedVideoErrorDialog extends StatelessWidget {
  final String errorMessages;

  const _ExportMergedVideoErrorDialog({required this.errorMessages});

  @override
  Widget build(BuildContext context) {
    final globalFocusNodesController = Get.find<GlobalFocusNodesController>();
    return Focus(
        focusNode: globalFocusNodesController.dialogFocusNode,
        autofocus: true,
        child: AlertDialog(
            title: const Text('Export Merged Video Failed'),
            content: Text(errorMessages),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK', style: TextStyle(color: Colors.blue)),
              ),
            ]));
  }
}

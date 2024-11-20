import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/constants.dart';
import 'package:xji_footage_toolbox/service/log_service.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/multi_select_panel.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/settings_dialog.dart';

import '../../../controllers/global_media_resources_controller.dart';
import '../../../controllers/global_settings_controller.dart';
import '../../../controllers/global_tasks_controller.dart';
import '../../../models/media_resource.dart';
import '../../../models/settings.dart';
import '../../../models/video_process.dart';
import '../../../utils/media_resources_utils.dart';
import 'custom_dual_option_dialog.dart';
import '../buttons/custom_icon_button.dart';
import '../../design_tokens.dart';
import '../views/video_trimmer.dart';

String _getDefaultOutputFileName(String originalFileName) {
  final lastDotIndex = originalFileName.lastIndexOf('.');
  final baseName = originalFileName.substring(0, lastDotIndex);
  return '${baseName}_OUTPUT';
}

String _get4DigitRandomString() {
  final random = Random();
  return random.nextInt(10000).toString().padLeft(4, '0');
}

Duration _getOutputDuration() {
  var duration = const Duration(seconds: 0);
  final GlobalMediaResourcesController globalMediaResourcesController =
      Get.find<GlobalMediaResourcesController>();
  final MultiSelectPanelController multiSelectPanelController = Get.find();
  if (multiSelectPanelController.isMerging.value) {
    for (final index in globalMediaResourcesController.selectedIndexList) {
      final videoResource = globalMediaResourcesController.mediaResources[index]
          as NormalVideoResource;
      duration += videoResource.duration;
    }
  } else {
    if (globalMediaResourcesController.isEditingMediaResources.value) {
      final videoTrimmerController = Get.find<VideoTrimmerController>();
      duration = videoTrimmerController.savedEnd.value -
          videoTrimmerController.savedStart.value;
    } else {
      final videoResource = globalMediaResourcesController.mediaResources[
              globalMediaResourcesController.currentMediaIndex.value]
          as NormalVideoResource;
      duration = videoResource.duration;
    }
  }
  return duration;
}

class _OutputInfoItem extends StatelessWidget {
  final String keyText;
  final String valueText;

  const _OutputInfoItem({required this.keyText, required this.valueText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(keyText,
            style: SemiTextStyles.header6ENRegular.copyWith(
                color: ColorDark.text1, overflow: TextOverflow.ellipsis)),
        const Spacer(),
        Text(valueText,
            style: SemiTextStyles.header6ENRegular.copyWith(
                color: ColorDark.text0, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

class _MergeFileListView extends StatelessWidget {
  final List<NormalVideoResource> videoResources;

  const _MergeFileListView({required this.videoResources});

  @override
  Widget build(BuildContext context) {
    final GlobalMediaResourcesController globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Merge files:',
          style:
              SemiTextStyles.header6ENRegular.copyWith(color: ColorDark.text1)),
      SizedBox(
        height: DesignValues.smallPadding,
      ),
      Expanded(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return Text(videoResources[index].name,
              style: SemiTextStyles.header6ENRegular
                  .copyWith(color: ColorDark.text0));
        },
        itemCount: globalMediaResourcesController.selectedIndexList.length,
      )),
    ]);
  }
}

class VideoExportDialog extends StatelessWidget {
  final List<NormalVideoResource> videoResources;

  const VideoExportDialog({super.key, this.videoResources = const []});

  @override
  Widget build(BuildContext context) {
    final GlobalMediaResourcesController globalMediaResourcesController =
        Get.find<GlobalMediaResourcesController>();
    final GlobalSettingsController globalSettingsController =
        Get.find<GlobalSettingsController>();
    final MultiSelectPanelController multiSelectPanelController = Get.find();
    final GlobalTasksController globalTasksController =
        Get.find<GlobalTasksController>();

    late final NormalVideoResource videoResource;

    if (multiSelectPanelController.isMerging.value) {
      videoResource = globalMediaResourcesController.mediaResources[
              globalMediaResourcesController.selectedIndexList.first]
          as NormalVideoResource;
    } else {
      if (globalMediaResourcesController.isEditingMediaResources.value) {
        videoResource = globalMediaResourcesController.mediaResources[
                globalMediaResourcesController.currentMediaIndex.value]
            as NormalVideoResource;
      } else {
        videoResource = globalMediaResourcesController.mediaResources[
                globalMediaResourcesController.currentMediaIndex.value]
            as NormalVideoResource;
      }
    }

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
    final selectedDirectoryTextController = TextEditingController();

    outputFileNameTextEditingController.text = outputFileName.value;

    return Obx(() => CustomDualOptionDialog(
        width: 480,
        height: 680,
        title: 'Export',
        option1: 'Cancel',
        option2: 'Export',
        disableOption2: !isOutputPathValid.value,
        onOption1Pressed: () {
          Get.back();
        },
        onOption2Pressed: () async {
          if (isOutputPathValid.value) {
            final outputFilePath =
                '${useSameDirectory.value ? videoResource.file.parent.path : selectedDirectory.value}'
                '/${outputFileName.value}.MP4';
            final preset = globalSettingsController.transCodingPresets
                .firstWhere(
                    (element) => element.id == transCodePresetIndex.value);

            if (multiSelectPanelController.isMerging.value) {
              final List<String> ffmpegArgs = [];
              final inputFilesTxtPath =
                  '${videoResource.file.parent.path}/.${outputFileName.value}_'
                  '${_get4DigitRandomString()}.txt';
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
                if (preset.useInputResolution == false) {
                  ffmpegArgs.add('-vf');
                  ffmpegArgs.add('scale=${preset.width}:${preset.height}');
                }
              } else {
                ffmpegArgs.add('copy');
              }
              ffmpegArgs.add('-map_metadata');
              ffmpegArgs.add('0');
              ffmpegArgs.add(outputFilePath);
              for (final arg in ffmpegArgs) {
                if (kDebugMode) {
                  print(arg);
                }
              }
              final process = VideoProcess(
                name: '$outputFileName.MP4',
                type: VideoProcessType.merge,
                duration: _getOutputDuration(),
                ffmpegArgs: ffmpegArgs,
                outputFilePath: outputFilePath,
                logFilePath: LogService.isDebug
                    ? '${videoResource.file.parent.path}/$logFolderName'
                    : null,
              );
              globalTasksController.addTask(process);
            } else {
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
                if (preset.useInputResolution == false) {
                  ffmpegArgs.add('-vf');
                  ffmpegArgs.add('scale=${preset.width}:${preset.height}');
                }
              } else {
                ffmpegArgs.add('copy');
              }

              if (globalMediaResourcesController
                  .isEditingMediaResources.value) {
                final videoTrimmerController =
                    Get.find<VideoTrimmerController>();
                ffmpegArgs.add('-ss');
                ffmpegArgs
                    .add(videoTrimmerController.savedStart.value.toString());
                ffmpegArgs.add('-to');
                ffmpegArgs
                    .add(videoTrimmerController.savedEnd.value.toString());
              }
              ffmpegArgs.add('-map_metadata');
              ffmpegArgs.add('0');
              ffmpegArgs.add(outputFilePath);
              final process = VideoProcess(
                name: '$outputFileName.MP4',
                type:
                    globalMediaResourcesController.isEditingMediaResources.value
                        ? VideoProcessType.trim
                        : VideoProcessType.transcode,
                duration: _getOutputDuration(),
                ffmpegArgs: ffmpegArgs,
                outputFilePath: outputFilePath,
                logFilePath: LogService.isDebug
                    ? '${videoResource.file.parent.path}/$logFolderName'
                    : null,
              );
              globalTasksController.addTask(process);
            }
            Get.back();
          }
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => CustomDialogCheckBoxWithText(
                  text: 'Use the same directory as source',
                  value: useSameDirectory.value,
                  onPressed: () {
                    useSameDirectory.value = !useSameDirectory.value;
                  })),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              Obx(() => useSameDirectory.value
                  ? const SizedBox()
                  : CustomDialogIconButtonWithText(
                      iconData: Icons.folder_open,
                      text: 'Select a output directory',
                      onPressed: () async {
                        final result =
                            await FilePicker.platform.getDirectoryPath();
                        if (result != null) {
                          selectedDirectory.value = result;
                          selectedDirectoryTextController.text = result;
                        }
                      })),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              Obx(() => useSameDirectory.value
                  ? const SizedBox()
                  : TextField(
                      readOnly: true,
                      cursorColor: ColorDark.text1,
                      controller: selectedDirectoryTextController,
                      style: SemiTextStyles.header6ENRegular
                          .copyWith(color: ColorDark.text0),
                      decoration: dialogInputDecoration,
                    )),
              SizedBox(
                height: DesignValues.ultraSmallPadding,
              ),
              Text(
                'Output file name',
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
                          controller: outputFileNameTextEditingController,
                          style: SemiTextStyles.header5ENRegular
                              .copyWith(color: ColorDark.text0),
                          decoration: dialogInputDecoration.copyWith(
                              suffix: Text(
                                '.MP4',
                                style: SemiTextStyles.header5ENRegular
                                    .copyWith(color: ColorDark.text1),
                              ),
                              errorText: isOutputPathValid.value
                                  ? null
                                  : 'File already exists',
                              errorMaxLines: 3),
                          onChanged: (value) {
                            outputFileName.value = value;
                            isOutputPathValid.value = !isFileExist(
                                '${useSameDirectory.value ? videoResource.file.parent.path : selectedDirectory.value}'
                                '/${outputFileName.value}.MP4');
                          },
                        ))),
              ),
              SizedBox(
                height: DesignValues.ultraSmallPadding,
              ),
              Obx(() => CustomDialogCheckBoxWithText(
                  text: 'Use the same encodings as source',
                  value: useInputEncodeSettings.value,
                  onPressed: () {
                    useInputEncodeSettings.value =
                        !useInputEncodeSettings.value;
                  })),
              Obx(() => useInputEncodeSettings.value
                  ? const SizedBox()
                  : Row(
                      children: [
                        Text('Transcode Preset:',
                            style: SemiTextStyles.header5ENRegular
                                .copyWith(color: ColorDark.text1)),
                        SizedBox(
                          width: DesignValues.mediumPadding,
                        ),
                        Expanded(
                            child: Obx(() => DropdownButton<int>(
                                  isExpanded: true,
                                  value: transCodePresetIndex.value,
                                  focusColor: ColorDark.defaultActive,
                                  dropdownColor: ColorDark.bg2,
                                  style: SemiTextStyles.header5ENRegular
                                      .copyWith(color: ColorDark.text0),
                                  items: globalSettingsController
                                      .transCodingPresets
                                      .map((e) => DropdownMenuItem<int>(
                                          value: e.id, child: Text(e.name)))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      transCodePresetIndex.value = value;
                                    }
                                  },
                                ))),
                        SizedBox(
                          width: DesignValues.largePadding,
                        ),
                        CustomIconButton(
                            iconData: Icons.settings,
                            onPressed: () async {
                              await Get.dialog(const SettingsDialog());
                            },
                            iconSize: DesignValues.mediumIconSize,
                            buttonSize: 24,
                            hoverColor: ColorDark.defaultHover,
                            focusColor: ColorDark.defaultActive,
                            iconColor: ColorDark.text1)
                      ],
                    )),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              const Divider(
                color: ColorDark.border,
                thickness: 1,
                height: 1,
              ),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              _OutputInfoItem(
                  keyText: 'Output duration:',
                  valueText: _getOutputDuration().toString()),
              Obx(() => _OutputInfoItem(
                  keyText: 'Output resolution:',
                  valueText: useInputEncodeSettings.value
                      ? '${videoResource.width}x${videoResource.height}'
                      : globalSettingsController.transCodingPresets
                              .firstWhere((element) =>
                                  element.id == transCodePresetIndex.value)
                              .useInputResolution
                          ? '${videoResource.width}x${videoResource.height}'
                          : '${globalSettingsController.transCodingPresets.firstWhere((element) => element.id == transCodePresetIndex.value).width}'
                              'x${globalSettingsController.transCodingPresets.firstWhere((element) => element.id == transCodePresetIndex.value).height}')),
              Obx(() => _OutputInfoItem(
                  keyText: 'Output codec:',
                  valueText: useInputEncodeSettings.value
                      ? videoResource.isHevc
                          ? 'H.265'
                          : 'H.264'
                      : globalSettingsController.transCodingPresets
                              .firstWhere((element) =>
                                  element.id == transCodePresetIndex.value)
                              .useHevc
                          ? 'H.265'
                          : 'H.264')),
              Obx(() => useInputEncodeSettings.value
                  ? const SizedBox()
                  : _OutputInfoItem(
                      keyText: 'Output CRF:',
                      valueText: globalSettingsController.transCodingPresets
                          .firstWhere((element) =>
                              element.id == transCodePresetIndex.value)
                          .crf
                          .toString())),
              Obx(() => useInputEncodeSettings.value
                  ? const SizedBox()
                  : _OutputInfoItem(
                      keyText: 'Output FFMPEG preset:',
                      valueText: FFmpegPreset.values[globalSettingsController
                              .transCodingPresets
                              .firstWhere((element) =>
                                  element.id == transCodePresetIndex.value)
                              .ffmpegPreset]
                          .toString()
                          .split('.')
                          .last)),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              const Divider(
                color: ColorDark.border,
                thickness: 1,
                height: 1,
              ),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              if (multiSelectPanelController.isMerging.value)
                Expanded(
                    child: _MergeFileListView(
                  videoResources: videoResources,
                )),
            ])));
  }
}

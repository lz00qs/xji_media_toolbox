import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/video_task.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/multi_select_panel.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/settings_dialog.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/video_trimmer.dart';
import '../../../models/media_resource.dart';
import '../../../models/settings.dart';
import '../../../utils/media_resources_utils.dart';
import 'custom_dual_option_dialog.dart';
import '../buttons/custom_icon_button.dart';
import '../../design_tokens.dart';

String _getDefaultOutputFileName(String originalFileName) {
  final lastDotIndex = originalFileName.lastIndexOf('.');
  final baseName = originalFileName.substring(0, lastDotIndex);
  return '${baseName}_OUTPUT';
}

String _get4DigitRandomString() {
  final random = Random();
  return random.nextInt(10000).toString().padLeft(4, '0');
}

Duration _getOutputDuration(
    {required bool isMerging,
    required bool isEditing,
    required WidgetRef ref}) {
  var duration = const Duration(seconds: 0);
  if (isMerging) {
    for (final element in ref.watch(
        mediaResourcesProvider.select((state) => state.selectedResources))) {
      final videoResource = element as NormalVideoResource;
      duration += videoResource.duration;
    }
  } else {
    if (isEditing) {
      duration = ref.watch(trimmerSavedEnd) -
          ref.watch(trimmerSavedStart);
    } else {
      if (ref.watch(mediaResourcesProvider
          .select((state) => state.resources.isNotEmpty))) {
        final videoResource = ref.watch(mediaResourcesProvider.select((state) =>
            state.resources[state.currentIndex] as NormalVideoResource));
        duration = videoResource.duration;
      }
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
        itemCount: videoResources.length,
      )),
    ]);
  }
}

class VideoExportDialog extends HookConsumerWidget {
  const VideoExportDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMerging = ref.watch(isMergingStateProvider);
    final isEditing =
        ref.watch(mediaResourcesProvider.select((state) => state.isEditing));

    late final NormalVideoResource videoResource;

    if (isMerging) {
      videoResource = ref.watch(mediaResourcesProvider.select(
          (state) => state.selectedResources[0] as NormalVideoResource));
    } else {
      if (ref.watch(mediaResourcesProvider
          .select((state) => state.resources.isNotEmpty))) {
        videoResource = ref.watch(mediaResourcesProvider.select((state) =>
            state.resources[state.currentIndex] as NormalVideoResource));
      }
    }

    final useSameDirectory = useState(true);
    final selectedDirectory = useState('');
    final outputFileName =
        useState(_getDefaultOutputFileName(videoResource.name));
    final isOutputPathValid = useState(!isFileExist(
        '${videoResource.file.parent.path}/${outputFileName.value}.MP4'));
    final useInputEncodeSettings = useState(false);
    final transcodePresetIndex = useState(ref.watch(
        settingsProvider.select((state) => state.defaultTranscodePresetId)));

    final outputFileNameTextEditingController =
        useTextEditingController(text: outputFileName.value);

    useEffect(() {
      outputFileNameTextEditingController.addListener(() {
        outputFileName.value = outputFileNameTextEditingController.text;
        isOutputPathValid.value = !isFileExist(
            '${useSameDirectory.value ? videoResource.file.parent.path : selectedDirectory.value}'
            '/${outputFileName.value}.MP4');
      });
      return null;
    }, []);

    final selectedDirectoryTextController = useTextEditingController(text: '');

    useEffect(() {
      selectedDirectoryTextController.addListener(() {
        selectedDirectory.value = selectedDirectoryTextController.text;
        isOutputPathValid.value = !isFileExist(
            '${useSameDirectory.value ? videoResource.file.parent.path : selectedDirectory.value}'
            '/${outputFileName.value}.MP4');
      });
      return null;
    }, []);

    return CustomDualOptionDialog(
        width: 480,
        height: 680,
        title: 'Export',
        option1: 'Cancel',
        option2: 'Export',
        disableOption2: !isOutputPathValid.value,
        onOption1Pressed: () {
          Navigator.pop(context);
        },
        onOption2Pressed: () async {
          if (isOutputPathValid.value) {
            final outputFilePath =
                '${useSameDirectory.value ? videoResource.file.parent.path : selectedDirectory.value}'
                '/${outputFileName.value}.MP4';
            final preset = ref.watch(settingsProvider.select((state) =>
                state.transcodingPresets.firstWhere(
                    (element) => element.id == transcodePresetIndex.value)));

            if (isMerging) {
              final List<String> ffmpegArgs = [];
              final inputFilesTxtPath =
                  '${videoResource.file.parent.path}/.${outputFileName.value}_'
                  '${_get4DigitRandomString()}.txt';
              final inputFilesTxtFile = File(inputFilesTxtPath);
              if (inputFilesTxtFile.existsSync()) {
                inputFilesTxtFile.deleteSync();
              }
              inputFilesTxtFile.writeAsStringSync(ref
                  .watch(mediaResourcesProvider
                      .select((state) => state.selectedResources))
                  .map((e) => 'file \'${e.file.path}\'')
                  .join('\n'));
              ffmpegArgs.add('-i');
              ffmpegArgs.add(videoResource.file.path);
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
              final task = VideoTask(
                name: '${outputFileName.value}.MP4',
                status: VideoTaskStatus.waiting,
                type: VideoTaskType.merge,
                ffmpegArgs: ffmpegArgs,
                duration: _getOutputDuration(
                    isMerging: true, isEditing: isEditing, ref: ref),
                progress: 0.0,
                outputFile: File(outputFilePath),
                tempFiles: [inputFilesTxtFile],
                eta: Duration(),
              );
              ref.read(taskManagerProvider.notifier).addTask(task);
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

              if (isEditing) {
                ffmpegArgs.add('-ss');
                ffmpegArgs
                    .add(ref.watch(trimmerSavedStart).toString());
                ffmpegArgs.add('-to');
                ffmpegArgs
                    .add(ref.watch(trimmerSavedEnd).toString());
              }
              ffmpegArgs.add('-map_metadata');
              ffmpegArgs.add('0');
              ffmpegArgs.add(outputFilePath);
              final task = VideoTask(
                name: '${outputFileName.value}.MP4',
                status: VideoTaskStatus.waiting,
                type: isEditing
                   ? VideoTaskType.trim
                   : VideoTaskType.transcode,
                ffmpegArgs: ffmpegArgs,
                duration: _getOutputDuration(
                    isMerging: false, isEditing: isEditing, ref: ref),
                progress: 0.0,
                outputFile: File(outputFilePath),
                tempFiles: [],
                eta: Duration(),
              );
              ref.read(taskManagerProvider.notifier).addTask(task);
            }
            Navigator.pop(context);
          }
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDialogCheckBoxWithText(
                  text: 'Use the same directory as source',
                  value: useSameDirectory.value,
                  onPressed: () {
                    useSameDirectory.value = !useSameDirectory.value;
                  }),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              useSameDirectory.value
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
                      }),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              useSameDirectory.value
                  ? const SizedBox()
                  : Theme(
                      data: Theme.of(context).copyWith(
                          textSelectionTheme: TextSelectionThemeData(
                              selectionColor: ColorDark.blue5
                                  .withAlpha((0.8 * 255).round()))),
                      child: TextField(
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
                            selectionColor: ColorDark.blue5
                                .withAlpha((0.8 * 255).round()))),
                    child: TextField(
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
                    )),
              ),
              SizedBox(
                height: DesignValues.ultraSmallPadding,
              ),
              CustomDialogCheckBoxWithText(
                  text: 'Use the same encodings as source',
                  value: useInputEncodeSettings.value,
                  onPressed: () {
                    useInputEncodeSettings.value =
                        !useInputEncodeSettings.value;
                  }),
              useInputEncodeSettings.value
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
                            child: DropdownButton<int>(
                          isExpanded: true,
                          value: transcodePresetIndex.value,
                          focusColor: ColorDark.defaultActive,
                          dropdownColor: ColorDark.bg2,
                          style: SemiTextStyles.header5ENRegular
                              .copyWith(color: ColorDark.text0),
                          items: ref
                              .watch(settingsProvider.select((state) => state
                                  .transcodingPresets
                                  .map((e) => DropdownMenuItem<int>(
                                      value: e.id, child: Text(e.name)))
                                  .toList()))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              transcodePresetIndex.value = value;
                            }
                          },
                        )),
                        SizedBox(
                          width: DesignValues.largePadding,
                        ),
                        CustomIconButton(
                            iconData: Icons.settings,
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SettingsDialog();
                                  });
                            },
                            iconSize: DesignValues.mediumIconSize,
                            buttonSize: 24,
                            hoverColor: ColorDark.defaultHover,
                            focusColor: ColorDark.defaultActive,
                            iconColor: ColorDark.text1)
                      ],
                    ),
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
                  valueText: _getOutputDuration(
                          isEditing: isEditing, isMerging: isMerging, ref: ref)
                      .toString()),
              _OutputInfoItem(
                  keyText: 'Output resolution:',
                  valueText: useInputEncodeSettings.value
                      ? '${videoResource.width}x${videoResource.height}'
                      : ref
                              .watch(settingsProvider.select((state) => state
                                  .transcodingPresets
                                  .firstWhere((element) =>
                                      element.id ==
                                      transcodePresetIndex.value)))
                              .useInputResolution
                          ? '${videoResource.width}x${videoResource.height}'
                          : '${ref.watch(settingsProvider.select((state) => state.transcodingPresets.firstWhere((element) => element.id == transcodePresetIndex.value))).width}x${ref.watch(settingsProvider.select((state) => state.transcodingPresets.firstWhere((element) => element.id == transcodePresetIndex.value))).height}'),
              _OutputInfoItem(
                keyText: 'Output codec:',
                valueText: useInputEncodeSettings.value
                    ? videoResource.isHevc
                        ? 'H.265'
                        : 'H.264'
                    : ref
                            .watch(settingsProvider.select((state) =>
                                state.transcodingPresets.firstWhere((element) =>
                                    element.id == transcodePresetIndex.value)))
                            .useHevc
                        ? 'H.265'
                        : 'H.264',
              ),
              useInputEncodeSettings.value
                  ? const SizedBox()
                  : _OutputInfoItem(
                      keyText: 'Output CRF:',
                      valueText: ref
                          .watch(settingsProvider.select((state) =>
                              state.transcodingPresets.firstWhere((element) =>
                                  element.id == transcodePresetIndex.value)))
                          .crf
                          .toString(),
                    ),
              useInputEncodeSettings.value
                  ? const SizedBox()
                  : _OutputInfoItem(
                      keyText: 'Output FFMPEG preset:',
                      valueText: FFmpegPreset.values[ref
                              .watch(settingsProvider.select((state) => state
                                  .transcodingPresets
                                  .firstWhere((element) =>
                                      element.id ==
                                      transcodePresetIndex.value)))
                              .ffmpegPreset]
                          .toString()
                          .split('.')
                          .last),
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
              if (isMerging)
                Expanded(
                    child: _MergeFileListView(
                  videoResources: ref.watch(mediaResourcesProvider.select(
                    (state) => state.selectedResources
                        .map((element) => element as NormalVideoResource)
                        .toList(),
                  )),
                )),
            ]));
  }
}

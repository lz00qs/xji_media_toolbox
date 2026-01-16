import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/models/video_task.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/settings_dialog.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/video_trimmer.dart';
import '../../../models/media_resource.dart';
import '../../../models/settings.dart';
import '../../../providers/media_resources_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/task_manager_provider.dart';
import '../../../utils/media_resources_utils.dart';
import 'custom_dual_option_dialog.dart';
import '../buttons/custom_icon_button.dart';
import '../../design_tokens.dart';

part 'video_export_dialog.g.dart';

class _VideoExportDialogState {
  final bool useSameDirectory;
  final String selectedDirectory;
  final String outputFileName;
  final bool isOutputPathValid;
  final bool useInputEncodeSettings;
  final int transcodePresetId;

  const _VideoExportDialogState({
    required this.useSameDirectory,
    required this.selectedDirectory,
    required this.outputFileName,
    required this.isOutputPathValid,
    required this.useInputEncodeSettings,
    required this.transcodePresetId,
  });

  _VideoExportDialogState copyWith({
    bool? useSameDirectory,
    String? selectedDirectory,
    String? outputFileName,
    bool? isOutputPathValid,
    bool? useInputEncodeSettings,
    int? transcodePresetId,
  }) {
    return _VideoExportDialogState(
      useSameDirectory: useSameDirectory ?? this.useSameDirectory,
      selectedDirectory: selectedDirectory ?? this.selectedDirectory,
      outputFileName: outputFileName ?? this.outputFileName,
      isOutputPathValid: isOutputPathValid ?? this.isOutputPathValid,
      useInputEncodeSettings:
          useInputEncodeSettings ?? this.useInputEncodeSettings,
      transcodePresetId: transcodePresetId ?? this.transcodePresetId,
    );
  }
}

@riverpod
class _VideoExportDialogController extends _$VideoExportDialogController {
  late final TextEditingController outputFileNameController;
  late final TextEditingController selectedDirectoryController;
  late NormalVideoResource videoResource;

  @override
  _VideoExportDialogState build() {
    // final isMerging = ref.watch(mediaResourcesProvider).isMerging;
    final mediaState = ref.watch(mediaResourcesProvider);
    final settings = ref.watch(settingsProvider);

    if (mediaState.isMerging) {
      videoResource =
          mediaState.selectedResources.first as NormalVideoResource;
    } else {
      videoResource =
          mediaState.resources[mediaState.currentIndex]
              as NormalVideoResource;
    }

    final defaultName = _getDefaultOutputFileName(videoResource.name);

    outputFileNameController = TextEditingController(text: defaultName);
    selectedDirectoryController = TextEditingController();

    outputFileNameController.addListener(_recalculatePath);
    selectedDirectoryController.addListener(_recalculatePath);

    ref.onDispose(() {
      outputFileNameController.dispose();
      selectedDirectoryController.dispose();
    });

    return _VideoExportDialogState(
      useSameDirectory: true,
      selectedDirectory: '',
      outputFileName: defaultName,
      isOutputPathValid: !_fileExists(defaultName, true, ''),
      useInputEncodeSettings: false,
      transcodePresetId: settings.value?.defaultTranscodePresetId ?? 0,
    );
  }

  void toggleUseSameDirectory() {
    state = state.copyWith(
      useSameDirectory: !state.useSameDirectory,
    );
    _recalculatePath();
  }

  void toggleUseInputEncodeSettings() {
    state = state.copyWith(
      useInputEncodeSettings: !state.useInputEncodeSettings,
    );
  }

  void setPreset(int id) {
    state = state.copyWith(transcodePresetId: id);
  }

  void setSelectedDirectory(String dir) {
    selectedDirectoryController.text = dir;
    state = state.copyWith(selectedDirectory: dir);
    _recalculatePath();
  }

  void _recalculatePath() {
    final exists = _fileExists(
      outputFileNameController.text,
      state.useSameDirectory,
      selectedDirectoryController.text,
    );

    state = state.copyWith(
      outputFileName: outputFileNameController.text,
      selectedDirectory: selectedDirectoryController.text,
      isOutputPathValid: !exists,
    );
  }

  bool _fileExists(
    String name,
    bool useSameDir,
    String customDir,
  ) {
    final dir = useSameDir ? videoResource.file.parent.path : customDir;
    return isFileExist('$dir/$name.MP4');
  }

// @override
// void dispose() {
//   outputFileNameController.dispose();
//   selectedDirectoryController.dispose();
//   super.dispose();
// }
}

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
    for (final element in ref.watch(mediaResourcesProvider
        .select((state) => state.selectedResources))) {
      final videoResource = element as NormalVideoResource;
      duration += videoResource.duration;
    }
  } else {
    if (isEditing) {
      duration = ref.watch(trimmerSavedEndProvider) - ref.watch(trimmerSavedEndProvider);
    } else {
      if (ref.watch(mediaResourcesProvider.select((state) {
        if (state.resources.isNotEmpty == true) {
          return true;
        }
        return false;
      }))) {
        final videoResource = ref.watch(mediaResourcesProvider.select((state) =>
            state.resources[state.currentIndex]
                as NormalVideoResource));
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

class VideoExportDialog extends ConsumerWidget {
  const VideoExportDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_videoExportDialogControllerProvider);
    final controller = ref.read(_videoExportDialogControllerProvider.notifier);

    final isMerging = ref.watch(mediaResourcesProvider.select((m) => m.isMerging));
    final isEditing = ref.watch(
      mediaResourcesProvider.select((s) => s.isEditing),
    );

    final videoResource = controller.videoResource;

    return CustomDualOptionDialog(
        width: 480,
        height: 680,
        title: 'Export',
        option1: 'Cancel',
        option2: 'Export',
        // disableOption2: !isOutputPathValid.value,
        disableOption2: !state.isOutputPathValid,
        onOption1Pressed: () {
          Navigator.pop(context);
        },
        onOption2Pressed: () async {
          if (state.isOutputPathValid) {
            // final outputFilePath =
            //     '${useSameDirectory.value ? videoResource.file.parent.path : selectedDirectory.value}'
            //     '/${outputFileName.value}.MP4';
            final outputFilePath =
                '${state.useSameDirectory ? videoResource.file.parent.path : state.selectedDirectory}'
                '/${state.outputFileName}.MP4';
            // final preset = ref.watch(settingsProvider.select((state) =>
            //     state.transcodingPresets.firstWhere(
            //         (element) => element.id == transcodePresetIndex.value)));
            final preset = ref.watch(settingsProvider.select((s) => s
                    .value?.transcodingPresets
                    .firstWhere((e) => e.id == state.transcodePresetId))) ??
                TranscodePreset()
              ..id = 0;
            if (isMerging) {
              final List<String> ffmpegArgs = [];
              final inputFilesTxtPath =
                  '${videoResource.file.parent.path}/.${state.outputFileName}_'
                  '${_get4DigitRandomString()}.txt';
              final inputFilesTxtFile = File(inputFilesTxtPath);
              if (inputFilesTxtFile.existsSync()) {
                inputFilesTxtFile.deleteSync();
              }
              inputFilesTxtFile.writeAsStringSync(ref
                  .watch(mediaResourcesProvider
                      .select((m) => m.selectedResources))
                  .map((e) => 'file \'${e.file.path}\'')
                  .join('\n'));
              ffmpegArgs.add('-f');
              ffmpegArgs.add('concat');
              ffmpegArgs.add('-safe');
              ffmpegArgs.add('0');
              ffmpegArgs.add('-i');
              ffmpegArgs.add(inputFilesTxtPath);
              ffmpegArgs.add('-i');
              ffmpegArgs.add(videoResource.file.path);
              ffmpegArgs.add('-map_metadata');
              ffmpegArgs.add('1');
              if (state.useInputEncodeSettings == false && preset.lutId != 0) {
                ffmpegArgs.add('-vf');
                ffmpegArgs.add(
                    "lut3d='${ref.watch(settingsProvider.select((s) => s.value?.luts.firstWhere((element) => element.id == preset.lutId)))?.path ?? ''}'");
              }
              ffmpegArgs.add('-c:v');
              if (state.useInputEncodeSettings == false) {
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
              ffmpegArgs.add(outputFilePath);
              for (final arg in ffmpegArgs) {
                if (kDebugMode) {
                  print(arg);
                }
              }
              final task = VideoTask(
                name: '${state.outputFileName}.MP4',
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
              // Export single file
              final List<String> ffmpegArgs = [];
              ffmpegArgs.add('-i');
              ffmpegArgs.add(videoResource.file.path);
              if (state.useInputEncodeSettings == false && preset.lutId != 0) {
                final lutPath = ref.watch(settingsProvider.select((s) =>
                    s.value?.luts
                        .firstWhere((e) => e.id == preset.lutId)
                        .path ??
                    ''));

                ffmpegArgs.add('-vf');
                ffmpegArgs.add(
                  'lut3d=$lutPath,format=yuv420p10le',
                );
              }
              ffmpegArgs.add('-c:v');
              if (state.useInputEncodeSettings == false) {
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
                ffmpegArgs.add(ref.watch(trimmerSavedStartProvider).toString());
                ffmpegArgs.add('-to');
                ffmpegArgs.add(ref.watch(trimmerSavedEndProvider).toString());
              }
              ffmpegArgs.add('-map_metadata');
              ffmpegArgs.add('0');
              ffmpegArgs.add(outputFilePath);
              final task = VideoTask(
                name: '${state.outputFileName}.MP4',
                status: VideoTaskStatus.waiting,
                type: isEditing ? VideoTaskType.trim : VideoTaskType.transcode,
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
                  value: state.useSameDirectory,
                  onPressed: () {
                    // useSameDirectory.value = !useSameDirectory.value;
                    controller.toggleUseSameDirectory();
                  }),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              state.useSameDirectory
                  ? const SizedBox()
                  : CustomDialogIconButtonWithText(
                      iconData: Icons.folder_open,
                      text: 'Select a output directory',
                      onPressed: () async {
                        final result =
                            await FilePicker.platform.getDirectoryPath();
                        if (result != null) {
                          // selectedDirectory.value = result;
                          // selectedDirectoryTextController.text = result;
                          controller.setSelectedDirectory(result);
                        }
                      }),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              state.useSameDirectory
                  ? const SizedBox()
                  : Theme(
                      data: Theme.of(context).copyWith(
                          textSelectionTheme: TextSelectionThemeData(
                              selectionColor: ColorDark.blue5
                                  .withAlpha((0.8 * 255).round()))),
                      child: TextField(
                        readOnly: true,
                        cursorColor: ColorDark.text1,
                        // controller: selectedDirectoryTextController,
                        controller: controller.selectedDirectoryController,
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
                      // controller: outputFileNameTextEditingController,
                      controller: controller.outputFileNameController,
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text0),
                      decoration: dialogInputDecoration.copyWith(
                          suffix: Text(
                            '.MP4',
                            style: SemiTextStyles.header5ENRegular
                                .copyWith(color: ColorDark.text1),
                          ),
                          // errorText: isOutputPathValid.value
                          errorText: state.isOutputPathValid
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
                  value: state.useInputEncodeSettings,
                  onPressed: () {
                    controller.toggleUseInputEncodeSettings();
                  }),
              SizedBox(
                height: DesignValues.mediumPadding,
              ),
              state.useInputEncodeSettings
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Transcode Preset:',
                            style: SemiTextStyles.header5ENRegular
                                .copyWith(color: ColorDark.text1)),
                        Row(
                          children: [
                            DropdownButton<int>(
                              isExpanded: false,
                              // value: transcodePresetIndex.value,
                              value: state.transcodePresetId,
                              focusColor: ColorDark.defaultActive,
                              dropdownColor: ColorDark.bg2,
                              style: SemiTextStyles.header5ENRegular
                                  .copyWith(color: ColorDark.text0),
                              items: ref
                                  .watch(settingsProvider.select((s) => s
                                      .value?.transcodingPresets
                                      .map((e) => DropdownMenuItem<int>(
                                          value: e.id, child: Text(e.name)))
                                      .toList()))
                                  ?.toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  controller.setPreset(value);
                                }
                              },
                            ),
                            Spacer(),
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
                        )
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
                  valueText: state.useInputEncodeSettings
                      ? '${videoResource.width}x${videoResource.height}'
                      : (ref
                                  .watch(settingsProvider.select((s) => s
                                      .value?.transcodingPresets
                                      .firstWhere((element) =>
                                          element.id ==
                                          state.transcodePresetId)))
                                  ?.useInputResolution ??
                              false)
                          ? '${videoResource.width}x${videoResource.height}'
                          : '${ref.watch(settingsProvider.select((s) => s.value?.transcodingPresets.firstWhere((element) => element.id == state.transcodePresetId)))?.width}x${ref.watch(settingsProvider.select((s) => s.value?.transcodingPresets.firstWhere((element) => element.id == state.transcodePresetId)))?.height}'),
              _OutputInfoItem(
                keyText: 'Output codec:',
                valueText: state.useInputEncodeSettings
                    ? videoResource.isHevc
                        ? 'H.265'
                        : 'H.264'
                    : ref
                                .watch(settingsProvider.select((s) => s
                                    .value?.transcodingPresets
                                    .firstWhere((element) =>
                                        element.id == state.transcodePresetId)))
                                ?.useHevc ??
                            false
                        ? 'H.265'
                        : 'H.264',
              ),
              state.useInputEncodeSettings
                  ? const SizedBox()
                  : _OutputInfoItem(
                      keyText: 'Output CRF:',
                      valueText: (ref
                                  .watch(settingsProvider.select((s) => s
                                      .value?.transcodingPresets
                                      .firstWhere((element) =>
                                          element.id ==
                                          state.transcodePresetId)))
                                  ?.crf ??
                              23)
                          .toString(),
                    ),
              state.useInputEncodeSettings
                  ? const SizedBox()
                  : _OutputInfoItem(
                      keyText: 'Output FFMPEG preset:',
                      valueText: FFmpegPreset.values[(ref
                                  .watch(settingsProvider.select((s) => s
                                      .value?.transcodingPresets
                                      .firstWhere((element) =>
                                          element.id ==
                                          state.transcodePresetId)))
                                  ?.ffmpegPreset) ??
                              FFmpegPreset.ultrafast.index]
                          .toString()
                          .split('.')
                          .last),
              // Output LUT:
              state.useInputEncodeSettings
                  ? const SizedBox()
                  : _OutputInfoItem(
                      keyText: 'Output LUT:',
                      valueText: ref
                              .watch(settingsProvider.select((s) =>
                                  s.value?.luts.firstWhere(
                                      (element) =>
                                          element.id ==
                                          ref
                                              .watch(settingsProvider.select(
                                                  (s) => s
                                                      .value?.transcodingPresets
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          state
                                                              .transcodePresetId)))
                                              ?.lutId,
                                      orElse: () => Lut()..name = "None")))
                              ?.name ??
                          "None"),
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
                    (s) =>
                        s.selectedResources
                            .map((element) => element as NormalVideoResource)
                            .toList(),
                  )),
                )),
            ]));
  }
}

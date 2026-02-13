import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/models/lut.model.dart';
import 'package:xji_footage_toolbox/models/media_resource.model.dart';
import 'package:xji_footage_toolbox/models/settings.model.dart';
import 'package:xji_footage_toolbox/models/video_task.dart';
import 'package:xji_footage_toolbox/providers/media_resources_state.notifier.dart';
import 'package:xji_footage_toolbox/ui/dialogs/settings_dialog.dart';
import 'package:xji_footage_toolbox/ui/panels/video_trimmer_panel.dart';
import '../../providers/settings.notifier.dart';
import '../../utils/tools.dart';
import '../buttons/custom_icon_button.dart';
import '../design_tokens.dart';
import 'dual_option_dialog.dart';

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
class _VideoExportDialogNotifier extends _$VideoExportDialogNotifier {
  late final TextEditingController outputFileNameController;
  late final TextEditingController selectedDirectoryController;

  @override
  _VideoExportDialogState build(Settings settings, String defaultName) {
    outputFileNameController = TextEditingController(text: defaultName);
    selectedDirectoryController = TextEditingController();

    return _VideoExportDialogState(
      useSameDirectory: true,
      selectedDirectory: '',
      outputFileName: defaultName,
      isOutputPathValid: _isOutputPathValid(defaultName, true, ''),
      useInputEncodeSettings: false,
      transcodePresetId: settings.defaultTranscodePresetId,
    );
  }

  void toggleUseSameDirectory() {
    state = state.copyWith(
      useSameDirectory: !state.useSameDirectory,
      isOutputPathValid: _isOutputPathValid(state.outputFileName,
          !state.useSameDirectory, state.selectedDirectory),
    );
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
    state = state.copyWith(
        selectedDirectory: dir,
        isOutputPathValid: _isOutputPathValid(
            state.outputFileName, state.useSameDirectory, dir));
  }

  void setOutputFileName(String name) {
    state = state.copyWith(
        outputFileName: name,
        isOutputPathValid: _isOutputPathValid(
            name, state.useSameDirectory, state.selectedDirectory));
  }

  bool _fileExists(
    String name,
    bool useSameDir,
    String customDir,
  ) {
    final dir = useSameDir
        ? ref.watch(mediaResourcesStateProvider).resourcesPath
        : customDir;
    return isFileExist('$dir/$name.MP4');
  }

  bool _isOutputPathValid(String name, bool useSameDir, String customDir) {
    if (name.isEmpty) {
      return false;
    }
    // 检查是否存在非法字符
    if (name.contains(RegExp(r'[\\/:*?"<>|]'))) {
      return false;
    }
    return !_fileExists(name, useSameDir, customDir);
  }
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
    {required VideoTaskType taskType, required WidgetRef ref}) {
  var duration = const Duration(seconds: 0);
  switch (taskType) {
    case VideoTaskType.merge:
      for (final element in ref.watch(mediaResourcesStateProvider
          .select((state) => state.selectedResources))) {
        final videoResource = element as VideoResource;
        duration += videoResource.duration;
      }
      break;
    case VideoTaskType.trim:
      final cutState = ref.watch(videoCutProvider);
      if (cutState.cutStart != Duration.zero ||
          cutState.cutEnd != Duration.zero) {
        duration = cutState.cutEnd - cutState.cutStart;
      } else {
        duration = (ref.watch(mediaResourcesStateProvider.select(
                    (state) => state.resources[state.currentResourceIndex]))
                as VideoResource)
            .duration;
      }
      break;
    case VideoTaskType.transcode:
      duration = (ref.watch(mediaResourcesStateProvider.select(
                  (state) => state.resources[state.currentResourceIndex]))
              as VideoResource)
          .duration;
      break;
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
  final List<VideoResource> videoResources;

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
  final VideoTaskType taskType;
  final VideoResource videoResource;

  const VideoExportDialog(
      {super.key, required this.taskType, required this.videoResource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_videoExportDialogProvider(
        ref.watch(settingsProvider),
        _getDefaultOutputFileName(videoResource.name)));
    final notifier = ref.read(_videoExportDialogProvider(
            ref.watch(settingsProvider),
            _getDefaultOutputFileName(videoResource.name))
        .notifier);

    return DualOptionDialog(
        width: 480,
        height: 680,
        title: 'Export',
        option1: 'Cancel',
        option2: 'Export',
        disableOption2: !state.isOutputPathValid,
        onOption1Pressed: () {
          Navigator.pop(context);
        },
        onOption2Pressed: () async {
          if (state.isOutputPathValid) {
            final outputFilePath =
                '${state.useSameDirectory ? videoResource.file.parent.path : state.selectedDirectory}'
                '/${state.outputFileName}.MP4';
            final preset = ref.watch(settingsProvider.select((s) => s
                .transcodingPresets
                .firstWhere((e) => e.id == state.transcodePresetId)));
            if (taskType == VideoTaskType.merge) {
              final List<String> ffmpegArgs = [];
              final inputFilesTxtPath =
                  '${videoResource.file.parent.path}/.${state.outputFileName}_'
                  '${_get4DigitRandomString()}.txt';
              final inputFilesTxtFile = File(inputFilesTxtPath);
              if (inputFilesTxtFile.existsSync()) {
                inputFilesTxtFile.deleteSync();
              }
              inputFilesTxtFile.writeAsStringSync(ref
                  .watch(mediaResourcesStateProvider
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
                    "lut3d='${ref.watch(settingsProvider.select((s) => s.luts.firstWhere((element) => element.id == preset.lutId))).path}'");
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
                ffmpegArgs.add(preset.ffmpegPreset.toString().split('.').last);
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
                duration: _getOutputDuration(taskType: taskType, ref: ref),
                progress: 0.0,
                outputPath: outputFilePath,
                tempFilePaths: [inputFilesTxtPath],
                logPath: ref.watch(settingsProvider
                    .select((s) => s.isDebugMode ? '$outputFilePath.log' : '')),
              );
              Navigator.of(context).pop(task);
            } else {
              // Export single file
              final List<String> ffmpegArgs = [];
              ffmpegArgs.add('-i');
              ffmpegArgs.add(videoResource.file.path);
              if (state.useInputEncodeSettings == false && preset.lutId != 0) {
                final lutPath = ref.watch(settingsProvider.select((s) =>
                    s.luts.firstWhere((e) => e.id == preset.lutId).path));

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
                ffmpegArgs.add(preset.ffmpegPreset.toString().split('.').last);
                if (preset.useInputResolution == false) {
                  ffmpegArgs.add('-vf');
                  ffmpegArgs.add('scale=${preset.width}:${preset.height}');
                }
              } else {
                ffmpegArgs.add('copy');
              }

              if (taskType == VideoTaskType.trim) {
                final videoCutState = ref.watch(videoCutProvider);
                if (videoCutState.cutStart != Duration.zero || videoCutState.cutEnd != Duration.zero) {
                  ffmpegArgs.add('-ss');
                  ffmpegArgs.add(videoCutState.cutStart.toString());
                  ffmpegArgs.add('-to');
                  ffmpegArgs.add(videoCutState.cutEnd.toString());
                }
              }
              ffmpegArgs.add('-map_metadata');
              ffmpegArgs.add('0');
              ffmpegArgs.add(outputFilePath);
              final task = VideoTask(
                name: '${state.outputFileName}.MP4',
                status: VideoTaskStatus.waiting,
                // type: VideoTaskType.trim,
                type: taskType == VideoTaskType.trim ? VideoTaskType.trim : VideoTaskType.transcode,
                ffmpegArgs: ffmpegArgs,
                duration: _getOutputDuration(taskType: taskType, ref: ref),
                progress: 0.0,
                outputPath: outputFilePath,
                logPath: ref.watch(settingsProvider
                    .select((s) => s.isDebugMode ? '$outputFilePath.log' : '')),
              );
              Navigator.of(context).pop(task);
            }
          }
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DialogCheckBoxWithText(
                  text: 'Use the same directory as source',
                  value: state.useSameDirectory,
                  onPressed: () {
                    // useSameDirectory.value = !useSameDirectory.value;
                    notifier.toggleUseSameDirectory();
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
                          notifier.setSelectedDirectory(result);
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
                        controller: notifier.selectedDirectoryController,
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
                      controller: notifier.outputFileNameController,
                      onChanged: (value) {
                        notifier.setOutputFileName(value);
                      },
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text0),
                      decoration: dialogInputDecoration.copyWith(
                          suffix: Text(
                            '.MP4',
                            style: SemiTextStyles.header5ENRegular
                                .copyWith(color: ColorDark.text1),
                          ),
                          errorText: state.isOutputPathValid
                              ? null
                              : 'File name not valid',
                          errorMaxLines: 3),
                    )),
              ),
              SizedBox(
                height: DesignValues.ultraSmallPadding,
              ),
              DialogCheckBoxWithText(
                  text: 'Use the same encodings as source',
                  value: state.useInputEncodeSettings,
                  onPressed: () {
                    notifier.toggleUseInputEncodeSettings();
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
                                      .transcodingPresets
                                      .map((e) => DropdownMenuItem<int>(
                                          value: e.id, child: Text(e.name)))
                                      .toList()))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  notifier.setPreset(value);
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
                  valueText: _getOutputDuration(taskType: taskType, ref: ref)
                      .toString()),
              _OutputInfoItem(
                  keyText: 'Output resolution:',
                  valueText: state.useInputEncodeSettings
                      ? '${videoResource.width}x${videoResource.height}'
                      : (ref
                              .watch(settingsProvider.select((s) =>
                                  s.transcodingPresets.firstWhere((element) =>
                                      element.id == state.transcodePresetId)))
                              .useInputResolution)
                          ? '${videoResource.width}x${videoResource.height}'
                          : '${ref.watch(settingsProvider.select((s) => s.transcodingPresets.firstWhere((element) => element.id == state.transcodePresetId))).width}x${ref.watch(settingsProvider.select((s) => s.transcodingPresets.firstWhere((element) => element.id == state.transcodePresetId))).height}'),
              _OutputInfoItem(
                keyText: 'Output codec:',
                valueText: state.useInputEncodeSettings
                    ? videoResource.isHevc
                        ? 'H.265'
                        : 'H.264'
                    : ref
                            .watch(settingsProvider.select((s) =>
                                s.transcodingPresets.firstWhere((element) =>
                                    element.id == state.transcodePresetId)))
                            .useHevc
                        ? 'H.265'
                        : 'H.264',
              ),
              state.useInputEncodeSettings
                  ? const SizedBox()
                  : _OutputInfoItem(
                      keyText: 'Output CRF:',
                      valueText: (ref
                              .watch(settingsProvider.select((s) =>
                                  s.transcodingPresets.firstWhere((element) =>
                                      element.id == state.transcodePresetId)))
                              .crf)
                          .toString(),
                    ),
              state.useInputEncodeSettings
                  ? const SizedBox()
                  : _OutputInfoItem(
                      keyText: 'Output FFMPEG preset:',
                      valueText: ref.watch(settingsProvider.select((s) => s
                          .transcodingPresets
                          .firstWhere((e) => e.id == state.transcodePresetId)
                          .ffmpegPreset
                          .toString()
                          .split('.')
                          .last))),
              // Output LUT:
              state.useInputEncodeSettings
                  ? const SizedBox()
                  : _OutputInfoItem(
                      keyText: 'Output LUT:',
                      valueText: ref.watch(settingsProvider.select((s) => s.luts
                          .firstWhere(
                              (e) =>
                                  e.id ==
                                  (s.transcodingPresets
                                      .firstWhere((f) =>
                                          f.id == state.transcodePresetId)
                                      .lutId),
                              orElse: () => Lut(name: "None"))
                          .name
                          .toString())),
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
              if (taskType == VideoTaskType.merge)
                Expanded(
                    child: _MergeFileListView(
                  videoResources: ref.watch(mediaResourcesStateProvider.select(
                    (s) => s.selectedResources
                        .map((element) => element as VideoResource)
                        .toList(),
                  )),
                )),
            ]));
  }
}

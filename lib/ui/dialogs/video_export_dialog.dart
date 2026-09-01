import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:xji_footage_toolbox/models/lut.model.dart';
import 'package:xji_footage_toolbox/models/media_resource.model.dart';
import 'package:xji_footage_toolbox/models/settings.model.dart';
import 'package:xji_footage_toolbox/models/video_task.dart';
import 'package:xji_footage_toolbox/providers/media_resources_state.notifier.dart';
import 'package:xji_footage_toolbox/services/video_export_builder.dart';
import 'package:xji_footage_toolbox/ui/dialogs/settings_dialog.dart';
import 'package:xji_footage_toolbox/ui/panels/video_trimmer_panel.dart';
import 'package:xji_footage_toolbox/utils/logger.dart';
import 'package:xji_footage_toolbox/utils/toast.dart';
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
      isOutputPathValid: _isOutputPathValid(
        state.outputFileName,
        !state.useSameDirectory,
        state.selectedDirectory,
      ),
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
        state.outputFileName,
        state.useSameDirectory,
        dir,
      ),
    );
  }

  void setOutputFileName(String name) {
    state = state.copyWith(
      outputFileName: name,
      isOutputPathValid: _isOutputPathValid(
        name,
        state.useSameDirectory,
        state.selectedDirectory,
      ),
    );
  }

  bool _isOutputPathValid(String name, bool useSameDir, String customDir) {
    final dir = useSameDir
        ? ref.watch(mediaResourcesStateProvider).resourcesPath
        : customDir;
    return isValidVideoOutputName(
      name,
      directory: dir,
      fileExists: isFileExist,
    );
  }
}

String _getDefaultOutputFileName(String originalFileName) {
  return defaultVideoOutputFileName(originalFileName);
}

// String _get4DigitRandomString() {
//   final random = Random();
//   return random.nextInt(10000).toString().padLeft(4, '0');
// }

Duration _getOutputDuration({
  required VideoTaskType taskType,
  required WidgetRef ref,
  required VideoResource videoResource,
}) {
  final mediaState = ref.watch(mediaResourcesStateProvider);
  final cutState = ref.watch(videoCutProvider);
  return videoOutputDuration(
    taskType: taskType,
    videoResource: videoResource,
    selectedResources: mediaState.selectedResources
        .whereType<VideoResource>()
        .toList(growable: false),
    cutStart: cutState.cutStart,
    cutEnd: cutState.cutEnd,
  );
}

Future<bool> _writeVideoExportPlan(VideoExportPlan plan) async {
  final artifactPaths = [
    if (plan.concatFilePath != null) plan.concatFilePath!,
    if (plan.commandFilePath != null) plan.commandFilePath!,
  ];
  for (final path in artifactPaths) {
    if (File(path).existsSync()) {
      final message = 'Export helper file $path already exists.';
      Logger.error(message);
      Toast.error(message);
      return false;
    }
  }

  try {
    await ensureVideoExportLut(plan);
    if (plan.concatFilePath != null) {
      await File(plan.concatFilePath!).writeAsString(plan.concatFileContents!);
    }
    if (plan.commandFilePath != null) {
      await File(
        plan.commandFilePath!,
      ).writeAsString(plan.commandFileContents!);
    }
    return true;
  } on FileSystemException catch (error) {
    Logger.error('Failed to write export helper file: $error');
    Toast.error('Failed to write export helper file.');
    return false;
  }
}

class _OutputInfoItem extends StatelessWidget {
  final String keyText;
  final String valueText;

  const _OutputInfoItem({required this.keyText, required this.valueText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          keyText,
          style: SemiTextStyles.header6ENRegular.copyWith(
            color: ColorDark.text1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        Text(
          valueText,
          style: SemiTextStyles.header6ENRegular.copyWith(
            color: ColorDark.text0,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MergeFileListView extends StatelessWidget {
  final List<VideoResource> videoResources;

  const _MergeFileListView({required this.videoResources});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Merge files:',
          style: SemiTextStyles.header6ENRegular.copyWith(
            color: ColorDark.text1,
          ),
        ),
        SizedBox(height: DesignValues.smallPadding),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Text(
                videoResources[index].name,
                style: SemiTextStyles.header6ENRegular.copyWith(
                  color: ColorDark.text0,
                ),
              );
            },
            itemCount: videoResources.length,
          ),
        ),
      ],
    );
  }
}

class VideoExportDialog extends ConsumerWidget {
  final VideoTaskType taskType;
  final VideoResource videoResource;

  const VideoExportDialog({
    super.key,
    required this.taskType,
    required this.videoResource,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      _videoExportDialogProvider(
        ref.watch(settingsProvider),
        _getDefaultOutputFileName(videoResource.name),
      ),
    );
    final notifier = ref.read(
      _videoExportDialogProvider(
        ref.watch(settingsProvider),
        _getDefaultOutputFileName(videoResource.name),
      ).notifier,
    );

    final exportCmdOnly = ref.watch(settingsProvider).exportCmdOnly;

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
        if (!state.isOutputPathValid) return;

        final settings = ref.read(settingsProvider);
        final preset = settings.transcodingPresets.firstWhere(
          (item) => item.id == state.transcodePresetId,
        );
        Lut? lut;
        if (preset.lutId != 0) {
          for (final item in settings.luts) {
            if (item.id == preset.lutId) {
              lut = item;
              break;
            }
          }
        }
        final mediaState = ref.read(mediaResourcesStateProvider);
        final cutState = ref.read(videoCutProvider);
        final plan = buildVideoExportPlan(
          VideoExportRequest(
            taskId: const Uuid().v4(),
            taskType: taskType,
            videoResource: videoResource,
            selectedResources: mediaState.selectedResources
                .whereType<VideoResource>()
                .toList(),
            preset: preset,
            lut: lut,
            cutStart: cutState.cutStart,
            cutEnd: cutState.cutEnd,
            outputFileName: state.outputFileName,
            selectedDirectory: state.selectedDirectory,
            useSameDirectory: state.useSameDirectory,
            useInputEncodeSettings: state.useInputEncodeSettings,
            exportCommandOnly: exportCmdOnly,
            debugLogging: settings.isDebugMode,
          ),
        );
        if (!await _writeVideoExportPlan(plan)) return;
        if (!context.mounted) return;
        Navigator.of(context).pop(plan.task);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          exportCmdOnly
              ? const SizedBox()
              : DialogCheckBoxWithText(
                  text: 'Use the same directory as source',
                  value: state.useSameDirectory,
                  onPressed: () {
                    // useSameDirectory.value = !useSameDirectory.value;
                    notifier.toggleUseSameDirectory();
                  },
                ),
          SizedBox(height: DesignValues.smallPadding),
          state.useSameDirectory
              ? const SizedBox()
              : CustomDialogIconButtonWithText(
                  iconData: Icons.folder_open,
                  text: 'Select a output directory',
                  onPressed: () async {
                    final result = await FilePicker.getDirectoryPath();
                    if (result != null) {
                      notifier.setSelectedDirectory(result);
                    }
                  },
                ),
          SizedBox(height: DesignValues.smallPadding),
          state.useSameDirectory
              ? const SizedBox()
              : Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: ColorDark.blue5.withAlpha(
                        (0.8 * 255).round(),
                      ),
                    ),
                  ),
                  child: TextField(
                    readOnly: true,
                    cursorColor: ColorDark.text1,
                    controller: notifier.selectedDirectoryController,
                    style: SemiTextStyles.header6ENRegular.copyWith(
                      color: ColorDark.text0,
                    ),
                    decoration: dialogInputDecoration,
                  ),
                ),
          SizedBox(height: DesignValues.ultraSmallPadding),
          Text(
            'Output file name',
            style: SemiTextStyles.header5ENRegular.copyWith(
              color: ColorDark.text1,
            ),
          ),
          SizedBox(
            height: 72,
            child: Theme(
              data: Theme.of(context).copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  selectionColor: ColorDark.blue5.withAlpha(
                    (0.8 * 255).round(),
                  ),
                ),
              ),
              child: TextField(
                cursorColor: ColorDark.text1,
                // controller: outputFileNameTextEditingController,
                controller: notifier.outputFileNameController,
                onChanged: (value) {
                  notifier.setOutputFileName(value);
                },
                style: SemiTextStyles.header5ENRegular.copyWith(
                  color: ColorDark.text0,
                ),
                decoration: dialogInputDecoration.copyWith(
                  suffix: Text(
                    '.MP4',
                    style: SemiTextStyles.header5ENRegular.copyWith(
                      color: ColorDark.text1,
                    ),
                  ),
                  errorText: state.isOutputPathValid
                      ? null
                      : 'File name not valid',
                  errorMaxLines: 3,
                ),
              ),
            ),
          ),
          SizedBox(height: DesignValues.ultraSmallPadding),
          DialogCheckBoxWithText(
            text: 'Use the same encodings as source',
            value: state.useInputEncodeSettings,
            onPressed: () {
              notifier.toggleUseInputEncodeSettings();
            },
          ),
          SizedBox(height: DesignValues.mediumPadding),
          state.useInputEncodeSettings
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transcode Preset:',
                      style: SemiTextStyles.header5ENRegular.copyWith(
                        color: ColorDark.text1,
                      ),
                    ),
                    Row(
                      children: [
                        DropdownButton<int>(
                          isExpanded: false,
                          // value: transcodePresetIndex.value,
                          value: state.transcodePresetId,
                          focusColor: ColorDark.defaultActive,
                          dropdownColor: ColorDark.bg2,
                          style: SemiTextStyles.header5ENRegular.copyWith(
                            color: ColorDark.text0,
                          ),
                          items: ref
                              .watch(
                                settingsProvider.select(
                                  (s) => s.transcodingPresets
                                      .map(
                                        (e) => DropdownMenuItem<int>(
                                          value: e.id,
                                          child: Text(e.name),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              notifier.setPreset(value);
                            }
                          },
                        ),
                        Spacer(),
                        SizedBox(width: DesignValues.largePadding),
                        CustomIconButton(
                          iconData: Icons.settings,
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SettingsDialog();
                              },
                            );
                          },
                          iconSize: DesignValues.mediumIconSize,
                          buttonSize: 24,
                          hoverColor: ColorDark.defaultHover,
                          focusColor: ColorDark.defaultActive,
                          iconColor: ColorDark.text1,
                        ),
                      ],
                    ),
                  ],
                ),
          SizedBox(height: DesignValues.smallPadding),
          const Divider(color: ColorDark.border, thickness: 1, height: 1),
          SizedBox(height: DesignValues.smallPadding),
          _OutputInfoItem(
            keyText: 'Output duration:',
            valueText: _getOutputDuration(
              taskType: taskType,
              ref: ref,
              videoResource: videoResource,
            ).toString(),
          ),
          _OutputInfoItem(
            keyText: 'Output resolution:',
            valueText: state.useInputEncodeSettings
                ? '${videoResource.width}x${videoResource.height}'
                : (ref
                      .watch(
                        settingsProvider.select(
                          (s) => s.transcodingPresets.firstWhere(
                            (element) => element.id == state.transcodePresetId,
                          ),
                        ),
                      )
                      .useInputResolution)
                ? '${videoResource.width}x${videoResource.height}'
                : '${ref.watch(settingsProvider.select((s) => s.transcodingPresets.firstWhere((element) => element.id == state.transcodePresetId))).width}x${ref.watch(settingsProvider.select((s) => s.transcodingPresets.firstWhere((element) => element.id == state.transcodePresetId))).height}',
          ),
          _OutputInfoItem(
            keyText: 'Output codec:',
            valueText: state.useInputEncodeSettings
                ? videoResource.isHevc
                      ? 'H.265'
                      : 'H.264'
                : ref
                      .watch(
                        settingsProvider.select(
                          (s) => s.transcodingPresets.firstWhere(
                            (element) => element.id == state.transcodePresetId,
                          ),
                        ),
                      )
                      .useHevc
                ? 'H.265'
                : 'H.264',
          ),
          state.useInputEncodeSettings
              ? const SizedBox()
              : _OutputInfoItem(
                  keyText: 'Output CRF:',
                  valueText:
                      (ref
                              .watch(
                                settingsProvider.select(
                                  (s) => s.transcodingPresets.firstWhere(
                                    (element) =>
                                        element.id == state.transcodePresetId,
                                  ),
                                ),
                              )
                              .crf)
                          .toString(),
                ),
          state.useInputEncodeSettings
              ? const SizedBox()
              : _OutputInfoItem(
                  keyText: 'Output FFMPEG preset:',
                  valueText: ref.watch(
                    settingsProvider.select(
                      (s) => s.transcodingPresets
                          .firstWhere((e) => e.id == state.transcodePresetId)
                          .ffmpegPreset
                          .toString()
                          .split('.')
                          .last,
                    ),
                  ),
                ),
          // Output LUT:
          state.useInputEncodeSettings
              ? const SizedBox()
              : _OutputInfoItem(
                  keyText: 'Output LUT:',
                  valueText: ref.watch(
                    settingsProvider.select(
                      (s) => s.luts
                          .firstWhere(
                            (e) =>
                                e.id ==
                                (s.transcodingPresets
                                    .firstWhere(
                                      (f) => f.id == state.transcodePresetId,
                                    )
                                    .lutId),
                            orElse: () => Lut(name: "None"),
                          )
                          .name
                          .toString(),
                    ),
                  ),
                ),
          SizedBox(height: DesignValues.smallPadding),
          const Divider(color: ColorDark.border, thickness: 1, height: 1),
          SizedBox(height: DesignValues.smallPadding),
          if (taskType == VideoTaskType.merge)
            Expanded(
              child: _MergeFileListView(
                videoResources: ref.watch(
                  mediaResourcesStateProvider.select(
                    (s) => s.selectedResources
                        .map((element) => element as VideoResource)
                        .toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

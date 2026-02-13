import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/providers/settings.notifier.dart';

import '../../../models/lut.model.dart';
import '../../../models/transcode_preset.model.dart';
import '../buttons/custom_icon_button.dart';
import '../design_tokens.dart';
import 'dual_option_dialog.dart';

part 'settings_dialog.g.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController transcodePresetScrollController = ScrollController();
    final ScrollController lutScrollController = ScrollController();
    return DualOptionDialog(
        width: 480,
        height: 680,
        title: 'Settings',
        option1: '',
        option2: 'Close',
        onOption1Pressed: () {},
        onOption2Pressed: () {
          Navigator.of(context).pop();
        },
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Transcode Presets',
                  style: SemiTextStyles.header4ENRegular
                      .copyWith(color: ColorDark.text0),
                ),
                SizedBox(
                  width: DesignValues.smallPadding,
                ),
                Consumer(builder: (context, ref, child) {
                  return CustomIconButton(
                      iconData: Icons.add_circle_outline,
                      onPressed: () async {
                        final result = await showDialog(
                            context: context,
                            builder: (context) {
                              return _EditTranscodePresetDialog(
                                  preset: TranscodePreset());
                            });
                        if (result != null) {
                          ref
                              .read(settingsProvider.notifier)
                              .addTranscodePreset(result);
                        }
                      },
                      iconSize: DesignValues.mediumIconSize,
                      buttonSize: 28,
                      hoverColor: ColorDark.defaultHover,
                      focusColor: ColorDark.defaultActive,
                      iconColor: ColorDark.text0);
                }),
              ],
            ),
            SizedBox(
              height: DesignValues.ultraSmallPadding,
            ),
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(DesignValues.smallBorderRadius),
              child: Container(
                color: ColorDark.bg3,
                height: 120,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: DesignValues.ultraSmallPadding,
                      bottom: DesignValues.ultraSmallPadding,
                      left: DesignValues.ultraSmallPadding),
                  child: RawScrollbar(
                    thickness: DesignValues.smallPadding,
                    trackVisibility: false,
                    thumbVisibility: true,
                    radius: Radius.circular(DesignValues.smallBorderRadius),
                    controller: transcodePresetScrollController,
                    child: Consumer(builder: (context, ref, child) {
                      final transcodingPresets = ref.watch(settingsProvider
                          .select((settings) => settings.transcodingPresets));
                      return ListView.builder(
                          controller: transcodePresetScrollController,
                          itemCount: transcodingPresets.length,
                          itemBuilder: (context, index) {
                            return _PresetItem(
                                preset: transcodingPresets[index]);
                          });
                    }),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: DesignValues.largePadding,
            ),
            Row(
              children: [
                Text(
                  'Luts',
                  style: SemiTextStyles.header4ENRegular
                      .copyWith(color: ColorDark.text0),
                ),
                SizedBox(
                  width: DesignValues.smallPadding,
                ),
                Consumer(builder: (context, ref, child) {
                  return CustomIconButton(
                      iconData: Icons.add_circle_outline,
                      onPressed: () async {
                        final result = await showDialog(
                            context: context,
                            builder: (context) {
                              return _EditLutDialog(lut: Lut());
                            });
                        if (result != null) {
                          ref.read(settingsProvider.notifier).addLut(result);
                        }
                      },
                      iconSize: DesignValues.mediumIconSize,
                      buttonSize: 28,
                      hoverColor: ColorDark.defaultHover,
                      focusColor: ColorDark.defaultActive,
                      iconColor: ColorDark.text0);
                }),
              ],
            ),
            SizedBox(
              height: DesignValues.ultraSmallPadding,
            ),
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(DesignValues.smallBorderRadius),
              child: Container(
                color: ColorDark.bg3,
                height: 120,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: DesignValues.ultraSmallPadding,
                      bottom: DesignValues.ultraSmallPadding,
                      left: DesignValues.ultraSmallPadding),
                  child: RawScrollbar(
                    thickness: DesignValues.smallPadding,
                    trackVisibility: false,
                    thumbVisibility: true,
                    radius: Radius.circular(DesignValues.smallBorderRadius),
                    controller: lutScrollController,
                    child: Consumer(builder: (context, ref, child) {
                      final luts = ref.watch(settingsProvider).luts;
                      return ListView.builder(
                          controller: lutScrollController,
                          itemCount: luts.length,
                          itemBuilder: (context, index) {
                            return _LutItem(lut: luts[index]);
                          });
                    }),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: DesignValues.largePadding,
            ),
            Row(
              children: [
                Text('Debug Mode:',
                    style: SemiTextStyles.header4ENRegular
                        .copyWith(color: ColorDark.text1)),
                const Spacer(),
                Consumer(builder: (context, ref, child) {
                  return Switch(
                    value: ref.watch(settingsProvider).isDebugMode,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).setIsDebugMode(value);
                    },
                    activeTrackColor: ColorDark.blue5,
                    activeThumbColor: ColorDark.white,
                  );
                })
              ],
            ),
            SizedBox(
              height: DesignValues.ultraSmallPadding,
            ),
            Row(
              children: [
                Text('Export Command Only:',
                    style: SemiTextStyles.header4ENRegular
                        .copyWith(color: ColorDark.text1)),
                const Spacer(),
                Consumer(builder: (context, ref, child) {
                  return Switch(
                    value: ref.watch(settingsProvider).exportCmdOnly,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).setExportCmdOnly(value);
                    },
                    activeTrackColor: ColorDark.blue5,
                    activeThumbColor: ColorDark.white,
                  );
                })
              ],
            ),
            SizedBox(
              height: DesignValues.smallPadding,
            ),
            Row(
              children: [
                Text('Version:',
                    style: SemiTextStyles.header4ENRegular
                        .copyWith(color: ColorDark.text1)),
                const Spacer(),
                Consumer(builder: (context, ref, child) {
                  return Text(ref.watch(settingsProvider).appVersion,
                      style: SemiTextStyles.header4ENRegular
                          .copyWith(color: ColorDark.text0));
                }),
              ],
            ),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            Row(
              children: [
                Text('Author:',
                    style: SemiTextStyles.header4ENRegular
                        .copyWith(color: ColorDark.text1)),
                const Spacer(),
                Text('lz00qs',
                    style: SemiTextStyles.header4ENRegular
                        .copyWith(color: ColorDark.text0)),
              ],
            ),
          ],
        ));
  }
}

class _PresetItem extends ConsumerWidget {
  final TranscodePreset preset;

  const _PresetItem({required this.preset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDefaultPreset = ref.watch(settingsProvider
        .select((s) => s.defaultTranscodePresetId == preset.id));
    return SizedBox(
      height: 37,
      child: Row(
        children: [
          Expanded(
              child: Column(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _ItemButton(
                      iconData: isDefaultPreset
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                      onPressed: () {
                        ref
                            .read(settingsProvider.notifier)
                            .setDefaultTranscodePreset(preset.id);
                      }),
                  Expanded(
                      child: Text(preset.name,
                          style: SemiTextStyles.header5ENRegular.copyWith(
                              color: ColorDark.text0,
                              overflow: TextOverflow.ellipsis))),
                  _ItemButton(
                      iconData: Icons.edit,
                      onPressed: () async {
                        final result = await showDialog(
                            context: context,
                            builder: (context) {
                              return _EditTranscodePresetDialog(preset: preset);
                            });
                        if (result != null) {
                          ref
                              .read(settingsProvider.notifier)
                              .updateTranscodePreset(result);
                        }
                      }),
                  SizedBox(
                    width: DesignValues.mediumPadding,
                  ),
                  _ItemButton(
                      iconData: Icons.delete,
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DualOptionDialog(
                                  width: 400,
                                  height: 240,
                                  title: 'Delete',
                                  option1: 'Delete',
                                  option2: 'Cancel',
                                  onOption1Pressed: () {
                                    ref
                                        .read(settingsProvider.notifier)
                                        .removeTranscodePreset(preset.id);
                                    Navigator.of(context).pop();
                                  },
                                  onOption2Pressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                      'Are you sure you want to delete this preset?',
                                      style: SemiTextStyles.header5ENRegular
                                          .copyWith(color: ColorDark.text0)));
                            });
                      }),
                ],
              )),
              const Divider(
                color: ColorDark.border,
                thickness: 1,
                height: 1,
              ),
            ],
          )),
          SizedBox(
            width: DesignValues.smallPadding,
          ),
        ],
      ),
    );
  }
}

class _LutItem extends StatelessWidget {
  final Lut lut;

  const _LutItem({required this.lut});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37,
      child: Row(
        children: [
          Expanded(
              child: Column(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: DesignValues.smallPadding,
                  ),
                  Expanded(
                      child: Text(lut.name,
                          style: SemiTextStyles.header5ENRegular.copyWith(
                              color: ColorDark.text0,
                              overflow: TextOverflow.ellipsis))),
                  Consumer(builder: (context, ref, child) {
                    return _ItemButton(
                        iconData: Icons.edit,
                        onPressed: () async {
                          final result = await showDialog(
                              context: context,
                              builder: (context) {
                                return _EditLutDialog(lut: lut);
                              });
                          if (result != null) {
                            ref
                                .read(settingsProvider.notifier)
                                .updateLut(result);
                          }
                        });
                  }),
                  SizedBox(
                    width: DesignValues.mediumPadding,
                  ),
                  _ItemButton(
                      iconData: Icons.delete,
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Consumer(builder: (context, ref, child) {
                                return DualOptionDialog(
                                    width: 400,
                                    height: 240,
                                    title: 'Delete',
                                    option1: 'Delete',
                                    option2: 'Cancel',
                                    onOption1Pressed: () {
                                      ref
                                          .read(settingsProvider.notifier)
                                          .removeLut(lut.id);
                                      Navigator.of(context).pop();
                                    },
                                    onOption2Pressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                        'Are you sure you want to delete this lut?',
                                        style: SemiTextStyles.header5ENRegular
                                            .copyWith(color: ColorDark.text0)));
                              });
                            });
                      }),
                ],
              )),
              const Divider(
                color: ColorDark.border,
                thickness: 1,
                height: 1,
              ),
            ],
          )),
          SizedBox(
            width: DesignValues.smallPadding,
          ),
        ],
      ),
    );
  }
}

class _ItemButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const _ItemButton({required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
        iconData: iconData,
        onPressed: onPressed,
        iconSize: DesignValues.mediumIconSize,
        buttonSize: 36,
        hoverColor: ColorDark.defaultHover,
        focusColor: ColorDark.defaultActive,
        iconColor: ColorDark.text0);
  }
}

@riverpod
class _EditLutDialogNotifier extends _$EditLutDialogNotifier {
  final ScrollController pathScrollController = ScrollController();
  late final TextEditingController nameController;

  @override
  Lut build(Lut lut) {
    nameController = TextEditingController(text: lut.name);
    nameController.addListener(() {
      final v = nameController.text;
      state = state.copyWith(name: v);
    });
    return Lut(id: lut.id, name: lut.name, path: lut.path);
  }

  Future<void> pickLutFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['cube'],
    );
    if (result == null) return;

    final path = result.files.single.path!;
    var name = path.split('/').last;
    name = name.substring(0, name.length - 5);
    if (name.length > 24) {
      name = name.substring(0, 24);
    }

    if (state.name.isEmpty) {
      state = state.copyWith(
        name: name,
        path: path,
      );
    } else {
      state = state.copyWith(
        path: path,
      );
    }
  }

  bool get isNameValid => state.name.isNotEmpty;

  bool get isPathValid => state.path.isNotEmpty;
}

class _EditLutDialog extends ConsumerWidget {
  final Lut lut;

  const _EditLutDialog({required this.lut});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(_editLutDialogProvider(lut));
    final notifier = ref.read(_editLutDialogProvider(lut).notifier);
    final isAdd = lut.id == 0;
    return DualOptionDialog(
      width: 480,
      height: 320,
      title: isAdd ? 'Add Lut' : 'Edit Lut',
      option1: 'Cancel',
      option2: isAdd ? 'Add' : 'Save',
      disableOption2: !notifier.isNameValid || !notifier.isPathValid,
      onOption1Pressed: () {
        Navigator.of(context).pop();
      },
      onOption2Pressed: () {
        Navigator.of(context).pop(item);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lut name',
            style: SemiTextStyles.header5ENRegular
                .copyWith(color: ColorDark.text1),
          ),
          SizedBox(
            height: 72,
            child: Theme(
              data: Theme.of(context).copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  selectionColor:
                      ColorDark.blue5.withAlpha((0.8 * 255).round()),
                ),
              ),
              child: TextField(
                maxLength: 24,
                controller: notifier.nameController,
                cursorColor: ColorDark.text1,
                style: SemiTextStyles.header5ENRegular
                    .copyWith(color: ColorDark.text0),
                decoration: dialogInputDecoration.copyWith(
                  errorText: notifier.isNameValid ? null : 'Name is required',
                ),
              ),
            ),
          ),
          if (isAdd) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select lut file',
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text1),
                ),
                _ItemButton(
                  iconData: Icons.folder_open,
                  onPressed: notifier.pickLutFile,
                ),
              ],
            ),
            Scrollbar(
              controller: notifier.pathScrollController,
              child: SingleChildScrollView(
                controller: notifier.pathScrollController,
                scrollDirection: Axis.horizontal,
                child: Text(
                  item.path.split('/').last,
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text0),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

@riverpod
class _EditTranscodePresetDialogNotifier
    extends _$EditTranscodePresetDialogNotifier {
  late final TextEditingController nameController;
  late final TextEditingController widthController;
  late final TextEditingController heightController;
  late final TextEditingController crfController;

  @override
  TranscodePreset build(TranscodePreset preset) {
    nameController = TextEditingController(text: preset.name);
    nameController.addListener(() {
      final v = nameController.text;
      state = state.copyWith(name: v);
    });
    widthController = TextEditingController(text: preset.width.toString());
    widthController.addListener(() {
      final v = int.tryParse(widthController.text) ?? 0;
      if (!state.useInputResolution) {
        state = state.copyWith(width: v);
      }
    });
    heightController = TextEditingController(text: preset.height.toString());
    heightController.addListener(() {
      final v = int.tryParse(heightController.text) ?? 0;
      if (!state.useInputResolution) {
        state = state.copyWith(height: v);
      }
    });
    crfController = TextEditingController(text: preset.crf.toString());
    crfController.addListener(() {
      final v = int.tryParse(crfController.text) ?? 0;
      state = state.copyWith(crf: v);
    });
    return TranscodePreset(
      id: preset.id,
      name: preset.name,
      useInputResolution: preset.useInputResolution,
      useHevc: preset.useHevc,
      width: preset.width,
      height: preset.height,
      crf: preset.crf,
      ffmpegPreset: preset.ffmpegPreset,
      lutId: preset.lutId,
    );
  }

  bool get isNameValid => state.name.isNotEmpty;

  bool get isWidthValid => state.width > 0;

  bool get isHeightValid => state.height > 0;

  bool get isCrfValid => state.crf > 0 && state.crf < 52;

  void toggleUseInputResolution() {
    state = state.copyWith(useInputResolution: !state.useInputResolution);
  }

  void toggleUseHevc() {
    state = state.copyWith(useHevc: !state.useHevc);
  }

  void setFfmpegPreset(FFmpegPreset preset) {
    state = state.copyWith(ffmpegPreset: preset);
  }

  void setLut(int lutId) {
    state = state.copyWith(lutId: lutId);
  }
}

class _EditTranscodePresetDialog extends ConsumerWidget {
  final TranscodePreset preset;
  final noneLut = Lut(id: 0, name: 'None');

  _EditTranscodePresetDialog({required this.preset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(_editTranscodePresetDialogProvider(preset));
    final notifier =
        ref.read(_editTranscodePresetDialogProvider(preset).notifier);
    final isAdd = item.id == 0;
    return DualOptionDialog(
        width: 480,
        height: 680,
        title: isAdd ? 'Add Preset' : 'Edit Preset',
        option1: 'Cancel',
        option2: isAdd ? 'Add' : 'Save',
        disableOption2: !notifier.isNameValid ||
            !notifier.isWidthValid ||
            !notifier.isHeightValid ||
            !notifier.isCrfValid,
        onOption1Pressed: () {
          Navigator.of(context).pop();
        },
        onOption2Pressed: () {
          Navigator.of(context).pop(item);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preset name',
              style: SemiTextStyles.header5ENRegular
                  .copyWith(color: ColorDark.text1),
            ),
            SizedBox(
              height: 72,
              child: Theme(
                  data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                          selectionColor:
                              ColorDark.blue5.withAlpha((0.8 * 255).round()))),
                  child: TextField(
                    maxLength: 24,
                    cursorColor: ColorDark.text1,
                    controller: notifier.nameController,
                    style: SemiTextStyles.header5ENRegular
                        .copyWith(color: ColorDark.text0),
                    decoration: dialogInputDecoration.copyWith(
                        errorText:
                            notifier.isNameValid ? null : 'Name is required'),
                  )),
            ),
            SizedBox(
              height: DesignValues.smallPadding,
            ),
            DialogCheckBoxWithText(
                text: 'Use Input Resolution',
                value: item.useInputResolution,
                onPressed: () {
                  notifier.toggleUseInputResolution();
                }),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            Builder(builder: (BuildContext context) {
              if (item.useInputResolution) {
                return const SizedBox();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Width',
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
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: notifier.widthController,
                          style: SemiTextStyles.header5ENRegular
                              .copyWith(color: ColorDark.text0),
                          decoration: dialogInputDecoration.copyWith(
                              errorText: notifier.isWidthValid
                                  ? null
                                  : 'Width cannot be 0'),
                        ),
                      ),
                    ),
                    Text(
                      'Height',
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
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: notifier.heightController,
                          style: SemiTextStyles.header5ENRegular
                              .copyWith(color: ColorDark.text0),
                          decoration: dialogInputDecoration.copyWith(
                              errorText: notifier.isHeightValid
                                  ? null
                                  : 'Height cannot be 0'),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CRF',
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
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: notifier.crfController,
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text0),
                      decoration: dialogInputDecoration.copyWith(
                          errorText: notifier.isCrfValid
                              ? null
                              : 'CRF must be between 0 and 51, higher is lower quality.'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: DesignValues.smallPadding,
            ),
            DialogCheckBoxWithText(
                text: 'Use H.265',
                value: item.useHevc,
                onPressed: () {
                  notifier.toggleUseHevc();
                }),
            SizedBox(
              height: DesignValues.smallPadding,
            ),
            Row(
              children: [
                Text(
                  "FFmpeg Preset:",
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text1),
                ),
                const Spacer(),
                DropdownButton<FFmpegPreset>(
                  value: item.ffmpegPreset,
                  focusColor: ColorDark.defaultActive,
                  dropdownColor: ColorDark.bg2,
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text0),
                  items: FFmpegPreset.values
                      .map((e) => DropdownMenuItem<FFmpegPreset>(
                            value: e,
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      notifier.setFfmpegPreset(value);
                    }
                  },
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "LUT:",
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text1),
                ),
                SizedBox(
                  width: DesignValues.largePadding,
                ),
                Expanded(
                    child: DropdownButton<Lut>(
                  value: ref.watch(settingsProvider.select((s) => s.luts
                      .firstWhere((element) => element.id == item.lutId,
                          orElse: () => noneLut))),
                  itemHeight: null,
                  isExpanded: true,
                  focusColor: ColorDark.defaultActive,
                  dropdownColor: ColorDark.bg2,
                  style: SemiTextStyles.header5ENRegular
                      .copyWith(color: ColorDark.text0),
                  items: [
                    DropdownMenuItem<Lut>(
                      value: noneLut,
                      child: Text(noneLut.name),
                    ),
                    ...ref.watch(settingsProvider.select((s) => s.luts)).map(
                          (e) => DropdownMenuItem<Lut>(
                            value: e,
                            child: Text(e.name),
                          ),
                        ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    notifier.setLut(value.id);
                  },
                ))
              ],
            ),
          ],
        ));
  }
}

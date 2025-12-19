import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/settings.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/custom_dual_option_dialog.dart';

import '../../design_tokens.dart';
import '../buttons/custom_icon_button.dart';

class SettingsDialog extends HookConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outputPresetScrollController = useScrollController();
    final transcodingPresets =
        ref.watch(settingsProvider.select((value) => value.transcodingPresets));
    final lutScrollController = useScrollController();
    final luts = ref.watch(settingsProvider.select((value) => value.luts));
    final isDebugMode =
        ref.watch(settingsProvider.select((value) => value.isDebugMode));
    final appVersion =
        ref.watch(settingsProvider.select((value) => value.appVersion));
    return CustomDualOptionDialog(
        width: 480,
        height: 640,
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
                CustomIconButton(
                    iconData: Icons.add_circle_outline,
                    onPressed: () async {
                      final oPreset = await showDialog(
                          context: context,
                          builder: (context) {
                            return _EditTranscodePresetDialog(preset: null);
                          });
                      if (oPreset != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .addTranscodePreset(oPreset);
                      }
                    },
                    iconSize: DesignValues.mediumIconSize,
                    buttonSize: 28,
                    hoverColor: ColorDark.defaultHover,
                    focusColor: ColorDark.defaultActive,
                    iconColor: ColorDark.text0),
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
                    controller: outputPresetScrollController,
                    child: Consumer(builder: (context, ref, child) {
                      return ListView.builder(
                          controller: outputPresetScrollController,
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
                CustomIconButton(
                    iconData: Icons.add_circle_outline,
                    onPressed: () async {
                      final oLut = await showDialog(
                          context: context,
                          builder: (context) {
                            return _EditLutDialog(lut: null);
                          });
                      if (oLut != null) {
                        ref.read(settingsProvider.notifier).addLut(oLut);
                      }
                    },
                    iconSize: DesignValues.mediumIconSize,
                    buttonSize: 28,
                    hoverColor: ColorDark.defaultHover,
                    focusColor: ColorDark.defaultActive,
                    iconColor: ColorDark.text0),
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
                      return ListView.builder(
                          controller: lutScrollController,
                          itemCount: luts.length,
                          // itemCount: 1,
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
                    style: SemiTextStyles.header5ENRegular
                        .copyWith(color: ColorDark.text1)),
                const Spacer(),
                Switch(
                  value: isDebugMode,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setIsDebugMode(value);
                    // todo: log service
                  },
                  activeTrackColor: ColorDark.blue5,
                  activeThumbColor: ColorDark.white,
                )
              ],
            ),
            SizedBox(
              height: DesignValues.smallPadding,
            ),
            Row(
              children: [
                Text('Version:',
                    style: SemiTextStyles.header5ENRegular
                        .copyWith(color: ColorDark.text1)),
                const Spacer(),
                Text(appVersion,
                    style: SemiTextStyles.header5ENRegular
                        .copyWith(color: ColorDark.text0)),
              ],
            ),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            Row(
              children: [
                Text('Author:',
                    style: SemiTextStyles.header5ENRegular
                        .copyWith(color: ColorDark.text1)),
                const Spacer(),
                Text('lz00qs',
                    style: SemiTextStyles.header5ENRegular
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
        .select((value) => value.defaultTranscodePresetId == preset.id));
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
                        final oPreset = await showDialog(
                            context: context,
                            builder: (context) {
                              return _EditTranscodePresetDialog(preset: preset);
                            });
                        if (oPreset != null) {
                          ref
                              .read(settingsProvider.notifier)
                              .updateTranscodePreset(oPreset);
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
                              return CustomDualOptionDialog(
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

class _LutItem extends ConsumerWidget {
  final Lut lut;

  const _LutItem({required this.lut});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isDefaultLut = ref.watch(settingsProvider
    //     .select((value) => value.defaultLutId == lut.id));
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
                  _ItemButton(
                      iconData: Icons.edit,
                      onPressed: () async {
                        final oLut = await showDialog(
                            context: context,
                            builder: (context) {
                              return _EditLutDialog(lut: lut);
                            });
                        if (oLut != null) {
                          ref.read(settingsProvider.notifier).updateLut(oLut);
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
                              return CustomDualOptionDialog(
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

class _EditLutDialog extends StatelessWidget {
  final Lut? lut;
  late final Lut iLut;
  late final StateProvider<String> nameProvider;
  late final StateProvider<String> pathProvider;

  _EditLutDialog({required this.lut}) {
    final isNew = lut == null;
    if (isNew) {
      iLut = Lut();
    } else {
      iLut = lut!;
    }
    nameProvider = StateProvider<String>((ref) => iLut.name);
    pathProvider = StateProvider<String>((ref) => iLut.path);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDualOptionDialog(
      width: 480,
      height: 320,
      title: lut == null ? 'Add Lut' : 'Edit Lut',
      option1: 'Cancel',
      option2: lut == null ? 'Add' : 'Save',
      onOption1Pressed: () {
        Navigator.of(context).pop();
      },
      onOption2Pressed: () {
        Navigator.of(context).pop(iLut);
      },
      child: HookConsumer(builder: (context, ref, child) {
        final nameController = useTextEditingController(text: iLut.name);
        final scrollController = ScrollController();
        useEffect(() {
          nameController.addListener(() {
            ref.read(nameProvider.notifier).state = nameController.text;
            if (nameController.text.isNotEmpty) {
              iLut.name = nameController.text;
            }
          });
          return null;
        });
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                              ColorDark.blue5.withAlpha((0.8 * 255).round()))),
                  child: TextField(
                    cursorColor: ColorDark.text1,
                    controller: nameController,
                    style: SemiTextStyles.header5ENRegular
                        .copyWith(color: ColorDark.text0),
                    decoration: dialogInputDecoration.copyWith(
                        errorText: (ref.watch(nameProvider)).isEmpty
                            ? 'Name is required'
                            : null),
                  )),
            ),
            lut == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select lut file',
                            style: SemiTextStyles.header5ENRegular
                                .copyWith(color: ColorDark.text1),
                          ),
                          SizedBox(
                            width: DesignValues.smallPadding,
                          ),
                          _ItemButton(
                            iconData: Icons.folder_open,
                            onPressed: () async {
                              final result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['cube'],
                              );
                              if (result != null) {
                                ref.read(pathProvider.notifier).state =
                                    result.files.single.path!;
                                iLut.path = result.files.single.path!;
                                iLut.name =
                                    result.files.single.path!.split('/').last;
                                iLut.name = iLut.name
                                    .substring(0, iLut.name.length - 5);
                                nameController.text = iLut.name;
                              }
                            },
                          ),
                        ],
                      ),
                      Scrollbar(
                          controller: scrollController,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: scrollController,
                            child: Text(
                              ref.watch(pathProvider).split('/').last,
                              style: SemiTextStyles.header5ENRegular
                                  .copyWith(color: ColorDark.text0),
                            ),
                          )),
                    ],
                  )
                : SizedBox()
          ],
        );
      }),
    );
  }
}

class _EditTranscodePresetDialog extends StatelessWidget {
  final TranscodePreset? preset;
  late final TranscodePreset iPreset;
  late final StateProvider<String> nameProvider;
  late final StateProvider<int> widthProvider;
  late final StateProvider<int> heightProvider;
  late final StateProvider<int> crfProvider;
  late final StateProvider<bool> useHevcProvider;
  late final StateProvider<bool> useInputResolutionProvider;
  late final StateProvider<int> selectedFFmpegPresetProvider;
  late final StateProvider<int> selectedLutProvider;

  _EditTranscodePresetDialog({required this.preset}) {
    final isNew = preset == null;
    if (isNew) {
      iPreset = TranscodePreset();
    } else {
      iPreset = preset!;
    }
    nameProvider = StateProvider<String>((ref) => iPreset.name);
    widthProvider = StateProvider<int>((ref) => iPreset.width);
    heightProvider = StateProvider<int>((ref) => iPreset.height);
    crfProvider = StateProvider<int>((ref) => iPreset.crf);
    useHevcProvider = StateProvider<bool>((ref) => iPreset.useHevc);
    useInputResolutionProvider =
        StateProvider<bool>((ref) => iPreset.useInputResolution);
    selectedFFmpegPresetProvider =
        StateProvider<int>((ref) => iPreset.ffmpegPreset);
    selectedLutProvider = StateProvider<int>((ref) => iPreset.lutId);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDualOptionDialog(
        width: 480,
        height: 680,
        title: preset == null ? 'Add Preset' : 'Edit Preset',
        option1: 'Cancel',
        option2: preset == null ? 'Add' : 'Save',
        onOption1Pressed: () {
          Navigator.of(context).pop();
        },
        onOption2Pressed: () {
          Navigator.of(context).pop(iPreset);
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
                  child: HookConsumer(builder: (context, ref, child) {
                    final nameController =
                        useTextEditingController(text: iPreset.name);
                    useEffect(() {
                      nameController.addListener(() {
                        ref.read(nameProvider.notifier).state =
                            nameController.text;
                        if (nameController.text.isNotEmpty) {
                          iPreset.name = nameController.text;
                        }
                      });
                      return null;
                    });
                    return TextField(
                      cursorColor: ColorDark.text1,
                      controller: nameController,
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text0),
                      decoration: dialogInputDecoration.copyWith(
                          errorText: (ref.watch(nameProvider)).isEmpty
                              ? 'Name is required'
                              : null),
                    );
                  })),
            ),
            SizedBox(
              height: DesignValues.smallPadding,
            ),
            Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return CustomDialogCheckBoxWithText(
                  text: 'Use Input Resolution',
                  value: ref.watch(useInputResolutionProvider),
                  onPressed: () {
                    ref.read(useInputResolutionProvider.notifier).state =
                        !ref.watch(useInputResolutionProvider);
                    iPreset.useInputResolution =
                        ref.watch(useInputResolutionProvider);
                  });
            }),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              if (ref.watch(useInputResolutionProvider)) {
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
                        child: HookConsumer(builder: (context, ref, child) {
                          final widthController = useTextEditingController(
                              text: iPreset.width.toString());
                          useEffect(() {
                            widthController.addListener(() {
                              try {
                                ref.read(widthProvider.notifier).state =
                                    int.parse(widthController.text);
                              } catch (e) {
                                ref.read(widthProvider.notifier).state = 0;
                              }
                              if (ref.watch(widthProvider) != 0 &&
                                  !ref.watch(useInputResolutionProvider)) {
                                iPreset.width = ref.watch(widthProvider);
                              }
                            });
                            return null;
                          });
                          return TextField(
                            cursorColor: ColorDark.text1,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: widthController,
                            style: SemiTextStyles.header5ENRegular
                                .copyWith(color: ColorDark.text0),
                            decoration: dialogInputDecoration.copyWith(
                                errorText: ref.watch(widthProvider) == 0
                                    ? 'Width cannot be 0'
                                    : null),
                          );
                        }),
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
                        child: HookConsumer(builder: (context, ref, child) {
                          final heightController = useTextEditingController(
                              text: iPreset.width.toString());
                          useEffect(() {
                            heightController.addListener(() {
                              try {
                                ref.read(heightProvider.notifier).state =
                                    int.parse(heightController.text);
                              } catch (e) {
                                ref.read(heightProvider.notifier).state = 0;
                              }
                              if (ref.watch(heightProvider) != 0 &&
                                  !ref.watch(useInputResolutionProvider)) {
                                iPreset.height = ref.watch(heightProvider);
                              }
                            });
                            return null;
                          });
                          return TextField(
                            cursorColor: ColorDark.text1,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: heightController,
                            style: SemiTextStyles.header5ENRegular
                                .copyWith(color: ColorDark.text0),
                            decoration: dialogInputDecoration.copyWith(
                                errorText: ref.watch(heightProvider) == 0
                                    ? 'Height cannot be 0'
                                    : null),
                          );
                        }),
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
                    child: HookConsumer(builder: (context, ref, child) {
                      final crfController = useTextEditingController(
                          text: iPreset.crf.toString());
                      final crf = ref.watch(crfProvider);
                      useEffect(() {
                        crfController.addListener(() {
                          try {
                            ref.read(crfProvider.notifier).state =
                                int.parse(crfController.text);
                          } catch (e) {
                            ref.read(crfProvider.notifier).state = 0;
                          }
                          if (crf > 0 && crf < 52) {
                            iPreset.crf = ref.watch(crfProvider);
                          }
                        });
                        return null;
                      });
                      return TextField(
                        cursorColor: ColorDark.text1,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: crfController,
                        style: SemiTextStyles.header5ENRegular
                            .copyWith(color: ColorDark.text0),
                        decoration: dialogInputDecoration.copyWith(
                            errorText: (crf > 0 && crf < 52)
                                ? null
                                : 'CRF must be between 0 and 51, higher is lower quality.'),
                      );
                    }),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: DesignValues.smallPadding,
            ),
            Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return CustomDialogCheckBoxWithText(
                  text: 'Use H.265',
                  value: ref.watch(useHevcProvider),
                  onPressed: () {
                    ref.read(useHevcProvider.notifier).state =
                        !ref.watch(useHevcProvider);
                    iPreset.useHevc = ref.watch(useHevcProvider);
                  });
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
                Consumer(builder:
                    (BuildContext context, WidgetRef ref, Widget? child) {
                  return DropdownButton<FFmpegPreset>(
                    value: FFmpegPreset
                        .values[ref.watch(selectedFFmpegPresetProvider)],
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
                        ref.read(selectedFFmpegPresetProvider.notifier).state =
                            value.index;
                        iPreset.ffmpegPreset = value.index;
                      }
                    },
                  );
                })
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
                Expanded(child: Consumer(
                  builder: (context, ref, child) {
                    final luts = ref.watch(settingsProvider).luts;
                    final selectedId = ref.watch(selectedLutProvider);
                    final noneLut = Lut()..id = 0;
                    noneLut.name = 'None';

                    final selectedLut = luts.firstWhere(
                      (e) => e.id == selectedId,
                      orElse: () => noneLut,
                    );
                    return DropdownButton<Lut>(
                      value: selectedLut,
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
                        ...luts.map(
                          (e) => DropdownMenuItem<Lut>(
                            value: e,
                            child: Text(e.name),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        ref.read(selectedLutProvider.notifier).state = value.id;
                        iPreset.lutId = value.id;
                      },
                    );
                  },
                ))
              ],
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xji_footage_toolbox/providers/settings.notifier.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/dual_option_dialog.dart';

import '../../../models/transcode_preset.model.dart';
import '../../design_tokens.dart';
import '../buttons/custom_icon_button.dart';

// part 'settings_dialog.g.dart';

// class _SettingsDialogUiState {
//   const _SettingsDialogUiState();
// }

// @riverpod
// class _SettingsDialogController extends _$SettingsDialogController {
//   late final ScrollController outputPresetScrollController;
//   late final ScrollController lutScrollController;
//
//   @override
//   _SettingsDialogUiState build() {
//     outputPresetScrollController = ScrollController();
//     lutScrollController = ScrollController();
//
//     ref.onDispose(() {
//       outputPresetScrollController.dispose();
//       lutScrollController.dispose();
//     });
//
//     return const _SettingsDialogUiState();
//   }
// }

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController transcodePresetScrollController = ScrollController();
    final ScrollController lutScrollController = ScrollController();
    return DualOptionDialog(
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
                      // final oPreset = await showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return _EditTranscodePresetDialog(preset: null);
                      //     });
                      // if (oPreset != null) {
                      //   ref
                      //       .read(settingsProvider.notifier)
                      //       .addTranscodePreset(oPreset);
                      // }
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
            Consumer(builder: (context, ref, child) {
              final transcodingPresets = ref.watch(settingsProvider
                  .select((settings) => settings.transcodingPresets));
              return ClipRRect(
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
                        return ListView.builder(
                            controller: transcodePresetScrollController,
                            itemCount: transcodingPresets.length,
                            itemBuilder: (context, index) {
                              return _PresetItem(
                                  preset: transcodingPresets[index]);
                              // return SizedBox();
                            });
                      }),
                    ),
                  ),
                ),
              );
            }),
            // ClipRRect(
            //   borderRadius:
            //   BorderRadius.circular(DesignValues.smallBorderRadius),
            //   child: Container(
            //     color: ColorDark.bg3,
            //     height: 120,
            //     child: Padding(
            //       padding: EdgeInsets.only(
            //           top: DesignValues.ultraSmallPadding,
            //           bottom: DesignValues.ultraSmallPadding,
            //           left: DesignValues.ultraSmallPadding),
            //       child: RawScrollbar(
            //         thickness: DesignValues.smallPadding,
            //         trackVisibility: false,
            //         thumbVisibility: true,
            //         radius: Radius.circular(DesignValues.smallBorderRadius),
            //         controller: outputPresetScrollController,
            //         child: Consumer(builder: (context, ref, child) {
            //           return ListView.builder(
            //               controller: outputPresetScrollController,
            //               itemCount: transcodingPresets.length,
            //               itemBuilder: (context, index) {
            //                 return _PresetItem(
            //                     preset: transcodingPresets[index]);
            //               });
            //         }),
            //       ),
            //     ),
            //   ),
            // ),
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
                      // final oLut = await showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return _EditLutDialog(lut: null);
                      //     });
                      // if (oLut != null) {
                      //   ref.read(settingsProvider.notifier).addLut(oLut);
                      // }
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
            // ClipRRect(
            //   borderRadius:
            //   BorderRadius.circular(DesignValues.smallBorderRadius),
            //   child: Container(
            //     color: ColorDark.bg3,
            //     height: 120,
            //     child: Padding(
            //       padding: EdgeInsets.only(
            //           top: DesignValues.ultraSmallPadding,
            //           bottom: DesignValues.ultraSmallPadding,
            //           left: DesignValues.ultraSmallPadding),
            //       child: RawScrollbar(
            //         thickness: DesignValues.smallPadding,
            //         trackVisibility: false,
            //         thumbVisibility: true,
            //         radius: Radius.circular(DesignValues.smallBorderRadius),
            //         controller: lutScrollController,
            //         child: Consumer(builder: (context, ref, child) {
            //           return ListView.builder(
            //               controller: lutScrollController,
            //               itemCount: luts.length,
            //               // itemCount: 1,
            //               itemBuilder: (context, index) {
            //                 return _LutItem(lut: luts[index]);
            //               });
            //         }),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: DesignValues.largePadding,
            ),
            Row(
              children: [
                Text('Debug Mode:',
                    style: SemiTextStyles.header5ENRegular
                        .copyWith(color: ColorDark.text1)),
                const Spacer(),
                // Switch(
                //   value: isDebugMode,
                //   onChanged: (value) {
                //     ref.read(settingsProvider.notifier).setIsDebugMode(value);
                //     // todo: log service
                //   },
                //   activeTrackColor: ColorDark.blue5,
                //   activeThumbColor: ColorDark.white,
                // )
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
                // Text(appVersion,
                //     style: SemiTextStyles.header5ENRegular
                //         .copyWith(color: ColorDark.text0)),
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
                        final oPreset = await showDialog(
                            context: context,
                            builder: (context) {
                              // return _EditTranscodePresetDialog(preset: preset);
                              return SizedBox();
                            });
                        if (oPreset != null) {
                          // ref
                          //     .read(settingsProvider.notifier)
                          //     .updateTranscodePreset(oPreset);
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

//
// class _LutItem extends ConsumerWidget {
//   final Lut lut;
//
//   const _LutItem({required this.lut});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final isDefaultLut = ref.watch(settingsProvider
//     //     .select((value) => value.defaultLutId == lut.id));
//     return SizedBox(
//       height: 37,
//       child: Row(
//         children: [
//           Expanded(
//               child: Column(
//                 children: [
//                   Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             width: DesignValues.smallPadding,
//                           ),
//                           Expanded(
//                               child: Text(lut.name,
//                                   style: SemiTextStyles.header5ENRegular.copyWith(
//                                       color: ColorDark.text0,
//                                       overflow: TextOverflow.ellipsis))),
//                           _ItemButton(
//                               iconData: Icons.edit,
//                               onPressed: () async {
//                                 final oLut = await showDialog(
//                                     context: context,
//                                     builder: (context) {
//                                       return _EditLutDialog(lut: lut);
//                                     });
//                                 if (oLut != null) {
//                                   ref.read(settingsProvider.notifier).updateLut(oLut);
//                                 }
//                               }),
//                           SizedBox(
//                             width: DesignValues.mediumPadding,
//                           ),
//                           _ItemButton(
//                               iconData: Icons.delete,
//                               onPressed: () async {
//                                 await showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return CustomDualOptionDialog(
//                                           width: 400,
//                                           height: 240,
//                                           title: 'Delete',
//                                           option1: 'Delete',
//                                           option2: 'Cancel',
//                                           onOption1Pressed: () {
//                                             ref
//                                                 .read(settingsProvider.notifier)
//                                                 .removeLut(lut.id);
//                                             Navigator.of(context).pop();
//                                           },
//                                           onOption2Pressed: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Text(
//                                               'Are you sure you want to delete this lut?',
//                                               style: SemiTextStyles.header5ENRegular
//                                                   .copyWith(color: ColorDark.text0)));
//                                     });
//                               }),
//                         ],
//                       )),
//                   const Divider(
//                     color: ColorDark.border,
//                     thickness: 1,
//                     height: 1,
//                   ),
//                 ],
//               )),
//           SizedBox(
//             width: DesignValues.smallPadding,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
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
//
// class _EditLutState {
//   final String name;
//   final String path;
//
//   const _EditLutState({
//     required this.name,
//     required this.path,
//   });
//
//   bool get isNameValid => name.isNotEmpty;
//
//   _EditLutState copyWith({
//     String? name,
//     String? path,
//   }) {
//     return _EditLutState(
//       name: name ?? this.name,
//       path: path ?? this.path,
//     );
//   }
// }
//
// @riverpod
// class _EditLutController extends _$EditLutController {
//   late final TextEditingController nameController;
//   late final ScrollController pathScrollController;
//
//   late final Lut _lut;
//
//   @override
//   _EditLutState build(Lut? lut) {
//     if (lut == null) {
//       _lut = Lut();
//     } else {
//       _lut = Lut()
//         ..id = lut.id
//         ..name = lut.name
//         ..path = lut.path;
//     }
//
//     nameController = TextEditingController(text: _lut.name);
//     pathScrollController = ScrollController();
//
//     void nameListener() {
//       final text = nameController.text;
//       if (text != state.name) {
//         _lut.name = text;
//         state = state.copyWith(name: text);
//       }
//     }
//
//     nameController.addListener(nameListener);
//
//     ref.onDispose(() {
//       nameController.removeListener(nameListener);
//       nameController.dispose();
//       pathScrollController.dispose();
//     });
//
//     return _EditLutState(
//       name: _lut.name,
//       path: _lut.path,
//     );
//   }
//
//   /// 选择 lut 文件（仅新建时使用）
//   Future<void> pickLutFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['cube'],
//     );
//     if (result == null) return;
//
//     final path = result.files.single.path!;
//     var name = path.split('/').last;
//     name = name.substring(0, name.length - 5);
//     if (name.length > 24) {
//       name = name.substring(0, 24);
//     }
//
//     _lut
//       ..path = path
//       ..name = name;
//
//     nameController.text = name;
//
//     state = state.copyWith(
//       name: name,
//       path: path,
//     );
//   }
//
//   Lut get result => _lut;
// }
//
// class _EditLutDialog extends ConsumerWidget {
//   final Lut? lut;
//
//   const _EditLutDialog({required this.lut});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(_editLutControllerProvider(lut));
//     final controller = ref.read(_editLutControllerProvider(lut).notifier);
//
//     return CustomDualOptionDialog(
//       width: 480,
//       height: 320,
//       title: lut == null ? 'Add Lut' : 'Edit Lut',
//       option1: 'Cancel',
//       option2: lut == null ? 'Add' : 'Save',
//       disableOption2: !state.isNameValid,
//       onOption1Pressed: () {
//         Navigator.of(context).pop();
//       },
//       onOption2Pressed: () {
//         Navigator.of(context).pop(controller.result);
//       },
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Lut name',
//             style: SemiTextStyles.header5ENRegular
//                 .copyWith(color: ColorDark.text1),
//           ),
//           SizedBox(
//             height: 72,
//             child: Theme(
//               data: Theme.of(context).copyWith(
//                 textSelectionTheme: TextSelectionThemeData(
//                   selectionColor:
//                   ColorDark.blue5.withAlpha((0.8 * 255).round()),
//                 ),
//               ),
//               child: TextField(
//                 maxLength: 24,
//                 controller: controller.nameController,
//                 cursorColor: ColorDark.text1,
//                 style: SemiTextStyles.header5ENRegular
//                     .copyWith(color: ColorDark.text0),
//                 decoration: dialogInputDecoration.copyWith(
//                   errorText: state.isNameValid ? null : 'Name is required',
//                 ),
//               ),
//             ),
//           ),
//           if (lut == null) ...[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Select lut file',
//                   style: SemiTextStyles.header5ENRegular
//                       .copyWith(color: ColorDark.text1),
//                 ),
//                 _ItemButton(
//                   iconData: Icons.folder_open,
//                   onPressed: controller.pickLutFile,
//                 ),
//               ],
//             ),
//             Scrollbar(
//               controller: controller.pathScrollController,
//               child: SingleChildScrollView(
//                 controller: controller.pathScrollController,
//                 scrollDirection: Axis.horizontal,
//                 child: Text(
//                   state.path.split('/').last,
//                   style: SemiTextStyles.header5ENRegular
//                       .copyWith(color: ColorDark.text0),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// class _EditTranscodePresetState {
//   final String name;
//   final bool useInputResolution;
//   final int width;
//   final int height;
//   final int crf;
//   final bool useHevc;
//   final int ffmpegPreset;
//   final int lutId;
//
//   const _EditTranscodePresetState({
//     required this.name,
//     required this.useInputResolution,
//     required this.width,
//     required this.height,
//     required this.crf,
//     required this.useHevc,
//     required this.ffmpegPreset,
//     required this.lutId,
//   });
//
//   bool get isNameValid => name.isNotEmpty;
//
//   bool get isWidthValid => width > 0;
//
//   bool get isHeightValid => height > 0;
//
//   bool get isCrfValid => crf > 0 && crf < 52;
//
//   _EditTranscodePresetState copyWith({
//     String? name,
//     bool? useInputResolution,
//     int? width,
//     int? height,
//     int? crf,
//     bool? useHevc,
//     int? ffmpegPreset,
//     int? lutId,
//   }) {
//     return _EditTranscodePresetState(
//       name: name ?? this.name,
//       useInputResolution: useInputResolution ?? this.useInputResolution,
//       width: width ?? this.width,
//       height: height ?? this.height,
//       crf: crf ?? this.crf,
//       useHevc: useHevc ?? this.useHevc,
//       ffmpegPreset: ffmpegPreset ?? this.ffmpegPreset,
//       lutId: lutId ?? this.lutId,
//     );
//   }
// }
//
// @riverpod
// class _EditTranscodePresetController extends _$EditTranscodePresetController {
//   late final TranscodePreset _preset;
//
//   late final TextEditingController nameController;
//   late final TextEditingController widthController;
//   late final TextEditingController heightController;
//   late final TextEditingController crfController;
//
//   @override
//   _EditTranscodePresetState build(TranscodePreset? preset) {
//     if (preset == null) {
//       _preset = TranscodePreset();
//     } else {
//       _preset = TranscodePreset()
//         ..id = preset.id
//         ..name = preset.name
//         ..useInputResolution = preset.useInputResolution
//         ..useHevc = preset.useHevc
//         ..width = preset.width
//         ..height = preset.height
//         ..crf = preset.crf
//         ..ffmpegPreset = preset.ffmpegPreset
//         ..lutId = preset.lutId;
//     }
//
//     nameController = TextEditingController(text: _preset.name);
//     widthController = TextEditingController(text: _preset.width.toString());
//     heightController = TextEditingController(text: _preset.height.toString());
//     crfController = TextEditingController(text: _preset.crf.toString());
//
//     nameController.addListener(_onNameChanged);
//     widthController.addListener(_onWidthChanged);
//     heightController.addListener(_onHeightChanged);
//     crfController.addListener(_onCrfChanged);
//
//     ref.onDispose(() {
//       nameController.dispose();
//       widthController.dispose();
//       heightController.dispose();
//       crfController.dispose();
//     });
//
//     return _EditTranscodePresetState(
//       name: _preset.name,
//       useInputResolution: _preset.useInputResolution,
//       width: _preset.width,
//       height: _preset.height,
//       crf: _preset.crf,
//       useHevc: _preset.useHevc,
//       ffmpegPreset: _preset.ffmpegPreset,
//       lutId: _preset.lutId,
//     );
//   }
//
//   // ---------------- listeners ----------------
//
//   void _onNameChanged() {
//     final v = nameController.text;
//     _preset.name = v;
//     state = state.copyWith(name: v);
//   }
//
//   void _onWidthChanged() {
//     final v = int.tryParse(widthController.text) ?? 0;
//     if (!state.useInputResolution) {
//       _preset.width = v;
//     }
//     state = state.copyWith(width: v);
//   }
//
//   void _onHeightChanged() {
//     final v = int.tryParse(heightController.text) ?? 0;
//     if (!state.useInputResolution) {
//       _preset.height = v;
//     }
//     state = state.copyWith(height: v);
//   }
//
//   void _onCrfChanged() {
//     final v = int.tryParse(crfController.text) ?? 0;
//     if (v > 0 && v < 52) {
//       _preset.crf = v;
//     }
//     state = state.copyWith(crf: v);
//   }
//
//   // ---------------- actions ----------------
//
//   void toggleUseInputResolution() {
//     final v = !state.useInputResolution;
//     _preset.useInputResolution = v;
//     state = state.copyWith(useInputResolution: v);
//   }
//
//   void toggleUseHevc() {
//     final v = !state.useHevc;
//     _preset.useHevc = v;
//     state = state.copyWith(useHevc: v);
//   }
//
//   void setFfmpegPreset(int preset) {
//     _preset.ffmpegPreset = preset;
//     state = state.copyWith(ffmpegPreset: preset);
//   }
//
//   void setLut(int id) {
//     _preset.lutId = id;
//     state = state.copyWith(lutId: id);
//   }
//
//   TranscodePreset get result => _preset;
// }
//
// class _EditTranscodePresetDialog extends ConsumerWidget {
//   final TranscodePreset? preset;
//
//   const _EditTranscodePresetDialog({required this.preset});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(_editTranscodePresetControllerProvider(preset));
//     final controller =
//     ref.read(_editTranscodePresetControllerProvider(preset).notifier);
//
//     final noneLut = Lut()
//       ..id = 0
//       ..name = 'None';
//
//     return CustomDualOptionDialog(
//         width: 480,
//         height: 680,
//         title: preset == null ? 'Add Preset' : 'Edit Preset',
//         option1: 'Cancel',
//         option2: preset == null ? 'Add' : 'Save',
//         onOption1Pressed: () {
//           Navigator.of(context).pop();
//         },
//         onOption2Pressed: () {
//           Navigator.of(context).pop(controller.result);
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Preset name',
//               style: SemiTextStyles.header5ENRegular
//                   .copyWith(color: ColorDark.text1),
//             ),
//             SizedBox(
//               height: 72,
//               child: Theme(
//                   data: Theme.of(context).copyWith(
//                       textSelectionTheme: TextSelectionThemeData(
//                           selectionColor:
//                           ColorDark.blue5.withAlpha((0.8 * 255).round()))),
//                   child: TextField(
//                     maxLength: 24,
//                     cursorColor: ColorDark.text1,
//                     controller: controller.nameController,
//                     style: SemiTextStyles.header5ENRegular
//                         .copyWith(color: ColorDark.text0),
//                     decoration: dialogInputDecoration.copyWith(
//                         errorText:
//                         state.isNameValid ? null : 'Name is required'),
//                   )),
//             ),
//             SizedBox(
//               height: DesignValues.smallPadding,
//             ),
//             Consumer(
//                 builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                   return CustomDialogCheckBoxWithText(
//                       text: 'Use Input Resolution',
//                       value: state.useInputResolution,
//                       onPressed: () {
//                         controller.toggleUseInputResolution();
//                       });
//                 }),
//             SizedBox(
//               height: DesignValues.mediumPadding,
//             ),
//             Consumer(
//                 builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                   if (state.useInputResolution) {
//                     return const SizedBox();
//                   } else {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Width',
//                           style: SemiTextStyles.header5ENRegular
//                               .copyWith(color: ColorDark.text1),
//                         ),
//                         SizedBox(
//                           height: 72,
//                           child: Theme(
//                             data: Theme.of(context).copyWith(
//                                 textSelectionTheme: TextSelectionThemeData(
//                                     selectionColor: ColorDark.blue5
//                                         .withAlpha((0.8 * 255).round()))),
//                             child: TextField(
//                               cursorColor: ColorDark.text1,
//                               keyboardType: TextInputType.number,
//                               inputFormatters: <TextInputFormatter>[
//                                 FilteringTextInputFormatter.digitsOnly
//                               ],
//                               controller: controller.widthController,
//                               style: SemiTextStyles.header5ENRegular
//                                   .copyWith(color: ColorDark.text0),
//                               decoration: dialogInputDecoration.copyWith(
//                                   errorText: state.isWidthValid
//                                       ? 'Width cannot be 0'
//                                       : null),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           'Height',
//                           style: SemiTextStyles.header5ENRegular
//                               .copyWith(color: ColorDark.text1),
//                         ),
//                         SizedBox(
//                           height: 72,
//                           child: Theme(
//                             data: Theme.of(context).copyWith(
//                                 textSelectionTheme: TextSelectionThemeData(
//                                     selectionColor: ColorDark.blue5
//                                         .withAlpha((0.8 * 255).round()))),
//                             child: TextField(
//                               cursorColor: ColorDark.text1,
//                               keyboardType: TextInputType.number,
//                               inputFormatters: <TextInputFormatter>[
//                                 FilteringTextInputFormatter.digitsOnly
//                               ],
//                               controller: controller.heightController,
//                               style: SemiTextStyles.header5ENRegular
//                                   .copyWith(color: ColorDark.text0),
//                               decoration: dialogInputDecoration.copyWith(
//                                   errorText: state.isHeightValid
//                                       ? 'Height cannot be 0'
//                                       : null),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                 }),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'CRF',
//                   style: SemiTextStyles.header5ENRegular
//                       .copyWith(color: ColorDark.text1),
//                 ),
//                 SizedBox(
//                   height: 72,
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                         textSelectionTheme: TextSelectionThemeData(
//                             selectionColor: ColorDark.blue5
//                                 .withAlpha((0.8 * 255).round()))),
//                     child: TextField(
//                       cursorColor: ColorDark.text1,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                       controller: controller.crfController,
//                       style: SemiTextStyles.header5ENRegular
//                           .copyWith(color: ColorDark.text0),
//                       decoration: dialogInputDecoration.copyWith(
//                           errorText: state.isCrfValid
//                               ? null
//                               : 'CRF must be between 0 and 51, higher is lower quality.'),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: DesignValues.smallPadding,
//             ),
//             CustomDialogCheckBoxWithText(
//                 text: 'Use H.265',
//                 value: state.useHevc,
//                 onPressed: () {
//                   controller.toggleUseHevc();
//                 }),
//             SizedBox(
//               height: DesignValues.smallPadding,
//             ),
//             Row(
//               children: [
//                 Text(
//                   "FFmpeg Preset:",
//                   style: SemiTextStyles.header5ENRegular
//                       .copyWith(color: ColorDark.text1),
//                 ),
//                 const Spacer(),
//                 DropdownButton<FFmpegPreset>(
//                   value: FFmpegPreset.values[state.ffmpegPreset],
//                   focusColor: ColorDark.defaultActive,
//                   dropdownColor: ColorDark.bg2,
//                   style: SemiTextStyles.header5ENRegular
//                       .copyWith(color: ColorDark.text0),
//                   items: FFmpegPreset.values
//                       .map((e) => DropdownMenuItem<FFmpegPreset>(
//                     value: e,
//                     child: Text(e.name),
//                   ))
//                       .toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       controller.setFfmpegPreset(value.index);
//                     }
//                   },
//                 )
//               ],
//             ),
//             Row(
//               children: [
//                 Text(
//                   "LUT:",
//                   style: SemiTextStyles.header5ENRegular
//                       .copyWith(color: ColorDark.text1),
//                 ),
//                 SizedBox(
//                   width: DesignValues.largePadding,
//                 ),
//                 Expanded(
//                     child: DropdownButton<Lut>(
//                       value: ref.watch(settingsProvider.select((s) {
//                         final luts = s.value?.luts;
//                         if (luts != null && luts.isNotEmpty && state.lutId != 0) {
//                           return luts.firstWhere(
//                                   (element) => element.id == state.lutId,
//                               orElse: () => noneLut);
//                         }
//                         return noneLut;
//                       })),
//                       itemHeight: null,
//                       isExpanded: true,
//                       focusColor: ColorDark.defaultActive,
//                       dropdownColor: ColorDark.bg2,
//                       style: SemiTextStyles.header5ENRegular
//                           .copyWith(color: ColorDark.text0),
//                       items: [
//                         DropdownMenuItem<Lut>(
//                           value: noneLut,
//                           child: Text(noneLut.name),
//                         ),
//                         ...ref
//                             .watch(
//                             settingsProvider.select((s) => s.value?.luts ?? []))
//                             .map(
//                               (e) => DropdownMenuItem<Lut>(
//                             value: e,
//                             child: Text(e.name),
//                           ),
//                         ),
//                       ],
//                       onChanged: (value) {
//                         if (value == null) return;
//                         controller.setLut(value.id);
//                       },
//                     ))
//               ],
//             ),
//           ],
//         ));
//   }
// }

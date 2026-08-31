// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as p;

import '../../models/media_resource.model.dart';
import '../../utils/tools.dart';
import '../design_tokens.dart';
import 'dual_option_dialog.dart';

part 'media_resource_rename_dialog.freezed.dart';
part 'media_resource_rename_dialog.g.dart';

const _fileExistErrorText = 'File already exists';
const _invalidNameErrorText = 'Invalid name';

@freezed
abstract class _RenameDialogState with _$RenameDialogState {
  const factory _RenameDialogState({
    @Default(false) bool isNewNameValid,
    @Default(_fileExistErrorText) String errorText,
  }) = __RenameDialogState;
}

@riverpod
class _MediaResourceRenameDialogNotifier
    extends _$MediaResourceRenameDialogNotifier {
  late final TextEditingController textController;

  @override
  _RenameDialogState build(MediaResource mediaResource) {
    final initialName = p.basenameWithoutExtension(mediaResource.name);

    textController = TextEditingController(text: initialName);

    void listener() {
      final extension = p.extension(mediaResource.file.path);
      final newPath = p.join(
        mediaResource.file.parent.path,
        '${textController.text}$extension',
      );
      if (textController.text.trim().isEmpty) {
        state = state.copyWith(
          errorText: _invalidNameErrorText,
          isNewNameValid: false,
        );
        return;
      }
      var valid = !isFileExist(newPath);
      if (!valid) {
        state = state.copyWith(
          errorText: _fileExistErrorText,
          isNewNameValid: false,
        );
      } else {
        if (!textController.text.contains(RegExp(r'[\\/:*?"<>|]'))) {
          state = state.copyWith(errorText: '', isNewNameValid: true);
        } else {
          state = state.copyWith(
            errorText: _invalidNameErrorText,
            isNewNameValid: false,
          );
        }
      }
    }

    textController.addListener(listener);

    ref.onDispose(() {
      textController.removeListener(listener);
      textController.dispose();
    });

    return const _RenameDialogState();
  }
}

class MediaResourceRenameDialog extends ConsumerWidget {
  final MediaResource mediaResource;

  const MediaResourceRenameDialog({super.key, required this.mediaResource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_mediaResourceRenameDialogProvider(mediaResource));

    final controller = ref
        .read(_mediaResourceRenameDialogProvider(mediaResource).notifier)
        .textController;

    final ext = p.extension(mediaResource.file.path);

    return DualOptionDialog(
      width: 400,
      height: 240,
      title: 'Rename',
      option1: 'Rename',
      option2: 'Cancel',
      disableOption1: !state.isNewNameValid,
      onOption1Pressed: () {
        Navigator.of(context).pop(controller.text);
      },
      onOption2Pressed: () {
        Navigator.of(context).pop();
      },
      child: SizedBox(
        height: 72,
        child: Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: ColorDark.blue5.withAlpha((0.8 * 255).round()),
            ),
          ),
          child: TextField(
            cursorColor: ColorDark.text1,
            controller: controller,
            style: SemiTextStyles.header5ENRegular.copyWith(
              color: ColorDark.text0,
            ),
            decoration: dialogInputDecoration.copyWith(
              suffix: Text(
                ext,
                style: SemiTextStyles.header5ENRegular.copyWith(
                  color: ColorDark.text1,
                ),
              ),
              errorText: state.isNewNameValid ? null : state.errorText,
              errorMaxLines: 3,
            ),
          ),
        ),
      ),
    );
  }
}

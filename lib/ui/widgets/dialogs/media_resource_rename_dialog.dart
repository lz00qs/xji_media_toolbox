import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/utils/media_resources_utils.dart';
import '../../../providers/media_resources_provider.dart';
import '../../design_tokens.dart';
import 'custom_dual_option_dialog.dart';

part 'media_resource_rename_dialog.g.dart';

class _RenameDialogState {
  final bool isNewNameValid;

  const _RenameDialogState({this.isNewNameValid = true});

  _RenameDialogState copyWith({bool? isNewNameValid}) {
    return _RenameDialogState(
      isNewNameValid: isNewNameValid ?? this.isNewNameValid,
    );
  }
}

@riverpod
class _MediaResourceRenameDialogController
    extends _$MediaResourceRenameDialogController {
  late final TextEditingController textController;

  @override
  _RenameDialogState build(MediaResource mediaResource) {
    final initialName =
        mediaResource.name.substring(0, mediaResource.name.lastIndexOf('.'));

    textController = TextEditingController(text: initialName);

    void listener() {
      final ext = mediaResource.file.path.split('.').last;
      final newPath =
          '${mediaResource.file.parent.path}/${textController.text}.$ext';

      final valid = !isFileExist(newPath);
      if (valid != state.isNewNameValid) {
        state = state.copyWith(isNewNameValid: valid);
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

  const MediaResourceRenameDialog({
    super.key,
    required this.mediaResource,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      _mediaResourceRenameDialogControllerProvider(mediaResource),
    );

    final controller = ref
        .read(_mediaResourceRenameDialogControllerProvider(mediaResource)
            .notifier)
        .textController;

    final ext = mediaResource.file.path.split('.').last;

    return CustomDualOptionDialog(
      width: 400,
      height: 240,
      title: 'Rename',
      option1: 'Rename',
      option2: 'Cancel',
      disableOption1: !state.isNewNameValid,
      onOption1Pressed: () {
        ref.read(mediaResourcesProvider.notifier).renameResource(
              resource: mediaResource,
              newName: '${controller.text}.$ext',
            );
        Navigator.of(context).pop();
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
            style: SemiTextStyles.header5ENRegular
                .copyWith(color: ColorDark.text0),
            decoration: dialogInputDecoration.copyWith(
              suffix: Text(
                '.$ext',
                style: SemiTextStyles.header5ENRegular
                    .copyWith(color: ColorDark.text1),
              ),
              errorText: state.isNewNameValid ? null : 'File already exists',
              errorMaxLines: 3,
            ),
          ),
        ),
      ),
    );
  }
}

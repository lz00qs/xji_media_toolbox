import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/utils/media_resources_utils.dart';
import '../../design_tokens.dart';
import 'custom_dual_option_dialog.dart';

class MediaResourceRenameDialog extends HookConsumerWidget {
  final MediaResource mediaResource;

  const MediaResourceRenameDialog({super.key, required this.mediaResource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController(
        text: mediaResource.name
            .substring(0, mediaResource.name.lastIndexOf('.')));
    final isNewNameValid = useState(true);
    useEffect(() {
      textController.addListener(() {
        isNewNameValid.value = !isFileExist('${mediaResource.file.parent.path}'
            '/${textController.text}.${mediaResource.file.path.split('.').last}');
      });
      return null;
    });
    // print(isNewNameValid.value);
    return CustomDualOptionDialog(
        width: 400,
        height: 240,
        title: 'Rename',
        option1: 'Rename',
        option2: 'Cancel',
        disableOption1: !isNewNameValid.value,
        onOption1Pressed: () {
          ref.read(mediaResourcesProvider.notifier).renameResource(
              resource: mediaResource,
              newName:
                  '${textController.text}.${mediaResource.file.path.split('.').last}');
          Navigator.of(context).pop();
        },
        onOption2Pressed: () {
          // Get.back();
          Navigator.of(context).pop();
        },
        child: SizedBox(
          height: 72,
          child: Theme(
              data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                      selectionColor:
                          ColorDark.blue5.withAlpha((0.8 * 255).round()))),
              child: TextField(
                cursorColor: ColorDark.text1,
                controller: textController,
                style: SemiTextStyles.header5ENRegular
                    .copyWith(color: ColorDark.text0),
                decoration: dialogInputDecoration.copyWith(
                    suffix: Text(
                      '.${mediaResource.file.path.split('.').last}',
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text1),
                    ),
                    errorText:
                        isNewNameValid.value ? null : 'File already exists',
                    errorMaxLines: 3),
              )),
        ));
  }
}

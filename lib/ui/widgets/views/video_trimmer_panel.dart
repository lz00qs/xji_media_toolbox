import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/video_export_dialog.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/video_trimmer.dart';

import '../buttons/custom_icon_button.dart';
import '../../design_tokens.dart';
import 'main_panel.dart';

class VideoTrimmerPanel extends ConsumerWidget {
  const VideoTrimmerPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(
        mediaResourcesProvider.select((state) => state.resources.isEmpty))) {
      return Container();
    }
    final resource = ref.watch(mediaResourcesProvider.select(
        (state) => state.resources[state.currentIndex] as NormalVideoResource));
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(DesignValues.smallPadding),
              child: VideoTrimmer(videoResource: resource)),
        ),
        MainPanelSideBar(
          children: [
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.arrow_back_ios_new,
                onPressed: () async {
                  ref.read(mediaResourcesProvider.notifier).setIsEditing(false);
                },
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.appBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.upload,
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return VideoExportDialog();
                      });
                },
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.appBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
          ],
        ),
      ],
    );
  }
}

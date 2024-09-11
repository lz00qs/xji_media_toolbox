import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/new_ui/photoView.dart';

import 'design_tokens.dart';
import 'main_panel.dart';

class NormalPhotoView extends StatelessWidget {
  final MediaResource mediaResource;

  const NormalPhotoView({super.key, required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(DesignValues.smallPadding),
              child: PhotoView(photoFile: mediaResource.file)),
        ),
        const MainPanelSideBar(
          children: [
            Expanded(child: MainPanelSideBarControlButtons()),
          ],
        ),
      ],
    );
  }
}

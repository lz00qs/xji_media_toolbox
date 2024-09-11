
import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/new_ui/photo_viewer.dart';

import 'design_tokens.dart';
import 'main_panel.dart';

class NormalPhotoView extends StatelessWidget {
  final NormalPhotoResource photoResource;

  const NormalPhotoView({super.key, required this.photoResource});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(DesignValues.smallPadding),
              child: PhotoViewer(photoFile: photoResource.file)),
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

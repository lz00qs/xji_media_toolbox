
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/photo_viewer.dart';

import '../../design_tokens.dart';
import 'main_panel.dart';

class NormalPhotoViewPanel extends StatelessWidget {
  final File photoFile;

  const NormalPhotoViewPanel({super.key, required this.photoFile});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(DesignValues.smallPadding),
              child: PhotoViewer(photoFile: photoFile)),
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

import 'dart:io';

import 'package:flutter/material.dart';

import '../design_tokens.dart';
import '../photo_viewer.dart';
import 'main_panel.dart';

class PhotoViewerPanel extends StatelessWidget {
  final File photoFile;

  const PhotoViewerPanel({super.key, required this.photoFile});

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

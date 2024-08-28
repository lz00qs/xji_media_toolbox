import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/photo_viewer_widget.dart';

import 'main_page_right_app_bar.dart';

class NormalPhotoViewerWidget extends StatelessWidget {
  final NormalPhotoResource photoResource;

  const NormalPhotoViewerWidget({super.key, required this.photoResource});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MainPageRightAppBar(
          children: [],
        ),
        Expanded(
          child: Center(
            child: PhotoViewerWidget(photoFile: photoResource.file),
          ),
        ),
      ],
    );
  }
}

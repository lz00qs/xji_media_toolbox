import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/photo_viewer_widget.dart';
import 'package:xji_footage_toolbox/ui/widgets/right_app_bar_media_delete_button.dart';

import 'main_page_right_app_bar.dart';

class NormalPhotoViewerWidget extends StatelessWidget {
  final NormalPhotoResource photoResource;

  const NormalPhotoViewerWidget({super.key, required this.photoResource});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MainPageRightAppBar(
          children: [
            RightAppBarMediaDeleteButton(),
          ],
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

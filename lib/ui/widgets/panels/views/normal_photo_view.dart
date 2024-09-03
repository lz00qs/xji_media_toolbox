import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/panels/views/photo_view.dart';

import '../../app_bars/right_app_bar.dart';

class NormalPhotoView extends StatelessWidget {
  final NormalPhotoResource photoResource;

  const NormalPhotoView({super.key, required this.photoResource});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RightAppBar(
          children: [],
        ),
        Expanded(
          child: Center(
            child: PhotoView(photoFile: photoResource.file),
          ),
        ),
      ],
    );
  }
}

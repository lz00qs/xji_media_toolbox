import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/aeb_photo_view_panel.dart';

import '../../../models/media_resource.dart';
import 'normal_photo_view.dart';

class PhotoPanel extends StatelessWidget {
  final MediaResource photoResource;

  const PhotoPanel({super.key, required this.photoResource});

  @override
  Widget build(BuildContext context) {
    if (photoResource.isAeb) {
      return AebPhotoViewPanel(
          photoResource: photoResource as AebPhotoResource);
    } else {
      return NormalPhotoViewPanel(photoFile: photoResource.file);
    }
  }
}

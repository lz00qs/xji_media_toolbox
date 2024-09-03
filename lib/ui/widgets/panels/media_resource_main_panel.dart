import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/panels/views/aeb_photo_view.dart';

import 'package:xji_footage_toolbox/ui/widgets/panels/views/normal_photo_view.dart';
import 'package:xji_footage_toolbox/ui/widgets/panels/views/normal_video_view.dart';

class MediaResourceMainPanel extends StatelessWidget {
  final MediaResource mediaResource;

  const MediaResourceMainPanel({super.key, required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    if (mediaResource.isVideo == false) {
      if (mediaResource.isAeb == true &&
          ((mediaResource as AebPhotoResource).aebFiles.length > 1)) {
        return AebPhotoView(photoResource: mediaResource as AebPhotoResource);
      } else {
        return NormalPhotoView(
            photoResource: mediaResource as NormalPhotoResource);
      }
    } else if (mediaResource.isVideo == true) {
      return NormalVideoView(
          videoResource: mediaResource as NormalVideoResource);
    }
    return const SizedBox();
  }
}

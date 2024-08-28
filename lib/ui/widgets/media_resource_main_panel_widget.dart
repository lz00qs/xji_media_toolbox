import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/aeb_photo_viewer_widget.dart';
import 'package:xji_footage_toolbox/ui/widgets/normal_photo_viewer_widget.dart';

import 'normal_video_viewer_widget.dart';

class MediaResourceMainPanelWidget extends StatelessWidget {
  final MediaResource mediaResource;

  const MediaResourceMainPanelWidget({super.key, required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    if (mediaResource.isVideo == false) {
      if (mediaResource.isAeb == false) {
        return NormalPhotoViewerWidget(
            photoResource: mediaResource as NormalPhotoResource);
      } else {
        return AebPhotoViewerWidget(
            photoResource: mediaResource as AebPhotoResource);
      }
    } else if (mediaResource.isVideo == true) {
      return NormalVideoViewerWidget(
          videoResource: mediaResource as NormalVideoResource);
    }
    return const SizedBox();
  }
}

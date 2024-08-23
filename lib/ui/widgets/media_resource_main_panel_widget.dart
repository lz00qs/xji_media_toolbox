import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/normal_photo_viewer_widget.dart';

class MediaResourceMainPanelWidget extends StatelessWidget {
  final MediaResource mediaResource;

  const MediaResourceMainPanelWidget({super.key, required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    if (mediaResource is NormalPhotoResource) {
      return NormalPhotoViewerWidget(
          photoResource: mediaResource as NormalPhotoResource);
    } else if (mediaResource is AebPhotoResource) {
      return const SizedBox();
    } else if (mediaResource is NormalVideoResource) {
      return const SizedBox();
    }
    return const SizedBox();
  }
}

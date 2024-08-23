import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/photo_viewer_widget.dart';
import 'package:xji_footage_toolbox/ui/widgets/right_app_bar_media_delete_button.dart';

import '../../constants.dart';

class _NormalPhotoViewerAppBarWidget extends StatelessWidget {
  const _NormalPhotoViewerAppBarWidget();

  @override
  Widget build(BuildContext context) {
    var appBarHeight = macAppBarHeight;
    if (GetPlatform.isWindows) {
      /// todo: implement windows app bar height
    }

    return SizedBox(
      height: appBarHeight,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RightAppBarMediaDeleteButton(),
        ],
      ),
    );
  }
}

class NormalPhotoViewerWidget extends StatelessWidget {
  final NormalPhotoResource photoResource;

  const NormalPhotoViewerWidget({super.key, required this.photoResource});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _NormalPhotoViewerAppBarWidget(),
        Expanded(
          child: Center(
            child: PhotoViewerWidget(photoFile: photoResource.file),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:xji_footage_toolbox/footage.dart';

class NormalPhotoEditorWidget extends StatelessWidget {
  const NormalPhotoEditorWidget({super.key, required this.footage});

  final Footage footage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          // windows 和 macos size 做区分
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.help),
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(margin: const EdgeInsets.all(20),
            child: ClipRect(
              child: PhotoView(
                  initialScale: PhotoViewComputedScale.contained,
                  controller: PhotoViewController(),
                  backgroundDecoration:
                  const BoxDecoration(color: Colors.transparent),
                  imageProvider: FileImage(footage.file)),
            ),
          ),),
        );
  }
}

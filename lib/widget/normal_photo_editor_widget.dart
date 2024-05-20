import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/footage.dart';

class NormalPhotoEditorWidget extends StatelessWidget {
  const NormalPhotoEditorWidget({super.key, required this.footage});

  final Footage footage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRect(
                child: ExtendedImage.file(
                  footage.file,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (state) {
                    return GestureConfig(
                      minScale: 1.0,
                      animationMinScale: 0.7,
                      maxScale: 10.0,
                      animationMaxScale: 10.0,
                      speed: 1.0,
                      inertialSpeed: 100.0,
                      initialScale: 1.0,
                      inPageView: false,
                      initialAlignment: InitialAlignment.center,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

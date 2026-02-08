import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'design_tokens.dart';

class PhotoViewer extends StatelessWidget {
  final File photoFile;

  const PhotoViewer({super.key, required this.photoFile});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.all(
                Radius.circular(DesignValues.smallBorderRadius)),
            child: ExtendedImage.file(
              photoFile,
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
        );
      },
    );
  }
}

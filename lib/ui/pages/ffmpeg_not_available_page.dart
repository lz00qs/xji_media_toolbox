import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

class FFmpegNotAvailablePage extends StatelessWidget {
  const FFmpegNotAvailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorDark.bg0,
      body: Center(
          child: SelectionArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FFmpeg or FFprobe is not available!',
              style: SemiTextStyles.header2ENRegular
                  .copyWith(color: ColorDark.text0),
            ),
            SizedBox(height: DesignValues.mediumPadding),
            Text(
              'The bundled FFmpeg runtime could not be started.',
              style: SemiTextStyles.header4ENRegular
                  .copyWith(color: ColorDark.text1),
            ),
            SizedBox(height: DesignValues.mediumPadding),
            Text(
              'Open Settings > Advanced to select a custom FFmpeg directory.',
              style: SemiTextStyles.header4ENRegular
                  .copyWith(color: ColorDark.text1),
            ),
            SizedBox(height: DesignValues.mediumPadding),
            Text(
              'The directory must contain compatible ffmpeg and ffprobe executables.',
              style: SemiTextStyles.header4ENRegular
                  .copyWith(color: ColorDark.warning),
            ),
          ],
        ),
      )),
    );
  }
}

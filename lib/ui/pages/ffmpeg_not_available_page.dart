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
              'For MacOS: brew install ffmpeg',
              style: SemiTextStyles.header4ENRegular
                  .copyWith(color: ColorDark.text1),
            ),
            SizedBox(height: DesignValues.mediumPadding),
            Text(
              'For Linux: sudo apt install ffmpeg',
              style: SemiTextStyles.header4ENRegular
                  .copyWith(color: ColorDark.text1),
            ),
            SizedBox(height: DesignValues.mediumPadding),
            Text(
              'For Windows: https://ffmpeg.org/download.html',
              style: SemiTextStyles.header4ENRegular
                  .copyWith(color: ColorDark.text1),
            ),
            SizedBox(height: DesignValues.mediumPadding),
            Text(
              'After installation, restart this APP!',
              style: SemiTextStyles.header4ENRegular
                  .copyWith(color: ColorDark.warning),
            ),
          ],
        ),
      )),
    );
  }
}

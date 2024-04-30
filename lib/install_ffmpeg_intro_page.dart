// A page that tells the user how to install FFmpeg.

import 'package:flutter/material.dart';

class InstallFFmpegIntroPage extends StatelessWidget {
  const InstallFFmpegIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Install FFmpeg'),
      ),
      body: const Center(
          child: SelectionArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('FFmpeg is not available', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('For MacOS: brew install ffmpeg'),
            SizedBox(height: 10),
            Text('For Linux: sudo apt install ffmpeg'),
            SizedBox(height: 10),
            Text('For Windows: https://ffmpeg.org/download.html'),
            SizedBox(height: 20),
            Text(
              'After installation, restart the app',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';

class FFmpegNotAvailablePage extends StatelessWidget {
  const FFmpegNotAvailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FFmpeg or FFprobe is not available'),
      ),
      body: const Center(
          child: SelectionArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text('For MacOS: brew install ffmpeg'),
            SizedBox(height: 10),
            Text('For Linux: sudo apt install ffmpeg'),
            SizedBox(height: 10),
            Text('For Windows: https://ffmpeg.org/download.html'),
            SizedBox(height: 20),
            Text(
              'After installation, restart this APP!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      )),
    );
  }
}

import 'dart:io';


Future<bool> hasFFmpeg() async {
  final result = await Process.run('ffmpeg', ['-version']);
  if (result.exitCode == 0) {
    return true;
  }
  return false;
}

bool isMediaFile(Uri uri) {
  final ext = uri.path.split('.').last.toUpperCase();
  return ext == 'MP4' || ext == 'JPG' || ext == 'DNG';
}

bool isFileExist(String path) {
  final file = File(path);
  return file.existsSync();
}



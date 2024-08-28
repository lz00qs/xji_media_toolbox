import 'dart:io';

/// 检查系统是否拥有 FFmpeg 以及 FFprobe
Future<bool> hasFFmpegAndFFprobe() async {
  var result = await Process.run('ffmpeg', ['-version']);
  if (result.exitCode != 0) {
    return false;
  }
  result = await Process.run('ffprobe', ['-version']);
  if (result.exitCode != 0) {
    return false;
  }
  return true;
}

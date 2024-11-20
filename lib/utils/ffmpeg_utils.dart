import 'dart:io';

class FFmpegUtils {
  static var ffmpeg = '';
  static var ffprobe = '';

  static Future<bool> checkFFmpeg() async {
    if (Platform.isMacOS) {
      if (File('/opt/homebrew/bin/ffmpeg').existsSync() &&
          File('/opt/homebrew/bin/ffprobe').existsSync()) {
        ffmpeg = '/opt/homebrew/bin/ffmpeg';
        ffprobe = '/opt/homebrew/bin/ffprobe';
        return true;
      } else if (File('/usr/bin/ffmpeg').existsSync() &&
          File('/usr/bin/ffprobe').existsSync()) {
        ffmpeg = '/usr/bin/ffmpeg';
        ffprobe = '/usr/bin/ffprobe';
        return true;
      }
    } else if (Platform.isWindows) {
      if (File('assets/windows/ffmpeg/ffmpeg.exe').existsSync() &&
          File('assets/windows/ffmpeg/ffprobe.exe').existsSync()) {
        ffmpeg = 'assets/windows/ffmpeg/ffmpeg.exe';
        ffprobe = 'assets/windows/ffmpeg/ffprobe.exe';
        return true;
      }
    }
    return false;
  }
}

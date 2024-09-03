import 'dart:io';

import 'package:get/get.dart';
import 'package:xji_footage_toolbox/controllers/global_settings_controller.dart';

/// 检查系统是否拥有 FFmpeg 以及 FFprobe
Future<bool> hasFFmpegAndFFprobe() async {
  final GlobalSettingsController globalSettingsController =
      Get.find<GlobalSettingsController>();
  if (Platform.isMacOS) {
    if (File('/opt/homebrew/bin/ffmpeg').existsSync() &&
        File('/opt/homebrew/bin/ffprobe').existsSync()) {
      globalSettingsController.ffmpegParentDir = '/opt/homebrew/bin/';
      return true;
    } else if (File('/usr/bin/ffmpeg').existsSync() &&
        File('/usr/bin/ffprobe').existsSync()) {
      globalSettingsController.ffmpegParentDir = '/usr/bin/';
      return true;
    }
  } else if (Platform.isWindows) {
    /// todo: windows ffmpeg detect
    return false;
  }
  return false;
}

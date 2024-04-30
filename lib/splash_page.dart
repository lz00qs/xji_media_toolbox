import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/global_controller.dart';

import 'install_ffmpeg_intro_page.dart';
import 'main_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalController controller = Get.find();
    return Obx(() => (controller.hasFFmpeg.value)
        ? const MainPage()
        : const InstallFFmpegIntroPage());
    // return Obx(() => (controller.hasFFmpeg.value)
    //     ? TestPage()
    //     : const InstallFFmpegIntroPage());
  }
}

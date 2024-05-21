import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/global_controller.dart';
import 'package:xji_footage_toolbox/loading_footage_page.dart';

import 'install_ffmpeg_intro_page.dart';
import 'main_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalController controller = Get.find();
    // return Obx(() => (controller.hasFFmpeg.value)
    //     ? const MainPage()
    //     : const InstallFFmpegIntroPage());
    // return Obx(() => (controller.hasFFmpeg.value)
    //     ? TestPage()
    //     : const InstallFFmpegIntroPage());
    return Obx(() {
      if (controller.hasFFmpeg.value) {
        if (controller.isLoadingFootage.value) {
          return const LoadingFootagePage();
        }
        return const MainPage();
      } else {
        return const InstallFFmpegIntroPage();
      }
    });
  }
}

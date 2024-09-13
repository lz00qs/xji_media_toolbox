import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xji_footage_toolbox/controllers/global_media_resources_controller.dart';
import 'package:xji_footage_toolbox/controllers/global_tasks_controller.dart';
import 'package:xji_footage_toolbox/ui/pages/ffmpeg_not_available_page.dart';
import 'package:xji_footage_toolbox/ui/pages/loading_media_resources_page.dart';
import 'package:xji_footage_toolbox/ui/pages/main_page.dart';
import 'package:xji_footage_toolbox/utils/ffmpeg_utils.dart';

import 'controllers/global_settings_controller.dart';
import 'new_ui/task_drawer.dart';

Future<void> main() async {
  // 确保 WidgetsFlutterBinding 已经初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 WindowManager
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1280, 720),
    size: Size(1280, 720),
    center: false,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  Get.put(GlobalMediaResourcesController());

  final packageInfo = await PackageInfo.fromPlatform();

  final globalSettingsController = Get.put(GlobalSettingsController());
  globalSettingsController.cpuThreads = Platform.numberOfProcessors;
  globalSettingsController.appVersion = packageInfo.version;
  await globalSettingsController.loadSettings();

  final isFFmpegAvailable = await hasFFmpegAndFFprobe();

  runApp(MyApp(isFFmpegAvailable: isFFmpegAvailable));
}

class MyApp extends StatelessWidget {
  final bool isFFmpegAvailable;

  const MyApp({super.key, required this.isFFmpegAvailable});

  @override
  Widget build(BuildContext context) {
    final LoadingMediaResourcesController loadingMediaResourcesController =
        Get.find<LoadingMediaResourcesController>();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        endDrawer: const TaskDrawer(),
        body: isFFmpegAvailable
            ? Obx(() =>
                loadingMediaResourcesController.isLoadingMediaResources.value
                    ? const LoadingMediaResourcesPage()
                    : const MainPage())
            : const FFmpegNotAvailablePage(),
      ),
    );
  }
}

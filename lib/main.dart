import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xji_footage_toolbox/controllers/global_media_resources_controller.dart';
import 'package:xji_footage_toolbox/service/log_service.dart';
import 'package:xji_footage_toolbox/ui/pages/ffmpeg_not_available_page.dart';
import 'package:xji_footage_toolbox/ui/pages/loading_media_resources_page.dart';
import 'package:xji_footage_toolbox/ui/pages/main_page.dart';
import 'package:xji_footage_toolbox/ui/widgets/main_page_app_bar.dart';
import 'package:xji_footage_toolbox/utils/ffmpeg_utils.dart';
import 'package:fvp/fvp.dart' as fvp;

import 'controllers/global_settings_controller.dart';
import 'ui/widgets/task_drawer.dart';

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
    windowButtonVisibility: true, // 仅对 macos 有效
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  fvp.registerWith(options: {
    'platforms': ['windows']
  }); // only these platforms will use this plugin implementation

  if (kDebugMode) {
    LogService.isDebug = true;
  }

  Get.put(GlobalMediaResourcesController());

  final packageInfo = await PackageInfo.fromPlatform();

  final globalSettingsController = Get.put(GlobalSettingsController());
  globalSettingsController.cpuThreads = Platform.numberOfProcessors;
  globalSettingsController.appVersion = packageInfo.version;
  await globalSettingsController.loadSettings();

  final isFFmpegAvailable = await FFmpegUtils.checkFFmpeg();

  runApp(MyApp(isFFmpegAvailable: isFFmpegAvailable));
}

class MyApp extends StatelessWidget {
  final bool isFFmpegAvailable;

  const MyApp({super.key, required this.isFFmpegAvailable});

  @override
  Widget build(BuildContext context) {
    final LoadingMediaResourcesController loadingMediaResourcesController =
        Get.find<LoadingMediaResourcesController>();
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            endDrawer: const TaskDrawer(),
            body: Center(
              child: Column(children: [
                const MainPageAppBar(),
                Expanded(
                  child: isFFmpegAvailable
                      ? Obx(() => loadingMediaResourcesController
                              .isLoadingMediaResources.value
                          ? const LoadingMediaResourcesPage()
                          : const MainPage())
                      : const FFmpegNotAvailablePage(),
                )
              ]),
            )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xji_footage_toolbox/global_controller.dart';
import 'package:xji_footage_toolbox/splash_page.dart';
import 'package:xji_footage_toolbox/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.setMinimumSize(const Size(1280, 720));
  await windowManager.setTitleBarStyle(TitleBarStyle.hidden);

  final controller = GlobalController();
  await controller.loadSettings();
  // detect if FFmpeg is available
  controller.hasFFmpeg.value = await hasFFmpeg();
  Get.put(controller);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}

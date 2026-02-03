import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xji_footage_toolbox/objectbox.dart';
import 'package:fvp/fvp.dart' as fvp;

// todo:
// 1. 修正所有不在 build 中的 ref.watch 调用
// 2. 使用 freezed 生成 state

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

  // if (kDebugMode) {
  //   LogService.isDebug = true;
  // }
  //
  // final isFFmpegAvailable = await FFmpegUtils.checkFFmpeg();

  // await ObjectBox.create();

  runApp(
    ToastificationWrapper(child: ProviderScope(child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp(isFFmpegAvailable: false),
        )))
  );
}

class MyApp extends ConsumerWidget {
  final bool isFFmpegAvailable;

  const MyApp({super.key, required this.isFFmpegAvailable});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isLoading =
    //     ref.watch(mediaResourcesProvider.select((state) => state.isLoading));
    //
    // return Scaffold(
    //   endDrawer: const TaskDrawer(),
    //   body: Center(
    //     child: Column(
    //       children: [
    //         const MainPageAppBar(),
    //         Expanded(
    //             // child: ResizablePanel(),)
    //             child: isFFmpegAvailable
    //                 ? isLoading
    //                     ? const LoadingMediaResourcesPage()
    //                     : MainPage(mainRef: ref)
    //                 : const FFmpegNotAvailablePage())
    //       ],
    //     ),
    //   ),
    // );
    return SizedBox();
  }
}

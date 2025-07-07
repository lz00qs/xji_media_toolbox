import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../design_tokens.dart';
import '../buttons/custom_icon_button.dart';
import 'main_panel.dart';

class _ChewieVideoPlayerHook extends HookWidget {
  final File videoFile;
  final bool showControls;

  const _ChewieVideoPlayerHook({
    required this.videoFile,
    this.showControls = true,
  });

  @override
  Widget build(BuildContext context) {
    final videoController = useMemoized(
      () => VideoPlayerController.file(videoFile),
      [videoFile.path], // 重建依赖
    );
    final chewieController = useState<ChewieController?>(null);
    final isInitialized = useState(false);

    useEffect(() {
      bool mounted = true;

      Future<void> init() async {
        await videoController.initialize();
        if (!mounted) return;

        chewieController.value = ChewieController(
          videoPlayerController: videoController,
          autoPlay: false,
          looping: false,
          showControls: showControls,
        );

        isInitialized.value = true;
      }

      init();

      return () {
        mounted = false;
        videoController.dispose();
        chewieController.value?.dispose();
      };
    }, [videoFile.path]);

    return ClipRRect(
      borderRadius:
          BorderRadius.all(Radius.circular(DesignValues.smallBorderRadius)),
      child: isInitialized.value
          ? Chewie(controller: chewieController.value!)
          : const Center(
              child: CircularProgressIndicator(
              color: ColorDark.primary,
            )),
    );

    // return AspectRatio(
    //   aspectRatio: isInitialized.value
    //       ? videoController.value.aspectRatio
    //       : 16 / 9,
    //   child: isInitialized.value && chewieController.value != null
    //       ? Chewie(controller: chewieController.value!)
    //       : const Center(child: CircularProgressIndicator()),
    // );
  }
}

class ChewieVideoPlayer extends ConsumerWidget {
  final File videoFile;

  const ChewieVideoPlayer({super.key, required this.videoFile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(DesignValues.smallPadding),
            child: _ChewieVideoPlayerHook(
              videoFile: videoFile,
              showControls: true,
            ),
            // child: VideoPlayerGetx(videoResource: videoResource)
          ),
        ),
        MainPanelSideBar(
          children: [
            const MainPanelSideBarControlButtons(),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.cut,
                onPressed: () async {
                  // final GlobalMediaResourcesController
                  // globalMediaResourcesController =
                  // Get.find<GlobalMediaResourcesController>();
                  // globalMediaResourcesController.isEditingMediaResources.value =
                  // true;
                },
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.appBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.upload,
                onPressed: () async {
                  // await Get.dialog(const VideoExportDialog());
                },
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.appBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
          ],
        ),
      ],
    );
  }
}

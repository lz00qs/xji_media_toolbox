import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';

import '../../design_tokens.dart';

class ChewieVideoPlayerHook extends HookWidget {
  final File videoFile;
  final bool showControls;

  const ChewieVideoPlayerHook({
    super.key,
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
  }
}

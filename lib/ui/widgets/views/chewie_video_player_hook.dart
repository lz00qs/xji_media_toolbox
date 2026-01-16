import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

import '../../design_tokens.dart';

part 'chewie_video_player_hook.g.dart';

class _ChewieVideoPlayerState {
  final bool isInitialized;
  final ChewieController? chewieController;

  const _ChewieVideoPlayerState({
    required this.isInitialized,
    required this.chewieController,
  });

  _ChewieVideoPlayerState copyWith({
    bool? isInitialized,
    ChewieController? chewieController,
  }) {
    return _ChewieVideoPlayerState(
      isInitialized: isInitialized ?? this.isInitialized,
      chewieController: chewieController ?? this.chewieController,
    );
  }
}

@riverpod
class _ChewieVideoPlayerController
    extends _$ChewieVideoPlayerController {
  late final VideoPlayerController _videoController;

  @override
  _ChewieVideoPlayerState build({
    required File videoFile,
    required bool showControls,
  }) {
    _videoController = VideoPlayerController.file(videoFile);

    _init(videoFile, showControls);

    ref.onDispose(() {
      _videoController.dispose();
      state.chewieController?.dispose();
    });

    return const _ChewieVideoPlayerState(
      isInitialized: false,
      chewieController: null,
    );
  }

  Future<void> _init(File videoFile, bool showControls) async {
    await _videoController.initialize();

    final chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      showControls: showControls,
    );

    state = state.copyWith(
      isInitialized: true,
      chewieController: chewieController,
    );
  }
}

class ChewieVideoPlayer extends ConsumerWidget {
  final File videoFile;
  final bool showControls;

  const ChewieVideoPlayer({
    super.key,
    required this.videoFile,
    this.showControls = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      _chewieVideoPlayerControllerProvider(
        videoFile: videoFile,
        showControls: showControls,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(DesignValues.smallBorderRadius),
      ),
      child: state.isInitialized
          ? Chewie(controller: state.chewieController!)
          : const Center(
        child: CircularProgressIndicator(
          color: ColorDark.primary,
        ),
      ),
    );
  }
}

// class ChewieVideoPlayerHook extends HookWidget {
//   final File videoFile;
//   final bool showControls;
//
//   const ChewieVideoPlayerHook({
//     super.key,
//     required this.videoFile,
//     this.showControls = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final videoController = useMemoized(
//       () => VideoPlayerController.file(videoFile),
//       [videoFile.path], // 重建依赖
//     );
//     final chewieController = useState<ChewieController?>(null);
//     final isInitialized = useState(false);
//
//     useEffect(() {
//       bool mounted = true;
//
//       Future<void> init() async {
//         await videoController.initialize();
//         if (!mounted) return;
//
//         chewieController.value = ChewieController(
//           videoPlayerController: videoController,
//           autoPlay: false,
//           looping: false,
//           showControls: showControls,
//         );
//
//         isInitialized.value = true;
//       }
//
//       init();
//
//       return () {
//         mounted = false;
//         videoController.dispose();
//         chewieController.value?.dispose();
//       };
//     }, [videoFile.path]);
//
//     return ClipRRect(
//       borderRadius:
//           BorderRadius.all(Radius.circular(DesignValues.smallBorderRadius)),
//       child: isInitialized.value
//           ? Chewie(controller: chewieController.value!)
//           : const Center(
//               child: CircularProgressIndicator(
//               color: ColorDark.primary,
//             )),
//     );
//   }
// }

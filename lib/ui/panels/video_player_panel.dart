import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:xji_footage_toolbox/models/media_resource.model.dart';
import 'package:xji_footage_toolbox/models/video_task.dart';
import 'package:xji_footage_toolbox/ui/panels/video_panel.dart';

import '../../providers/task_scheduler.dart';
import '../buttons/custom_icon_button.dart';
import '../design_tokens.dart';
import '../dialogs/video_export_dialog.dart';
import 'main_panel.dart';

part 'video_player_panel.freezed.dart';

part 'video_player_panel.g.dart';

@freezed
abstract class _VideoPlayerPanelState with _$VideoPlayerPanelState {
  const factory _VideoPlayerPanelState({
    @Default(null) ChewieController? chewieController,
  }) = __VideoPlayerPanelState;
}

@riverpod
class _VideoPlayerPanelStateNotifier extends _$VideoPlayerPanelStateNotifier {
  late final VideoPlayerController _videoController;
  late final ChewieController _chewieController;

  @override
  Future<_VideoPlayerPanelState> build({
    required File videoFile,
  }) async {
    _videoController = VideoPlayerController.file(videoFile);
    await _videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      showControls: true,
    );
    ref.onDispose(() async {
      await _videoController.dispose();
      _chewieController.dispose();
    });
    return _VideoPlayerPanelState(chewieController: _chewieController);
  }
}

class VideoPlayerPanel extends ConsumerWidget {
  const VideoPlayerPanel({
    super.key,
    required this.videoResource,
  });

  final VideoResource videoResource;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoPlayerPanelStateAsync = ref
        .watch(_videoPlayerPanelStateProvider(videoFile: videoResource.file));
    return videoPlayerPanelStateAsync.when(
      data: (data) {
        // return ClipRRect(
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(DesignValues.smallBorderRadius),
        //   ),
        //   child: Chewie(controller: data.chewieController!,),
        // );
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(DesignValues.smallPadding),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(DesignValues.smallBorderRadius),
                  ),
                  child: Chewie(
                    controller: data.chewieController!,
                  ),
                ),
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
                      ref.read(videoPanelProvider.notifier).toggle();
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
                      final task = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return VideoExportDialog(
                              videoResource: videoResource,
                              taskType: VideoTaskType.transcode,
                            );
                          });
                      if (task != null) {
                        ref
                            .read(taskSchedulerProvider.notifier)
                            .addTask(task);
                      }
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
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
    );
  }
}

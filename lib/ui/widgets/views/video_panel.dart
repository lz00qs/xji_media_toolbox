import 'dart:io';

import 'package:flutter/Material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/video_player_panel.dart';

class VideoPanel extends ConsumerWidget {
  final File videoFile;

  const VideoPanel({super.key, required this.videoFile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing =
        ref.watch(mediaResourcesProvider.select((state) => state.isEditing));
    return isEditing ? Container() : VideoPlayerPanel(videoFile: videoFile);
  }
}

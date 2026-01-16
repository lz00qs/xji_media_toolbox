import 'dart:io';

import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/video_player.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/video_trimmer_panel.dart';

import '../../../providers/media_resources_provider.dart';

class VideoPanel extends ConsumerWidget {
  final File videoFile;

  const VideoPanel({super.key, required this.videoFile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing =
        ref.watch(mediaResourcesProvider.select((state) => state.isEditing));
    return isEditing
        ? VideoTrimmerPanel()
        : VideoPlayer(videoFile: videoFile);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/models/media_resource.model.dart';
import 'package:xji_footage_toolbox/ui/panels/video_player_panel.dart';
import 'package:xji_footage_toolbox/ui/panels/video_trimmer_panel.dart';

part 'video_panel.g.dart';

@riverpod
class VideoPanelNotifier extends _$VideoPanelNotifier {
  @override
  bool build(String videoPath) => false;

  void toggle() {
    state = !state;
  }
}

class VideoPanel extends ConsumerWidget {
  final VideoResource resource;

  const VideoPanel({super.key, required this.resource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showTrimmer = ref.watch(videoPanelProvider(resource.file.path));
    return showTrimmer
        ? VideoTrimmerPanel(resource: resource)
        : VideoPlayerPanel(videoResource: resource);
  }
}

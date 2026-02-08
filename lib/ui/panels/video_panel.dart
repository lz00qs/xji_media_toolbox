import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xji_footage_toolbox/models/media_resource.model.dart';
import 'package:xji_footage_toolbox/ui/panels/video_player_panel.dart';

part 'video_panel.g.dart';

@riverpod
class VideoPanelState extends _$VideoPanelState {
  @override
  bool build() => false;
}

class VideoPanel extends ConsumerWidget {
  final MediaResource resource;

  const VideoPanel({super.key, required this.resource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VideoPlayerPanel(
      videoFile: resource.file,
    );
  }
}

import 'dart:io';

abstract class MediaResource {
  final bool isVideo;
  final String name;
  final File file;
  final int width;
  final int height;
  final int sizeInBytes;
  final DateTime creationTime;
  final int sequence;
  final isAeb = false;
  File? thumbFile;
  final Map<int, List<String>> errors = {};
  bool hide = false;

  MediaResource(
      {required this.isVideo,
      required this.name,
      required this.file,
      required this.width,
      required this.height,
      required this.sizeInBytes,
      required this.creationTime,
      required this.sequence});
}

class NormalPhotoResource extends MediaResource {
  NormalPhotoResource(
      {required super.name,
      required super.file,
      required super.width,
      required super.height,
      required super.sizeInBytes,
      required super.creationTime,
      required super.sequence})
      : super(isVideo: false);
}

class AebPhotoResource extends NormalPhotoResource {
  final String evBias;
  final List<MediaResource> aebResources = [];

  @override
  get isAeb => true;

  AebPhotoResource({
    required super.name,
    required super.file,
    required super.width,
    required super.height,
    required super.sizeInBytes,
    required super.creationTime,
    required super.sequence,
    required this.evBias,
  });
}

class NormalVideoResource extends MediaResource {
  final double frameRate;
  final Duration duration;
  final bool isHevc;

  NormalVideoResource(
      {required super.name,
      required super.file,
      required super.width,
      required super.height,
      required super.sizeInBytes,
      required super.creationTime,
      required super.sequence,
      required this.frameRate, // fps
      required this.duration,
      required this.isHevc})
      : super(isVideo: true);
}

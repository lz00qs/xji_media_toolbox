import 'dart:io';

class Footage {
  final String name;
  final File file;
  File? thumbFile;
  final bool isVideo;

  Footage({required this.file})
      : name = file.uri.pathSegments.last,
        isVideo = file.uri.pathSegments.last.endsWith('.MP4');
}

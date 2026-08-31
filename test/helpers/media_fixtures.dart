import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:xji_footage_toolbox/models/media_resource.model.dart';

PhotoResource photoFixture({
  String name = 'photo.JPG',
  File? file,
  int width = 4000,
  int height = 3000,
  int sizeInBytes = 1024,
  DateTime? creationTime,
  int sequence = 1,
  Map<int, List<String>> errors = const {},
}) {
  final source = file ?? File(p.join('/fixtures', name));
  return PhotoResource(
    name: name,
    file: source,
    width: width,
    height: height,
    sizeInBytes: sizeInBytes,
    creationTime: creationTime ?? DateTime(2024, 1, 1),
    sequence: sequence,
    thumbFile: source,
    errors: errors,
  );
}

VideoResource videoFixture({
  String name = 'video.MP4',
  File? file,
  File? thumbFile,
  int width = 3840,
  int height = 2160,
  int sizeInBytes = 2048,
  DateTime? creationTime,
  int sequence = 1,
  Duration duration = const Duration(seconds: 10),
  double frameRate = 30,
  bool isHevc = true,
  Map<int, List<String>> errors = const {},
}) {
  final source = file ?? File(p.join('/fixtures', name));
  return VideoResource(
    name: name,
    file: source,
    width: width,
    height: height,
    sizeInBytes: sizeInBytes,
    creationTime: creationTime ?? DateTime(2024, 1, 1),
    sequence: sequence,
    thumbFile: thumbFile ?? File(p.join('/fixtures', '$name.thumb.JPG')),
    duration: duration,
    frameRate: frameRate,
    isHevc: isHevc,
    errors: errors,
  );
}

AebPhotoResource aebPhotoFixture({
  String name = 'aeb.JPG',
  File? file,
  String evBias = '0',
  int sequence = 1,
  List<AebPhotoResource> aebResources = const [],
  Map<int, List<String>> errors = const {},
}) {
  final source = file ?? File(p.join('/fixtures', name));
  return AebPhotoResource(
    name: name,
    file: source,
    width: 4000,
    height: 3000,
    sizeInBytes: 1024,
    creationTime: DateTime(2024, 1, 1),
    sequence: sequence,
    thumbFile: source,
    evBias: evBias,
    aebResources: aebResources,
    errors: errors,
  );
}

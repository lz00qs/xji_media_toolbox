import 'dart:io';

import 'package:xji_footage_toolbox/constants.dart';

class Footage {
  final String name;
  final File file;
  File? thumbFile;
  final bool isVideo;
  bool isAeb = false;
  final List<File> aebFiles = [];
  late final DateTime time;
  late final int sequence;
  final Map<int, List<String>> errors = {};
  bool hide = false;

  Footage({required this.file})
      : name = file.uri.pathSegments.last,
        isVideo = file.uri.pathSegments.last.endsWith('.MP4') {
    RegExp regex = RegExp(r'DJI_(\d{14})_(\d{4})_D.JPG');

    Match? match = regex.firstMatch(name);
    if (match != null) {
      try {
        time = DateTime.parse(match.group(1)!);
      } catch (e) {
        errors[parseFootageErrorCode] = [parseFootageTimeError];
        time = file.lastModifiedSync();
      }
      try {
        sequence = int.parse(match.group(2)!);
      } catch (e) {
        if (errors.containsKey(parseFootageErrorCode)) {
          errors[parseFootageErrorCode]!.add(parseFootageSequenceError);
        } else {
          errors[parseFootageErrorCode] = [parseFootageSequenceError];
        }
        sequence = 0;
      }
    } else {
      errors[parseFootageErrorCode] = [
        parseFootageTimeError,
        parseFootageSequenceError
      ];
      time = file.lastModifiedSync();
      sequence = 0;
    }
  }
}

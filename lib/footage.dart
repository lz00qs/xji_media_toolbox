import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:xji_footage_toolbox/constants.dart';

class Footage {
  final RxString name = ''.obs;
  File file;
  File? thumbFile;
  final bool isVideo;
  bool isAeb = false;
  final List<File> aebFiles = [];
  late final DateTime time;
  late final int sequence;
  final Map<int, List<String>> errors = {};
  bool hide = false;
  int height = 0;
  int width = 0;
  int sizeInBytes = 0;
  double frameRate = 0.0; // fps
  double duration = 0.0; // seconds
  bool isHevc = false;
  String evBias = '';

  Footage({required this.file})
      : isVideo = file.uri.pathSegments.last.toUpperCase().endsWith('.MP4') {
    name.value = file.uri.pathSegments.last;
    RegExp regex = RegExp(r'DJI_(\d{14})_(\d{4})_D');

    Match? match = regex.firstMatch(name.value);
    if (match != null) {
      try {
        time = DateTime.parse(
            ('${match.group(1)!.substring(0, 8)}T${match.group(1)!.substring(8)}'));
      } catch (e) {
        errors[parseFootageErrorCode] = [parseFootageTimeError];
        if (kDebugMode) {
          print('Parse footage time error: $e');
        }
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

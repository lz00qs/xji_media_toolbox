String formatDuration(Duration duration, {bool showMilliseconds = false}) {
  return '${duration.inHours}:'
      '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
      '${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}'
      '${showMilliseconds ? '.${duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')}' : ''}';
}

String formatSize(int sizeInBytes) {
  if (sizeInBytes < 1024) {
    return '$sizeInBytes B';
  } else if (sizeInBytes < 1024 * 1024) {
    return '${(sizeInBytes / 1024).toStringAsFixed(2)} KB';
  } else if (sizeInBytes < 1024 * 1024 * 1024) {
    return '${(sizeInBytes / 1024 / 1024).toStringAsFixed(2)} MB';
  } else {
    return '${(sizeInBytes / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
  }
}

String parseAebEvBias(int index) {
  switch (index) {
    case 0:
      return '0.0';
    case 1:
      return '-0.7';
    case 2:
      return '+0.7';
    case 3:
      return '-1.3';
    case 4:
      return '+1.3';
    case 5:
      return '-2.0';
    case 6:
      return '+2.0';
    default:
      return '0.0';
  }
}

import 'dart:io';

bool isFileExist(String path) {
  final file = File(path);
  return file.existsSync();
}

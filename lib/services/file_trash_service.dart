import 'dart:io';

import 'package:flutter/services.dart';

abstract interface class FileTrashService {
  Future<void> moveFileToTrash(File file);
}

final class PlatformFileTrashService implements FileTrashService {
  const PlatformFileTrashService();

  static const _channel = MethodChannel('xji_footage_toolbox/file_trash');

  @override
  Future<void> moveFileToTrash(File file) async {
    if (!Platform.isMacOS && !Platform.isWindows) {
      throw UnsupportedError(
        'Moving files to the system trash is not supported on '
        '${Platform.operatingSystem}.',
      );
    }
    if (!await file.exists()) {
      throw FileSystemException('File does not exist', file.path);
    }

    await _channel.invokeMethod<void>('moveToTrash', {'path': file.path});
  }
}

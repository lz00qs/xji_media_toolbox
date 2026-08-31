import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:xji_footage_toolbox/utils/tools.dart';

import '../helpers/test_environment.dart';

void main() {
  test(
    'isFileExist distinguishes files from missing paths and directories',
    () async {
      final directory = await createTestDirectory('tools-test');
      addTearDown(() => deleteTestDirectory(directory));
      final file = File(p.join(directory.path, 'media.mp4'));
      await file.writeAsString('data');

      expect(isFileExist(file.path), isTrue);
      expect(isFileExist(p.join(directory.path, 'missing.mp4')), isFalse);
      expect(isFileExist(directory.path), isFalse);
    },
  );
}

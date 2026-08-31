import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xji_footage_toolbox/utils/logger.dart';

import '../helpers/test_environment.dart';

void main() {
  late Directory temporaryDirectory;

  setUp(() async {
    await Logger.disableFileOutput();
    Logger.setLogLevel(LogLevel.info);
    temporaryDirectory = await createTestDirectory('logger-test');
  });

  tearDown(() async {
    await Logger.disableFileOutput();
    Logger.setLogLevel(LogLevel.info);
    await deleteTestDirectory(temporaryDirectory);
  });

  test(
    'writes messages at or above the configured level to one log file',
    () async {
      Logger.setLogLevel(LogLevel.warn);
      await Logger.enableFileOutput(temporaryDirectory.path);

      Logger.debug('hidden debug');
      Logger.info('hidden info');
      Logger.warn('visible warning');
      Logger.error('visible error', StateError('boom'));
      await Logger.disableFileOutput();

      final logFiles = temporaryDirectory.listSync().whereType<File>().toList();
      expect(logFiles, hasLength(1));
      final contents = await logFiles.single.readAsString();
      expect(contents, isNot(contains('hidden debug')));
      expect(contents, isNot(contains('hidden info')));
      expect(contents, contains('[WARN] visible warning'));
      expect(contents, contains('[ERROR] visible error'));
      expect(contents, contains('Bad state: boom'));
    },
  );

  test(
    'does not open a second file while file output is already enabled',
    () async {
      await Logger.enableFileOutput(temporaryDirectory.path);
      await Logger.enableFileOutput(temporaryDirectory.path);
      Logger.info('once');
      await Logger.disableFileOutput();

      final logFiles = temporaryDirectory.listSync().whereType<File>().toList();
      expect(logFiles, hasLength(1));
      expect(await logFiles.single.readAsString(), contains('once'));
    },
  );
}

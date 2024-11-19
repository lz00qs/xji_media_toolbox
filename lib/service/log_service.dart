import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class LogService {
  static final Logger _logger = Logger('Global');
  static late File _logFile;
  static bool isDebug = false;

  static Future<void> enableDebug(String logFileDir) async {
    isDebug = true;
    Logger.root.level = Level.ALL;
    // log 文件名为 yyyy-MM-dd-HH-mm-ss.log
    final logFileName =
        '${DateTime.now().toString().substring(0, 19).replaceAll(':', '-')}.log';
    _logFile = File('$logFileDir/$logFileName');
    print('Log file path: ${_logFile.path}');
    if (!await _logFile.exists()) {
      await _logFile.create(recursive: true);
    }

    Logger.root.onRecord.listen((record) async {
      final logMessage =
          '${record.time}: [${record.level.name}] ${record.loggerName} - ${record.message}\n';
      if (kDebugMode) {
        print(logMessage);
      }
      _appendToFile(logMessage);
    });
  }

  static Future<void> disableDebug() async {
    isDebug = false;
    Logger.root.clearListeners();
    Logger.root.level = Level.INFO;
  }

  static void _appendToFile(String logMessage) async {
    try {
      // await _logFile.writeAsString(logMessage, mode: FileMode.append);
      _logFile.writeAsStringSync(logMessage, mode: FileMode.append);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to write log to file: $e');
      }
    }
  }

  static void info(String message) {
    _logger.info(message);
  }

  static void warning(String message) {
    _logger.warning(message);
  }

  static void severe(String message) {
    _logger.severe(message);
  }

  static void shout(String message) {
    _logger.shout(message);
  }

  static void fine(String message) {
    _logger.fine(message);
  }

  static void finer(String message) {
    _logger.finer(message);
  }

  static void finest(String message) {
    _logger.finest(message);
  }
}

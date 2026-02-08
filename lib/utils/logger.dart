import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';


enum LogLevel {
  debug(0),
  info(1),
  warn(2),
  error(3),
  fatal(4);

  final int priority;
  const LogLevel(this.priority);
}


class Logger {
  Logger._();

  static final Logger instance = Logger._();

  LogLevel _logLevel = LogLevel.info;
  IOSink? _fileSink;

  static void setLogLevel(LogLevel level){
    instance._logLevel = level;
  }

  static void debug(String message, [Object? error, StackTrace? stack]) {
    instance._log(LogLevel.debug, message, error, stack);
  }

  static void info(String message) {
    instance._log(LogLevel.info, message);
  }

  static void warn(String message) {
    instance._log(LogLevel.warn, message);
  }

  static void error(String message, [Object? error, StackTrace? stack]) {
    instance._log(LogLevel.error, message, error, stack);
  }

  static void fatal(String message, [Object? error, StackTrace? stack]) {
    instance._log(LogLevel.fatal, message, error, stack);
  }

  void _log(
      LogLevel level,
      String message, [
        Object? error,
        StackTrace? stack,
      ]) {
    if (level.priority < _logLevel.priority) return;

    final time = DateTime.now().toIso8601String();
    final logLine = _format(time, level, message, error, stack);

    // 控制台
    if (kDebugMode) {
      // ignore: avoid_print
      print(logLine);
    }

    _fileSink?.writeln(logLine);
  }

  String _format(
      String time,
      LogLevel level,
      String message,
      Object? error,
      StackTrace? stack,
      ) {
    final buffer = StringBuffer()
      ..write('[$time]')
      ..write('[${level.name.toUpperCase()}] ')
      ..write(message);

    if (error != null) {
      buffer.write(' | error: $error');
    }

    if (stack != null) {
      buffer.write('\n$stack');
    }

    return buffer.toString();
  }

  /// 应用退出时调用
  static Future<void> dispose() async {
    await instance._fileSink?.flush();
    await instance._fileSink?.close();
  }

  static Future<void> enableFileOutput(String logPath) async {
    if (instance._fileSink != null) return;

    final logFileName =
        '${DateTime.now().toString().substring(0, 19).replaceAll(':', '').replaceAll(' ', '-')}.log';
    final logFile = File('$logPath/$logFileName');
    if (!await logFile.exists()) {
      await logFile.create(recursive: true);
    }
    instance._fileSink = logFile.openWrite(mode: FileMode.append);

    Logger.info('Log file output enabled');
  }

  static Future<void> disableFileOutput() async {
    await instance._fileSink?.flush();
    await instance._fileSink?.close();
    instance._fileSink = null;

    Logger.info('Log file output disabled');
  }
}

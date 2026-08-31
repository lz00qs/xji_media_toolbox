import 'dart:io';

import 'package:path/path.dart' as p;

Future<Directory> createTestDirectory(String prefix) {
  return Directory.systemTemp.createTemp('xji-$prefix-');
}

Future<void> deleteTestDirectory(Directory directory) async {
  if (await directory.exists()) {
    await directory.delete(recursive: true);
  }
}

Future<void> createFFmpegPlaceholders(Directory directory) async {
  final suffix = Platform.isWindows ? '.exe' : '';
  await File(p.join(directory.path, 'ffmpeg$suffix')).writeAsString('fake');
  await File(p.join(directory.path, 'ffprobe$suffix')).writeAsString('fake');
}

typedef ProcessResponder =
    ProcessResult Function(String executable, List<String> arguments);

final class ProcessInvocation {
  const ProcessInvocation(this.executable, this.arguments);

  final String executable;
  final List<String> arguments;
}

final class RecordingProcessRunner {
  RecordingProcessRunner(this._responder);

  final ProcessResponder _responder;
  final List<ProcessInvocation> invocations = [];

  Future<ProcessResult> call(String executable, List<String> arguments) async {
    invocations.add(ProcessInvocation(executable, List.of(arguments)));
    return _responder(executable, arguments);
  }
}

ProcessResult processResult({
  int exitCode = 0,
  Object stdout = '',
  Object stderr = '',
}) {
  return ProcessResult(1, exitCode, stdout, stderr);
}

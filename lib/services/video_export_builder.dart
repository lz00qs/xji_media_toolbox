import 'package:path/path.dart' as p;

import '../models/lut.model.dart';
import '../models/media_resource.model.dart';
import '../models/transcode_preset.model.dart';
import '../models/video_task.dart';

final class VideoExportRequest {
  const VideoExportRequest({
    required this.taskId,
    required this.taskType,
    required this.videoResource,
    required this.preset,
    required this.outputFileName,
    this.selectedResources = const [],
    this.lut,
    this.cutStart = Duration.zero,
    this.cutEnd = Duration.zero,
    this.selectedDirectory = '',
    this.useSameDirectory = true,
    this.useInputEncodeSettings = false,
    this.exportCommandOnly = false,
    this.debugLogging = false,
  });

  final String taskId;
  final VideoTaskType taskType;
  final VideoResource videoResource;
  final List<VideoResource> selectedResources;
  final TranscodePreset preset;
  final Lut? lut;
  final Duration cutStart;
  final Duration cutEnd;
  final String outputFileName;
  final String selectedDirectory;
  final bool useSameDirectory;
  final bool useInputEncodeSettings;
  final bool exportCommandOnly;
  final bool debugLogging;
}

final class VideoExportPlan {
  const VideoExportPlan({
    required this.task,
    this.concatFilePath,
    this.concatFileContents,
    this.commandFilePath,
    this.commandFileContents,
  });

  final VideoTask task;
  final String? concatFilePath;
  final String? concatFileContents;
  final String? commandFilePath;
  final String? commandFileContents;
}

String defaultVideoOutputFileName(String originalFileName) {
  return '${p.basenameWithoutExtension(originalFileName)}_OUTPUT';
}

bool isValidVideoOutputName(
  String name, {
  required String directory,
  required bool Function(String path) fileExists,
}) {
  final trimmed = name.trim();
  if (directory.trim().isEmpty ||
      trimmed.isEmpty ||
      trimmed.contains(RegExp(r'[\\/:*?"<>|]'))) {
    return false;
  }
  return !fileExists(p.join(directory, '$trimmed.MP4'));
}

Duration videoOutputDuration({
  required VideoTaskType taskType,
  required VideoResource videoResource,
  List<VideoResource> selectedResources = const [],
  Duration cutStart = Duration.zero,
  Duration cutEnd = Duration.zero,
}) {
  switch (taskType) {
    case VideoTaskType.merge:
      return selectedResources.fold(
        Duration.zero,
        (total, resource) => total + resource.duration,
      );
    case VideoTaskType.trim:
      if (cutEnd > cutStart) return cutEnd - cutStart;
      return videoResource.duration;
    case VideoTaskType.transcode:
      return videoResource.duration;
  }
}

VideoExportPlan buildVideoExportPlan(VideoExportRequest request) {
  if (request.taskId.isEmpty) {
    throw ArgumentError.value(request.taskId, 'taskId', 'must not be empty');
  }
  if (request.outputFileName.trim().isEmpty) {
    throw ArgumentError.value(
      request.outputFileName,
      'outputFileName',
      'must not be empty',
    );
  }
  if (request.taskType == VideoTaskType.merge &&
      request.selectedResources.isEmpty) {
    throw ArgumentError('Merge exports require at least one input video.');
  }

  final sourceDirectory = request.videoResource.file.parent.path;
  final outputName = '${request.outputFileName}.MP4';
  final outputPath = request.exportCommandOnly
      ? outputName
      : p.join(
          request.useSameDirectory
              ? sourceDirectory
              : request.selectedDirectory,
          outputName,
        );
  final idSuffix = request.taskId.length <= 4
      ? request.taskId
      : request.taskId.substring(request.taskId.length - 4);

  String inputPath(String path) {
    return request.exportCommandOnly ? p.basename(path) : path;
  }

  final arguments = <String>[];
  String? concatFilePath;
  String? concatFileContents;
  if (request.taskType == VideoTaskType.merge) {
    concatFilePath = p.join(
      sourceDirectory,
      '.${request.outputFileName}_$idSuffix.txt',
    );
    concatFileContents = request.selectedResources
        .map((resource) => "file '${_escapeConcatPath(resource.file.path)}'")
        .join('\n');
    arguments.addAll([
      '-f',
      'concat',
      '-safe',
      '0',
      '-i',
      inputPath(concatFilePath),
      '-i',
      inputPath(request.videoResource.file.path),
      '-map_metadata',
      '1',
    ]);
  } else {
    arguments.addAll(['-i', inputPath(request.videoResource.file.path)]);
  }

  _addEncodingArguments(arguments, request);

  if (request.taskType == VideoTaskType.trim &&
      request.cutEnd > request.cutStart) {
    arguments.addAll([
      '-ss',
      request.cutStart.toString(),
      '-to',
      request.cutEnd.toString(),
    ]);
  }
  if (request.taskType != VideoTaskType.merge) {
    arguments.addAll(['-map_metadata', '0']);
  }
  arguments.add(outputPath);

  final duration = videoOutputDuration(
    taskType: request.taskType,
    videoResource: request.videoResource,
    selectedResources: request.selectedResources,
    cutStart: request.cutStart,
    cutEnd: request.cutEnd,
  );
  final task = VideoTask(
    id: request.taskId,
    name: outputName,
    duration: duration,
    type: request.taskType,
    status: request.exportCommandOnly
        ? VideoTaskStatus.finished
        : VideoTaskStatus.waiting,
    ffmpegArgs: arguments,
    outputPath: outputPath,
    tempFilePaths: concatFilePath == null ? const [] : [concatFilePath],
    logPath: request.debugLogging ? '$outputPath.log' : '',
  );

  return VideoExportPlan(
    task: task,
    concatFilePath: concatFilePath,
    concatFileContents: concatFileContents,
    commandFilePath: request.exportCommandOnly
        ? p.join(sourceDirectory, '${request.outputFileName}_$idSuffix.txt')
        : null,
    commandFileContents: request.exportCommandOnly
        ? 'ffmpeg ${arguments.map(_quoteCommandArgument).join(' ')}'
        : null,
  );
}

void _addEncodingArguments(List<String> arguments, VideoExportRequest request) {
  arguments.add('-c:v');
  if (request.useInputEncodeSettings) {
    arguments.add('copy');
    return;
  }

  arguments.add(request.preset.useHevc ? 'libx265' : 'libx264');
  if (request.preset.useHevc) arguments.addAll(['-tag:v', 'hvc1']);
  arguments.addAll([
    '-crf',
    request.preset.crf.toString(),
    '-preset',
    request.preset.ffmpegPreset.name,
  ]);

  final filters = <String>[];
  if (request.preset.lutId != 0 && request.lut != null) {
    filters.add('lut3d=${request.lut!.path}');
    if (request.taskType != VideoTaskType.merge) {
      filters.add('format=yuv420p10le');
    }
  }
  if (!request.preset.useInputResolution) {
    filters.add('scale=${request.preset.width}:${request.preset.height}');
  }
  if (filters.isNotEmpty) arguments.addAll(['-vf', filters.join(',')]);
}

String _escapeConcatPath(String path) => path.replaceAll("'", r"'\''");

String _quoteCommandArgument(String argument) {
  if (!argument.contains(RegExp(r'''[\s'"\\]'''))) return argument;
  return "'${argument.replaceAll("'", r"'\''")}'";
}

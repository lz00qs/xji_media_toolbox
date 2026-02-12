import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_task.freezed.dart';

enum VideoTaskType {
  transcode,
  trim,
  merge,
}

enum VideoTaskStatus {
  waiting,
  processing,
  finished,
  canceled,
  failed,
}

// class CancelToken {
//   bool _canceled = false;
//
//   bool get isCanceled => _canceled;
//
//   void cancel() {
//     _canceled = true;
//   }
// }
//

@freezed
abstract class VideoTask with _$VideoTask {
  const factory VideoTask({
    @Default('') String id,
    @Default('') String name,
    @Default(Duration.zero) Duration duration,
    @Default(VideoTaskType.transcode) VideoTaskType type,
    @Default(VideoTaskStatus.waiting) VideoTaskStatus status,
    @Default(0.0) double progress,
    @Default(Duration.zero) Duration eta,
    @Default([]) List<String> ffmpegArgs,
    @Default('') String outputPath,
    @Default([]) List<String> tempFilePaths,
    @Default('') String logPath,
  }) = _VideoTask;
}

// @freezed
// class VideoTask with _$VideoTask {
//   @override
//   final String name;
//   @override
//   final VideoTaskStatus status;
//   @override
//   final VideoTaskType type;
//   @override
//   final List<String> ffmpegArgs;
//   @override
//   final Duration duration;
//   @override
//   final double progress;
//   @override
//   final File outputFile;
//   @override
//   final List<File> tempFiles;
//   @override
//   final File? logFile;
//   @override
//   final Duration eta;
//   @override
//   final Process? process;
//
//   @override
//   final CancelToken cancelToken = CancelToken();
//
//   VideoTask({
//     required this.name,
//     required this.status,
//     required this.type,
//     required this.ffmpegArgs,
//     required this.duration,
//     required this.progress,
//     required this.outputFile,
//     required this.tempFiles,
//     required this.eta,
//     this.logFile,
//     this.process,
//   });
//
//   void cancel() {
//     process?.kill();
//     cancelToken.cancel();
//     for (var file in tempFiles) {
//       if (file.existsSync()) {
//         file.deleteSync();
//       }
//     }
//     if (outputFile.existsSync()) {
//       outputFile.deleteSync();
//     }
//   }
// }

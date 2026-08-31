enum FFmpegSource { unavailable, bundled, custom }

final class FFmpegConfiguration {
  const FFmpegConfiguration({
    required this.source,
    this.directory = '',
    this.ffmpegPath = '',
    this.ffprobePath = '',
    this.version = '',
    this.errorMessage = '',
  });

  const FFmpegConfiguration.unavailable([String errorMessage = ''])
    : this(source: FFmpegSource.unavailable, errorMessage: errorMessage);

  final FFmpegSource source;
  final String directory;
  final String ffmpegPath;
  final String ffprobePath;
  final String version;
  final String errorMessage;

  bool get isAvailable => source != FFmpegSource.unavailable;
}

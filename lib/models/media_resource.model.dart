import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_resource.model.freezed.dart';

@freezed
@freezed
sealed class MediaResource with _$MediaResource {
  const MediaResource._(); // 允许写通用 getter / 方法

  /// 普通照片
  const factory MediaResource.photo({
    required String name,
    required File file,
    required int width,
    required int height,
    required int sizeInBytes,
    required DateTime creationTime,
    required int sequence,
    required String thumbFile,
    @Default(false) bool hide,
  }) = PhotoResource;

  /// AEB 照片
  const factory MediaResource.aebPhoto({
    required String name,
    required File file,
    required int width,
    required int height,
    required int sizeInBytes,
    required DateTime creationTime,
    required int sequence,
    required String thumbFile,
    @Default(false) bool hide,

    /// aeb 特有
    required int evBias,
  }) = AebPhotoResource;

  /// 视频
  const factory MediaResource.video({
    required String name,
    required File file,
    required int width,
    required int height,
    required int sizeInBytes,
    required DateTime creationTime,
    required int sequence,
    required String thumbFile,
    @Default(false) bool hide,

    /// video 特有
    required Duration duration,
  }) = VideoResource;
}
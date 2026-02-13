import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_resource.model.freezed.dart';

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
    required File thumbFile,
    @Default(false) bool hide,
    /// 错误信息
    @Default({}) Map<int, List<String>> errors,
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
    required File thumbFile,
    @Default(false) bool hide,
    /// 错误信息
    @Default({}) Map<int, List<String>> errors,

    /// aeb 特有
    required String evBias,
    required List<AebPhotoResource> aebResources,
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
    required File thumbFile,
    @Default(false) bool hide,
    /// 错误信息
    @Default({}) Map<int, List<String>> errors,

    /// video 特有
    required Duration duration,
    required double frameRate,
    required bool isHevc,
  }) = VideoResource;
}
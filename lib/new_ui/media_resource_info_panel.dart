import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/new_ui/design_tokens.dart';
import 'package:xji_footage_toolbox/new_ui/format.dart';

import '../ui/widgets/panels/views/aeb_photo_view.dart';

class _MediaResourceInfoKeyText extends StatelessWidget {
  final String keyText;

  const _MediaResourceInfoKeyText({required this.keyText});

  @override
  Widget build(BuildContext context) {
    return Text(keyText,
        style: SemiTextStyles.header6ENRegular
            .copyWith(color: ColorDark.text0, overflow: TextOverflow.ellipsis));
  }
}

class _MediaResourceInfoValueText extends StatelessWidget {
  final String valueText;

  const _MediaResourceInfoValueText({required this.valueText});

  @override
  Widget build(BuildContext context) {
    return Text(valueText,
        style: SemiTextStyles.header6ENRegular
            .copyWith(color: ColorDark.text0, overflow: TextOverflow.ellipsis));
  }
}

class _NormalVideoInfo extends StatelessWidget {
  final NormalVideoResource mediaResource;

  const _NormalVideoInfo({required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MediaResourceInfoKeyText(keyText: 'Duration:'),
              _MediaResourceInfoKeyText(keyText: 'Codec:'),
            ],
          ),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MediaResourceInfoValueText(
                valueText: formatDuration(mediaResource.duration,
                    showMilliseconds: false)),
            _MediaResourceInfoValueText(
                valueText: mediaResource.isHevc ? 'H.265' : 'H.264'),
          ],
        ))
      ],
    );
  }
}

class _AebPhotoInfo extends StatelessWidget {
  final AebPhotoResource mediaResource;

  const _AebPhotoInfo({required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    final AebPhotoViewController aebPhotoViewController =
        AebPhotoViewController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MediaResourceInfoKeyText(keyText: 'Name:'),
              _MediaResourceInfoKeyText(keyText: 'Size:'),
              _MediaResourceInfoKeyText(keyText: 'Date:'),
              _MediaResourceInfoKeyText(keyText: 'Resolution:'),
              _MediaResourceInfoKeyText(keyText: 'AEB Count:'),
              _MediaResourceInfoKeyText(keyText: 'EV Bias:'),
            ],
          ),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => _MediaResourceInfoValueText(
                valueText: mediaResource
                    .aebResources[aebPhotoViewController.currentAebIndex.value]
                    .name)),
            Obx(() => _MediaResourceInfoValueText(
                valueText: formatSize(mediaResource
                    .aebResources[aebPhotoViewController.currentAebIndex.value]
                    .sizeInBytes))),
            Obx(() => _MediaResourceInfoValueText(
                valueText: mediaResource
                    .aebResources[aebPhotoViewController.currentAebIndex.value]
                    .creationTime
                    .toString()
                    .substring(0, 19))),
            Obx(() => _MediaResourceInfoValueText(
                valueText:
                    '${mediaResource.aebResources[aebPhotoViewController.currentAebIndex.value].width}x'
                    '${mediaResource.aebResources[aebPhotoViewController.currentAebIndex.value].height}')),
            _MediaResourceInfoValueText(
                valueText: mediaResource.aebResources.length.toString()),
            Obx(() => _MediaResourceInfoValueText(
                valueText: parseAebEvBias(
                    aebPhotoViewController.currentAebIndex.value))),
          ],
        ))
      ],
    );
  }
}

class MediaResourceInfoPanel extends StatelessWidget {
  final MediaResource mediaResource;

  const MediaResourceInfoPanel({super.key, required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DesignValues.smallPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          mediaResource.isAeb
              ? _AebPhotoInfo(mediaResource: mediaResource as AebPhotoResource)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _MediaResourceInfoKeyText(keyText: 'Name:'),
                          _MediaResourceInfoKeyText(keyText: 'Size:'),
                          _MediaResourceInfoKeyText(keyText: 'Date:'),
                          _MediaResourceInfoKeyText(keyText: 'Resolution:'),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MediaResourceInfoValueText(
                            valueText: mediaResource.name),
                        _MediaResourceInfoValueText(
                            valueText: formatSize(mediaResource.sizeInBytes)),
                        _MediaResourceInfoValueText(
                            valueText: mediaResource.creationTime
                                .toString()
                                .substring(0, 19)),
                        _MediaResourceInfoValueText(
                            valueText:
                                '${mediaResource.width}x${mediaResource.height}'),
                      ],
                    ))
                  ],
                ),
          mediaResource.isVideo
              ? _NormalVideoInfo(
                  mediaResource: mediaResource as NormalVideoResource)
              : const SizedBox(),
        ],
      ),
    );
  }
}

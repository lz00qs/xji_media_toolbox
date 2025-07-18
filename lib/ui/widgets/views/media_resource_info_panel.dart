import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';
import 'package:xji_footage_toolbox/utils/format.dart';

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

class _AebPhotoInfoValueColumn extends StatelessWidget {
  final MediaResource mediaResource;
  final int aebCount;

  const _AebPhotoInfoValueColumn(
      {required this.mediaResource, required this.aebCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MediaResourceInfoValueText(valueText: mediaResource.name),
        _MediaResourceInfoValueText(
            valueText: formatSize(mediaResource.sizeInBytes)),
        _MediaResourceInfoValueText(
            valueText: mediaResource.creationTime.toString().substring(0, 19)),
        _MediaResourceInfoValueText(
            valueText: '${mediaResource.width}x'
                '${mediaResource.height}'),
        _MediaResourceInfoValueText(valueText: aebCount.toString()),
        _MediaResourceInfoValueText(
            valueText: (mediaResource as AebPhotoResource).evBias),
      ],
    );
  }
}

class _AebPhotoInfo extends StatelessWidget {
  final AebPhotoResource mediaResource;

  const _AebPhotoInfo({required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    // final AebPhotoViewController aebPhotoViewController = Get.find();
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
        Expanded(child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final currentAebIndex = ref.watch(
              mediaResourcesProvider.select((state) => state.currentAebIndex));
          return _AebPhotoInfoValueColumn(
              mediaResource: mediaResource.aebResources[currentAebIndex],
              aebCount: mediaResource.aebResources.length);
        }))
      ],
    );
  }
}

class MediaResourceInfoPanel extends ConsumerWidget {
  const MediaResourceInfoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaResources =
        ref.watch(mediaResourcesProvider.select((state) => state.resources));
    final currentIndex =
        ref.watch(mediaResourcesProvider.select((state) => state.currentIndex));
    final mediaResourcesLength = ref.watch(
        mediaResourcesProvider.select((state) => state.resources.length));
    if (mediaResourcesLength == 0) {
      return Container();
    }
    final mediaResource = mediaResources[currentIndex];
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

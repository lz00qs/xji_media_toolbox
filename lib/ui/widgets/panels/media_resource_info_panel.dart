import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';
import 'package:xji_footage_toolbox/utils/format.dart';

import '../../../models/media_resource.model.dart';

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

class _MediaInfo extends StatelessWidget {
  final String keyText;
  final String valueText;

  const _MediaInfo({required this.keyText, required this.valueText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: _MediaResourceInfoKeyText(keyText: keyText),
        ),
        Expanded(
          child: _MediaResourceInfoValueText(valueText: valueText),
        )
      ],
    );
  }
}

class MediaResourceInfoPanel extends ConsumerWidget {
  final MediaResource mediaResource;

  const MediaResourceInfoPanel({super.key, required this.mediaResource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(DesignValues.smallPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _MediaInfo(keyText: 'Name:', valueText: mediaResource.name),
          _MediaInfo(
              keyText: 'Size:',
              valueText: formatSize(mediaResource.sizeInBytes)),
          _MediaInfo(
              keyText: 'Date:',
              valueText:
                  mediaResource.creationTime.toString().substring(0, 19)),
          _MediaInfo(
              keyText: 'Resolution:',
              valueText: '${mediaResource.width}x${mediaResource.height}'),
          (mediaResource is AebPhotoResource)
              ? _MediaInfo(
                  keyText: 'EV Bias:',
                  valueText: (mediaResource as AebPhotoResource).evBias)
              : SizedBox(),
          (mediaResource is VideoResource)
              ? _MediaInfo(
                  keyText: 'Duration:',
                  valueText: formatDuration(
                      (mediaResource as VideoResource).duration,
                      showMilliseconds: false))
              : SizedBox(),
          (mediaResource is VideoResource)
              ? _MediaInfo(
                  keyText: 'Frame Rate:',
                  valueText:
                      '${(mediaResource as VideoResource).frameRate.toStringAsFixed(2)}fps')
              : SizedBox(),
        ],
      ),
    );
  }
}

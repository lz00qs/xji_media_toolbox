import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';

const _infoTextStyle = TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis);

String _dynamicSizeText(int sizeInBytes) {
  if (sizeInBytes < 1024) {
    return '$sizeInBytes bytes';
  } else if (sizeInBytes < 1024 * 1024) {
    return '${(sizeInBytes / 1024).toStringAsFixed(2)} KB';
  } else if (sizeInBytes < 1024 * 1024 * 1024) {
    return '${(sizeInBytes / 1024 / 1024).toStringAsFixed(2)} MB';
  } else {
    return '${(sizeInBytes / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
  }
}

List<Widget> _genericMediaResourceInfo(MediaResource mediaResource) {
  return [
    mediaResource.isAeb
        ? const SizedBox()
        : Text(
            'FileName: ${mediaResource.name}',
            style: _infoTextStyle,
          ),
    Text(
      'Resolution: ${mediaResource.width}x${mediaResource.height}',
      style: _infoTextStyle,
    ),
    Text(
      'Creation Time: ${mediaResource.creationTime}',
      style: _infoTextStyle,
    ),
    Text(
      'Size: ${_dynamicSizeText(mediaResource.sizeInBytes)}',
      style: _infoTextStyle,
    ),
  ];
}

Widget _genericMediaResourceError(MediaResource mediaResource) {
  return mediaResource.errors.isEmpty == false
      ? Column(
          children: mediaResource.errors.entries
              .map((entry) => Text(
                    'Error: ${entry.value}',
                    style: const TextStyle(
                        fontSize: 15, overflow: TextOverflow.clip),
                  ))
              .toList(),
        )
      : const SizedBox();
}

class _PhotoInfoPanel extends StatelessWidget {
  final MediaResource mediaResource;

  const _PhotoInfoPanel({required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ..._genericMediaResourceInfo(mediaResource),
        mediaResource.isAeb == true
            ? Text(
                'AEB: ${(mediaResource as AebPhotoResource).aebFiles.length}',
                style: _infoTextStyle,
              )
            : const SizedBox(),
        _genericMediaResourceError(mediaResource),
      ],
    );
  }
}

class _VideoInfoPanel extends StatelessWidget {
  final MediaResource mediaResource;

  const _VideoInfoPanel({required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ..._genericMediaResourceInfo(mediaResource),
        Text(
          'Duration: ${(mediaResource as NormalVideoResource).duration}',
          style: _infoTextStyle,
        ),
        Text(
          'FrameRate: ${(mediaResource as NormalVideoResource).frameRate}',
          style: _infoTextStyle,
        ),
        Text(
          'Codec: ${(mediaResource as NormalVideoResource).isHevc ? 'HEVC' : 'H.264'}',
          style: _infoTextStyle,
        ),
        _genericMediaResourceError(mediaResource),
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
        padding: const EdgeInsets.all(10),
        child: mediaResource.isVideo
            ? _VideoInfoPanel(mediaResource: mediaResource)
            : _PhotoInfoPanel(mediaResource: mediaResource));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/global_controller.dart';

const infoTextStyle = TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis);

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

class PhotoInfoWidget extends StatelessWidget {
  const PhotoInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'FileName: ${controller.footageList[controller.currentFootageIndex.value].name}',
              style: infoTextStyle,
            ),
            Text(
              'Resolution: ${controller.footageList[controller.currentFootageIndex.value].width}x${controller.footageList[controller.currentFootageIndex.value].height}',
              style: infoTextStyle,
            ),
            Text(
              'Time: ${controller.footageList[controller.currentFootageIndex.value].time}',
              style: infoTextStyle,
            ),
            Text(
              'Size: ${_dynamicSizeText(controller.footageList[controller.currentFootageIndex.value].sizeInBytes)}',
              style: infoTextStyle,
            ),
            Text(
                'EV Bias: ${controller.footageList[controller.currentFootageIndex.value].evBias}',
                style: infoTextStyle),
            controller.footageList[controller.currentFootageIndex.value]
                        .isAeb ==
                    true
                ? Text(
                    'AEB: ${controller.footageList[controller.currentFootageIndex.value].aebFiles.length}',
                    style: infoTextStyle,
                  )
                : const SizedBox(),
            controller.footageList[controller.currentFootageIndex.value].errors
                        .isEmpty ==
                    false
                ? Text(
                    'Errors: ${controller.footageList[controller.currentFootageIndex.value].errors}',
                    style: infoTextStyle,
                  )
                : const SizedBox(),
          ],
        ));
  }
}

class VideoInfoWidget extends StatelessWidget {
  const VideoInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'FileName: ${controller.footageList[controller.currentFootageIndex.value].name}',
              style: infoTextStyle,
            ),
            Text(
              'Resolution: ${controller.footageList[controller.currentFootageIndex.value].width}x${controller.footageList[controller.currentFootageIndex.value].height}',
              style: infoTextStyle,
            ),
            Text(
              'Time: ${controller.footageList[controller.currentFootageIndex.value].time}',
              style: infoTextStyle,
            ),
            Text(
              'Size: ${_dynamicSizeText(controller.footageList[controller.currentFootageIndex.value].sizeInBytes)}',
              style: infoTextStyle,
            ),
            Text(
              'Duration: ${controller.footageList[controller.currentFootageIndex.value].duration} sec',
              style: infoTextStyle,
            ),
            Text(
              'FrameRate: ${controller.footageList[controller.currentFootageIndex.value].frameRate}',
              style: infoTextStyle,
            ),
            Text(
              'Codec: ${controller.footageList[controller.currentFootageIndex.value].isHevc ? 'HEVC' : 'H.264'}',
              style: infoTextStyle,
            ),
            controller.footageList[controller.currentFootageIndex.value].errors
                        .isEmpty ==
                    false
                ? Text(
                    'Errors: ${controller.footageList[controller.currentFootageIndex.value].errors}',
                    style: infoTextStyle,
                  )
                : const SizedBox(),
          ],
        ));
  }
}

class FootageInfoWidget extends StatelessWidget {
  const FootageInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          if (controller.footageList.isEmpty) {
            return const Center(
              child: Text('No Footage'),
            );
          }
          if (controller
                  .footageList[controller.currentFootageIndex.value].isVideo ==
              true) {
            return const VideoInfoWidget();
          } else {
            return const PhotoInfoWidget();
          }
        }));
  }
}

import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:xji_footage_toolbox/global_controller.dart';

import '../footage.dart';

class AebPhotoEditorWidget extends StatelessWidget {
  const AebPhotoEditorWidget({super.key, required this.footage});

  final Footage footage;

  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();
    controller.currentAebIndex.value = 0;

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRect(
                    child: Obx(() => ExtendedImage.file(
                          footage.aebFiles[controller.currentAebIndex.value],
                          fit: BoxFit.contain,
                          mode: ExtendedImageMode.gesture,
                          initGestureConfigHandler: (state) {
                            return GestureConfig(
                              minScale: 1.0,
                              animationMinScale: 0.7,
                              maxScale: 10.0,
                              animationMaxScale: 10.0,
                              speed: 1.0,
                              inertialSpeed: 100.0,
                              initialScale: 1.0,
                              inPageView: false,
                              initialAlignment: InitialAlignment.center,
                            );
                          },
                        )),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 150,
          child: Center(
              child: ScrollablePositionedList.builder(
            // initialAlignment: 100,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(5.0),
            itemCount: footage.aebFiles.length,
            itemScrollController: controller.aebListScrollController,
            itemPositionsListener: controller.aebListScrollListener,
            itemBuilder: (BuildContext context, int index) {
              var evBias = '';
              switch (index) {
                case 0:
                  evBias = '0.0';
                  break;
                case 1:
                  evBias = '-0.7';
                  break;
                case 2:
                  evBias = '+0.7';
                  break;
                case 3:
                  evBias = '-1.3';
                  break;
                case 4:
                  evBias = '+1.3';
                  break;
                case 5:
                  evBias = '-2.0';
                  break;
                case 6:
                  evBias = '+2.0';
                  break;
                default:
                  evBias = '0.0';
              }
              return Obx(() => _AebThumbnailWidget(
                  file: footage.aebFiles[index],
                  evBias: evBias,
                  width: 150,
                  height: 150,
                  isSelected: controller.currentAebIndex.value == index,
                  onTap: () {
                    controller.currentAebIndex.value = index;
                  }));
            },
          )),
        )
      ],
    ));
  }
}

class _AebThumbnailWidget extends StatelessWidget {
  final File file;
  final double width;
  final double height;
  final bool isSelected;
  final String evBias;
  final void Function() onTap;

  const _AebThumbnailWidget({
    required this.file,
    required this.evBias,
    required this.width,
    required this.height,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.grey : Colors.transparent,
        height: height,
        width: width,
        padding: const EdgeInsets.all(5.0),
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Image.file(
                  file,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(evBias,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black))
            ]),
      ),
    );
  }
}

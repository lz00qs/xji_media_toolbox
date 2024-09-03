import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:xji_footage_toolbox/ui/widgets/panels/views/photo_view.dart';

import '../../../../constants.dart';
import '../../../../models/media_resource.dart';
import '../../buttons/app_bar_aeb_photos_name_add_suffix_button.dart';
import '../../buttons/app_bar_media_delete_button.dart';




class _AebPhotoViewAppBarWidget extends StatelessWidget {
  const _AebPhotoViewAppBarWidget();

  @override
  Widget build(BuildContext context) {
    var appBarHeight = macAppBarHeight;
    if (GetPlatform.isWindows) {
      /// todo: implement windows app bar height
    }

    return SizedBox(
      height: appBarHeight,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBarAebPhotosNameAddSuffixButton(),
          AppBarMediaDeleteButton(),
        ],
      ),
    );
  }
}

class AebPhotoViewController extends GetxController {
  final currentAebIndex = 0.obs;
  final aebListScrollController = ItemScrollController();
  final aebListScrollListener = ItemPositionsListener.create();
}

class AebPhotoView extends GetView<AebPhotoViewController> {
  final AebPhotoResource photoResource;

  const AebPhotoView({super.key, required this.photoResource});

  @override
  Widget build(BuildContext context) {
    controller.currentAebIndex.value = 0;
    return Column(
      children: [
        const _AebPhotoViewAppBarWidget(),
        Expanded(
          child: Obx(() => PhotoView(
              photoFile:
                  photoResource.aebFiles[controller.currentAebIndex.value])),
        ),
        Obx(() => Text(photoResource.aebFiles[controller.currentAebIndex.value]
            .uri.pathSegments.last)),
        SizedBox(
          height: 150,
          child: ScrollConfiguration(
              behavior: _ScrollbarBehavior(),
              child: ScrollablePositionedList.builder(
                // initialAlignment: 100,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(5.0),
                itemCount: photoResource.aebFiles.length,
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
                  return Column(children: [
                    Expanded(child: Obx(() => _AebThumbnail(
                        file: photoResource.aebFiles[index],
                        evBias: evBias,
                        width: 150,
                        height: 150,
                        isSelected: controller.currentAebIndex.value == index,
                        onTap: () {
                          controller.currentAebIndex.value = index;
                        }))),
                    const SizedBox(height: 10.0),
                  ],);
                },
              )),
        )
      ],
    );
  }
}

class _ScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return Scrollbar(controller: details.controller, child: child);
  }
}

class _AebThumbnail extends StatelessWidget {
  final File file;
  final double width;
  final double height;
  final bool isSelected;
  final String evBias;
  final void Function() onTap;

  const _AebThumbnail({
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

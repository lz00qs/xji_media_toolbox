import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/aeb_add_suffix_dialog.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/photo_viewer.dart';

import '../../../models/media_resource.dart';
import '../../../providers/media_resources_provider.dart';
import '../buttons/custom_icon_button.dart';
import '../../design_tokens.dart';
import 'main_panel.dart';
import 'media_resources_list_panel.dart';

final _aebListScrollController = ScrollController();

class _AebPhotoThumbnail extends ConsumerWidget {
  final AebPhotoResource photoResource;
  final bool isSelected;
  final int index;

  const _AebPhotoThumbnail({required this.photoResource,
    required this.index,
    required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(mediaResourcesProvider.notifier).setCurrentAebIndex(
                    index);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    DesignValues.ultraSmallPadding),
                child: Container(
                  height: 100 - DesignValues.smallPadding,
                  color: isSelected
                      ? ColorDark.data8.withAlpha((0.7 * 255).round())
                      : Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: DesignValues.ultraSmallPadding,
                            left: DesignValues.ultraSmallPadding,
                            right: DesignValues.ultraSmallPadding),
                        child: MediaResourceThumbnail(
                            mediaResource: photoResource),
                      ),
                      Expanded(
                          child: Center(
                            child: Text(photoResource.evBias,
                                style: SemiTextStyles.regularENRegular.copyWith(
                                    color:
                                    isSelected ? ColorDark.text0 : ColorDark
                                        .text1,
                                    overflow: TextOverflow.ellipsis)),
                          )),
                    ],
                  ),
                ),
              ),
            )),
        SizedBox(
          height: DesignValues.smallPadding,
        ),
      ],
    );
  }
}

class _AebPhotoThumbnailList extends StatelessWidget {
  final List<MediaResource> resources;

  const _AebPhotoThumbnailList({required this.resources});

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
        thickness: DesignValues.smallPadding,
        trackVisibility: false,
        thumbVisibility: true,
        radius: Radius.circular(DesignValues.smallBorderRadius),
        controller: _aebListScrollController,
        child: ListView.builder(
            controller: _aebListScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: resources.length,
            itemBuilder: (context, index) {
              return Consumer(builder:
                  (BuildContext context, WidgetRef ref, Widget? child) {
                final currentAebIndex = ref.watch(mediaResourcesProvider
                    .select((state) => state.currentAebIndex));
                return _AebPhotoThumbnail(
                    photoResource: resources[index] as AebPhotoResource,
                    index: index,
                    isSelected: index == currentAebIndex);
              });
            }));
  }
}

class AebPhotoViewPanel extends StatelessWidget {
  final AebPhotoResource photoResource;

  const AebPhotoViewPanel({super.key, required this.photoResource});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(DesignValues.smallPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: Consumer(builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final currentAebIndex = ref.watch(mediaResourcesProvider
                        .select((state) => state.currentAebIndex));
                    return PhotoViewer(
                        photoFile:
                        photoResource.aebResources[currentAebIndex].file);
                  })),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer(builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          return CustomIconButton(
                            iconData: Icons.chevron_left,
                            onPressed: () {
                              ref
                                  .read(mediaResourcesProvider.notifier)
                                  .decreaseCurrentAebIndex();
                            },
                            iconSize: 32,
                            buttonSize: 48,
                            hoverColor: ColorDark.defaultHover,
                            focusColor: ColorDark.defaultActive,
                            iconColor: ColorDark.text0,
                          );
                        }),
                        SizedBox(
                          width: DesignValues.largePadding,
                        ),
                        Consumer(builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          return CustomIconButton(
                            iconData: Icons.chevron_right,
                            onPressed: () {
                              ref
                                  .read(mediaResourcesProvider.notifier)
                                  .increaseCurrentAebIndex();
                            },
                            iconSize: 32,
                            buttonSize: 48,
                            hoverColor: ColorDark.defaultHover,
                            focusColor: ColorDark.defaultActive,
                            iconColor: ColorDark.text0,
                          );
                        })
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(DesignValues.smallBorderRadius)),
                    child: Container(
                      color: ColorDark.bg2,
                      height: 100,
                      child: Column(
                        children: [
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: DesignValues.ultraSmallPadding,
                                    right: DesignValues.ultraSmallPadding,
                                    top: DesignValues.ultraSmallPadding),
                                child: _AebPhotoThumbnailList(
                                    resources: photoResource.aebResources),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        MainPanelSideBar(
          children: [
            const MainPanelSideBarControlButtons(),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.upload,
                onPressed: () async {
                  await showDialog(
                      context: context, builder: (BuildContext context) {
                    return AebAddSuffixDialog();
                  });
                },
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.appBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/custom_icon_button.dart';

import '../../../providers/media_resources_provider.dart';
import '../../../utils/format.dart';
import '../../design_tokens.dart';
import '../dialogs/media_resources_sort_dialog.dart';

const _listWidgetHeight = 73.0;

var _panelHeight = 0.0;
final _mediaResourcesListScrollController = ScrollController();

void mediaResourcesListScrollToIndex(int index, bool isIncrement) {
  if (isIncrement) {
    if (index * _listWidgetHeight >
        _panelHeight +
            _mediaResourcesListScrollController.position.pixels -
            _listWidgetHeight) {
      _mediaResourcesListScrollController
          .jumpTo(index * _listWidgetHeight - _panelHeight + _listWidgetHeight);
    }
  } else {
    if (index * _listWidgetHeight <
        _mediaResourcesListScrollController.position.pixels) {
      _mediaResourcesListScrollController.jumpTo(index * _listWidgetHeight);
    }
  }
}

class MediaResourceThumbnail extends StatelessWidget {
  final MediaResource mediaResource;

  const MediaResourceThumbnail({super.key, required this.mediaResource});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 56,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignValues.smallBorderRadius),
        child: mediaResource.thumbFile == null
            ? Image.asset('assets/common/images/resource_not_found.jpeg')
            : Image.file(
                mediaResource.thumbFile!,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}

class _MediaResourcesListTopBar extends StatelessWidget {
  const _MediaResourcesListTopBar();

  @override
  Widget build(BuildContext context) {
    /// todo: implement windows app bar height
    return ClipRRect(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignValues.mediumBorderRadius)),
        child: Container(
          height: DesignValues.appBarHeight,
          width: double.infinity,
          color: ColorDark.bg3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: DesignValues.smallPadding,
              ),
              Text(
                'Files',
                style: SemiTextStyles.header6ENRegular
                    .copyWith(color: ColorDark.text2),
              ),
              const Spacer(),
              CustomIconButton(
                  iconData: Icons.sort,
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return const MediaResourcesSortDialog();
                        });
                  },
                  iconSize: DesignValues.mediumIconSize,
                  buttonSize: 32.0,
                  hoverColor: ColorDark.defaultHover,
                  focusColor: ColorDark.defaultActive,
                  iconColor: ColorDark.text2),
              SizedBox(
                width: DesignValues.smallPadding,
              ),
              Consumer(builder:
                  (BuildContext context, WidgetRef ref, Widget? child) {
                final isMultipleSelection = ref.watch(mediaResourcesProvider
                    .select((value) => value.isMultipleSelection));
                return CustomIconButton(
                    iconData: isMultipleSelection
                        ? Icons.keyboard_return
                        : Icons.checklist_rtl,
                    onPressed: () {
                      if (ref.watch(mediaResourcesProvider
                          .select((state) => isMultipleSelection))) {
                        ref
                            .read(mediaResourcesProvider.notifier)
                            .clearSelectedResources();
                      }
                      ref
                          .read(mediaResourcesProvider.notifier)
                          .toggleIsMultipleSelection();
                      if (isMultipleSelection) {
                        ref
                            .read(mediaResourcesProvider.notifier)
                            .setIsMerging(false);
                      }
                    },
                    iconSize: DesignValues.mediumIconSize,
                    buttonSize: 32.0,
                    hoverColor: ColorDark.defaultHover,
                    focusColor: ColorDark.defaultActive,
                    iconColor: ColorDark.text2);
              })
            ],
          ),
        ));
  }
}

class _FileTypeFab extends StatelessWidget {
  final String fileType;
  final Color color;

  const _FileTypeFab({required this.fileType, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2.0),
      child: Container(
        height: 14,
        color: color,
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 2),
          child: Text(
            fileType,
            style:
                SemiTextStyles.smallENRegular.copyWith(color: ColorDark.text0),
          ),
        ),
      ),
    );
  }
}

class _MediaResourceListWidget extends ConsumerWidget {
  final MediaResource mediaResource;
  final bool isSelected;
  final bool isMultipleSelection;
  final int index;

  const _MediaResourceListWidget(
      {required this.index,
      required this.mediaResource,
      this.isSelected = false,
      this.isMultipleSelection = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileName = mediaResource.name.split('.').first;
    final extension = mediaResource.name.split('.').last.toUpperCase();
    return Row(
      children: [
        Expanded(
            child: GestureDetector(
          onTap: () {
            if (isMultipleSelection) {
              ref
                      .watch(mediaResourcesProvider)
                      .selectedResources
                      .contains(mediaResource)
                  ? ref
                      .read(mediaResourcesProvider.notifier)
                      .removeSelectedResource(mediaResource)
                  : ref
                      .read(mediaResourcesProvider.notifier)
                      .addSelectedResource(mediaResource);
            } else {
              ref.read(mediaResourcesProvider.notifier).setCurrentIndex(index);
            }
          },
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(DesignValues.mediumBorderRadius),
            child: Column(
              children: [
                Container(
                  height: _listWidgetHeight - 1,
                  width: double.infinity,
                  color: isSelected
                      // ? ColorDark.blue0.withOpacity(0.8)
                      ? ColorDark.blue0.withAlpha((0.8 * 255).round())
                      : Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: DesignValues.smallPadding,
                        top: DesignValues.smallPadding,
                        bottom: DesignValues.smallPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MediaResourceThumbnail(mediaResource: mediaResource),
                        SizedBox(
                          width: DesignValues.ultraSmallPadding,
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  fileName,
                                  style: SemiTextStyles.regularENSemiBold
                                      .copyWith(
                                          color: ColorDark.text0,
                                          overflow: TextOverflow.ellipsis),
                                )),
                                // const Spacer(),
                                SizedBox(
                                  width: DesignValues.smallPadding,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 26,
                              child: Center(
                                child: Row(
                                  children: [
                                    extension == 'JPG'
                                        ? const _FileTypeFab(
                                            fileType: 'JPG',
                                            color: ColorDark.data4)
                                        : const SizedBox(),
                                    extension == 'JPG'
                                        ? mediaResource.isAeb
                                            ? SizedBox(
                                                width: DesignValues
                                                    .ultraSmallPadding)
                                            : const SizedBox()
                                        : const SizedBox(),
                                    extension == 'JPG'
                                        ? mediaResource.isAeb
                                            ? const _FileTypeFab(
                                                fileType: 'AEB',
                                                color: ColorDark.data8)
                                            : const SizedBox()
                                        : const SizedBox(),
                                    extension == 'MP4'
                                        ? const _FileTypeFab(
                                            fileType: 'MP4',
                                            color: ColorDark.data0)
                                        : const SizedBox(),
                                    extension == 'MP4'
                                        ? (mediaResource as NormalVideoResource)
                                                .isHevc
                                            ? SizedBox(
                                                width: DesignValues
                                                    .ultraSmallPadding)
                                            : const SizedBox()
                                        : const SizedBox(),
                                    extension == 'MP4'
                                        ? (mediaResource as NormalVideoResource)
                                                .isHevc
                                            ? const _FileTypeFab(
                                                fileType: 'HEVC',
                                                color: ColorDark.data2)
                                            : const SizedBox()
                                        : const SizedBox(),
                                    const Spacer(),
                                    isMultipleSelection
                                        ? CustomIconButton(
                                            iconData: isSelected
                                                ? Icons.check_box_outlined
                                                : Icons.check_box_outline_blank,
                                            onPressed: () {
                                              if (isMultipleSelection) {
                                                ref
                                                        .watch(
                                                            mediaResourcesProvider)
                                                        .selectedResources
                                                        .contains(mediaResource)
                                                    ? ref
                                                        .read(
                                                            mediaResourcesProvider
                                                                .notifier)
                                                        .removeSelectedResource(
                                                            mediaResource)
                                                    : ref
                                                        .read(
                                                            mediaResourcesProvider
                                                                .notifier)
                                                        .addSelectedResource(
                                                            mediaResource);
                                              }
                                            },
                                            iconSize:
                                                DesignValues.smallIconSize,
                                            buttonSize: 24,
                                            hoverColor: ColorDark.defaultHover,
                                            focusColor: ColorDark.defaultActive,
                                            iconColor: ColorDark.text1)
                                        : const SizedBox(),
                                    SizedBox(
                                      width: DesignValues.mediumPadding,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${mediaResource.width}x${mediaResource.height}',
                                  style: SemiTextStyles.smallENRegular
                                      .copyWith(color: ColorDark.text2),
                                ),
                                const Spacer(),
                                Text(
                                  mediaResource.isVideo
                                      ? formatDuration(
                                          (mediaResource as NormalVideoResource)
                                              .duration)
                                      : formatSize(mediaResource.sizeInBytes),
                                  style: SemiTextStyles.smallENRegular
                                      .copyWith(color: ColorDark.text2),
                                ),
                                SizedBox(
                                  width: DesignValues.smallPadding,
                                )
                              ],
                            )
                          ],
                        )),
                        SizedBox(
                          width: DesignValues.smallPadding,
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: ColorDark.border,
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

class MediaResourcesListPanel extends ConsumerWidget {
  const MediaResourcesListPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaResources =
        ref.watch(mediaResourcesProvider.select((value) => value.resources));
    final currentIndex =
        ref.watch(mediaResourcesProvider.select((value) => value.currentIndex));
    final isMultipleSelection = ref.watch(
        mediaResourcesProvider.select((value) => value.isMultipleSelection));
    final mediaResourcesLength = ref.watch(
        mediaResourcesProvider.select((value) => value.resources.length));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const _MediaResourcesListTopBar(),
        Expanded(child: LayoutBuilder(builder: (context, constraints) {
          _panelHeight = constraints.maxHeight;
          return RawScrollbar(
              thickness: DesignValues.smallPadding,
              trackVisibility: false,
              thumbVisibility: true,
              radius: Radius.circular(DesignValues.smallBorderRadius),
              controller: _mediaResourcesListScrollController,
              child: Row(
                children: [
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          controller: _mediaResourcesListScrollController,
                          itemCount: mediaResourcesLength,
                          itemBuilder: (context, index) {
                            final mediaResource = mediaResources[index];
                            return _MediaResourceListWidget(
                                index: index,
                                mediaResource: mediaResource,
                                isSelected: isMultipleSelection
                                    ? ref.watch(mediaResourcesProvider.select(
                                        (state) => state.selectedResources
                                            .contains(mediaResource)))
                                    : currentIndex == index,
                                isMultipleSelection: isMultipleSelection);
                          }))
                ],
              ));
        }))
      ],
    );
  }
}

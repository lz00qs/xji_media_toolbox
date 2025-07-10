import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';
import 'package:xji_footage_toolbox/ui/widgets/views/multi_select_panel.dart';

import '../buttons/custom_icon_button.dart';
import 'main_panel.dart';

class _VideoThumbnail extends StatelessWidget {
  final NormalVideoResource videoResource;

  const _VideoThumbnail({required this.videoResource});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 272,
      height: 173,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 153,
              width: 272,
              child: videoResource.thumbFile == null
                  ? Image.asset('assets/common/images/resource_not_found.jpeg')
                  : Image.file(
                      videoResource.thumbFile!,
                      fit: BoxFit.fill,
                    )),
          Expanded(
              child: Text(
            videoResource.name.split('.').first,
            style: SemiTextStyles.regularENSemiBold
                .copyWith(color: ColorDark.text0),
          )),
          SizedBox(
            height: DesignValues.smallPadding,
          ),
        ],
      ),
    );
  }
}

class VideoMergerPanel extends ConsumerWidget {
  const VideoMergerPanel({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedResources = ref.watch(mediaResourcesProvider.select((state) => state.selectedResources.map((e) => e as NormalVideoResource).toList()));
    final scrollController = ScrollController();
    return Row(
      children: [
        Expanded(
            child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(
                Radius.circular(DesignValues.mediumBorderRadius)),
            child: Container(
              height: 200,
              color: ColorDark.bg3,
              child: Padding(
                padding: EdgeInsets.only(
                    left: DesignValues.mediumPadding,
                    right: DesignValues.mediumPadding,
                    top: DesignValues.mediumPadding),
                child: RawScrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    radius: Radius.circular(DesignValues.smallBorderRadius),
                    child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: ColorDark.bg3,
                          // shadowColor: Colors.transparent,
                        ),
                        child: ReorderableListView.builder(
                            buildDefaultDragHandles: false,
                            scrollDirection: Axis.horizontal,
                            scrollController: scrollController,
                            itemBuilder: (context, index) {
                              return ReorderableDragStartListener(
                                  key: ValueKey(selectedResources[index]),
                                  index: index,
                                  child: _VideoThumbnail(
                                    videoResource: selectedResources[index],
                                  ));
                            },
                            itemCount: selectedResources.length,
                            onReorder: (int oldIndex, int newIndex) {
                              ref.read(mediaResourcesProvider.notifier)
                                 .reorderSelectedResources(
                                     oldIndex: oldIndex, newIndex: newIndex);
                            }))),
              ),
            ),
          ),
        )),
        MainPanelSideBar(
          children: [
            CustomIconButton(
                iconData: Icons.arrow_back_ios_new,
                onPressed: () {
                  ref.read(isMergingStateProvider.notifier).state = false;
                },
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.appBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
            SizedBox(
              height: DesignValues.mediumPadding,
            ),
            CustomIconButton(
                iconData: Icons.save,
                onPressed: () async {
                  // await Get.dialog(VideoExportDialog(
                  //   videoResources: rxVideoResources,
                  // ));
                },
                iconSize: DesignValues.mediumIconSize,
                buttonSize: DesignValues.appBarHeight,
                hoverColor: ColorDark.defaultHover,
                focusColor: ColorDark.defaultActive,
                iconColor: ColorDark.text0),
          ],
        )
      ],
    );
  }
}

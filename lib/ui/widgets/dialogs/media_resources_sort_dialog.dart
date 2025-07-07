import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import '../../../models/settings.dart';
import '../../design_tokens.dart';
import 'custom_dual_option_dialog.dart';

class MediaResourcesSortDialog extends ConsumerWidget {
  const MediaResourcesSortDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortType =
        ref.watch(settingsProvider.select((value) => value.sortType));
    final sortAsc =
        ref.watch(settingsProvider.select((value) => value.sortAsc));
    return CustomDualOptionDialog(
        width: 400,
        height: 320,
        title: 'Sort',
        option1: '',
        disableOption1: true,
        option2: 'OK',
        onOption1Pressed: () {},
        onOption2Pressed: () async {
          final mediaResources = ref
              .watch(mediaResourcesProvider.select((state) => state.resources));
          switch (sortType) {
            case SortType.name:
              // globalMediaResourcesController.mediaResources.sort((a, b) =>
              //     globalSettingsController.sortAsc.value
              //         ? a.name.compareTo(b.name)
              //         : b.name.compareTo(a.name));
              mediaResources.sort((a, b) => sortAsc
                  ? a.name.compareTo(b.name)
                  : b.name.compareTo(a.name));
              break;
            case SortType.date:
              // globalMediaResourcesController.mediaResources.sort((a, b) =>
              //     globalSettingsController.sortAsc.value
              //         ? a.creationTime.compareTo(b.creationTime)
              //         : b.creationTime.compareTo(a.creationTime));
              mediaResources.sort((a, b) => sortAsc
                  ? a.creationTime.compareTo(b.creationTime)
                  : b.creationTime.compareTo(a.creationTime));
              break;
            case SortType.size:
              // globalMediaResourcesController.mediaResources.sort((a, b) =>
              //     globalSettingsController.sortAsc.value
              //         ? a.sizeInBytes.compareTo(b.sizeInBytes)
              //         : b.sizeInBytes.compareTo(a.sizeInBytes));
              mediaResources.sort((a, b) => sortAsc
                  ? a.sizeInBytes.compareTo(b.sizeInBytes)
                  : b.sizeInBytes.compareTo(a.sizeInBytes));
              break;
            case SortType.sequence:
              // globalMediaResourcesController.mediaResources.sort((a, b) =>
              //     globalSettingsController.sortAsc.value
              //         ? a.sequence.compareTo(b.sequence)
              //         : b.sequence.compareTo(a.sequence));
              mediaResources.sort((a, b) => sortAsc
                  ? a.sequence.compareTo(b.sequence)
                  : b.sequence.compareTo(a.sequence));
              break;
          }
          ref
              .read(mediaResourcesProvider.notifier)
              .setResources(mediaResources);
          ref.read(mediaResourcesProvider.notifier).setCurrentIndex(0);
          ref.read(settingsProvider.notifier).saveSettings();
          Navigator.of(context).pop();
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Sort type:',
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text1)),
                  const Spacer(),
                  DropdownButton<SortType>(
                    value: sortType,
                    focusColor: ColorDark.defaultActive,
                    dropdownColor: ColorDark.bg2,
                    style: SemiTextStyles.header5ENRegular
                        .copyWith(color: ColorDark.text0),
                    items: SortType.values
                        .map((e) => DropdownMenuItem<SortType>(
                            value: e, child: Text(e.name)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(settingsProvider.notifier).setSortType(value);
                      }
                    },
                  )
                ],
              ),
              SizedBox(
                height: DesignValues.smallPadding,
              ),
              Row(
                children: [
                  Text('Sort order:',
                      style: SemiTextStyles.header5ENRegular
                          .copyWith(color: ColorDark.text1)),
                  const Spacer(),
                  DropdownButton<bool>(
                    value: sortAsc,
                    focusColor: ColorDark.defaultActive,
                    dropdownColor: ColorDark.bg2,
                    style: SemiTextStyles.header5ENRegular
                        .copyWith(color: ColorDark.text0),
                    items: const [
                      DropdownMenuItem<bool>(
                          value: true, child: Text('Ascending')),
                      DropdownMenuItem<bool>(
                          value: false, child: Text('Descending'))
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(settingsProvider.notifier).setSortAsc(value);
                      }
                    },
                  )
                ],
              ),
            ]));
  }
}

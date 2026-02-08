import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/settings.model.dart';
import '../../design_tokens.dart';
import 'dual_option_dialog.dart';

part 'media_resources_sort_dialog.g.dart';

@riverpod
class _MediaResourcesSortDialogNotifier
    extends _$MediaResourcesSortDialogNotifier {
  @override
  Sort build(Sort sort) {
    return sort.copyWith();
  }

  void setSortType(SortType sortType) {
    state = state.copyWith(sortType: sortType);
  }

  void setSortAsc(bool sortAsc) {
    state = state.copyWith(sortAsc: sortAsc);
  }
}

class MediaResourcesSortDialog extends ConsumerWidget {
  final Sort sort;

  const MediaResourcesSortDialog({super.key, required this.sort});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_mediaResourcesSortDialogProvider(sort));
    final notifier = ref.read(_mediaResourcesSortDialogProvider(sort).notifier);

    return DualOptionDialog(
        width: 400,
        height: 320,
        title: 'Sort',
        option1: 'Cancel',
        option2: 'OK',
        onOption1Pressed: () {
          Navigator.of(context).pop();
        },
        onOption2Pressed: () async {
          Navigator.of(context).pop(state);
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
                    value: state.sortType,
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
                        notifier.setSortType(value);
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
                    value: state.sortAsc,
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
                        notifier.setSortAsc(value);
                      }
                    },
                  )
                ],
              ),
            ]));
  }
}

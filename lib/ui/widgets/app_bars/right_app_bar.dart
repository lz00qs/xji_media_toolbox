import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/constants.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/app_bar_media_delete_button.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/app_bar_show_task_list_drawer_button.dart';

class RightAppBar extends StatelessWidget {
  final List<Widget> children;
  final bool disableDeleteButton;

  const RightAppBar(
      {super.key, required this.children, this.disableDeleteButton = false});

  @override
  Widget build(BuildContext context) {
    var appBarHeight = macAppBarHeight;
    if (GetPlatform.isWindows) {
      /// todo: implement windows app bar height
    }

    return SizedBox(
      height: appBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...children,
          if (!disableDeleteButton) const AppBarMediaDeleteButton(),
          const AppBarShowTaskListDrawerButton()
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/constants.dart';
import 'package:xji_footage_toolbox/ui/widgets/right_app_bar_media_delete_button.dart';
import 'package:xji_footage_toolbox/ui/widgets/show_transcode_tasks_drawer_button.dart';

class MainPageRightAppBar extends StatelessWidget {
  final List<Widget> children;

  const MainPageRightAppBar({super.key, required this.children});

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
          const RightAppBarMediaDeleteButton(),
          const ShowTranscodeTasksDrawerButton()
        ],
      ),
    );
  }
}

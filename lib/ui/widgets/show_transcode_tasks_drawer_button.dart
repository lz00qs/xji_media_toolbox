import 'package:flutter/material.dart';

import 'main_page_app_bar_button.dart';

class ShowTranscodeTasksDrawerButton extends StatelessWidget {
  const ShowTranscodeTasksDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainPageAppBarButton(
        iconData: Icons.task_alt,
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        });
  }
}

import 'package:flutter/material.dart';

import 'app_bar_button.dart';

class AppBarShowTaskListDrawerButton extends StatelessWidget {
  const AppBarShowTaskListDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarButton(
        iconData: Icons.task_alt,
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        });
  }
}

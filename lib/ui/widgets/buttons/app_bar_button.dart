import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData iconData;

  const AppBarButton(
      {super.key, this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    var appBarButtonSize = macAppBarHeight - 2 * macAppBarButtonPadding;
    var appBarButtonPadding = macAppBarButtonPadding;
    if (GetPlatform.isWindows) {
      /// todo: implement windows app bar height
    }
    return IconButton(
      padding: EdgeInsets.all(appBarButtonPadding),
      onPressed: onPressed,
      icon: Icon(
        iconData,
        size: appBarButtonSize,
      ),
    );
  }
}

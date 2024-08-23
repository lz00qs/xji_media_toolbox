import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/widgets/media_resource_delete_dialog_widget.dart';

import '../../constants.dart';

class RightAppBarMediaDeleteButton extends StatelessWidget {
  const RightAppBarMediaDeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    var appBarButtonSize = macAppBarHeight - 2 * macAppBarButtonPadding;
    var appBarButtonPadding = macAppBarButtonPadding;
    if (GetPlatform.isWindows) {
      /// todo: implement windows app bar height
    }
    return IconButton(
      padding: EdgeInsets.all(appBarButtonPadding),
      onPressed: () async {
        Get.dialog(const MediaResourceDeleteDialog());
      },
      icon: Icon(
        Icons.delete,
        size: appBarButtonSize,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/app_bar_button.dart';
import 'package:xji_footage_toolbox/ui/widgets/dialogs/media_resource_delete_dialog.dart';

class AppBarMediaDeleteButton extends StatelessWidget {
  const AppBarMediaDeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarButton(
        iconData: Icons.delete,
        onPressed: () {
          Get.dialog(const MediaResourceDeleteDialog(
            isDeleteMultipleMediaResources: false,
          ));
        });
  }
}

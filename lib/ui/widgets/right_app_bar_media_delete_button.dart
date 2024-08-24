import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/widgets/main_page_app_bar_button.dart';
import 'package:xji_footage_toolbox/ui/widgets/media_resource_delete_dialog.dart';

class RightAppBarMediaDeleteButton extends StatelessWidget {
  const RightAppBarMediaDeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainPageAppBarButton(
        iconData: Icons.delete,
        onPressed: () {
          Get.dialog(const MediaResourceDeleteDialog());
        });
  }
}

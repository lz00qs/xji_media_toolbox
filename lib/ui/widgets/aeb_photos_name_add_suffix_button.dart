import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/widgets/main_page_app_bar_button.dart';

import 'aeb_photos_name_add_suffix_dialog.dart';

class AebPhotosNameAddSuffixButton extends StatelessWidget {
  const AebPhotosNameAddSuffixButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainPageAppBarButton(iconData: Icons.drive_file_rename_outline, onPressed: () {
      Get.dialog(const AebPhotosNameAddSuffixDialog());
    });
  }
}

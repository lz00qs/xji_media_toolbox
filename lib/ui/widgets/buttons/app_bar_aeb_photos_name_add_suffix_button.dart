import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/app_bar_button.dart';

import '../dialogs/aeb_photos_name_add_suffix_dialog.dart';

class AppBarAebPhotosNameAddSuffixButton extends StatelessWidget {
  const AppBarAebPhotosNameAddSuffixButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarButton(iconData: Icons.drive_file_rename_outline, onPressed: () {
      Get.dialog(const AebPhotosNameAddSuffixDialog());
    });
  }
}

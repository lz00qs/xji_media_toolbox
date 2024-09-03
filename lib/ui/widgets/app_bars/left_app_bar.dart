import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/constants.dart';
import 'package:xji_footage_toolbox/ui/widgets/buttons/app_bar_button.dart';

import '../../../utils/media_resources_utils.dart';
import '../../pages/settings_page.dart';

class _MacLeftAppBar extends StatelessWidget {
  const _MacLeftAppBar();

  @override
  Widget build(BuildContext context) {
    var onPressed = false;
    return SizedBox(
      height: macAppBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 75,
          ),
          AppBarButton(
              iconData: Icons.folder_open,
              onPressed: () async {
                if (onPressed) {
                  return;
                }
                onPressed = true;
                await openMediaResourcesFolder();
                onPressed = false;
              }),
          AppBarButton(
              iconData: Icons.settings,
              onPressed: () {
                Get.to(() => const SettingsPage());
              }),
          AppBarButton(iconData: Icons.help, onPressed: () {}),
        ],
      ),
    );
  }
}

class LeftAppBar extends StatelessWidget {
  const LeftAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isMacOS
        ? const _MacLeftAppBar()
        : const SizedBox();
  }
}

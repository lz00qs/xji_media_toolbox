import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/constants.dart';
import 'package:xji_footage_toolbox/ui/widgets/main_page_app_bar_button.dart';

import '../../utils/media_resources_utils.dart';

class _MainPageMacLeftAppBar extends StatelessWidget {
  const _MainPageMacLeftAppBar();

  @override
  Widget build(BuildContext context) {
    var onPressed = false;
    // var appBarButtonSize = macAppBarHeight - 2 * macAppBarButtonPadding;
    return SizedBox(
      height: macAppBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 75,
          ),
          MainPageAppBarButton(
              iconData: Icons.folder_open,
              onPressed: () async {
                if (onPressed) {
                  return;
                }
                onPressed = true;
                await openMediaResourcesFolder();
                onPressed = false;
              }),
          MainPageAppBarButton(iconData: Icons.settings, onPressed: () {}),
          MainPageAppBarButton(iconData: Icons.help, onPressed: () {}),
        ],
      ),
    );
  }
}

class MainPageLeftAppBar extends StatelessWidget {
  const MainPageLeftAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isMacOS
        ? const _MainPageMacLeftAppBar()
        : const SizedBox();
  }
}

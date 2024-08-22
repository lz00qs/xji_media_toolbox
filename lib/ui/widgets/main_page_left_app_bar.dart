import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/constants.dart';

import '../../utils/media_resources_utils.dart';

class _MainPageMacLeftAppBar extends StatelessWidget {
  const _MainPageMacLeftAppBar();

  @override
  Widget build(BuildContext context) {
    var onPressed = false;
    var appBarButtonSize = macAppBarHeight - 2 * macAppBarButtonPadding;
    return SizedBox(
      height: macAppBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 75,
          ),
          IconButton(
            padding: const EdgeInsets.all(macAppBarButtonPadding),
            onPressed: () async {
              if (onPressed) {
                return;
              }
              onPressed = true;
              await openMediaResourcesFolder();
              onPressed = false;
            },
            icon: Icon(
              Icons.folder_open,
              size: appBarButtonSize,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(macAppBarButtonPadding),
            onPressed: () {},
            icon: Icon(Icons.settings, size: appBarButtonSize),
          ),
          IconButton(
            padding: const EdgeInsets.all(macAppBarButtonPadding),
            onPressed: () {},
            icon: Icon(Icons.help, size: appBarButtonSize),
          ),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

import '../../utils/media_resources_utils.dart';
import 'buttons/custom_icon_button.dart';
import 'dialogs/settings_dialog.dart';

class _MacAppBarIconButton extends StatelessWidget {
  static const double _buttonSize = 32.0;

  final IconData iconData;
  final VoidCallback onPressed;

  const _MacAppBarIconButton({required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      iconData: iconData,
      onPressed: onPressed,
      iconSize: DesignValues.mediumIconSize,
      buttonSize: _buttonSize,
      hoverColor: ColorDark.defaultHover,
      focusColor: ColorDark.defaultActive,
      iconColor: ColorDark.text0,
    );
  }
}

class _MacMainPageAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var onPressed = false;
    return SizedBox(
      height: DesignValues.macAppBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 84,
          ),
          _MacAppBarIconButton(
              iconData: Icons.folder_open,
              onPressed: () async {
                if (onPressed) {
                  return;
                }
                onPressed = true;
                await openMediaResourcesFolder();
                onPressed = false;
              }),
          SizedBox(
            width: DesignValues.mediumPadding,
          ),
          _MacAppBarIconButton(
              iconData: Icons.settings,
              onPressed: () async {
                if (onPressed) {
                  return;
                }
                onPressed = true;
                await Get.dialog(const SettingsDialog());
                onPressed = false;
              }),
          const Spacer(),
          _MacAppBarIconButton(
              iconData: Icons.playlist_add_check_outlined,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              }),
          SizedBox(width: DesignValues.ultraSmallPadding,)
        ],
      ),
    );
  }
}

class MainPageAppBar extends StatelessWidget {
  const MainPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    /// todo: implement windows app bar height

    return Container(
      color: ColorDark.bg4,
      // color: const Color.fromRGBO(79, 81, 89, 1),
      child: GetPlatform.isMacOS ? _MacMainPageAppBar() : const SizedBox(),
    );
  }
}

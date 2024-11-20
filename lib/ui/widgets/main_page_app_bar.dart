import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

import '../../utils/media_resources_utils.dart';
import 'buttons/custom_icon_button.dart';
import 'dialogs/settings_dialog.dart';

class _AppBarIconButton extends StatelessWidget {
  static const double _buttonSize = 32.0;

  final IconData iconData;
  final VoidCallback onPressed;

  const _AppBarIconButton({required this.iconData, required this.onPressed});

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

class _WinBarActionButton extends StatelessWidget {
  static const _buttonSize = 32.0;

  final String icon;
  final VoidCallback onPressed;

  const _WinBarActionButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      icon: Iconify(
        icon,
        color: ColorDark.text2,
        size: DesignValues.mediumIconSize,
      ),
      onPressed: onPressed,
      hoverColor: ColorDark.defaultHover,
      focusColor: ColorDark.defaultActive,
      style: ButtonStyle(
        minimumSize:
            WidgetStateProperty.all<Size>(const Size(_buttonSize, _buttonSize)),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(0)),
      ),
    );
  }
}

class _MacMainPageAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var onPressed = false;
    return SizedBox(
      height: DesignValues.appBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 84,
          ),
          _AppBarIconButton(
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
          _AppBarIconButton(
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
          _AppBarIconButton(
              iconData: Icons.list,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              }),
          SizedBox(
            width: DesignValues.ultraSmallPadding,
          )
        ],
      ),
    );
  }
}

class _WinMainPageAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var onPressed = false;
    final isMaximizedObx = false.obs;
    return SizedBox(
      height: DesignValues.appBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: DesignValues.mediumPadding,
          ),
          _AppBarIconButton(
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
          _AppBarIconButton(
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
          _AppBarIconButton(
              iconData: Icons.list,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              }),
          SizedBox(
            width: DesignValues.largePadding,
          ),
          _WinBarActionButton(
              icon: Mdi.window_minimize,
              onPressed: () {
                WindowManager.instance.minimize();
              }),
          SizedBox(
            width: DesignValues.mediumPadding,
          ),
          Obx(() => _WinBarActionButton(
              icon: isMaximizedObx.value
                  ? Mdi.window_restore
                  : Mdi.window_maximize,
              onPressed: () {
                if (isMaximizedObx.value) {
                  WindowManager.instance.restore();
                } else {
                  WindowManager.instance.maximize();
                }
                isMaximizedObx.value = !isMaximizedObx.value;
              })),
          SizedBox(
            width: DesignValues.mediumPadding,
          ),
          _WinBarActionButton(
              icon: Mdi.window_close,
              onPressed: () {
                WindowManager.instance.close();
              }),
          SizedBox(
            width: DesignValues.smallPadding,
          ),
        ],
      ),
    );
  }
}

class MainPageAppBar extends StatelessWidget {
  const MainPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(
        child: Container(
      color: ColorDark.bg4,
      // color: const Color.fromRGBO(79, 81, 89, 1),
      child: GetPlatform.isMacOS ? _MacMainPageAppBar() : _WinMainPageAppBar(),
    ));
  }
}

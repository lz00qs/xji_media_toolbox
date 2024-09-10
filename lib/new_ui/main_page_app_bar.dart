import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/new_ui/design_tokens.dart';

class _MacAppBarIconButton extends StatelessWidget {
  static const double _buttonSize = 32.0;

  final IconData iconData;
  final VoidCallback onPressed;

  const _MacAppBarIconButton({required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _buttonSize,
      width: _buttonSize,
      child: IconButton(
          padding: const EdgeInsets.all(0),
          hoverColor: ColorDark.defaultHover,
          focusColor: ColorDark.defaultActive,
          onPressed: onPressed,
          icon: Icon(
            iconData,
            size: DesignValues.mediumIconSize,
            color: ColorDark.text0,
          )),
    );
  }
}

class _MacMainPageAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              iconData: Icons.folder_open, onPressed: () async {}),
          SizedBox(
            width: DesignValues.mediumPadding,
          ),
          _MacAppBarIconButton(iconData: Icons.settings, onPressed: () {}),
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

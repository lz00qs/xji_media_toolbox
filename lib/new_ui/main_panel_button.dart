import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/new_ui/design_tokens.dart';

class MainPanelButton extends StatelessWidget {
  static const double _buttonSize = 64.0;
  final IconData iconData;
  final VoidCallback onPressed;

  const MainPanelButton(
      {super.key, required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorDark.bg3,
        iconColor: ColorDark.text0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignValues.mediumBorderRadius),
        ),
        overlayColor: ColorDark.defaultHover,
        shadowColor: ColorDark.defaultActive,
        fixedSize: const Size(_buttonSize, _buttonSize),
        padding: EdgeInsets.zero,
      ),
      child: Icon(
        iconData,
        size: 48,
      ),
    );
  }
}

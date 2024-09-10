import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  final double iconSize;
  final double buttonSize;
  final Color hoverColor;
  final Color focusColor;
  final Color iconColor;

  const CustomIconButton(
      {super.key,
      required this.iconData,
      required this.onPressed,
      required this.iconSize,
      required this.buttonSize,
      required this.hoverColor,
      required this.focusColor,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonSize,
      width: buttonSize,
      child: IconButton(
          padding: const EdgeInsets.all(0),
          hoverColor: hoverColor,
          focusColor: focusColor,
          onPressed: onPressed,
          icon: Icon(
            iconData,
            size: iconSize,
            color: iconColor,
          )),
    );
  }
}

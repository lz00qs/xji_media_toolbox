import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/new_ui/design_tokens.dart';

import 'custom_icon_button.dart';

class CustomDialogCheckBoxWithText extends StatelessWidget {
  final String text;
  final bool value;
  final VoidCallback onPressed;

  const CustomDialogCheckBoxWithText(
      {super.key,
      required this.text,
      required this.value,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomDialogIconButtonWithText(
        iconData: value ? Icons.check_box : Icons.check_box_outline_blank,
        text: text,
        onPressed: onPressed);
  }
}

class CustomDialogIconButtonWithText extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onPressed;

  const CustomDialogIconButtonWithText(
      {super.key,
      required this.iconData,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style:
              SemiTextStyles.header5ENRegular.copyWith(color: ColorDark.text1),
        ),
        const Spacer(),
        CustomIconButton(
            iconData: iconData,
            onPressed: onPressed,
            iconSize: DesignValues.mediumIconSize,
            buttonSize: 24,
            hoverColor: ColorDark.defaultHover,
            focusColor: ColorDark.defaultActive,
            iconColor: ColorDark.text0)
      ],
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOption1;
  final bool disabled;

  const _OptionButton(
      {required this.text,
      required this.onPressed,
      required this.isOption1,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disabled ? null : onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(ColorDark.defaultHover),
      ),
      child: Text(
        text,
        style: SemiTextStyles.header5ENRegular.copyWith(
            color: disabled
                ? ColorDark.disabledText
                : isOption1
                    ? ColorDark.danger
                    : ColorDark.info),
      ),
    );
  }
}

class CustomDualOptionDialog extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final String title;
  final String option1;
  final String option2;
  final VoidCallback onOption1Pressed;
  final VoidCallback onOption2Pressed;
  final bool disableOption1;
  final bool disableOption2;

  const CustomDualOptionDialog(
      {super.key,
      required this.width,
      required this.height,
      required this.child,
      required this.title,
      required this.option1,
      required this.option2,
      required this.onOption1Pressed,
      required this.onOption2Pressed,
      this.disableOption1 = false,
      this.disableOption2 = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignValues.mediumBorderRadius),
          child: Container(
            color: ColorDark.bg2,
            width: width,
            height: height,
            child: Padding(
                padding: EdgeInsets.all(DesignValues.largePadding),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: SemiTextStyles.header1ENRegular
                            .copyWith(color: ColorDark.text0),
                      ),
                      SizedBox(height: DesignValues.mediumPadding),
                      Expanded(child: child),
                      SizedBox(height: DesignValues.mediumPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _OptionButton(
                            onPressed: onOption1Pressed,
                            text: option1,
                            isOption1: true,
                            disabled: disableOption1,
                          ),
                          SizedBox(width: DesignValues.mediumPadding),
                          _OptionButton(
                            onPressed: onOption2Pressed,
                            text: option2,
                            isOption1: false,
                            disabled: disableOption2,
                          ),
                        ],
                      ),
                    ])),
          ),
        ));
  }
}

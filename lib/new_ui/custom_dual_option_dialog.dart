import 'package:flutter/material.dart';
import 'package:xji_footage_toolbox/new_ui/design_tokens.dart';

class _OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOption1;

  const _OptionButton(
      {required this.text, required this.onPressed, required this.isOption1});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(ColorDark.defaultHover),
      ),
      child: Text(
        text,
        style: SemiTextStyles.header5ENRegular
            .copyWith(color: isOption1 ? ColorDark.danger : ColorDark.info),
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
                          disableOption1 ? const SizedBox() : _OptionButton(
                            onPressed: onOption1Pressed,
                            text: option1,
                            isOption1: true,
                          ),
                          SizedBox(width: DesignValues.mediumPadding),
                          disableOption2 ? const SizedBox() : _OptionButton(
                            onPressed: onOption2Pressed,
                            text: option2,
                            isOption1: false,
                          ),
                        ],
                      ),
                    ])),
          ),
        ));
  }
}

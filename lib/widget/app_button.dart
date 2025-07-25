import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urticaria/widget/touchable_opacity.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/styles.dart';

enum ButtonType { small, normal }

class AppButton extends StatelessWidget {
  final String title;
  final double? width;
  final String? iconRight;
  final String? iconLeft;
  final Color? backgroundColor;
  final Gradient? gradient;
  final List<Color>? listColor;
  final Function onPressed;
  final bool isLeftGradient;
  final ButtonType type;
  final TextStyle? labelStyle;
  final double? height;
  final bool isDisable;
  final Widget? childWidget;
  final Color? iconLeftColor;
  final Color? iconRightColor;
  final Color? primaryColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;

  const AppButton({
    Key? key,
    required this.title,
    this.iconRight,
    this.primaryColor,
    this.backgroundColor = AppColors.primary500,
    this.gradient,
    this.listColor,
    required this.onPressed,
    this.iconLeft,
    this.width,
    this.isLeftGradient = false,
    this.type = ButtonType.normal,
    this.labelStyle,
    this.height,
    this.isDisable = false,
    this.childWidget,
    this.iconLeftColor = AppColors.neutral100,
    this.iconRightColor = AppColors.neutral100,
    this.borderRadius,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => isDisable ? {} : onPressed(),
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        height: height ??
            (type == ButtonType.normal
                ? Constants.buttonHeight
                : Constants.buttonHeightSmall),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          gradient: gradient,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          color: primaryColor ?? AppColors.primary,
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(ViewConstants.defaultBorderRadiusBtn),
              ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconLeft != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isLeftGradient ? 12 : 4),
                    child: SvgPicture.asset(
                      iconLeft!,
                      color: iconLeftColor,
                      height: 20,
                    ),
                  )
                : const SizedBox(
                    width: 12,
                  ),
            childWidget ??
                Text(
                  title,
                  style: labelStyle ?? Styles.titleButton,
                ),
            iconRight != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isLeftGradient ? 12 : 4),
                    child: SvgPicture.asset(
                      iconRight!,
                      color: iconRightColor,
                      width: 20,
                    ))
                : const SizedBox(
                    width: 12,
                  ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class PrimaryButtons extends StatelessWidget {
  const PrimaryButtons({
    super.key,
    required this.buttonStyle,
    required this.onTap,
    this.title,
    this.titleSize,
    this.context,
    this.textColor,
    this.bgColor,
    this.borderColor,
    this.icon,
    this.iconLeftPosition = true,
  });

  final ButtonsStyle buttonStyle;
  final VoidCallback onTap;
  final String? title;
  final double? titleSize;
  final BuildContext? context;
  final Color? textColor;
  final Color? bgColor;
  final Color? borderColor;
  final Widget? icon;
  final bool? iconLeftPosition;

  @override
  Widget build(BuildContext context) {
    switch (buttonStyle) {

      case (ButtonsStyle.activePrimaryButton):
        return activePrimaryButton(onTap, title, icon, context);

      case (ButtonsStyle.activeSecondaryButton):
        return activeSecondaryButton(onTap, title, icon, context);

      case (ButtonsStyle.iconicDynamicButton):
        return iconicDynamicButton(onTap, title, icon, context,bgColor,borderColor,textColor);

      case (ButtonsStyle.cancelButton):
        return cancelButton(title, context, onTap);

      case (ButtonsStyle.disableButton):
        return disableButton(title, context, onTap);

      case (ButtonsStyle.authButton):
        return authButton(onTap, title, icon, context,bgColor,borderColor,textColor);
      }
  }

  Widget activePrimaryButton(VoidCallback onClick, String? title, Widget? icon, context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10,),
        decoration: ShapeDecoration(
          color: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            icon ?? const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget activeSecondaryButton(VoidCallback onClick, String? title, Widget? icon, context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.primary),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: titleSize ?? TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            icon ?? const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget disableButton(String? title, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          decoration: BoxDecoration(
              color: AppColors.disableBackground,
              borderRadius: BorderRadius.circular(6),),
          child: Text(
            title ?? '',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.disableText,
                fontSize: titleSize ?? TextSize.font14(context)),
          )),
    );
  }

  Widget cancelButton(String? title, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10,),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.greyLight, width: 1),),
        child: Text(
          title ?? '',
          style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
              fontSize: titleSize ?? TextSize.font14(context)),
        ),
      ),
    );
  }

  Widget iconicDynamicButton(VoidCallback onClick, String? title, Widget? icon, context,Color? bgColor,Color? borderColor,Color? textColor) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
            border: Border.all(color: borderColor ?? Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iconLeftPosition! && icon != null) icon,
            if (iconLeftPosition! && icon != null) const SizedBox(width: 10),
            Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!iconLeftPosition! && icon != null) const SizedBox(width: 10),
            if (!iconLeftPosition! && icon != null) icon,
          ],
        ),
      ),
    );
  }

  Widget authButton(VoidCallback onClick, String? title, Widget? icon, context,Color? bgColor,Color? borderColor,Color? textColor) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
            border: Border.all(color: borderColor ?? Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ?? const SizedBox(width: 10),
            const SizedBox(width: 10,),
            Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: TextSize.font16(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

enum ButtonsStyle {
  activePrimaryButton,
  activeSecondaryButton,
  disableButton,
  cancelButton,
  iconicDynamicButton,
  authButton
}

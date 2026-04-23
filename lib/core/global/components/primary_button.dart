import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class PrimaryButtons extends StatelessWidget {
  const PrimaryButtons({
    super.key,
    required this.buttonStyle,
    required this.onTap,
    this.title,
    this.titleSize,
    this.iconSize,
    this.context,
    this.textColor,
    this.bgColor,
    this.borderColor,
    this.svgIconColor,
    this.svgIconPath,
    this.iconLeftPosition = true,
    this.isExpand = true,
    this.verticalPadding,
    this.horizontalPadding,
  });

  final ButtonsStyle buttonStyle;
  final VoidCallback onTap;
  final String? title;
  final double? titleSize;
  final double? iconSize;
  final BuildContext? context;
  final Color? textColor;
  final Color? bgColor;
  final Color? borderColor;
  final Color? svgIconColor;
  final bool? iconLeftPosition;
  final String? svgIconPath;
  final bool isExpand;
  final double? verticalPadding;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    switch (buttonStyle) {
      case (ButtonsStyle.activePrimaryButton):
        return activePrimaryButton(context);

      case (ButtonsStyle.activeSecondaryButton):
        return activeSecondaryButton(context);

      case (ButtonsStyle.iconicDynamicButton):
        return iconicDynamicButton(context);

      case (ButtonsStyle.cancelButton):
        return cancelButton(context);

      case (ButtonsStyle.disableButton):
        return disableButton(context);

      case (ButtonsStyle.authButton):
        return authButton(context);
    }
  }

  Widget activePrimaryButton(context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,horizontal: 16
        ),
        decoration: ShapeDecoration(
          color: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Row(
          mainAxisSize: isExpand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget activeSecondaryButton(context) {
    return GestureDetector(
      onTap: onTap,
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
          ],
        ),
      ),
    );
  }

  Widget disableButton(context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: AppColors.disableBackground,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            title ?? '',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.disableText,
                fontSize: titleSize ?? TextSize.font14(context)),
          )),
    );
  }

  Widget cancelButton(context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.greyLight, width: 1),
        ),
        child: Text(
          title ?? '',
          style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.w500,
              fontSize: titleSize ?? TextSize.font14(context)),
        ),
      ),
    );
  }

  Widget iconicDynamicButton(context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.symmetric(vertical: verticalPadding ?? 10),
        decoration: BoxDecoration(
          color: bgColor,
          border:
              Border.all(color: borderColor ?? Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iconLeftPosition! && svgIconPath != null)
              ShowImage(
                imagePath: svgIconPath,
                width: iconSize ?? 20,
                height: iconSize ?? 20,
                color: svgIconColor,
              ),
            if (iconLeftPosition! && svgIconPath != null)
              const SizedBox(
                width: 8,
              ),
            Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!iconLeftPosition! && svgIconPath != null)
              const SizedBox(
                width: 8,
              ),
            if (!iconLeftPosition! && svgIconPath != null)
              ShowImage(
                imagePath: svgIconPath,
                width: 20,
                height: 20,
                color: svgIconColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget authButton(context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          border:
              Border.all(color: borderColor ?? Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            svgIconPath != null
                ? ShowImage(
                    imagePath: svgIconPath,
                    width: 20,
                    height: 20,
                    color: svgIconColor,
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              width: 10,
            ),
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

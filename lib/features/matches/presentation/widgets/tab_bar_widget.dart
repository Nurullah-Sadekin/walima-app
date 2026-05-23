import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    super.key,
    required this.text,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.padding,
    this.fontSize,
    this.isSelected = false,
    this.selectedBackgroundColor,
    this.selectedTextColor,
    this.selectedBorderColor,
    this.prefixImagePath,
    this.count,
    this.isBorder = false,
  });

  final String text;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final bool isSelected;
  final Color? selectedBackgroundColor;
  final Color? selectedTextColor;
  final Color? selectedBorderColor;
  final String? prefixImagePath;
  final double? count;
  final bool isBorder;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = isSelected
        ? (selectedBackgroundColor ?? AppColors.primary)
        : (backgroundColor ?? AppColors.white);

    final effectiveTextColor = isSelected
        ? (selectedTextColor ?? AppColors.white)
        : (textColor ?? AppColors.textSecondaryLight);

    final effectiveBorderColor = isSelected
        ? (selectedBorderColor ?? AppColors.primary)
        : (borderColor ?? AppColors.greyLight);

    final effectiveBorderWidth = borderWidth ?? 1.0;
    final effectiveBorderRadius = borderRadius ?? 6.0;
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
    final effectiveFontSize = fontSize ?? TextSize.font14(context);
    const effectiveFontWeight = FontWeight.w500;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: effectivePadding,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          border: isSelected
              ? isBorder
                  ? Border.all(color: effectiveBorderColor, width: 1)
                  : const Border()
              : Border.all(
                  color: effectiveBorderColor,
                  width: effectiveBorderWidth,
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            if (prefixImagePath != null) ...[
              ShowImage(
                imagePath: prefixImagePath!,
                width: effectiveFontSize,
                height: effectiveFontSize,
                color: effectiveTextColor,
              ),
            ],
            Text(
              text.localized(context),
              style: TextStyle(
                color: effectiveTextColor,
                fontSize: effectiveFontSize,
                fontWeight: effectiveFontWeight,
              ),
            ),
            if (count != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.white : AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count!.toInt().toString(),
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';

class InfoCardWidget extends StatelessWidget {

  const InfoCardWidget({
    super.key,
    required this.title,
    required this.description,
    this.backgroundColor,
    this.borderColor,
    this.titleColor,
    this.descriptionColor,
    this.titleFontSize,
    this.descriptionFontSize,
    this.titleFontWeight,
    this.descriptionFontWeight,
    this.padding,
    this.spacing,
    this.borderRadius,
    this.borderWidth,
  });

  final String title;
  final String description;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? titleColor;
  final Color? descriptionColor;
  final double? titleFontSize;
  final double? descriptionFontSize;
  final FontWeight? titleFontWeight;
  final FontWeight? descriptionFontWeight;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final double? borderRadius;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryVariant,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: Border.all(
          color: borderColor ?? AppColors.primary,
          width: borderWidth ?? 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: spacing ?? 8,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor ?? AppColors.textPrimaryLight,
              fontSize: titleFontSize ?? TextSize.font14(context),
              fontWeight: titleFontWeight ?? FontWeight.w500,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              color: descriptionColor ?? AppColors.textSecondaryLight,
              fontSize: descriptionFontSize ?? TextSize.font12(context),
              fontWeight: descriptionFontWeight ?? FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
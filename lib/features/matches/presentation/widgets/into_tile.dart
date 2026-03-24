import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class InfoTile extends StatelessWidget { // Control leading image visibility

  const InfoTile({
    super.key,
    required this.title,
    required this.value,
    this.leadingImagePath = AppImages.editWrite,
    this.trailingImagePath,
    this.leadingImageColor,
    this.trailingImageColor,
    this.leadingBackgroundColor,
    this.onTap,
    this.titleStyle,
    this.valueStyle,
    this.leadingImageSize = 16,
    this.trailingImageSize = 16,
    this.leadingRadius = 14,
    this.padding,
    this.showTrailingImage = true,
    this.showLeadingImage = true,
  });
  final String title;
  final String value;
  final String? leadingImagePath ; // Optional leading image
  final String? trailingImagePath; // Optional trailing image
  final Color? leadingImageColor;
  final Color? trailingImageColor;
  final Color? leadingBackgroundColor;
  final VoidCallback? onTap; // For edit functionality
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final double? leadingImageSize;
  final double? trailingImageSize;
  final double? leadingRadius;
  final EdgeInsetsGeometry? padding;
  final bool showTrailingImage ; // Control trailing image visibility
  final bool showLeadingImage ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.greyLight, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - Leading image and title
            Row(
              spacing: 8,
              children: [
                if (showLeadingImage && leadingImagePath != null)
                  CircleAvatar(
                    radius: leadingRadius,
                    backgroundColor: leadingBackgroundColor ?? AppColors.primaryVariant,
                    child: ShowImage(
                      imagePath: leadingImagePath!,
                      width: leadingImageSize,
                      height: leadingImageSize,
                      color: leadingImageColor ?? AppColors.primary,
                    ),
                  ),
                Text(
                  title,
                  style: titleStyle ??
                      TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: TextSize.font12(context),
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),

            // Right side - Value and trailing image
            Row(
              spacing: 8,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: valueStyle ??
                      TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontSize: TextSize.font12(context),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (showTrailingImage && trailingImagePath != null)
                  ShowImage(
                    imagePath: trailingImagePath!,
                    width: trailingImageSize,
                    height: trailingImageSize,
                    color: trailingImageColor ?? AppColors.primary,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class InfoTile extends StatelessWidget { // Control leading image visibility

  const InfoTile({
    super.key,
    required this.title,
    this.value,
    this.subtitle,
    this.leadingImagePath,
    this.trailingImagePath = AppImages.editWrite,
    this.leadingImageColor,
    this.trailingImageColor,
    this.leadingBackgroundColor,
    this.onTap,
    this.titleStyle,
    this.valueStyle,
    this.leadingImageSize = 16,
    this.trailingImageSize = 16,
    this.leadingRadius = 14,
    this.borderRadius,
    this.padding,
    this.showTrailingImage = true,
    this.showLeadingImage = true,
  });
  final String title;
  final String? value;
  final String? subtitle;
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
  final double? borderRadius;
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
          borderRadius: BorderRadius.circular( borderRadius ?? 4),
          border: Border.all(color: AppColors.greyLight, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 8,
          children: [
            // Left side - Leading image and title
            Expanded(
              child: Row(
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
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: titleStyle ??
                              TextStyle(
                                color: subtitle != null ?  AppColors.textPrimaryLight : AppColors.textSecondaryLight,
                                fontSize:  subtitle != null ? TextSize.font14(context) : TextSize.font12(context),
                                fontWeight: subtitle != null ?  FontWeight.w500: FontWeight.w400,
                              ),
                        ),
                        if(subtitle != null)...[
                          const SizedBox(height: 4,),
                          Text(
                            subtitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle ??
                                TextStyle(
                                  color: AppColors.textSecondaryLight,
                                  fontSize: TextSize.font12(context),
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                if (value != null)
                Flexible(
                  child: Text(
                    value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: valueStyle ??
                        TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                if (showTrailingImage)
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
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class EmptyStateWidget extends StatelessWidget {

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onTap,
    this.showButton = true,
    this.horizontalPadding,
    this.spacing,
    this.imagePath,
    this.imageSize,
    this.imageColor,
  });
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onTap;
  final bool showButton;
  final double? horizontalPadding;
  final double? spacing;
  final String? imagePath;
  final double? imageSize;
  final Color? imageColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 12.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null) ...[
            ShowImage(
              imagePath: imagePath!,
              width: imageSize ?? 80,
              height: imageSize ?? 80,
              color: imageColor ?? AppColors.hintTextColor,
            ),
            SizedBox(height: spacing ?? 16),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: TextSize.font20(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing ?? 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w400,
            ),
          ),
          if (showButton && buttonText != null) ...[
            SizedBox(height: spacing ?? 16),
            PrimaryButtons(
              buttonStyle: ButtonsStyle.activePrimaryButton,
              onTap: onTap ?? () {},
              title: buttonText,
              isExpand: false,
            ),
          ],
        ],
      ),
    );
  }
}
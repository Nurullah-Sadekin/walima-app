import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class SafetyTipCard extends StatelessWidget {

  const SafetyTipCard({
    super.key,
    this.customMessage,
    this.backgroundColor,
    this.iconPath,
    this.title,
  });

  final String? customMessage;
  final Color? backgroundColor;
  final String? iconPath;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFFFD9C0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 6,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               ShowImage(
                imagePath: iconPath ?? AppImages.safetySvgIcon,
                width: 15,
                height: 18,
                color: AppColors.textPrimaryLight,
              ),
              Text(
                title ?? 'Safety First',
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            customMessage ??  'Be respectful. Never share financial information, and avoid sharing personal details with matches you don’t know to stay safe at all times.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
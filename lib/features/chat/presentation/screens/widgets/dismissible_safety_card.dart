import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class DismissibleSafetyCard extends StatelessWidget {

  const DismissibleSafetyCard({
    super.key,
    required this.title,
    required this.message,
    required this.iconPath,
    this.onTap,
    this.backgroundColor,
    this.elevation,
  });
  final String title;
  final String message;
  final String iconPath;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShowImage(
          imagePath: iconPath,
          width: TextSize.font20(context),
          height: TextSize.font20(context),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 6,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Usage:
// SafetyTipCard(
//   title: 'Take Your Time',
//   message: 'Get to know someone well before taking the conversation offline.',
//   iconPath: AppImages.safetySvgIcon,
//   onTap: () => print('Safety tip tapped'),
// )
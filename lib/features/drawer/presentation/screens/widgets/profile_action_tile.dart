import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class ProfileActionTile extends StatelessWidget {
  const ProfileActionTile({
    super.key,
    required this.iconImagePath,
    required this.title,
    this.onTap,
    this.iconSize = 16,
    this.iconContainerSize = 32, // 16 + 8+8 padding
    this.iconColor = AppColors.textSecondaryLight,
    this.iconBackgroundColor = AppColors.disableBackground,
    this.textColor = AppColors.textSecondaryLight,
    this.arrowColor = AppColors.hintTextColor,
    this.titleStyle,
    this.trailing,
    this.showTrailing = true,
  });
  final String iconImagePath;
  final String title;
  final VoidCallback? onTap;
  final double iconSize;
  final double iconContainerSize;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color textColor;
  final Color arrowColor;
  final TextStyle? titleStyle;
  final Widget? trailing;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 8,
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: ShowImage(
                  imagePath: iconImagePath,
                  width: iconSize,
                  height: iconSize,
                  color: iconColor,
                ),
              ),
              // Title Text
              Text(
                title.localized(context),
                style: titleStyle ??
                    TextStyle(
                      color: textColor,
                      fontSize: TextSize.font14(context),
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
          ),
          // Trailing Arrow or Custom Widget
          if (showTrailing)
            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: TextSize.font14(context),
                  color: arrowColor,
                ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class VerificationTile extends StatelessWidget {
  const VerificationTile({
    super.key,
    required this.iconImagePath,
    required this.title,
    this.titleSize,
    this.statusText,
    this.statusColor,
    this.statusBackgroundColor,
    this.onTap,
    this.iconSize = 26,
    this.iconColor,
    this.statusFontSize = 10,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    this.backgroundColor = AppColors.white,
    this.borderColor = AppColors.greyLight,
    this.titleColor = AppColors.textPrimaryLight,
    this.arrowColor = AppColors.hintTextColor,
    this.titleStyle,
    this.statusStyle,
    this.trailing,
    this.showArrow = true,
    this.customStatusBadge,
  });
  final String iconImagePath;
  final String title;
  final double? titleSize;
  final String? statusText;
  final Color? statusColor;
  final Color? statusBackgroundColor;
  final VoidCallback? onTap;
  final double iconSize;
  final Color? iconColor;
  final double statusFontSize;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color arrowColor;
  final TextStyle? titleStyle;
  final TextStyle? statusStyle;
  final Widget? trailing;
  final bool showArrow;
  final Widget? customStatusBadge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                // Icon
                ShowImage(
                  imagePath: iconImagePath,
                  width: iconSize,
                  height: iconSize,
                  color: iconColor ?? AppColors.primary,
                ),
                // Title
                Text(
                  title.localized(context),
                  style: titleStyle ??
                      TextStyle(
                        color: titleColor,
                        fontSize: titleSize ?? TextSize.font14(context),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                // Status Badge (Custom or Default)
                customStatusBadge ??
                    (statusText == null || statusText!.isEmpty
                        ? const SizedBox()
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: statusBackgroundColor,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              statusText!.localized(context),
                              style: statusStyle ??
                                  TextStyle(
                                    color: statusColor,
                                    fontSize: TextSize.font10(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          )),
              ],
            ),
            // Trailing Arrow or Custom Widget
            if (showArrow)
              trailing ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: TextSize.font14(context),
                    color: arrowColor,
                  ),
          ],
        ),
      ),
    );
  }
}

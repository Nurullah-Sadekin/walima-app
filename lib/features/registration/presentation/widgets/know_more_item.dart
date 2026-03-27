import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class KnowMoreItemCard extends StatelessWidget {
  const KnowMoreItemCard({
    super.key,
    required this.text,
    this.icon,
    this.iconColor,
    this.iconPadding,
    this.iconSize,
    this.maxLines = 2,
    this.textStyle,
    this.spacing = 8,
    this.isActive,
  });
  final String text;
  final IconData? icon;
  final Color? iconColor;
  final double? iconPadding;
  final double? iconSize;
  final int? maxLines;
  final TextStyle? textStyle;
  final double spacing;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing,
      children: [
        if (isActive != null)
        ShowImage(
          imagePath: isActive!
              ? AppImages.successCircle
              : AppImages.cancelCircle,
          height: iconSize ?? TextSize.font18(context),
          width: iconSize ?? TextSize.font18(context),
        ),
        if (isActive == null)
        Padding(
          padding: EdgeInsets.symmetric(vertical: iconPadding ?? 2.0),
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize ?? TextSize.font18(context),
          ),
        ),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: textStyle ??
                TextStyle(
                  fontSize: TextSize.font12(context),
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ],
    );
  }
}

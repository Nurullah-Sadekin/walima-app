import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class KnowMoreItemCard extends StatelessWidget {

  const KnowMoreItemCard({
    super.key,
    required this.text,
    required this.icon,
    required this.iconColor,
    this.iconPadding,
    this.iconSize,
    this.maxLines = 2,
    this.textStyle,
    this.spacing = 8,
  });
  final String text;
  final IconData icon;
  final Color iconColor;
  final double? iconPadding;
  final double? iconSize;
  final int? maxLines;
  final TextStyle? textStyle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(vertical: iconPadding ?? 2.0),
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
            style: textStyle ?? TextStyle(
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
import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class IconTitleCard extends StatelessWidget {
  const IconTitleCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.textColor,
    this.iconSize = 16,
    this.iconWidth,
    this.iconHeight,
    this.spacing = 6,
    this.borderRadius = 4,
    this.padding,
    this.mood = IconTitleCardMood.vertical,
    this.onTap,
  });
  final String imagePath;
  final String title;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? textColor;
  final double iconSize;
  final double? iconWidth;
  final double? iconHeight;
  final double spacing;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final IconTitleCardMood mood;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = mood == IconTitleCardMood.vertical
        ? _buildVertical(context)
        : _buildHorizontal(context);

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }

    return content;
  }

  Widget _buildVertical(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: spacing,
      children: [
        _buildIconContainer(context),
        _buildTitle(context),
      ],
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: spacing,
      children: [
        _buildIconContainer(context),
        _buildTitle(context),
      ],
    );
  }

  Widget _buildIconContainer(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        border: Border.all(color: borderColor ?? AppColors.transparent),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ShowImage(
        imagePath: imagePath,
        width: iconWidth ?? iconSize,
        height: iconHeight ?? iconSize,
        radius: BorderRadius.circular(borderRadius),
        fit: BoxFit.contain,
        color: iconColor ?? AppColors.white,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title.localized(context),
      style: TextStyle(
        fontSize: TextSize.font12(context),
        fontWeight: FontWeight.w400,
        color: textColor ?? AppColors.textSecondaryLight,
      ),
    );
  }
}

enum IconTitleCardMood {
  vertical,
  horizontal,
}

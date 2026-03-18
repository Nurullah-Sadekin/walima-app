import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class IconTitleCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final Color? backgroundColor;
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

  const IconTitleCard({
    Key? key,
    required this.imagePath,
    required this.title,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.iconSize = 16,
    this.iconWidth,
    this.iconHeight,
    this.spacing = 4,
    this.borderRadius = 4,
    this.padding,
    this.mood = IconTitleCardMood.vertical,
    this.onTap,
  }) : super(key: key);

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
      children: [
        _buildIconContainer(context),
        const SizedBox(height: 4),
        _buildTitle(context),
      ],
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconContainer(context),
        const SizedBox(width: 4),
        _buildTitle(context),
      ],
    );
  }

  Widget _buildIconContainer(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
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
      title,
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
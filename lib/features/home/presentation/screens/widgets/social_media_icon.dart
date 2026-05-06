import 'package:flutter/material.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';

class SocialMediaIcon extends StatelessWidget {

  const SocialMediaIcon({
    super.key,
    required this.imagePath,
    this.size = 24,
    this.backgroundColor = AppColors.disableBackground,
    this.borderColor = AppColors.greyLight,
    this.iconColor = AppColors.textSecondaryLight,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(8),
    this.onTap,
    this.shape = BoxShape.rectangle,
  });

  final String imagePath;
  final double size;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(borderRadius) : null,
        shape: shape,
        border: Border.all(color: borderColor),
      ),
      child: ShowImage(
        imagePath: imagePath,
        color: iconColor,
        height: size,
        width: size,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: widget,
      );
    }

    return widget;
  }
}
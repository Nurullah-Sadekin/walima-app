import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class ProfileImageCard extends StatelessWidget {

  const ProfileImageCard({
    super.key,
    required this.imagePath,
    this.imageSize = 97,
    this.iconSize = 16,
    this.borderWidth = 2,
    this.backgroundColor = AppColors.white,
    this.iconBackgroundColor = AppColors.primaryVariant,
    this.iconColor = AppColors.primary,
    this.borderColor = AppColors.white,
    this.onTopPressed,
    this.onEdit,
    this.showTopIcon = true,
    this.showBottomIcon = true,
    this.bottomPositionImagePath,
    this.topPositionImagePath,
    this.imageFit = BoxFit.cover,
  });

  final String imagePath;
  final double imageSize;
  final double iconSize;
  final double borderWidth;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color borderColor;
  final VoidCallback? onTopPressed;
  final VoidCallback? onEdit;
  final bool showTopIcon;
  final bool showBottomIcon;
  final String? bottomPositionImagePath;
  final String? topPositionImagePath;
  final BoxFit imageFit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: imageSize + 3, // Adding small padding for icons
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [

              GestureDetector(
                onTap: onTopPressed,
                child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ShowImage(
                    imagePath: imagePath,
                    width: imageSize,
                    height: imageSize,
                    fit: imageFit,
                    radius: const BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),

              if (showBottomIcon)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: EdgeInsets.all(iconSize * 0.25),
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor,
                          width: borderWidth,
                        ),
                      ),
                      child: ShowImage(
                        imagePath: bottomPositionImagePath ?? AppImages.verifiedBadgeSvgIcon,
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                        color: iconColor,
                      ),
                    ),
                  ),
                ),

              // Check Icon (Top Left)
              if (showTopIcon)
                Positioned(
                  top: 6,
                  left: 6,
                  child: ShowImage(
                    imagePath: topPositionImagePath ?? AppImages.verifiedBadgeSvgIcon,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
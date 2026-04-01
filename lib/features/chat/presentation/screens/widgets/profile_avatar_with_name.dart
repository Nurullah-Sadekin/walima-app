import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class ProfileAvatarWithName extends StatelessWidget {

  const ProfileAvatarWithName({
    super.key,
    required this.imagePath,
    this.name,
    this.avatarSize = 56,
    this.indicatorSize = 14,
    this.spacing = 2,
    this.indicatorColor = AppColors.greenButtonColor,
    this.borderColor = AppColors.white,
    this.borderWidth = 2,
    this.onTap,
    this.showOnlineIndicator = true,
  });
  final String imagePath;
  final String? name;
  final double avatarSize;
  final double indicatorSize;
  final double spacing;
  final Color indicatorColor;
  final Color borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final bool showOnlineIndicator;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatarStack(context),
          if (name?.isNotEmpty == true)...[
            SizedBox(height: spacing),
            _buildNameText(context),
          ],

        ],
      ),
    );
  }

  Widget _buildAvatarStack(BuildContext context) {
    return Stack(
      children: [
        ShowImage(
          imagePath: imagePath,
          width: avatarSize,
          height: avatarSize,
          radius: const BorderRadius.all(Radius.circular(999)),
        ),
        if (showOnlineIndicator)
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: indicatorSize,
            height: indicatorSize,
            decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildNameText(BuildContext context) {
    return Text(
      name ?? '',
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      style: TextStyle(
        fontSize: TextSize.font10(context),
        color: AppColors.textPrimaryLight,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
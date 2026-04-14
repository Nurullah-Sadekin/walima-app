import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/profile_image_card.dart';

class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({
    super.key,
    required this.displayName,
    required this.memberId,
    required this.planName,
    required this.expiryText,
    required this.profileImagePath,
    this.showTopIcon = false,
    this.showBottomIcon = false,
    this.topIconPath,
    this.bottomIconPath,
    this.imageSize = 97,
    this.iconSize = 20,
    this.onTapImage,
    this.onBottomIconPressed,
  });

  final String displayName;
  final String memberId;
  final String planName;
  final String expiryText;
  final String profileImagePath;
  final bool showTopIcon;
  final bool showBottomIcon;
  final String? topIconPath;
  final String? bottomIconPath;
  final double imageSize;
  final double iconSize;
  final VoidCallback? onTapImage;
  final VoidCallback? onBottomIconPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileImageCard(
            imagePath: profileImagePath,
            imageSize: imageSize,
            iconSize: iconSize,
            showTopIcon: showTopIcon,
            showBottomIcon: showBottomIcon,
            topPositionImagePath: topIconPath ?? AppImages.verifiedBadgeSvgIcon,
            bottomPositionImagePath: bottomIconPath ?? AppImages.cameraSvgIcon,
            onTopPressed: onTapImage,
            onEdit: onBottomIconPressed,
          ),
          const SizedBox(width: 12),
          Expanded(child: _profileDetails(context)),
        ],
      ),
    );
  }

  Widget _profileDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: TextSize.font20(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          _memberIdChip(context),
          const SizedBox(height: 4),
          _subscriptionRow(context),
        ],
      ),
    );
  }

  Widget _memberIdChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: AppColors.greyLight,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ID : $memberId',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.copy_rounded,
            color: AppColors.textSecondaryLight,
            size: TextSize.font12(context),
          ),
        ],
      ),
    );
  }

  Widget _subscriptionRow(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            planName,
            style: TextStyle(
              color: AppColors.white,
              fontSize: TextSize.font10(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        planName.toLowerCase() == 'free'
            ? const SizedBox.shrink()
            : Text(
                expiryText,
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
      ],
    );
  }
}

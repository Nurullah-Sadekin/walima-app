import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class ContactAllowBottomSheet extends StatelessWidget {
  const ContactAllowBottomSheet({
    super.key,
    required this.userName,
    required this.profileImagePath,
    this.profileType,
    required this.onCallPressed,
    required this.onMessagePressed,
    this.primaryButtonText,
    this.primaryButtonIcon,
    this.contactStatus = 'Contact Not Viewed',
  });

  final String userName;
  final String profileImagePath;
  final String? profileType;
  final VoidCallback onCallPressed;
  final VoidCallback onMessagePressed;
  final String? primaryButtonText;
  final String? primaryButtonIcon;
  final String contactStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildProfileImage(context),
        const SizedBox(height: 8),
        _buildUserName(context),
        const SizedBox(height: 5),
        _buildProfileTypeBadge(context),
        _buildBottomButtons(context),
        const Divider(
          color: AppColors.greyLight,
          thickness: 1,
          height: 30,
        ),
        _buildContactStatus(context),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return ShowImage(
      imagePath: profileImagePath,
      height: 64,
      width: 64,
      radius: BorderRadius.circular(1000),
    );
  }

  Widget _buildUserName(BuildContext context) {
    return Text(
      userName,
      style: TextStyle(
        fontSize: TextSize.font18(context),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryLight,
      ),
    );
  }

  Widget _buildProfileTypeBadge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        profileType ?? 'Profile Created by Self',
        style: TextStyle(
          fontSize: TextSize.font12(context),
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.iconicDynamicButton,
            title: 'Send Message',
            borderColor: AppColors.greyLight,
            textColor: AppColors.textPrimaryLight,
            svgIconPath: AppImages.emailSvgIcon,
            svgIconColor: AppColors.textPrimaryLight,
            onTap: onCallPressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.iconicDynamicButton,
            borderColor: AppColors.primary,
            bgColor: AppColors.primary,
            textColor: AppColors.white,
            svgIconPath: primaryButtonIcon ?? AppImages.callSvgIcon,
            svgIconColor: AppColors.white,
            title: primaryButtonText ?? 'Phone Call',
            onTap: onMessagePressed,
          ),
        ),
      ],
    );
  }

  Widget _buildContactStatus(BuildContext context) {
    return Text(
      contactStatus,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: TextSize.font14(context),
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryLight,
      ),
    );
  }

}

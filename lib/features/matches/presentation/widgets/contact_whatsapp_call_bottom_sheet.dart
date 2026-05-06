import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/features/registration/presentation/widgets/know_more_item.dart';

class ContactWhatsappCallBottomSheet extends StatelessWidget {
  const ContactWhatsappCallBottomSheet({
    super.key,
    required this.userName,
    required this.profileImagePath,
    this.profileType,
    required this.onPressedPrimary,
    required this.onMessagePressed,
    this.primaryButtonText,
    this.primaryButtonIcon,
    this.contactStatus = 'Contact Not Viewed',
    this.isWhatsappContact = true,
    this.contactNumber,
  });

  final String userName;
  final String profileImagePath;
  final String? profileType;
  final VoidCallback onPressedPrimary;
  final VoidCallback onMessagePressed;
  final String? primaryButtonText;
  final String? primaryButtonIcon;
  final String contactStatus;
  final bool isWhatsappContact;
  final String? contactNumber;

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
        if(isWhatsappContact)...[
          const SizedBox(height: 20),
          _buildAllowInformation(context),
        ],
        if(!isWhatsappContact)...[
          const SizedBox(height: 20),
          Text(contactNumber ?? '+880 1234567890',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: TextSize.font16(context),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ],
        const SizedBox(height: 20),
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

  Widget _buildAllowInformation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            'Allowed & Not Allowed',
            style: TextStyle(
              fontSize: TextSize.font16(context),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ),

        const KnowMoreItemCard(
          text: 'Give a short introduction',
          isActive: true,
        ),
        const KnowMoreItemCard(
          text: 'Add your profile link',
          isActive: true,
        ),
        const KnowMoreItemCard(
          text: 'Please wait for a response',
          isActive: true,
        ),
        const KnowMoreItemCard(
          text: 'Sending excessive messages',
          isActive: false,
        ),
        const KnowMoreItemCard(
          text: 'Calling without notice',
          isActive: false,
        ),
        const KnowMoreItemCard(
          text: 'Using inappropriate content',
          isActive: false,
        ),
      ],
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
            onTap: onPressedPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.iconicDynamicButton,
            borderColor: AppColors.primary,
            bgColor: AppColors.primary,
            textColor: AppColors.white,
            svgIconPath: primaryButtonIcon ??  (isWhatsappContact ? AppImages.whatsappSvgIcon: AppImages.callSvgIcon) ,
            svgIconColor: AppColors.white,
            title: primaryButtonText ?? (isWhatsappContact ? 'Whatsapp' : 'Phone Call' ),
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

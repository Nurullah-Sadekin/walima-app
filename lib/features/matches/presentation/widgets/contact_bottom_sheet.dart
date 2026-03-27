import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet_widget/widgets/icon_title_card.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class ContactBottomSheet extends StatelessWidget {
  const ContactBottomSheet({
    super.key,
    required this.userName,
    required this.profileImagePath,
    this.profileType,
    this.description,
    this.onWalimaChatPressed,
    this.onWhatsappPressed,
    this.onCallPressed,
    required this.onConnectionSentPressed,
    required this.onWalimaChatButtonPressed,
    this.chatButtonTitle,
    this.chatButtonIcon,
    this.contactStatus = 'Contact Not Viewed',
    this.isDescriptionVisible = false,
  });

  final String userName;
  final String profileImagePath;
  final String? profileType;
  final String? description;
  final VoidCallback? onWalimaChatPressed;
  final VoidCallback? onWhatsappPressed;
  final VoidCallback? onCallPressed;
  final VoidCallback onConnectionSentPressed;
  final VoidCallback onWalimaChatButtonPressed;
  final String? chatButtonTitle;
  final String? chatButtonIcon;
  final String contactStatus;
  final bool isDescriptionVisible;

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
        const SizedBox(height: 16),
        _buildDescription(context),
        if (isDescriptionVisible)...[
          const SizedBox(height: 16),
          _buildActionButtons(context),
        ],
        const SizedBox(height: 16),
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

  Widget _buildDescription(BuildContext context) {
    return Text(
      description ?? 'She shares her phone number only with connected members.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: TextSize.font14(context),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryLight,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconTitleCard(
          title: 'Walima Chat',
          imagePath: AppImages.chatIcon,
          backgroundColor: AppColors.primary,
          textColor: AppColors.textSecondaryLight,
          iconColor: AppColors.white,
          onTap: onWalimaChatPressed,
        ),
        IconTitleCard(
          title: 'Whatsapp',
          imagePath: AppImages.whatsappSvgIcon,
          backgroundColor: AppColors.greenButtonColor,
          textColor: AppColors.textSecondaryLight,
          iconColor: AppColors.white,
          onTap: onWhatsappPressed,
        ),
        IconTitleCard(
          title: 'Call',
          imagePath: AppImages.callSvgIcon,
          backgroundColor: Colors.teal,
          textColor: AppColors.textSecondaryLight,
          iconColor: AppColors.white,
          onTap: onCallPressed,
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
            title: 'Connection Sent',
            borderColor: AppColors.greenButtonColor,
            textColor: AppColors.greenButtonColor,
            svgIconPath: AppImages.favouriteIcon,
            svgIconColor: AppColors.greenButtonColor,
            onTap: onConnectionSentPressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.iconicDynamicButton,
            borderColor: AppColors.primary,
            bgColor: AppColors.primary,
            textColor: AppColors.white,
            svgIconPath: chatButtonIcon ?? AppImages.chatIcon,
            svgIconColor: AppColors.white,
            title: chatButtonTitle ?? 'Walima Chat',
            onTap: onWalimaChatButtonPressed,
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

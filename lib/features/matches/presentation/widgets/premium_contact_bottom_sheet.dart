import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet_widget/widgets/icon_title_card.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class PremiumContactBottomSheet extends StatelessWidget {

  const PremiumContactBottomSheet({
    super.key,
    this.imagePath,
    this.name,
    this.contact,
    this.email,
    this.topIconPath,
    this.title,
    this.onWalimaChatTap,
    this.onWhatsappTap,
    this.onCallTap,
    this.onViewPlanTap,
  });

  final String? imagePath;
  final String? name;
  final String? contact;
  final String? email;
  final String? topIconPath;
  final String? title;
  final VoidCallback? onWalimaChatTap;
  final VoidCallback? onWhatsappTap;
  final VoidCallback? onCallTap;
  final VoidCallback? onViewPlanTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        if (topIconPath != null || title != null) ...[
          _buildTopIcon(context),
          _buildTitleText(context),
        ],
        _buildContactInfoCard(context),
        const SizedBox(height: 10),
        _buildViewPlanButton(context),
      ],
    );
  }

  Widget _buildTopIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: ShowImage(
        imagePath: topIconPath ?? AppImages.premiumSvgIcon,
        width: TextSize.font18(context),
        height: TextSize.font18(context),
        radius: BorderRadius.circular(8),
        fit: BoxFit.fitWidth,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildTitleText(BuildContext context) {
    return Text(
      title ?? 'Upgrade Now to Contact Her Directly',
      style: TextStyle(
        fontSize: TextSize.font18(context),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryLight,
      ),
    );
  }

  Widget _buildContactInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyLight, width: 1),
      ),
      child: Column(
        spacing: 20,
        children: [
          _buildProfileSection(context),
          _buildContactButtons(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        ShowImage(
          imagePath: imagePath ?? AppImages.demoProfile,
          width: 80,
          height: 80,
          radius: BorderRadius.circular(99),
        ),
        SizedBox(
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                name ?? 'User Name',
                style: TextStyle(
                  fontSize: TextSize.font16(context),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              if (contact != null)
                _buildContactRow(
                  context,
                  iconPath: AppImages.callSvgIcon,
                  text: contact!,
                ),
              if (email != null)
                _buildContactRow(
                  context,
                  iconPath: AppImages.emailSvgIcon,
                  text: email!,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(BuildContext context, {
    required String iconPath,
    required String text,
  }) {
    return Row(
      spacing: 8,
      children: [
        ShowImage(
          imagePath: iconPath,
          width: TextSize.font14(context),
          height: TextSize.font14(context),
          color: AppColors.textSecondaryLight,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildContactButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [

          IconTitleCard(
            title: 'Walima Chat',
            imagePath: AppImages.chatIcon,
            backgroundColor: AppColors.primary,
            textColor: AppColors.textSecondaryLight,
            iconColor: AppColors.white,
            onTap: onWalimaChatTap,
            mood: IconTitleCardMood.vertical,
          ),

          IconTitleCard(
            title: 'Whatsapp',
            imagePath: AppImages.whatsappSvgIcon,
            backgroundColor: AppColors.greenButtonColor,
            textColor: AppColors.textSecondaryLight,
            iconColor: AppColors.white,
            onTap: onWhatsappTap,
            mood: IconTitleCardMood.vertical,
          ),

          IconTitleCard(
            title: 'Call Her',
            imagePath: AppImages.callSvgIcon,
            backgroundColor: AppColors.blue,
            textColor: AppColors.textSecondaryLight,
            iconColor: AppColors.white,
            onTap: onCallTap,
            mood: IconTitleCardMood.vertical,
          ),
      ],
    );
  }

  Widget _buildViewPlanButton(BuildContext context) {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.iconicDynamicButton,
      onTap: onViewPlanTap ?? () {},
      title: 'View Plan',
      bgColor: AppColors.primary,
      svgIconColor: AppColors.white,
      textColor: AppColors.white,
      svgIconPath: AppImages.premiumSvgIcon,
    );
  }
}
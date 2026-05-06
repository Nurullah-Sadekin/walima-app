import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/bottom_sheet_widget/widgets/icon_title_card.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';

class ContactsViewed extends StatelessWidget {
  const ContactsViewed({
    super.key,
    this.profileImage,
    this.name,
    this.profileCreatedBy,
    this.onTapShaadi,
    this.onTapWhatsapp,
    this.onTapCall,
    this.onTapMessage,
    this.onTapConnectionSent,
  });

  final String? profileImage;
  final String? name;
  final String? profileCreatedBy;
  final VoidCallback? onTapShaadi;
  final VoidCallback? onTapWhatsapp;
  final VoidCallback? onTapCall;
  final VoidCallback? onTapMessage;
  final VoidCallback? onTapConnectionSent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShowImage(
          imagePath: profileImage ?? AppImages.demoProfile,
          height: 64,
          width: 64,
          radius: BorderRadius.circular(100),
        ),
        Text(name ?? 'N/A',
          style: TextStyle(
            fontSize: TextSize.font18(context),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimaryLight,
          ),
        ),
        Container(
          decoration:
          BoxDecoration(
            color: AppColors.primaryVariant,
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text('Profile Created by ${profileCreatedBy ?? 'N/A'}',
            style: TextStyle(
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),

        IconTitleCard(
          title: 'Walima Chat',
          imagePath: AppImages.chatIcon,
          backgroundColor: const Color(0xFF155DFC),
          iconColor: AppColors.white,
          onTap: onTapShaadi,
        ),

      ],
    );
  }
}


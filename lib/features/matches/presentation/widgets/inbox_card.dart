import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class InboxCard extends StatelessWidget {
  const InboxCard({
    super.key,

    // Primary
    required this.imagePath,
    required this.name,
    this.isVerified = false,
    this.isPremium = false,
    this.day,
    this.onMenuTap,

    this.subtitle,
    this.subtitleColor,

    this.isBottomSection = true,
    this.onTapWalimaChat,
    this.onTapPhoneCall,
    this.onTapWhatsapp,

    this.scale = InboxCardImageScale.medium,

    // for medium & small
    this.age,
    this.height,
    this.location,
    this.profession,

    // for large
    this.contact,
    this.email,
    this.sendSMS,
    this.viewSMS,
    this.onTapSendSMS,
    this.onTapViewSMS,
  });

  // Primary
  final String imagePath;
  final String name;
  final bool isVerified;
  final bool isPremium;
  final String? day;
  final VoidCallback? onMenuTap;

  final String? subtitle;
  final String? subtitleColor;

  final bool isBottomSection;
  final VoidCallback? onTapWalimaChat;
  final VoidCallback? onTapPhoneCall;
  final VoidCallback? onTapWhatsapp;


  final InboxCardImageScale scale;

  // for medium & small
  final String? age;
  final String? height;
  final String? location;
  final String? profession;

  // for large card
  final String? contact;
  final String? email;
  final String? sendSMS;
  final String? viewSMS;
  final VoidCallback? onTapSendSMS;
  final VoidCallback? onTapViewSMS;

  @override
  Widget build(BuildContext context) {

    final double imageSize = switch (scale) {
      InboxCardImageScale.small => MediaQuery.of(context).size.width * 0.15,
      InboxCardImageScale.medium => MediaQuery.of(context).size.width * 0.2,
      InboxCardImageScale.large => MediaQuery.of(context).size.width * 0.25,
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyLight, width: 1),
      ),
      child: Column(
        children: [
          // Row -> Image + Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _inboxImage(imageSize),
              const SizedBox(width: 12),
              // Expanded details column
              Expanded(
                child: SizedBox(
                  height: imageSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _inboxHeader(context),
                      _inboxDetails(context,),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom action section
          if (isBottomSection) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(
                color: AppColors.greyLight,
                thickness: 1,
                height: 0,
              ),
            ),
            _inboxActions(context),
          ],
        ],
      ),
    );
  }

  Widget _inboxImage(double imageSize) {
    return ShowImage(
      imagePath: imagePath,
      width: imageSize,
      height: imageSize,
      radius:BorderRadius.circular(8),
    );
  }

  Widget _inboxHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: TextSize.font16(context),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: 4),
                          ShowImage(
                            imagePath: AppImages.verifiedBadgeSvgIcon,
                            width: TextSize.font14(context),
                            height: TextSize.font14(context),
                          )
                        ],
                        if (isPremium) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: ShowImage(
                              imagePath: AppImages.premiumSvgIcon,
                              width: TextSize.font12(context),
                              height: TextSize.font12(context),
                              color: AppColors.white,
                            ),
                          )
                        ],
                      ],
                    ),
                  ),
                  if (day != null) ...[
                    Row(
                      children: [
                        SizedBox(
                          height: TextSize.font12(context),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: VerticalDivider(
                              color: AppColors.hintTextColor,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Text(
                          day!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: TextSize.font10(context),
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    )
                  ],
                ],
              ),
            ),
            InkWell(
              onTap: onMenuTap,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Icon(
                  Icons.more_vert,
                  color: AppColors.textSecondaryLight,
                  size: TextSize.font16(context),
                ),
              ),
            ),
          ],
        ),
        if(subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: TextSize.font10(context),
              fontWeight: FontWeight.w400,
              color: subtitleColor != null ? Color(int.parse(subtitleColor!)) : AppColors .textSecondaryLight,
            ),
          ),
      ],
    );
  }

  Widget _inboxDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (age != null && height != null)
          Text(
            '$age, $height',
            style: TextStyle(
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryLight,
            ),
          ),
        if (location != null)
          Text(
            location!,
            style: TextStyle(
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryLight,
            ),
          ),
        if (profession != null)
          Text(
            profession!,
            style: TextStyle(
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryLight,
            ),
          ),
      ],
    );
  }

  Widget _inboxActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: onTapWalimaChat,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShowImage(
                      imagePath: AppImages.chatIcon,
                      width: TextSize.font16(context),
                      height: TextSize.font16(context),
                      radius: BorderRadius.circular(8),
                      fit: BoxFit.fitWidth,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('Walima Chat',
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondaryLight,
                  ))
            ],
          ),
        ),
        InkWell(
          onTap: onTapPhoneCall,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF335CFF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShowImage(
                      imagePath: AppImages.callSvgIcon,
                      width: TextSize.font16(context),
                      height: TextSize.font16(context),
                      radius: BorderRadius.circular(8),
                      fit: BoxFit.fitWidth,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('Phone Call',
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondaryLight,
                  ))
            ],
          ),
        ),
        InkWell(
          onTap: onTapWhatsapp,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  color: AppColors.greenButtonColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShowImage(
                      imagePath: AppImages.whatsappSvgIcon,
                      width: TextSize.font16(context),
                      height: TextSize.font16(context),
                      radius: BorderRadius.circular(8),
                      fit: BoxFit.fitWidth,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('Whatsapp',
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondaryLight,
                  ))
            ],
          ),
        ),
      ],
    );
  }

}

enum InboxCardImageScale {
  small,
  medium,
  large,
}

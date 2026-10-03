import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class NewMatchesCard extends StatelessWidget {
  const NewMatchesCard({
    super.key,
    required this.imagePath,
    this.imageHeight,
    this.imageWidth,
    required this.name,
    required this.age,
    required this.height,
    required this.location,
    this.maritalStatus,
    this.profession,
    this.religion,
    this.activeStatusText,
    this.photoCount,
    this.menu,
    this.isPremiumConnect = false,
    this.isVerified = false,
    this.viewOnAccept = false,
    this.photoRequest = false,
    this.isSingleButton = false,
    this.onTapUpgradeNow,
    this.onTapWalimaChat,
    this.onTapPhoneCall,
    this.onTapWhatsapp,
  });

  final String imagePath;
  final double? imageHeight;
  final double? imageWidth;

  final String name;
  final String age;
  final String height;
  final String? maritalStatus;
  final String? profession;
  final String? religion;
  final String location;

  final bool isPremiumConnect;
  final String? activeStatusText;
  final String? photoCount;

  final bool? menu;
  final bool isVerified;
  final bool viewOnAccept;
  final bool photoRequest;
  final bool isSingleButton;

  final VoidCallback? onTapUpgradeNow;
  final VoidCallback? onTapWalimaChat;
  final VoidCallback? onTapPhoneCall;
  final VoidCallback? onTapWhatsapp;

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.height * 0.4;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ShowImage(
                imagePath: imagePath,
                width: imageWidth ?? double.infinity,
                height: imageHeight ?? imageSize,
                radius: BorderRadius.circular(8),
                fit: BoxFit.fill,
              ),
              if (viewOnAccept)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.disable,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4,
                          children: [
                            ShowImage(
                              imagePath: AppImages.viewOnAccept,
                              width: TextSize.font48(context),
                              height: TextSize.font48(context),
                              radius: BorderRadius.circular(8),
                              fit: BoxFit.fitWidth,
                              color: AppColors.white,
                            ),
                            Text('View on Accept'.localized(context),
                                style: TextStyle(
                                  fontSize: TextSize.font14(context),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (photoRequest)
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryVariant,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          spacing: 8,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShowImage(
                              imagePath: AppImages.photoIcon,
                              width: TextSize.font16(context),
                              height: TextSize.font16(context),
                              fit: BoxFit.fill,
                              color: AppColors.primary,
                            ),
                            Text('Photo Request'.localized(context),
                                style: TextStyle(
                                  fontSize: TextSize.font14(context),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              if (isPremiumConnect)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: ShowImage(
                      imagePath: AppImages.premiumSvgIcon,
                      width: TextSize.font18(context),
                      height: TextSize.font18(context),
                      radius: BorderRadius.circular(8),
                      fit: BoxFit.fitWidth,
                      color: AppColors.white,
                    ),
                  ),
                ),
              if (activeStatusText != null)
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.disableDark,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Row(
                      spacing: 4,
                      children: [
                        Container(
                          width: TextSize.font8(context),
                          height: TextSize.font8(context),
                          decoration: const BoxDecoration(
                            color: Color(0XFF1FC16B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          activeStatusText ?? '',
                          style: TextStyle(
                            fontSize: TextSize.font12(context),
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (photoCount != null || menu == true)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      if (photoCount != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 6),
                          decoration: const BoxDecoration(
                            color: AppColors.disableDark,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Column(
                            spacing: 6,
                            children: [
                              ShowImage(
                                imagePath: AppImages.photoIcon,
                                width: TextSize.font16(context),
                                height: TextSize.font16(context),
                                radius: BorderRadius.circular(8),
                                fit: BoxFit.fitWidth,
                                color: AppColors.white,
                              ),
                              Text(
                                '1/$photoCount',
                                style: TextStyle(
                                  fontSize: TextSize.font10(context),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (menu == true && photoCount != null)
                        const SizedBox(
                          height: 6,
                        ),
                      if (menu == true)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 6,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.disableDark,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Icon(
                            Icons.more_vert,
                            size: TextSize.font16(context),
                            color: AppColors.white,
                          ),
                        )
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                      style: TextStyle(
                        fontSize: TextSize.font20(context),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  ShowImage(
                    imagePath: AppImages.verifiedBadgeSvgIcon,
                    width: TextSize.font20(context),
                    height: TextSize.font20(context),
                    radius: BorderRadius.circular(8),
                    fit: BoxFit.fitWidth,
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$age, $height',
                    style: TextStyle(
                      fontSize: TextSize.font16(context),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  if (religion != null || maritalStatus != null)
                    Row(
                      spacing: 4,
                      children: [
                        Text(
                          religion ?? '',
                          style: TextStyle(
                            fontSize: TextSize.font16(context),
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                        const Icon(
                          Icons.circle,
                          size: 4,
                          color: AppColors.textSecondaryLight,
                        ),
                        Text(
                          maritalStatus ?? 'Never Married',
                          style: TextStyle(
                            fontSize: TextSize.font16(context),
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  if (profession != null && location.isNotEmpty)
                    const SizedBox(
                      height: 12,
                    ),
                  if (profession != null)
                    Text(
                      profession ?? '',
                      style: TextStyle(
                        fontSize: TextSize.font16(context),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  if (location.isNotEmpty)
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: TextSize.font16(context),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(
                  color: AppColors.greyLight,
                  thickness: 1,
                ),
              ),
              Column(
                spacing: 10,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        'To Contact Her Directly',
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                        style: TextStyle(
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                      InkWell(
                        onTap: onTapUpgradeNow,
                        child: Row(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Upgrade Now',
                              textHeightBehavior: const TextHeightBehavior(
                                applyHeightToFirstAscent: false,
                                applyHeightToLastDescent: false,
                              ),
                              style: TextStyle(
                                fontSize: TextSize.font12(context),
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_outlined,
                              size: TextSize.font12(context),
                              color: AppColors.primary,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: onTapWalimaChat,
                        child: Row(
                          spacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
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
                            Text('Walima Chat'.localized(context),
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
                          spacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
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
                            Text('Phone Call'.localized(context),
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
                          spacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
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
                            Text('Whatsapp'.localized(context),
                                style: TextStyle(
                                  fontSize: TextSize.font12(context),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondaryLight,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class ProfileComprehensiveCard extends StatelessWidget {
  const ProfileComprehensiveCard({
    super.key,
    required this.imagePath,
    this.imageHeight,
    this.imageWidth,
    this.leftIconPath,
    this.rightIconPath,
    required this.name,
    this.age,
    this.height,
    this.location,
    this.maritalStatus,
    this.profession,
    this.religion,
    this.leftButtonText = 'Connect',
    this.rightButtonText = 'Contact',
    this.onTapLeftButton,
    this.onTapRightButton,
    this.isPremiumConnect = false,
    this.isVerified = false,
    this.leftButtonColor,
    this.rightButtonColor,
    this.leftButtonTextColor,
    this.leftButtonIconColor,
    this.rightButtonIconColor,
    this.rightButtonTextColor,
    this.leftButtonBorderColor,
    this.rightButtonBorderColor,
    this.activeStatusText,
    this.photoCount,
    this.menu,
    this.viewOnAccept = false,
    this.photoRequest = false,
    this.isSingleButton = false,
    this.onTapSingleButton,
    this.onTapCard,
    this.singleButtonColor,
    this.singleButtonTextColor,
    this.singleButtonBorderColor,
    this.singleButtonIconColor,
    this.singleButtonText = 'Connect Now',
    this.onMenuTap,
    this.noButton = false,
    this.isOnline = false,
  });

  final String imagePath;
  final double? imageHeight;
  final double? imageWidth;
  final String? leftIconPath;
  final String? rightIconPath;

  final String name;
  final String? age;
  final String? height;
  final String? maritalStatus;
  final String? profession;
  final String? religion;
  final String? leftButtonText;
  final String? rightButtonText;
  final String? location;

  final VoidCallback? onTapLeftButton;
  final VoidCallback? onTapRightButton;
  final Color? leftButtonColor;
  final Color? rightButtonColor;
  final Color? leftButtonTextColor;
  final Color? leftButtonIconColor;
  final Color? rightButtonIconColor;
  final Color? rightButtonTextColor;
  final Color? leftButtonBorderColor;
  final Color? rightButtonBorderColor;

  final String? activeStatusText;
  final String? photoCount;
  final bool isPremiumConnect;
  final bool isVerified;
  final bool? menu;
  final bool viewOnAccept;
  final bool photoRequest;
  final bool isSingleButton;

  final VoidCallback? onMenuTap;
  final VoidCallback? onTapCard;

  final VoidCallback? onTapSingleButton;
  final Color? singleButtonColor;
  final Color? singleButtonTextColor;
  final Color? singleButtonBorderColor;
  final Color? singleButtonIconColor;
  final String? singleButtonText;

  final bool noButton;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.height * 0.4;

    return GestureDetector(
      onTap: onTapCard,
      child: Container(
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 6),
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
                            decoration: BoxDecoration(
                              color: isOnline
                                  ? const Color(0XFF1FC16B)
                                  : AppColors.disableBackground,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
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
                          InkWell(
                            onTap: onMenuTap ?? () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 6,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.disableDark,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                              child: Icon(
                                Icons.more_vert,
                                size: TextSize.font16(context),
                                color: AppColors.white,
                              ),
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
                    if (isVerified)
                      ShowImage(
                        imagePath: AppImages.verifiedBadgeSvgIcon,
                        width: TextSize.font20(context),
                        height: TextSize.font20(context),
                        radius: BorderRadius.circular(8),
                        fit: BoxFit.fitWidth,
                      )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (age != null && height != null)
                      const SizedBox(
                        height: 12,
                      ),
                    if (age != null && height != null)
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
                    if (profession != null && location!.isNotEmpty)
                      const SizedBox(
                        height: 12,
                      ),
                    if (profession != null)
                      Text(
                        profession ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: TextSize.font16(context),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                    if (location != null && location!.isNotEmpty)
                      Text(
                        location!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: TextSize.font16(context),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                  ],
                ),
                if (noButton == true)
                  const SizedBox()
                else
                  const SizedBox(
                    height: 16,
                  ),
                if (isSingleButton && noButton == false)
                  PrimaryButtons(
                      buttonStyle: ButtonsStyle.iconicDynamicButton,
                      iconLeftPosition: true,
                      bgColor: singleButtonColor ?? AppColors.white,
                      onTap: onTapSingleButton ?? () {},
                      borderColor: singleButtonBorderColor ?? AppColors.primary,
                      textColor: singleButtonTextColor ?? AppColors.primary,
                      title: (singleButtonText ?? 'Connect Now')
                          .localized(context)),
                if (!isSingleButton && noButton == false)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: PrimaryButtons(
                              buttonStyle: ButtonsStyle.iconicDynamicButton,
                              iconLeftPosition: true,
                              bgColor:
                                  leftButtonColor ?? const Color(0XFF1FC16B),
                              onTap: onTapLeftButton ?? () {},
                              svgIconColor:
                                  leftButtonIconColor ?? AppColors.white,
                              svgIconPath:
                                  leftIconPath ?? AppImages.favouriteIcon,
                              borderColor: leftButtonBorderColor ??
                                  const Color(0XFF1FC16B),
                              textColor: leftButtonTextColor ?? AppColors.white,
                              title: (leftButtonText ?? 'Connect')
                                  .localized(context)),
                        ),
                        Expanded(
                          child: PrimaryButtons(
                              buttonStyle: ButtonsStyle.iconicDynamicButton,
                              onTap: onTapRightButton ?? () {},
                              svgIconColor:
                                  rightButtonIconColor ?? AppColors.primary,
                              svgIconPath:
                                  rightIconPath ?? AppImages.callSvgIcon,
                              title: (rightButtonText ?? 'Contact')
                                  .localized(context),
                              bgColor: rightButtonColor ?? AppColors.white,
                              borderColor:
                                  rightButtonBorderColor ?? AppColors.primary,
                              textColor:
                                  rightButtonTextColor ?? AppColors.primary),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

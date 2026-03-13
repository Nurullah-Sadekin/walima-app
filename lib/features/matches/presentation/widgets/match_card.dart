import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.imagePath,
    this.leftIconPath,
    this.rightIconPath,
    required this.name,
    required this.age,
    required this.height,
    this.leftButtonText = 'Connect',
    this.rightButtonText = 'Contact',
    required this.location,
    this.onTapLeftButton,
    this.onTapRightButton,
    this.isPremiumConnect = false,
    this.isVerified = false,
    this.leftButtonColor,
    this.rightButtonColor,
    this.leftButtonTextColor,
    this.rightButtonTextColor,
    this.leftButtonBorderColor,
    this.rightButtonBorderColor,
    this.activeStatusText,
    this.photoCount,
    this.menu,
    this.viewOnAccept = false,
    this.photoRequest = false,
  });

  final String imagePath;
  final String? leftIconPath;
  final String? rightIconPath;
  final String name;
  final String age;
  final String height;
  final String? leftButtonText;
  final String? rightButtonText;
  final String location;
  final VoidCallback? onTapLeftButton;
  final VoidCallback? onTapRightButton;
  final bool isPremiumConnect;
  final bool isVerified;
  final Color? leftButtonColor;
  final Color? rightButtonColor;
  final Color? leftButtonTextColor;
  final Color? rightButtonTextColor;
  final Color? leftButtonBorderColor;
  final Color? rightButtonBorderColor;
  final String? activeStatusText;
  final String? photoCount;
  final bool? menu;
  final bool viewOnAccept;
  final bool photoRequest;

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
                width: double.infinity,
                height: imageSize,
                radius: BorderRadius.circular(8),
                fit: BoxFit.fill,
              ),
              if (viewOnAccept)
                Positioned.fill(
                  child: ClipRRect(
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
                            Text('View on Accept',
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(8)),
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
                            Text('Photo Request',
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
                    decoration: BoxDecoration(
                      color: const Color(0XFF000000).withOpacity(0.5),
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
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
                        decoration: BoxDecoration(
                          color: const Color(0XFF000000).withOpacity(0.5),
                          shape: BoxShape.rectangle,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
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
                              vertical: 6, horizontal: 6),
                          decoration: BoxDecoration(
                            color: const Color(0XFF000000).withOpacity(0.5),
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
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
                  Text(
                    name,
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
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: PrimaryButtons(
                          buttonStyle: ButtonsStyle.iconicDynamicButton,
                          iconLeftPosition: true,
                          bgColor: leftButtonColor ?? const Color(0XFF1FC16B),
                          onTap: onTapLeftButton ?? () {},
                          svgIconColor: AppColors.white,
                          svgIconPath: leftIconPath ?? AppImages.favouriteIcon,
                          borderColor:
                              leftButtonBorderColor ?? const Color(0XFF1FC16B),
                          textColor: leftButtonTextColor ?? AppColors.white,
                          title: leftButtonText ?? 'Connect'),
                    ),
                    Expanded(
                      child: PrimaryButtons(
                          buttonStyle: ButtonsStyle.iconicDynamicButton,
                          onTap: onTapRightButton ?? () {},
                          svgIconColor: AppColors.primary,
                          svgIconPath: rightIconPath ?? AppImages.callSvgIcon,
                          title: rightButtonText ?? 'Contact',
                          bgColor: rightButtonColor ?? AppColors.white,
                          borderColor:
                              rightButtonBorderColor ?? AppColors.primary,
                          textColor: rightButtonTextColor ?? AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

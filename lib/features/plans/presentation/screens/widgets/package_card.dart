import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/icon_text_row.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/popular_badge.dart';

class PackageCard extends StatelessWidget {

  const PackageCard({
    super.key,
    required this.packageName,
    this.packageThemeColor,
    this.duration,
    required this.packagePrice,
    required this.perMonthPrice,
    this.buttonText,
    required this.buttonOnTap,
    this.messageText,
    this.contactText,
    this.contactCount = 0,
    this.profileText,
    this.matchText,
    this.messageIsAvailable = false,
    this.contactIsAvailable = false,
    this.profileIsAvailable = false,
    this.matchIsAvailable = false,
    this.backgroundColor,
    this.packageBadgeText,
    this.packageBadgeBackgroundColor,
    this.packageBadgeIcon,
  });

  final String packageName;
  final Color? packageThemeColor;
  final String? duration;
  final String packagePrice;
  final String perMonthPrice;

  final String? buttonText;
  final VoidCallback buttonOnTap;

  final String? messageText;
  final String? contactText;
  final int? contactCount;
  final String? profileText;
  final String? matchText;

  final bool? messageIsAvailable;
  final bool? contactIsAvailable;
  final bool? profileIsAvailable;
  final bool? matchIsAvailable;

  final Color? backgroundColor;
  final String? packageBadgeText;
  final Color? packageBadgeBackgroundColor;
  final String? packageBadgeIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Column(
                spacing: 8,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$packageName / ',
                        textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                        style: TextStyle(
                          fontSize: TextSize.font18(context),
                          fontWeight: FontWeight.w600,
                          color: packageThemeColor ?? AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        duration ?? '3 Months',
                        textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                        style: TextStyle(
                          fontSize: TextSize.font16(context),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    packagePrice,
                    textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                    style: TextStyle(
                      fontSize: TextSize.font36(context),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    '( $perMonthPrice / month )',
                    textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                    style: TextStyle(
                      fontSize: TextSize.font16(context),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButtons(
                buttonStyle: ButtonsStyle.activePrimaryButton,
                onTap: buttonOnTap,
                title: buttonText,
              ),
              const SizedBox(height: 24),
              Column(
                spacing: 20,
                children: [
                  IconTextRow(
                    imagePath: AppImages.messageSvgIcon,
                    text: messageText ?? 'Send unlimited messages',
                    textColor: AppColors.textSecondaryLight,
                    imageColor: AppColors.hintTextColor,
                    availableOption: messageIsAvailable,
                  ),
                  IconTextRow(
                    imagePath: AppImages.contactSvgIcon,
                    text: contactText ?? 'View uo to $contactCount contact numbers',
                    textColor: AppColors.textSecondaryLight,
                    imageColor: AppColors.hintTextColor,
                    availableOption: contactIsAvailable,
                  ),
                  IconTextRow(
                    imagePath: AppImages.profileSvgIcon,
                    text: profileText ?? 'Profile highlight',
                    textColor: AppColors.textSecondaryLight,
                    imageColor: AppColors.hintTextColor,
                    availableOption: profileIsAvailable,
                  ),
                  IconTextRow(
                    imagePath: AppImages.matchSvgIcon,
                    text: matchText ?? 'Direct contact from matches',
                    textColor: AppColors.textSecondaryLight,
                    imageColor: AppColors.hintTextColor,
                    availableOption: matchIsAvailable,
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          left: -10,
          top: 22,
          child: PopularBadge(
              badgeText: packageBadgeText,
              badgeBackgroundColor: packageBadgeBackgroundColor,
              badgeIcon: packageBadgeIcon,
              badgeThemeColor: packageThemeColor,
          ),
        ),
      ],
    );
  }
}
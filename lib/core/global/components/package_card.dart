import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/popular_badge.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

import 'icon_text_row.dart';

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
    this.packageStatusText,
    this.packageStatusBgColor,
    this.packageStatusIcon,
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
  final String? packageStatusText;
  final Color? packageStatusBgColor;
  final String? packageStatusIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: MediaQuery.of(context).size.width * 0.65,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Column(
            children: [

              const SizedBox(height: 25),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$packageName / ',
                        style: TextStyle(
                          fontSize: TextSize.font18(context),
                          fontWeight: FontWeight.w600,
                          color: packageThemeColor ?? AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        duration ?? '3 Months',
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
                    style: TextStyle(
                      fontSize: TextSize.font36(context),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    '( $perMonthPrice / month )',
                    style: TextStyle(
                      fontSize: TextSize.font16(context),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButtons(
                buttonStyle: ButtonsStyle.activePrimaryButton,
                onTap: buttonOnTap,
                title: buttonText,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  IconTextRow(
                    imagePath: AppImages.messageSvgIcon,
                    text: messageText ?? 'Send unlimited messages',
                    textColor: AppColors.textSecondaryLight,
                    imageColor: AppColors.hintTextColor,
                    availableOption: messageIsAvailable,
                  ),
                  const SizedBox(height: 16),

                  IconTextRow(
                    imagePath: AppImages.contactSvgIcon,
                    text: contactText ?? 'View uo to $contactCount contact numbers',
                    textColor: AppColors.textSecondaryLight,
                    imageColor: AppColors.hintTextColor,
                    availableOption: contactIsAvailable,
                  ),
                  const SizedBox(height: 16),

                  IconTextRow(
                    imagePath: AppImages.profileSvgIcon,
                    text: profileText ?? 'Profile highlight',
                    textColor: AppColors.textSecondaryLight,
                    imageColor: AppColors.hintTextColor,
                    availableOption: profileIsAvailable,
                  ),
                  const SizedBox(height: 16),

                  IconTextRow(
                    imagePath: AppImages.matchSvgIcon,
                    text: matchText ?? 'Direct contact from matches',
                    textColor: AppColors.textSecondaryLight,
                    imageColor: AppColors.hintTextColor,
                    availableOption: matchIsAvailable,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: -10,
          top: 12,
          child: PopularBadge(
              packageStatusText: 'Recommended',
              packageStatusBgColor: packageStatusBgColor,
              packageStatusIcon: AppImages.matchSvgIcon,
              packageThemeColor: packageThemeColor,
          ),
        ),
      ],
    );
  }
}
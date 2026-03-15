import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class RemindCard extends StatelessWidget {
  const RemindCard({
    super.key,
    required this.onTap,
    required this.imagePath,
    required this.name,
    required this.age,
    required this.height,
    required this.location,
    this.isVerified = false,
    this.singleButton = true,
    this.leftButtonTitle = 'Reject',
    this.leftButtonOnTap,
    this.leftButtonBackgroundColor = AppColors.white,
    this.leftButtonBorderColor = AppColors.greyLight,
    this.leftButtonTextColor = AppColors.textPrimaryLight,
    this.leftButtonSvgIconPath = AppImages.cancelSvgIcon,
    this.leftButtonSvgIconColor = AppColors.textPrimaryLight,
    this.leftButtonIconSize = 16,
    this.rightButtonTitle = 'Approve',
    this.rightButtonOnTap,
    this.rightButtonBorderColor = AppColors.greenButtonColor,
    this.rightButtonBackgroundColor = AppColors.greenButtonColor,
    this.rightButtonTextColor = AppColors.white,
    this.rightButtonSvgIconPath = AppImages.favouriteIcon,
    this.rightButtonSvgIconColor = AppColors.white,
    this.rightButtonIconSize = 16,
  });

  final VoidCallback onTap;
  final String imagePath;
  final String name;
  final String age;
  final String height;
  final String location;
  final bool isVerified;

  final bool singleButton;

  final String leftButtonTitle;
  final VoidCallback? leftButtonOnTap;
  final Color leftButtonBackgroundColor;
  final Color leftButtonBorderColor;
  final Color leftButtonTextColor;
  final String leftButtonSvgIconPath;
  final Color leftButtonSvgIconColor;
  final double leftButtonIconSize;

  final VoidCallback? rightButtonOnTap;
  final String rightButtonTitle;
  final Color rightButtonBackgroundColor;
  final Color rightButtonBorderColor;
  final Color rightButtonTextColor;
  final String rightButtonSvgIconPath;
  final Color rightButtonSvgIconColor;
  final double rightButtonIconSize;

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.width * 0.185;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyLight, width: 1),
      ),
      child: Column(
        children: [
          SizedBox(
            height: imageSize,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowImage(
                  imagePath: imagePath,
                  width: imageSize,
                  height: imageSize,
                  radius: BorderRadius.circular(8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$age, $height',
                          style: TextStyle(
                            fontSize: TextSize.font12(context),
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: TextSize.font12(context),
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(
              color: AppColors.greyLight,
              thickness: 1,
              height: 0,
            ),
          ),
          if (singleButton)
            PrimaryButtons(
              buttonStyle: ButtonsStyle.iconicDynamicButton,
              onTap: onTap,
              title: 'Remind',
              borderColor: AppColors.primary,
              textColor: AppColors.primary,
              svgIconPath: AppImages.notificationSvgIcon,
              svgIconColor: AppColors.primary,
              iconSize: 16,
            ),
          if (!singleButton) ...[
            Row(
              children: [
                Expanded(
                  child: PrimaryButtons(
                    buttonStyle: ButtonsStyle.iconicDynamicButton,
                    onTap: leftButtonOnTap ?? () {},
                    title: leftButtonTitle,
                    borderColor: leftButtonBorderColor,
                    textColor: leftButtonTextColor,
                    bgColor: leftButtonBackgroundColor,
                    svgIconPath: leftButtonSvgIconPath,
                    svgIconColor: leftButtonSvgIconColor,
                    iconSize: leftButtonIconSize,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButtons(
                    buttonStyle: ButtonsStyle.iconicDynamicButton,
                    onTap: rightButtonOnTap ?? () {},
                    title: rightButtonTitle,
                    borderColor: rightButtonBorderColor,
                    textColor: rightButtonTextColor,
                    bgColor: rightButtonBackgroundColor,
                    svgIconPath: rightButtonSvgIconPath,
                    svgIconColor: rightButtonSvgIconColor,
                    iconSize: rightButtonIconSize,
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}

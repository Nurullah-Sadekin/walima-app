import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class ConnectNowCard extends StatelessWidget {
  const ConnectNowCard({
    super.key,
    required this.imagePath,
    this.iconPath,
    required this.name,
    required this.age,
    required this.height,
    this.buttonText = 'Connect Now',
    required this.location,
    this.onButtonTap,
    this.isPremiumConnect = false,
  });

  final String imagePath;
  final String? iconPath;
  final String name;
  final String age;
  final String height;
  final String? buttonText;
  final String location;
  final VoidCallback? onButtonTap;
  final bool isPremiumConnect;

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.height * 0.275;

    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyLight, width: 1),
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Stack(
              children: [
                ShowImage(
                  imagePath: imagePath,
                  width: double.infinity,
                  height: imageSize,
                  radius: BorderRadius.circular(8),
                  fit: BoxFit.fitWidth,
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
                      imagePath: iconPath ?? AppImages.matchSvgIcon,
                      width: TextSize.font18(context),
                      height: TextSize.font18(context),
                      radius: BorderRadius.circular(8),
                      fit: BoxFit.fitWidth,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: TextSize.font20(context),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: PrimaryButtons(
                        buttonStyle: ButtonsStyle.activeSecondaryButton,
                        onTap: onButtonTap ?? () {},
                        title: buttonText ?? 'Connect Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

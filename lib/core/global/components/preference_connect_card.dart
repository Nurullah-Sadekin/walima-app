import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/icon_text_row.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';

class PreferenceConnectCard extends StatelessWidget {
  const PreferenceConnectCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.imagePath,
    required this.name,
    required this.age,
    required this.height,
    required this.religion,
    required this.location,
    this.profession,
    this.blurPhoto = false,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final String imagePath;
  final String name;
  final String age;
  final String height;
  final String religion;
  final String location;
  final String? profession;
  final bool blurPhoto;

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.width * 0.31;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryVariant : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.greyLight,
              width: 1),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: blurPhoto ? 12 : 0,
                    sigmaY: blurPhoto ? 12 : 0,
                  ),
                  child: ShowImage(
                    imagePath: imagePath,
                    width: imageSize,
                    height: imageSize,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: TextSize.font14(context),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        Icon(
                          isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.hintTextColor,
                          size: TextSize.font22(context),
                        ),
                      ],
                    ),
                    Text(
                      profession ?? 'Profession',
                      style: TextStyle(
                        fontSize: TextSize.font13(context),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    IconTextRow(
                      imagePath: AppImages.calendarSvgIcon,
                      text: age,
                      textColor: AppColors.textSecondaryLight,
                      imageColor: AppColors.hintTextColor,
                    ),
                    IconTextRow(
                      imagePath: AppImages.heightSvgIcon,
                      text: height,
                      textColor: AppColors.textSecondaryLight,
                      imageColor: AppColors.hintTextColor,
                    ),
                    IconTextRow(
                      imagePath: AppImages.religionSvgIcon,
                      text: religion,
                      textColor: AppColors.textSecondaryLight,
                      imageColor: AppColors.hintTextColor,
                    ),
                    IconTextRow(
                      imagePath: AppImages.locationSvgIcon,
                      text: location,
                      textColor: AppColors.textSecondaryLight,
                      imageColor: AppColors.hintTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

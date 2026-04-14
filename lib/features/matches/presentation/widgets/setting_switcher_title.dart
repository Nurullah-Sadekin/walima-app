import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class SettingsSwitchTile extends StatelessWidget { // Control switch size

  const SettingsSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.showTrailingImage = false,
    this.trailingImage,
    this.switchScale = 0.6,
    this.trailingImageSize,
    this.trailingImageColor,
  });
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showTrailingImage;
  final String? trailingImage;
  final double switchScale;
  final double? trailingImageSize;
  final Color? trailingImageColor;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side - Title and optional subtitle
        Expanded(
          child: Row(
            children: [
              if (showTrailingImage)
                ShowImage(
                  imagePath: trailingImage,
                  width: trailingImageSize ?? TextSize.font20(context),
                  height: trailingImageSize ?? TextSize.font20(context),
                  color: trailingImageColor ?? AppColors.textPrimaryLight,
                ),
              if (showTrailingImage) const SizedBox(width: 8), // Spacing between image and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    title,
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                    style: TextStyle(
                      color: AppColors.textPrimaryLight,
                      fontSize: TextSize.font14(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: TextSize.font12(context),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // Right side - Switch and optional trailing image
        Transform.scale(
          scale: switchScale,
          alignment: Alignment.centerRight,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.greyLight,
            thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Icon(
                    Icons.circle,
                    color: AppColors.primary,
                    size: TextSize.font10(context),
                  );
                }
                return Icon(
                  Icons.circle,
                  color: AppColors.greyLight,
                  size: TextSize.font10(context),
                );
              },
            ),
            thumbColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return AppColors.white;
              },
            ),
            trackColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.primary;
                }
                return AppColors.greyLight;
              },
            ),
            trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.primary;
                }
                return AppColors.greyLight;
              },
            ),
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
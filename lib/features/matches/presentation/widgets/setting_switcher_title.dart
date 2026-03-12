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
    this.showSubtitle = true,
    this.showTrailingImage = false,
    this.trailingImage,
    this.switchScale = 0.6,
  });
  final String title;
  final String? subtitle; // Optional subtitle
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showSubtitle; // Control subtitle visibility
  final bool showTrailingImage; // Control trailing image visibility
  final String? trailingImage; // Custom trailing image
  final double switchScale;

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
                  width: 24,
                  height: 24,
                ),
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
                  if (showSubtitle && subtitle != null)
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
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
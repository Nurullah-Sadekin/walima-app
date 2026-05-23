import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class IsProfileForItemWidget extends StatelessWidget {
  const IsProfileForItemWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    this.showIcon = false,
  });
  final String title;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryVariant : Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.greyLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Trailing Icon
            Container(
              height: TextSize.font16(context),
              width: TextSize.font16(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.disableText,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),

            if (showIcon) ...[
              const SizedBox(width: 8),
              ShowImage(
                imagePath: imagePath,
                height: TextSize.font20(context),
                width: TextSize.font20(context),
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondaryLight,
              )
            ],
            const SizedBox(width: 8),

            /// Title
            Text(
              title.localized(context),
              style: TextStyle(
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
                color:
                    isSelected ? AppColors.primary : AppColors.textPrimaryLight,
              ),
            ),

            // const SizedBox(width: 8),
            // Image.asset(
            //   imagePath,
            //   height: TextSize.font20(context),
            //   width: TextSize.font20(context),
            // ),
          ],
        ),
      ),
    );
  }
}

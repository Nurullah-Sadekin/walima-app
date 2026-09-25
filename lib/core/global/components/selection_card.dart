import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class SelectionCard extends StatelessWidget {
  const SelectionCard({
    super.key,
    required this.buttonStyle,
    required this.onTap,
    required this.title,
    this.subtitle,
    this.isSelected,
    this.isExpand = false,
    this.noBorder = false,
    this.radiaBackgroundColor,
    this.borderRadius,
  });

  final SelectionStyle buttonStyle;
  final VoidCallback onTap;
  final String? title;
  final String? subtitle;
  final bool? isSelected;
  final bool isExpand;
  final bool noBorder;
  final Color? radiaBackgroundColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveSelected = isSelected ?? false;
    switch (buttonStyle) {
      case SelectionStyle.selectedRadio:
        return selectedRadio(effectiveSelected, context);
      case SelectionStyle.unSelectedRadio:
        return unSelectedRadio(effectiveSelected, context);
      case SelectionStyle.selectedItem:
        return selectedItem(effectiveSelected, context);
      case SelectionStyle.unSelectedItem:
        return unSelectedItem(effectiveSelected, context);
      case SelectionStyle.selectedCheckbox:
        return selectedCheckbox(effectiveSelected, context);
      case SelectionStyle.unSelectedCheckbox:
        return unSelectedCheckbox(effectiveSelected, context);
    }
  }

  String _title(BuildContext context) => (title ?? '').localized(context);

  String _subtitle(BuildContext context) => (subtitle ?? '').localized(context);

  Widget _radioText({
    required BuildContext context,
    required Color titleColor,
    required FontWeight titleWeight,
  }) {
    final hasSubtitle = subtitle?.trim().isNotEmpty ?? false;
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title(context),
            style: TextStyle(
              color: titleColor,
              fontSize: TextSize.font13(context),
              fontWeight: titleWeight,
            ),
          ),
          if (hasSubtitle) ...[
            const SizedBox(height: 3),
            Text(
              _subtitle(context),
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font10(context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget selectedRadio(bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: noBorder ? 0 : 12,
          horizontal: noBorder ? 0 : 12,
        ),
        decoration: ShapeDecoration(
          color: radiaBackgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            side: noBorder
                ? BorderSide.none
                : const BorderSide(width: 1, color: AppColors.inputBorderColor),
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            ShowImage(
              imagePath: AppImages.selectedRadio,
              width: TextSize.font20(context),
              height: TextSize.font20(context),
            ),
            _radioText(
              context: context,
              titleColor: AppColors.textPrimaryLight,
              titleWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget unSelectedRadio(bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: noBorder ? 0 : 12,
          horizontal: noBorder ? 0 : 12,
        ),
        decoration: ShapeDecoration(
          color: radiaBackgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            side: noBorder
                ? BorderSide.none
                : const BorderSide(width: 1, color: AppColors.inputBorderColor),
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 6,
          children: [
            ShowImage(
              imagePath: AppImages.unSelectedRadio,
              width: TextSize.font20(context),
              height: TextSize.font20(context),
            ),
            _radioText(
              context: context,
              titleColor: AppColors.textSecondaryLight,
              titleWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  Widget selectedItem(bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryVariant : Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Text(
          _title(context),
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textPrimaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget unSelectedItem(bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.disableBackground,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        child: Text(
          _title(context),
          style: TextStyle(
            color:
                isSelected ? AppColors.primary : AppColors.textSecondaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget selectedCheckbox(bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: ShapeDecoration(
          color: AppColors.primaryVariant,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color:
                  isSelected ? AppColors.primary : AppColors.inputBorderColor,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
          ),
        ),
        child: Row(
          mainAxisSize: isExpand ? MainAxisSize.max : MainAxisSize.min,
          children: [
            ShowImage(
              imagePath: AppImages.selectedCheckbox,
              width: TextSize.font20(context),
              height: TextSize.font20(context),
            ),
            const SizedBox(width: 8),
            Text(
              _title(context),
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget unSelectedCheckbox(bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.inputBorderColor),
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
          ),
        ),
        child: Row(
          mainAxisSize: isExpand ? MainAxisSize.max : MainAxisSize.min,
          children: [
            ShowImage(
              imagePath: AppImages.unselectedCheckbox,
              width: TextSize.font20(context),
              height: TextSize.font20(context),
            ),
            const SizedBox(width: 8),
            Text(
              _title(context),
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SelectionStyle {
  selectedRadio,
  unSelectedRadio,
  selectedItem,
  unSelectedItem,
  selectedCheckbox,
  unSelectedCheckbox,
}

enum SelectionState {
  selected,
  unselected,
}

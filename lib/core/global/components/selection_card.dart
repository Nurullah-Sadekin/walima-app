import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class SelectionCard extends StatelessWidget {
  const SelectionCard({
    super.key,
    required this.buttonStyle,
    required this.onTap,
    required this.title,
    this.isSelected ,
    this.isExpand = false,
  });

  final SelectionStyle buttonStyle;
  final VoidCallback onTap;
  final String? title;
  final bool? isSelected;
  final bool isExpand;

  @override
  Widget build(BuildContext context) {
    final effectiveSelected = isSelected ?? false;
    switch (buttonStyle) {
      case SelectionStyle.selectedRadio:
        return selectedRadio(onTap, title, effectiveSelected, context);
      case SelectionStyle.unSelectedRadio:
        return unSelectedRadio(onTap, title, effectiveSelected, context);
      case SelectionStyle.selectedItem:
        return selectedItem(onTap, title, effectiveSelected, context);
      case SelectionStyle.unSelectedItem:
        return unSelectedItem(onTap, title, effectiveSelected, context);
      case SelectionStyle.selectedCheckbox:
        return selectedCheckbox(onTap, title, isExpand, effectiveSelected, context);
      case SelectionStyle.unSelectedCheckbox:
        return unSelectedCheckbox(onTap, title, isExpand, effectiveSelected, context);
    }
  }


  Widget selectedRadio(VoidCallback onClick, String? title, bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.inputBorderColor),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 6,
          children: [
            Container(
              height: TextSize.font16(context),
              width: TextSize.font16(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.greyLight,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: isSelected
                  ? const Center(
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.white,
                ),
              )
                  : null,
            ),
            Text(
              title ?? '',
              textAlign: TextAlign.center,
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

  Widget unSelectedRadio(VoidCallback onClick, String? title, bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.inputBorderColor),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 6,
          children: [
            Container(
              height: TextSize.font16(context),
              width: TextSize.font16(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.greyLight,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: isSelected
                  ? const Center(
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.white,
                ),
              )
                  : null,
            ),
            Text(
              title ?? '',
              textAlign: TextAlign.center,
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

  Widget selectedItem(VoidCallback onClick, String? title, bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryVariant : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Text(
          title ?? '',
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textPrimaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget unSelectedItem(VoidCallback onClick, String? title, bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.disableBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title ?? '',
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget selectedCheckbox(VoidCallback onClick, String? title, bool isExpand, bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: isSelected ? AppColors.primary : AppColors.inputBorderColor),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Row(
          mainAxisSize: isExpand ? MainAxisSize.max :MainAxisSize.min,
          children: [
            ShowImage(
              imagePath: AppImages.selectedCheckbox,
              width: TextSize.font20(context),
              height: TextSize.font20(context),
            ),
            const SizedBox(width: 8),
            Text(
              title ?? '',
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

  Widget unSelectedCheckbox(VoidCallback onClick, String? title, bool isExpand, bool isSelected, BuildContext context) {
    // visually identical to selectedCheckbox but without check mark
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.inputBorderColor),
            borderRadius: BorderRadius.circular(6),
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
              title ?? '',
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

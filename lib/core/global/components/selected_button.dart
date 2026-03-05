import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class SelectedButtons extends StatelessWidget {
  const SelectedButtons({
    super.key,
    required this.buttonStyle,
    required this.onTap,
    required this.title,
    this.isSelected ,
  });

  final SelectedButtonsStyle buttonStyle;
  final VoidCallback onTap;
  final String? title;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    switch (buttonStyle) {

      case (SelectedButtonsStyle.primeSelectedButton):
        return primeSelectedButton(onTap, title, isSelected ?? false, context);
      case SelectedButtonsStyle.secondarySelectedButton:
        return secondarySelectedButton(onTap, title, isSelected ?? false, context);

    }
  }


  Widget primeSelectedButton(VoidCallback onClick, String? title, bool isSelected, BuildContext context) {
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

  Widget secondarySelectedButton(VoidCallback onClick, String? title, bool isSelected, BuildContext context) {
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



}

enum SelectedButtonsStyle {
  primeSelectedButton,
  secondarySelectedButton,

}

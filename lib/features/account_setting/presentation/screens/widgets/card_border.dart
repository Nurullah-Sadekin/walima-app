import 'package:flutter/material.dart';
import 'package:walima_llc/core/constants/app_colors.dart';

class CardBorder extends StatelessWidget {
  const CardBorder({
    super.key,
    this.widget,
    this.backgroundColor,
    this.borderColor,
    this.verticalPadding,
  });

  final Widget? widget;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? verticalPadding;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(vertical: verticalPadding ?? 16, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor ?? AppColors.greyLight,
        ),
      ),
      child: widget,
    );
  }
}

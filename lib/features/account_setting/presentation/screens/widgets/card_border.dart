import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class CardBorder extends StatelessWidget {
  const CardBorder({
    super.key,
    this.widget,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget? widget;
  final Color? backgroundColor;
  final Color? borderColor;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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

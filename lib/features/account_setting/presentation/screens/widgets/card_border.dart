import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class CardBorder extends StatelessWidget {
  const CardBorder({
    super.key,
    this.widget,
  });

  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.greyLight,
        ),
      ),
      child: widget,
    );
  }
}

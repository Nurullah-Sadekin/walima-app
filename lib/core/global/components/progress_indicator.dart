import 'package:flutter/material.dart';
import 'package:walima_llc/core/constants/app_colors.dart';

class ProgressNumberedIndicator extends StatelessWidget {

  const ProgressNumberedIndicator({
    super.key,
    required this.total,
    required this.activeIndex,
  });
  final int total;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (index) {
          // All indices <= activeIndex get primary color (left side)
          final isActiveOrDone = index <= activeIndex;

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              decoration: BoxDecoration(
                color: isActiveOrDone ? AppColors.primary : AppColors.greyLight,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          );
        }),
      ),
    );
  }
}
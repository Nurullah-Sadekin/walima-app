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
          final isActive = index == activeIndex;
          final number = index + 1;

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.greyLight,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                '$number',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[700],
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class GradientBackground extends ConsumerWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.gradientColor,
  });
  final Widget child;
  final Gradient? gradientColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
          gradient: gradientColor ?? AppColors.customBackgroundGradient,
        ),
        child: child,
      );
  }
}

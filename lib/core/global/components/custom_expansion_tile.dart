import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? borderColor;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? collapsedIconColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final bool initiallyExpanded;
  final CrossAxisAlignment? crossAxisAlignment; // Added for alignment
  final MainAxisAlignment? mainAxisAlignment; // Added for alignment

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.child,
    this.borderColor,
    this.borderRadius,
    this.backgroundColor,
    this.collapsedIconColor,
    this.iconColor,
    this.padding,
    this.initiallyExpanded = false,
    this.crossAxisAlignment = CrossAxisAlignment.start, // Default to left
    this.mainAxisAlignment = MainAxisAlignment.start, // Default to left
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        border: Border.all(
            color: borderColor ?? AppColors.greyLight,
            width: 1
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? 8),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          collapsedIconColor: collapsedIconColor ?? AppColors.hintTextColor,
          iconColor: iconColor ?? AppColors.hintTextColor,
          title: Text(
            title,
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimaryLight,
            ),
          ),
          children: [
            Container( // Added Container for better alignment control
              width: double.infinity, // Take full width
              padding: padding ?? const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
                mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
                children: [
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
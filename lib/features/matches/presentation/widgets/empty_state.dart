import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onTap;
  final bool showButton;
  final double? horizontalPadding;
  final double? spacing;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onTap,
    this.showButton = true,
    this.horizontalPadding,
    this.spacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 12.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: TextSize.font20(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing ?? 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w400,
            ),
          ),
          if (showButton) ...[
            SizedBox(height: spacing ?? 16),
            PrimaryButtons(
              buttonStyle: ButtonsStyle.activePrimaryButton,
              onTap: onTap ?? () {},
              title: buttonText,
              isExpand: false,
            ),
          ],
        ],
      ),
    );
  }
}
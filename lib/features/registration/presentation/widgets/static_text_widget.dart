import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';

class StaticTextWidget extends StatelessWidget {

  const StaticTextWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: TextSize.font24(context),
            ),
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.hintTextColor,
              fontWeight: FontWeight.w400,
              fontSize: TextSize.font14(context),
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
        ],
      ),
    );
  }
}
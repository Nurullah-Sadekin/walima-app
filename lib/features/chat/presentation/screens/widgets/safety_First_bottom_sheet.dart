import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';

import '../../../../../core/utils/image_viewer.dart';
import 'dismissible_safety_card.dart';

class SafetyFirst extends StatelessWidget {

  const SafetyFirst({
    super.key,
    this.onViewMoreTips,
    this.additionalTips,
  });
  final VoidCallback? onViewMoreTips;
  final List<SafetyTip>? additionalTips;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 20),
        ..._buildSafetyTips(),
        if (additionalTips != null) ..._buildAdditionalTips(),
        const SizedBox(height: 16),
        _buildViewMoreButton(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Safety First',
      style: TextStyle(
        fontSize: TextSize.font18(context),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryLight,
      ),
    );
  }

  List<Widget> _buildSafetyTips() {
    return const [
      DismissibleSafetyCard(
        title: 'Take Your Time',
        message: 'Get to know someone well before taking the conversation offline.',
        iconPath: AppImages.lockPasswordSvgIcon,
      ),
      SizedBox(height: 16),
      DismissibleSafetyCard(
        title: 'Stay Alert',
        message: 'Watch out for quick commitments or money requests. Keep your financial details private.',
        iconPath: AppImages.alertSvgIcon,
      ),
      SizedBox(height: 16),
      DismissibleSafetyCard(
        title: 'Report',
        message: 'Report the profile if you encounter offensive messages or anything suspicious.',
        iconPath: AppImages.flagSvgIcon,
      ),
    ];
  }

  List<Widget> _buildAdditionalTips() {
    return additionalTips!
        .expand((tip) => [
      const SizedBox(height: 16),
      DismissibleSafetyCard(
        title: tip.title,
        message: tip.message,
        iconPath: tip.iconPath,
      ),
    ])
        .toList();
  }

  Widget _buildViewMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: onViewMoreTips,
      child: Row(
        children: [
          Text(
            'Get More Safety Tips',
            style: TextStyle(
              fontSize: TextSize.font16(context),
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          ShowImage(
            imagePath: AppImages.arrowRightSvgIcon,
            width: TextSize.font20(context),
            height: TextSize.font20(context),
          ),
        ],
      ),
    );
  }
}

class SafetyTip {

  const SafetyTip({
    required this.title,
    required this.message,
    required this.iconPath,
  });
  final String title;
  final String message;
  final String iconPath;
}
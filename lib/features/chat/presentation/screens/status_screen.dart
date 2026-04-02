import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onTapButton,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTapButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              const UpperLayer(
                imagePath: AppImages.done,
                isShowAppbar: false,
              ),
              Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: TextSize.font20(context),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: TextSize.font14(context),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              PrimaryButtons(
                buttonStyle: ButtonsStyle.activePrimaryButton,
                title: buttonText,
                onTap: onTapButton,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}


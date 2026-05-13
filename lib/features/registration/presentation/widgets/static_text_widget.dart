import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';

class StaticTextWidget extends StatelessWidget {

  const StaticTextWidget({
    super.key,
    required this.title,
    required this.subtitle, this.isOptional = false,
  });
  final String title;
  final String subtitle;
  final bool isOptional;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: TextSize.font24(context),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.disable,
                  fontWeight: FontWeight.w400,
                  fontSize: TextSize.font14(context),
                ),
              ),
              if(isOptional)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: AppColors.disableBackground,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: AppColors.disableText,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Optional',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.disable,
                    fontWeight: FontWeight.w400,
                    fontSize: TextSize.font12(context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
        ],
      ),
    );
  }
}
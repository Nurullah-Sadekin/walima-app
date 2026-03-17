import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/icon_text_row.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/popular_badge.dart';
import 'package:flutter_boilerplate/features/plans/data/models/get_plans_response.dart';

class PackageCard extends StatelessWidget {

  const PackageCard({
    super.key,
    required this.packageName,
    required this.buttonOnTap,
    required this.plan

  });

  final String packageName;
  final VoidCallback buttonOnTap;
  final Plans plan;



  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Column(
                spacing: 8,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${plan.name} / ',
                        textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                        style: TextStyle(
                          fontSize: TextSize.font18(context),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          (plan.description ?? '').length > 7
                              ? (plan.description ?? '').substring(0, 8)
                              : (plan.description ?? ''),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: TextSize.font16(context),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    plan.pricings?.first.price.toString() ?? '',
                    textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                    style: TextStyle(
                      fontSize: TextSize.font36(context),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    '( ${plan.pricings?.first.actualPerMonthPrice.toString() } / month )',
                    textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                    style: TextStyle(
                      fontSize: TextSize.font16(context),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButtons(
                buttonStyle: ButtonsStyle.activePrimaryButton,
                onTap: buttonOnTap,
                title: 'Continue',
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: plan.features?.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: IconTextRow(
                        imagePath: AppImages.flagSvgIcon,
                        text: feature.name ?? 'Feature',
                        textColor: AppColors.textSecondaryLight,
                        imageColor: AppColors.hintTextColor,
                        availableOption: feature.included ?? false,
                      ),
                    )).toList() ?? [],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          left: -10,
          top: 22,
          child: PopularBadge(
              badgeText: plan.tag ?? 'Premium',
              badgeBackgroundColor: AppColors.primaryVariant,
              badgeIcon: AppImages.flagSvgIcon,
              badgeThemeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
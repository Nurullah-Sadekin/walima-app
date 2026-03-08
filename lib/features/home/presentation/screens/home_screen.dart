import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/icon_text_row.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/global/components/profile_type_card.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/generated/l10n/app_localizations.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(Paths.settings),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            spacing: 10,
            children: [
              PrimaryButtons(
                buttonStyle: ButtonsStyle.activePrimaryButton,
                onTap: () {},
                title: 'Active Primary Button',
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.greyLight, width: 1),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 10,
                    children: [
                      ShowImage(
                        imagePath: AppImages.demoProfile,
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Profile Name',
                                  style: TextStyle(
                                    fontSize: TextSize.font14(context),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimaryLight,
                                  ),
                                ),
                                Icon(Icons.check_box_outline_blank, color: AppColors.hintTextColor,size: TextSize.font18(context),)
                              ],
                            ),
                            const IconTextRow(
                              imagePath: AppImages.calendarSvgIcon,
                              text: '28 Years',
                              textColor: AppColors.textSecondaryLight,
                              imageColor: AppColors.hintTextColor,
                            ),
                            const IconTextRow(
                              imagePath: AppImages.heightSvgIcon,
                              text: '5 Feet 3Inches',
                              textColor: AppColors.textSecondaryLight,
                              imageColor: AppColors.hintTextColor,
                            ),
                            const IconTextRow(
                              imagePath: AppImages.religionSvgIcon,
                              text: 'Muslim, Sunni',
                              textColor: AppColors.textSecondaryLight,
                              imageColor: AppColors.hintTextColor,
                            ),
                            const IconTextRow(
                              imagePath: AppImages.locationSvgIcon,
                              text: 'Gulshan, Dhaka, BD',
                              textColor: AppColors.textSecondaryLight,
                              imageColor: AppColors.hintTextColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

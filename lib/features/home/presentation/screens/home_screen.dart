import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/icon_text_row.dart';
import 'package:flutter_boilerplate/core/global/components/package_card.dart';
import 'package:flutter_boilerplate/core/global/components/preference_connect_card.dart';
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            PreferenceConnectCard(
              isSelected: _isSelected,
              onTap: () {
                setState(() {
                  _isSelected = !_isSelected;
                });
              },
              imagePath: AppImages.demoProfile,
              name: 'Profile Name',
              age: '28 Years',
              height: '5 Feet 3 Inches',
              religion: 'Muslim, Sunni',
              location: 'Gulshan, Dhaka, BD',
            ),
            PackageCard(
              packageName: 'Gold',
              duration: '3 Months',
              packagePrice: '2200',
              perMonthPrice: '733',
              buttonText: 'Continue',
              buttonOnTap: () {},
              messageText: 'Send unlimited messages',
              contactText: 'View up to 50 contact numbers',
              profileText: 'Profile highlight',
              matchText: 'Direct contact from matches',
              messageIsAvailable: true,
              contactIsAvailable: true,
              profileIsAvailable: false,
              matchIsAvailable: false,
              backgroundColor: AppColors.surfaceLight,
              packageThemeColor: AppColors.primary,
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //   width: MediaQuery.of(context).size.width * 0.65,
            //   decoration: BoxDecoration(
            //     color: AppColors.surfaceLight,
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(color: AppColors.primary, width: 1),
            //   ),
            //   child: Column(
            //     spacing: 16,
            //     children: [
            //       Column(
            //         children: [
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text(
            //                 'Package Name / ',
            //                 style: TextStyle(
            //                   fontSize: TextSize.font18(context),
            //                   fontWeight: FontWeight.w600,
            //                   color: AppColors.textPrimaryLight,
            //                 ),
            //               ),
            //               Text(
            //                 'Duration',
            //                 style: TextStyle(
            //                   fontSize: TextSize.font16(context),
            //                   fontWeight: FontWeight.w500,
            //                   color: AppColors.textPrimaryLight,
            //                 ),
            //               ),
            //             ],
            //           ),
            //           Text(
            //             '2200 ',
            //             style: TextStyle(
            //               fontSize: TextSize.font36(context),
            //               fontWeight: FontWeight.w700,
            //               color: AppColors.textPrimaryLight,
            //             ),
            //           ),
            //           Text(
            //             '(733 / month) ',
            //             style: TextStyle(
            //               fontSize: TextSize.font16(context),
            //               fontWeight: FontWeight.w500,
            //               color: AppColors.textSecondaryLight,
            //             ),
            //           ),
            //         ],
            //       ),
            //       PrimaryButtons(
            //           buttonStyle: ButtonsStyle.activePrimaryButton,
            //           onTap: () {},
            //           title: 'Continue'),
            //       const Column(
            //         spacing: 16,
            //         children: [
            //           IconTextRow(
            //             imagePath: AppImages.messageSvgIcon,
            //             text: 'Send unlimited messages',
            //             textColor: AppColors.textSecondaryLight,
            //             imageColor: AppColors.hintTextColor,
            //             availableOption: true,
            //           ),
            //           IconTextRow(
            //             imagePath: AppImages.contactSvgIcon,
            //             text:
            //                 'View uo to 50 contact numbers unlimited messages',
            //             textColor: AppColors.textSecondaryLight,
            //             imageColor: AppColors.hintTextColor,
            //             availableOption: true,
            //           ),
            //           IconTextRow(
            //             imagePath: AppImages.profileSvgIcon,
            //             text: 'Profile highlight',
            //             textColor: AppColors.textSecondaryLight,
            //             imageColor: AppColors.hintTextColor,
            //             availableOption: false,
            //           ),
            //           IconTextRow(
            //             imagePath: AppImages.messageSvgIcon,
            //             text: 'Direct contact from matches',
            //             textColor: AppColors.textSecondaryLight,
            //             imageColor: AppColors.hintTextColor,
            //             availableOption: false,
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

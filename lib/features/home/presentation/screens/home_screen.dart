import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/connect_now_card.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
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
      body: GradientBackground(
        child: Column(
          children: [
            AppBar(
              leading: const Icon(Icons.menu_sharp, color: AppColors.textPrimaryLight),
              title: Text('My Walima',
                  style: TextStyle(
                      color: AppColors.textPrimaryLight,
                      fontSize: TextSize.font18(context),
                      fontWeight: FontWeight.w500)
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimaryLight),
                ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body(),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 12.0),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  const ShowImage(
                    imagePath: AppImages.demoProfile,
                    width: 100,
                    height: 100,
                    isCircle: true,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Tahmina Rahman',
                          style: TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontSize: TextSize.font20(context),
                              fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Row(
                          spacing: 4,
                          children: [
                            Text('ID : 1234567890',
                                style: TextStyle(
                                    color: AppColors.textSecondaryLight,
                                    fontSize: TextSize.font12(context),
                                    fontWeight: FontWeight.w400,),
                            ),
                            Icon(Icons.copy_rounded, color: AppColors.textSecondaryLight, size: TextSize.font12(context))
                          ],
                        ),
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text('Gold',
                              style: TextStyle(
                                color: AppColors.white, fontSize: TextSize.font10(context),
                                fontWeight: FontWeight.w600,),
                            ),
                          ),
                          Text('Expires: March 2026',
                            style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: TextSize.font14(context),
                              fontWeight: FontWeight.w700,),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SingleChildScrollView(
              child: ConnectNowCard(
                imagePath: AppImages.demoProfile,
                iconPath: AppImages.premiumSvgIcon,
                isPremiumConnect: true,
                name: 'Profile Name',
                age: '28 Years',
                height: '5 Feet 3 Inches',
                location: 'Gulshan, Dhaka, BD',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
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

class ConnectMatches extends ConsumerStatefulWidget {
  const ConnectMatches({super.key});

  @override
  ConsumerState<ConnectMatches> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<ConnectMatches> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(
        isBackButton: true,
        isTrailing: true,
        trailingText: 'Skip',
        onTrailingTap: null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                packageName: 'Hermony',
                duration: '3 Months',
                packagePrice: '2200',
                perMonthPrice: '733',
                buttonText: 'Continue',
                buttonOnTap: () {},
                messageText: 'Send unlimited messages',
                contactCount: 100,
                profileText: 'Profile highlight',
                matchText: 'Direct contact from matches',
                messageIsAvailable: true,
                contactIsAvailable: true,
                profileIsAvailable: false,
                matchIsAvailable: false,
                backgroundColor: AppColors.transparent,
                packageThemeColor: Colors.purple,
                packageBadgeBackgroundColor: Colors.purple.shade50,
                packageBadgeText: 'Recommended',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

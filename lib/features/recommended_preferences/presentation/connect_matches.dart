import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/preference_connect_card.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConnectMatches extends ConsumerStatefulWidget {
  const ConnectMatches({super.key});

  @override
  ConsumerState<ConnectMatches> createState() => _ConnectMatchesState();
}

class _ConnectMatchesState extends ConsumerState<ConnectMatches> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
          child: Column(
        children: [
          CustomBackAppBar(
            isBackButton: true,
            isTrailing: true,
            trailingText: 'Skip',
            onTrailingTap: () {
              context.push(Paths.upgradePremium);
              // Handle skip action
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PreferenceConnectCard(
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
                );
              },
            ),
          ),
          const SizedBox(
            height: 60,
          )
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: SingleChildScrollView(
          //     child: Column(
          //       crossAxisAlignment: CrossAxi sAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       spacing: 10,
          //       children: [
          //         PreferenceConnectCard(
          //           isSelected: _isSelected,
          //           onTap: () {
          //             setState(() {
          //               _isSelected = !_isSelected;
          //             });
          //           },
          //           imagePath: AppImages.demoProfile,
          //           name: 'Profile Name',
          //           age: '28 Years',
          //           height: '5 Feet 3 Inches',
          //           religion: 'Muslim, Sunni',
          //           location: 'Gulshan, Dhaka, BD',
          //         ),
          //         // PackageCard(
          //         //   packageName: 'Hermony',
          //         //   duration: '3 Months',
          //         //   packagePrice: '2200',
          //         //   perMonthPrice: '733',
          //         //   buttonText: 'Continue',
          //         //   buttonOnTap: () {},
          //         //   messageText: 'Send unlimited messages',
          //         //   contactCount: 100,
          //         //   profileText: 'Profile highlight',
          //         //   matchText: 'Direct contact from matches',
          //         //   messageIsAvailable: true,
          //         //   contactIsAvailable: true,
          //         //   profileIsAvailable: false,
          //         //   matchIsAvailable: false,
          //         //   backgroundColor: AppColors.transparent,
          //         //   packageThemeColor: Colors.purple,
          //         //   packageBadgeBackgroundColor: Colors.purple.shade50,
          //         //   packageBadgeText: 'Recommended',
          //         // ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      )),
    );
  }
}

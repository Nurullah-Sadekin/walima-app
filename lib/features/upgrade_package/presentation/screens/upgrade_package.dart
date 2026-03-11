import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/features/upgrade_package/presentation/screens/widgets/package_card.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

class UpgradePackageScreen extends ConsumerStatefulWidget {
  const UpgradePackageScreen({super.key});

  @override
  ConsumerState<UpgradePackageScreen> createState() => _UpdateToPremiumState();
}

class _UpdateToPremiumState extends ConsumerState<UpgradePackageScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            _headerSection(),
            _bodySection(),
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Column(
      children: [
        UpperLayer(
          imagePath: AppImages.upgradePremium,
          isBackButton: true,
          backIconBackground: AppColors.transparent,
          isTrailing: true,
          trailingText: 'Skip',
          onTrailingTap: () {
            context.push(Paths.anchor);
            // Handle skip action
          },
          spacing: 0,
          imageHeight: 120,
          imageWidth: 145,
          verticalPadding: 0,
        ),
        const SizedBox(height: 24),
        Text(
          'Update to Premium',
          style: TextStyle(
              fontSize: TextSize.font24(context),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimaryLight),
        ),
      ],
    );
  }

  Widget _bodySection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            const SizedBox(height: 16),

            // Replace horizontal list with CarouselSlider
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                 // homeController.changePage(index);
                },
              ),
              items: [1,2,3,4,5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: PackageCard(
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
                    );
                  },
                );
              }).toList(),
            ),
    Obx(() {
    return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(homeController.splashList.length, (index) {
    return InkWell(
    onTap: () => homeController.changePage(index),
    child: Container(
    width: homeController.selectedPage.value == index ? 15.0 : 10.0,
    height: 10.0,
    margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.0),
    decoration: BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(7)),
    color: homeController.selectedPage.value == index
    ? AppColor.baseColor
        : Colors.grey.shade300,
    ),
    ),
    );
    }),
    );
          ],
        ),
      ),
    );
  }
}

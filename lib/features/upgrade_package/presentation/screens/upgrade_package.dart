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
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/upgrade_package/presentation/providers/upgrade_package_provider.dart';

class UpgradePackageScreen extends ConsumerStatefulWidget {
  const UpgradePackageScreen({super.key});

  @override
  ConsumerState<UpgradePackageScreen> createState() => _UpdateToPremiumState();
}

class _UpdateToPremiumState extends ConsumerState<UpgradePackageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(upgradePackageProvider);

    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            _headerSection(),
            _bodySection(provider),
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
          },
          spacing: 0,
          imageHeight: 120,
          imageWidth: 145,
          verticalPadding: 0,
        ),
        const SizedBox(height: 20),
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

  Widget _bodySection(UpgradePackageProvider provider) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CarouselSlider.builder(
              itemCount: provider.packageItems.length,
              itemBuilder: (context, index, realIdx) {
                final item = provider.packageItems[index];
                return PackageCard(
                  packageName: item.packageName,
                  duration: item.duration,
                  packagePrice: item.packagePrice,
                  perMonthPrice: item.perMonthPrice,
                  buttonText: item.buttonText ?? 'Continue',
                  buttonOnTap: () {},
                  messageText: 'Send unlimited messages',
                  contactCount: 100,
                  profileText: 'Profile highlight',
                  matchText: 'Direct contact from matches',
                  messageIsAvailable: item.messageIsAvailable ?? false,
                  contactIsAvailable: item.contactIsAvailable ?? false,
                  profileIsAvailable: item.profileIsAvailable ?? false,
                  matchIsAvailable: item.matchIsAvailable ?? false,
                  backgroundColor: AppColors.transparent,
                  packageBadgeText: item.packageBadgeText ?? '',
                  packageThemeColor: item.packageThemeColor ?? AppColors.transparent,
                  packageBadgeBackgroundColor: item.packageBadgeBackgroundColor ?? AppColors.transparent,
                );
              },
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                viewportFraction: 0.75,
                animateToClosest: false,
                enableInfiniteScroll: false,
                disableCenter: true,
                aspectRatio: 0.94,
                onPageChanged: (index, _) {
                  ref.read(upgradePackageProvider).changePage(index);
                },
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(provider.packageItems.length, (index) {
                final isActive = provider.selectedPage == index;
                return GestureDetector(
                  onTap: () => ref.read(upgradePackageProvider).changePage(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: isActive ? 30 : 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10 / 2),
                      color: isActive ? AppColors.primary : AppColors.primaryShade300,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );

  }
}

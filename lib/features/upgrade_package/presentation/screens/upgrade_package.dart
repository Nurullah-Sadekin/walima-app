import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/custom_expansion_tile.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/upgrade_package/presentation/screens/widgets/package_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/upgrade_package/presentation/providers/upgrade_package_provider.dart';

class UpgradePackageScreen extends ConsumerStatefulWidget {
  const UpgradePackageScreen({super.key});

  @override
  ConsumerState<UpgradePackageScreen> createState() => _UpgradePackageScreenState();
}

class _UpgradePackageScreenState extends ConsumerState<UpgradePackageScreen> {
  final UpgradePackageProvider provider = UpgradePackageProvider();

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
            _appbarSection(),
            _body(),
          ],
        ),
      ),
    );
  }


  Widget _appbarSection() {
    return const CustomBackAppBar(
      isBackButton: true,
      backIconBackground: AppColors.transparent,
      isTrailing: true,
      trailingText: 'Skip',
      onTrailingTap: null,
    );
  }

  Widget _body(){
    return Expanded(
      child: SingleChildScrollView(
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
        const ShowImage(
          imagePath:  AppImages.upgradePremium,
          width: 145,
          height: 120,
        ),
        const SizedBox(height: 20),
        Text(
          'Upgrade to Premium',
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _carouselSliderSection(),
          _haveQuestionSection(),
        ],
      ),
    );
  }

  Widget _carouselSliderSection() {
    return Column(
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
              packageThemeColor:
                  item.packageThemeColor ?? AppColors.transparent,
              packageBadgeBackgroundColor:
                  item.packageBadgeBackgroundColor ?? AppColors.transparent,
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
                  color:
                      isActive ? AppColors.primary : AppColors.primaryShade300,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _haveQuestionSection() {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text('You Have Questions?',
          style: TextStyle(
            fontSize: TextSize.font18(context),
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: provider.haveQuestion.entries.map((entry) {
            return  CustomExpansionTile(
              title: entry.key,
              backgroundColor: AppColors.transparent,
              titleBackgroundColor: AppColors.transparent,
              bottomMargin: 16,
              borderColor: AppColors.primary,
              child: Text(entry.value,
                style: TextStyle(
                  fontSize: TextSize.font12(context),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            );
          }).toList(),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryShade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Still Need Help?',
                style: TextStyle(
                  fontSize: TextSize.font18(context),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 6),
              Text('We are right here to help you. Give us a call anything between  10am-7pm',
                style: TextStyle(
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const ShowImage(
                          imagePath: AppImages.callSvgIcon,
                          width: 16,
                          height: 16,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('01715-7277279',
                        style: TextStyle(
                          fontSize: TextSize.font14(context),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const ShowImage(
                          imagePath: AppImages.whatsappSvgIcon,
                          width: 16,
                          height: 16,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('01715-7277279',
                        style: TextStyle(
                          fontSize: TextSize.font14(context),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        )

      ],
    );
  }

}

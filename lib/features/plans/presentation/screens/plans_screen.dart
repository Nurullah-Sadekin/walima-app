import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/custom_expansion_tile.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/plans/data/models/get_plans_response.dart';
import 'package:flutter_boilerplate/features/plans/presentation/screens/widgets/package_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/plans/presentation/providers/plans_provider.dart';
import 'package:go_router/go_router.dart';

class UpgradePackageScreen extends ConsumerStatefulWidget {
  const UpgradePackageScreen({super.key, required this.fromScreen});
  final String? fromScreen;

  @override
  ConsumerState<UpgradePackageScreen> createState() =>
      _UpgradePackageScreenState();
}

class _UpgradePackageScreenState extends ConsumerState<UpgradePackageScreen> {
  late PlansProvider provider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(plansProvider).fetchUpgradePackages();
      ref.read(profileProvider).getDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(plansProvider);
    return TransparentLoading(
      isLoading:
          provider.screenStates == UpgradePackageScreenStates.transparent,
      child: Scaffold(
        body: GradientBackground(
          child: Column(
            children: [
              _appbarSection(),
              provider.loaderState == UpgradePackageScreenStates.loading
                  ? const Expanded(child: Center(child: Loading()))
                  : _body(),
              // if(provider.screenStates == UpgradePackageScreenStates.transparent)
              //   TransparentLoading(child: child, isLoading: isLoading)
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbarSection() {
    return CustomBackAppBar(
      isBackButton: true,
      backIconBackground: AppColors.transparent,
      isTrailing: widget.fromScreen != Routes.anchor,
      trailingText: 'Skip',
      onTrailingTap: () {
        if (widget.fromScreen == Routes.anchor) {
          context.push(Paths.connectMatches);
          return;
        }
        context.push(Paths.anchor);
      },
    );
  }

  Widget _body() {
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
          imagePath: AppImages.upgradePremium,
          width: 140,
          height: 110,
        ),
        const SizedBox(height: 20),
        Text(
          'Upgrade to Premium',
          style: TextStyle(
            fontSize: TextSize.font24(context),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _bodySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
    final activePlanId =
        _resolveCurrentPlanIdFromDashboard() ?? provider.currentPlanId;
    final activePlanRanking = _resolveCurrentPlanRanking(
      activePlanId: activePlanId,
      plans: provider.packages,
    );

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: provider.packages.length,
          itemBuilder: (context, index, realIdx) {
            final item = provider.packages[index];
            final isCurrentPlan = _isCurrentPlan(
              item: item,
              activePlanId: activePlanId,
            );
            final isButtonDisabled = _isPlanActionDisabled(
              item: item,
              activePlanId: activePlanId,
              activePlanRanking: activePlanRanking,
            );

            return PackageCard(
              packageName: item.name ?? '',
              buttonOnTap: isButtonDisabled
                  ? () {}
                  : () async {
                      final plansState = ref.read(plansProvider);
                      final redirectUrl = await plansState.startPlanPurchase(
                        context: context,
                        selectedPlan: item,
                      );
                      if (!context.mounted || redirectUrl == null) return;

                      final appTransactionId = plansState
                          .latestPaymentSession?.transactionId
                          ?.trim();
                      final gatewayTransactionId = plansState
                          .latestPaymentSession?.rawResponse?.transactionId
                          ?.trim();

                      await context.pushNamed(
                        Routes.paymentWebView,
                        extra: <String, dynamic>{
                          'redirectUrl': redirectUrl,
                          'transactionId': appTransactionId,
                          'tranId': gatewayTransactionId,
                        },
                      );
                    },
              plan: item,
              isButtonDisabled: isButtonDisabled,
              buttonTitle: isCurrentPlan ? 'Current Plan' : 'Continue',
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
              ref.read(plansProvider).changePage(index);
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(provider.packages.length, (index) {
            final isActive = provider.selectedPage == index;
            return GestureDetector(
              onTap: () => ref.read(plansProvider).changePage(index),
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

  int? _resolveCurrentPlanRanking({
    required String? activePlanId,
    required List<Plans> plans,
  }) {
    if (activePlanId == null || activePlanId.isEmpty) return null;

    for (final plan in plans) {
      final planId = (plan.id ?? '').trim();
      if (planId == activePlanId) {
        return plan.ranking;
      }
    }

    return null;
  }

  String? _resolveCurrentPlanIdFromDashboard() {
    final dashboard = ref.watch(profileProvider).dashboard;
    final membership = dashboard?.profile?.membership;

    final directPlanId = membership?.planId?.trim();
    if (directPlanId?.isNotEmpty == true) {
      return directPlanId;
    }

    final nestedPlanId = membership?.plan?.id?.trim();
    if (nestedPlanId?.isNotEmpty == true) {
      return nestedPlanId;
    }

    return null;
  }

  bool _isCurrentPlan({
    required Plans item,
    required String? activePlanId,
  }) {
    if (activePlanId == null || activePlanId.isEmpty) return false;
    return (item.id ?? '').trim() == activePlanId;
  }

  bool _isPlanActionDisabled({
    required Plans item,
    required String? activePlanId,
    required int? activePlanRanking,
  }) {
    if (_isCurrentPlan(item: item, activePlanId: activePlanId)) return true;
    if (activePlanRanking == null) return false;

    final itemRanking = item.ranking;
    if (itemRanking == null) return false;

    return itemRanking <= activePlanRanking;
  }

  Widget _haveQuestionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
          'You Have Questions?',
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
            return CustomExpansionTile(
              title: entry.key,
              backgroundColor: AppColors.transparent,
              titleBackgroundColor: AppColors.transparent,
              bottomMargin: 16,
              borderColor: AppColors.primary,
              child: Text(
                entry.value,
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
              Text(
                'Still Need Help?',
                style: TextStyle(
                  fontSize: TextSize.font18(context),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'We are right here to help you. Give us a call anything between  10am-7pm',
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
                      Text(
                        '01715-7277279',
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
                      Text(
                        '01715-7277279',
                        style: TextStyle(
                          fontSize: TextSize.font14(context),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

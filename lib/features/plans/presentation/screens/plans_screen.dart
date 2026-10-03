import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/bottom_sheet.dart';
import 'package:walima_llc/core/global/components/custom_expansion_tile.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/features/anchor_point/achore_appbar.dart';
import 'package:walima_llc/features/plans/data/models/get_plans_response.dart';
import 'package:walima_llc/features/plans/presentation/screens/widgets/package_card.dart';
import 'package:walima_llc/features/plans/presentation/screens/widgets/order_summary_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/plans/presentation/providers/plans_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class UpgradePackageScreen extends ConsumerStatefulWidget {
  const UpgradePackageScreen(
      {super.key, this.fromScreen, this.showAppBar = true});
  final String? fromScreen;
  final bool showAppBar;

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
              if (widget.showAppBar) _appbarSection(),
              if (!widget.showAppBar) _anchoredAppBarSection(),
              provider.loaderState == UpgradePackageScreenStates.loading
                  ? const Expanded(child: Center(child: Loading()))
                  : _body(),
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

  Widget _anchoredAppBarSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AnchoredAppBar(
        context: context,
        title: 'Premium Plans'.localized(context),
        onNotificationPressed: () => context.pushNamed(Routes.notifications),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
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
        // const ShowImage(
        //   imagePath: AppImages.upgradePremium,
        //   width: 140,
        //   height: 110,
        // ),
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '21'.localized(context),
                textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false),
                style: TextStyle(
                  fontSize: TextSize.font36(context),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                  color: AppColors.white,
                ),
              ),
              Text(
                'Days'.localized(context),
                textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false),
                style: TextStyle(
                  fontSize: TextSize.font16(context),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'MONEY BACK GUARANTEE'.localized(context),
            style: TextStyle(
              fontSize: TextSize.font10(context),
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ),

        const SizedBox(height: 20),
        Text(
          'Upgrade to Premium'.localized(context),
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
                      final preview =
                          await plansState.prepareOrderSummaryPreview(
                        context: context,
                        selectedPlan: item,
                      );
                      if (preview == null || !context.mounted) return;

                      final proceed = await BottomSheetUtils.open(
                        context: context,
                        fullHeight: true,
                        showHeader: false,
                        child: OrderSummaryBottomSheet(
                          plan: item,
                          upgradeQuote: preview.upgradeQuote,
                        ),
                      );
                      if (proceed != true || !context.mounted) return;

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
                width: isActive ? 30 : 16,
                height: 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
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
          'You Have Questions?'.localized(context),
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
              title: entry.key.localized(context),
              backgroundColor: AppColors.transparent,
              titleBackgroundColor: AppColors.transparent,
              bottomMargin: 16,
              borderColor: AppColors.primary,
              child: Text(
                entry.value.localized(context),
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
                'Still Need Help?'.localized(context),
                style: TextStyle(
                  fontSize: TextSize.font18(context),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'We are right here to help you. Give us a call anything between  10am-7pm'
                    .localized(context),
                style: TextStyle(
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  InkWell(
                    onTap: () => callNumber('01305455665'),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const ShowImage(
                            imagePath: AppImages.callIcon,
                            width: 16,
                            height: 16,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '01305-455665',
                          style: TextStyle(
                            fontSize: TextSize.font14(context),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () => openWhatsApp('1305455665'),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.greenButtonColor,
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
                          '01305-455665',
                          style: TextStyle(
                            fontSize: TextSize.font14(context),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void openWhatsApp(String number) async {
    final uri = Uri.parse('https://wa.me/88$number'); // BD country code
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> callNumber(String number) async {
    final uri = Uri(scheme: 'tel', path: number);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

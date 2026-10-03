import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class PartnerPreferencesScreen extends ConsumerStatefulWidget {
  const PartnerPreferencesScreen({
    super.key,
    this.isFromDrawer = false,
  });

  final bool isFromDrawer;

  @override
  ConsumerState<PartnerPreferencesScreen> createState() =>
      _PartnerPreferencesScreenState();
}

class _PartnerPreferencesScreenState
    extends ConsumerState<PartnerPreferencesScreen> {
  late RecommendedPreferencesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(recommendedPreferencesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      provider.setPreferenceFlowSource(isFromDrawer: widget.isFromDrawer);
      provider.initControllersListener();
      if (widget.isFromDrawer) {
        await provider.loadSavedPreferences();
      } else {
        await provider.getInitialData();
      }
    });
  }

  @override
  void dispose() {
    provider.disposeControllersListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(recommendedPreferencesProvider);
    return TransparentLoading(
      isLoading: provider.loaderState ==
              RecommendedPreferencesScreenStates.preferences ||
          provider.isSavedPreferencesLoading,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates ==
                  RecommendedPreferencesScreenStates.preferences
              ? const Loading()
              : Column(
                  children: [
                    UpperLayer(
                      imagePath: AppImages.recommendedPreferences,
                      isShowAppbar: true,
                      isBackButton: true,
                      isTrailing: true,
                      trailingText: 'Skip Preferences',
                      onTrailingTap: _onSkipTap,
                    ),
                    body(),
                  ],
                ),
        ),
      ),
    );
  }

  void _onSkipTap() {
    // ref.read(currentTabProvider.notifier).state = 0;
    // final homeState = ref.read(homeProvider);
    // homeState.loadPremiumMatches(force: true);
    // homeState.loadRecentVisitors(force: true);
    context.goNamed(Routes.connectMatches);
  }

  Widget body() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          spacing: 10,
          children: [
            const StaticTextWidget(
              title: 'Partner Preferences',
              subtitle:
                  'Set your preferences so we can find the right partner for you.',
            ),
            if (provider.savedPreferencesError != null && widget.isFromDrawer)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  provider.savedPreferencesError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                spacing: 20,
                children: [
                  Row(spacing: 10, children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryShade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const ShowImage(
                        imagePath: AppImages.searchSvgIcon,
                        height: 20,
                        width: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smarter Matches',
                            style: TextStyle(
                                fontSize: TextSize.font14(context),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimaryLight),
                          ),
                          Text(
                            'We\'ll show you profiles that match your criteria first',
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: TextSize.font12(context),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                    )
                  ]),
                  Row(spacing: 10, children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryShade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const ShowImage(
                        imagePath: AppImages.saveTime,
                        height: 20,
                        width: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Save TIme',
                            style: TextStyle(
                                fontSize: TextSize.font14(context),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimaryLight),
                          ),
                          Text(
                            'No need to scroll through irrelevant profiles',
                            style: TextStyle(
                                fontSize: TextSize.font12(context),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                    )
                  ]),
                  Row(spacing: 10, children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryShade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const ShowImage(
                        imagePath: AppImages.settingsSvgIcon,
                        height: 20,
                        width: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You\'re in Control',
                            style: TextStyle(
                                fontSize: TextSize.font14(context),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimaryLight),
                          ),
                          Text(
                            'Update your preferences anytime from settings',
                            style: TextStyle(
                                fontSize: TextSize.font12(context),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                    )
                  ]),
                ],
              ),
            ),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.iconicDynamicButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: provider.savedPreferencesError != null && widget.isFromDrawer
          ? 'Retry'
          : 'Continue',
      onTap: () async {
        if (provider.isSavedPreferencesLoading) return;
        if (provider.savedPreferencesError != null && widget.isFromDrawer) {
          await provider.loadSavedPreferences();
          return;
        }
        context.push(Paths.basicDetails);
      },
    );
  }
}

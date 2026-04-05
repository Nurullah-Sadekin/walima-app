import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';

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

class _PartnerPreferencesScreenState extends ConsumerState<PartnerPreferencesScreen> {
  late RecommendedPreferencesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(recommendedPreferencesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.setPreferenceFlowSource(isFromDrawer: widget.isFromDrawer);
      provider.getInitialData();
      provider.initControllersListener();
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
      isLoading: provider.loaderState == RecommendedPreferencesScreenStates.preferences,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates == RecommendedPreferencesScreenStates.preferences
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(
                        imagePath: AppImages.recommendedPreferences,
                        isShowAppbar: true,
                        isBackButton: false,
                        isTrailing: true,
                        trailingText: 'Skip',
                        onTrailingTap: null),
                    body(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          spacing: 10,
          children: [
            completeMessage(),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget completeMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Partner Preferences',
            style: TextStyle(
              fontSize: TextSize.font20(context),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
          Text(
            'Set your preferences so we can find the right partner for you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Continue',
      onTap: () {
         context.push(Paths.basicDetails);
      },
    );
  }
}

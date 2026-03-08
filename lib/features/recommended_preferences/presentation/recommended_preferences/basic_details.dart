import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:go_router/go_router.dart';

class BasicDetailsScreen extends ConsumerStatefulWidget {
  const BasicDetailsScreen({super.key});
  @override
  ConsumerState<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends ConsumerState<BasicDetailsScreen> {
  late RecommendedPreferencesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(recommendedPreferencesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
            view(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget view() {
    return Expanded(
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Age Range',
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          // Age range slider
          RangeSlider(
            values: RangeValues(provider.ageStart.toDouble(), provider.ageEnd.toDouble()),
            min: provider.ageMinLimit.toDouble(),
            max: provider.ageMaxLimit.toDouble(),
            divisions: provider.ageMaxLimit - provider.ageMinLimit,
            labels: RangeLabels('${provider.ageStart}', '${provider.ageEnd}'),
            onChanged: (values) => provider.setAgeRange(values),
            activeColor: AppColors.primary,
            inactiveColor: const Color(0xFFEAEAEA),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              return AppColors.primaryVariant;
            }),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          Text(
            'Height Range',
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          // Height range slider
          RangeSlider(
            values: RangeValues(provider.heightStart.toDouble(), provider.heightEnd.toDouble()),
            min: provider.heightMinLimit.toDouble(),
            max: provider.heightMaxLimit.toDouble(),
            divisions: ((provider.heightMaxLimit - provider.heightMinLimit) ~/ 1) > 0 ? (provider.heightMaxLimit - provider.heightMinLimit) ~/ 1 : null,
            labels: RangeLabels('${provider.heightStart} cm', '${provider.heightEnd} cm'),
            activeColor: AppColors.primary,
            inactiveColor: const Color(0xFFEAEAEA),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              return AppColors.primaryVariant;
            }),
            onChanged: (values) => provider.setHeightRange(values),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          Text(
            'Martial Status',
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const double spacing = 10.0;
                  return Consumer(builder: (context, ref, _) {
                    final provider = ref.watch(recommendedPreferencesProvider);
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: List.generate(provider.maritalStatusDataList.length, (index) {
                        final item = provider.maritalStatusDataList[index];

                        return SelectionCard(
                          buttonStyle: item.isSelected
                              ? SelectionStyle.selectedCheckbox
                              : SelectionStyle.unSelectedCheckbox,
                          onTap: () {
                            provider.toggleMaritalStatus(index);
                          },
                          isSelected: item.isSelected,
                          title: item.name,
                        );
                      }),
                    );
                  });
                },
              ),
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
        context.push(Paths.community);
      },
    );
  }
}

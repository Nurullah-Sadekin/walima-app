import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:go_router/go_router.dart';

class EducationScreen extends ConsumerStatefulWidget {
  const EducationScreen({super.key});
  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
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
                  isBackButton: true,),
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
            'Education  Qualification',
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
                      children: List.generate(provider.countryDataList.length, (index) {
                        final item = provider.countryDataList[index];

                        return SelectionCard(
                          buttonStyle: item.isSelected
                              ? SelectionStyle.selectedCheckbox
                              : SelectionStyle.unSelectedCheckbox,
                          onTap: () {
                            provider.toggleCity(index);
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
        context.push(Paths.career);
      },
    );
  }
}

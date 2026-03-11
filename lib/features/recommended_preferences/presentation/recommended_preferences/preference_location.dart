import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:go_router/go_router.dart';

class PreferenceLocationScreen extends ConsumerStatefulWidget {
  const PreferenceLocationScreen({super.key});
  @override
  ConsumerState<PreferenceLocationScreen> createState() =>
      _PreferenceLocationScreenState();
}

class _PreferenceLocationScreenState
    extends ConsumerState<PreferenceLocationScreen> {
  late RecommendedPreferencesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(recommendedPreferencesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.loadLocationData();
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
      isLoading: provider.loaderState ==
          RecommendedPreferencesScreenStates.preferences,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates ==
                  RecommendedPreferencesScreenStates.preferences
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(
                      imagePath: AppImages.recommendedPreferences,
                      isShowAppbar: true,
                      isBackButton: true,
                    ),
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
            dataField(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget dataField() {
    return Expanded(
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropDownField(
            headLine: 'Country Living In',
            hintText: 'Select',
            popUpHeader: 'Select Preferable Country Living In',
            items: provider.countryDropdownItems,
            controller: provider.countryPreferenceController,
            onTap: provider.loadLocationData,
            onConfirm: (value) =>
                provider.onCountryPreferenceSelected(value?.toString()),
            isSearch: true,
          ),
          Text(
            'City',
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          provider.countryPreferenceController.text.isEmpty
              ? const SizedBox.shrink()
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Consumer(builder: (context, ref, _) {
                      final provider =
                          ref.watch(recommendedPreferencesProvider);
                      if (provider.cityDropdownItems.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      const double spacing = 10.0;
                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: provider.cityDropdownItems.map((cityName) {
                          final isSelected =
                              provider.preferableCity.contains(cityName);
                          return SelectionCard(
                            buttonStyle: isSelected
                                ? SelectionStyle.selectedCheckbox
                                : SelectionStyle.unSelectedCheckbox,
                            onTap: () {
                              provider.togglePreferableCity(cityName);
                            },
                            isSelected: isSelected,
                            title: cityName,
                          );
                        }).toList(),
                      );
                    }),
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
        context.push(Paths.education);
      },
    );
  }
}

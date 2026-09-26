import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class PreferenceLocationScreen extends ConsumerStatefulWidget {
  const PreferenceLocationScreen({super.key});
  @override
  ConsumerState<PreferenceLocationScreen> createState() =>
      _PreferenceLocationScreenState();
}

class _PreferenceLocationScreenState
    extends ConsumerState<PreferenceLocationScreen> {
  late RecommendedPreferencesProvider provider;
  final ScrollController _cityScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    provider = ref.read(recommendedPreferencesProvider);
    _cityScrollController.addListener(_onCityScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider.getInitialData();
      await provider.loadLocationData();
      provider.initControllersListener();
    });
  }

  @override
  void dispose() {
    _cityScrollController
      ..removeListener(_onCityScroll)
      ..dispose();
    provider.disposeControllersListener();
    super.dispose();
  }

  void _onCityScroll() {
    if (!_cityScrollController.hasClients) return;

    final position = _cityScrollController.position;
    if (position.pixels >= position.maxScrollExtent - 120) {
      ref
          .read(recommendedPreferencesProvider)
          .loadMoreCitiesForSelectedCountry();
    }
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
                    UpperLayer(
                      imagePath: AppImages.recommendedPreferences,
                      isShowAppbar: true,
                      isBackButton: true,
                      isTrailing: true,
                      trailingText: 'Skip',
                      onTrailingTap: () {
                        context.push(Paths.education);
                      },
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          spacing: 10,
          children: [
            const StaticTextWidget(
              title: 'Partner Location Preference',
              subtitle: 'Select preference country and city',
            ),
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
            // onTap: provider.loadLocationData,
            onConfirm: (value) =>
                provider.onCountryPreferenceSelected(value?.toString()),
            isSearch: true,
          ),
          provider.countryPreferenceController.text.isEmpty
              ? const SizedBox.shrink()
              : Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final provider =
                          ref.watch(recommendedPreferencesProvider);

                      const double spacing = 10.0;
                      return SingleChildScrollView(
                        controller: _cityScrollController,
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'City',
                              style: TextStyle(
                                fontSize: TextSize.font14(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: spacing),
                            Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              children: [
                                SelectionCard(
                                  borderRadius: 40,
                                  buttonStyle: provider.isOpenToAllCities
                                      ? SelectionStyle.selectedCheckbox
                                      : SelectionStyle.unSelectedCheckbox,
                                  onTap: provider.toggleOpenToAllCities,
                                  isSelected: provider.isOpenToAllCities,
                                  title: RecommendedPreferencesProvider
                                      .openToAllCitiesLabel,
                                ),
                                ...provider.cityDropdownItems.map((cityName) {
                                  final isSelected = provider.preferableCity
                                      .contains(cityName);
                                  return SelectionCard(
                                    borderRadius: 40,
                                    buttonStyle: isSelected
                                        ? SelectionStyle.selectedCheckbox
                                        : SelectionStyle.unSelectedCheckbox,
                                    onTap: () {
                                      provider.togglePreferableCity(cityName);
                                    },
                                    isSelected: isSelected,
                                    title: cityName,
                                  );
                                }),
                              ],
                            ),
                            if (provider.isCityLoading &&
                                provider.cityDropdownItems.isEmpty)
                              const Center(child: CircularProgressIndicator()),
                            if (!provider.isCityLoading &&
                                provider.cityDropdownItems.isEmpty)
                              const Text(
                                'No cities available for the selected country.',
                              ),
                            if (provider.isCityLoadingMore)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.iconicDynamicButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: () {
        context.push(Paths.education);
      },
    );
  }
}

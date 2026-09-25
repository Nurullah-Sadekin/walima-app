import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/paginated_search_picker_sheet.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class LocationAndYourReligion extends ConsumerStatefulWidget {
  const LocationAndYourReligion({super.key});
  @override
  ConsumerState<LocationAndYourReligion> createState() => _LocationAndYourReligionState();
}

class _LocationAndYourReligionState extends ConsumerState<LocationAndYourReligion> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.initControllersListener();
      provider.loadReligionData();
      provider.loadLocationData();
    });
  }

  @override
  void dispose() {
    provider.disposeControllersListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(registrationProvider);
    final screenProvider = ref.watch(registrationScreenStateProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor || provider.isReligionDataLoading || provider.isLocationDataLoading,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates == RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.religion, totalProgressCount: 11, currentIndexProgress: 2, showProgress: true),
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
              title: 'Religion & Location',
              subtitle: 'Tell us about your faith and where you live',
            ),
            dataInsertField(),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget dataInsertField() {
    return Column(
      children: [
        DropDownField(
          headLine: 'Your Religion',
          isRequired: true,
          hintText: 'Select',
          popUpHeader: 'Select Religion',
          items: provider.religionDropdownItems,
          controller: provider.religionController,
          onTap: provider.loadCommunityData,
          onConfirm: (value) => provider.onReligionSelected(value?.toString()),
          isSearch: true,
        ),
        SizedBox(height: TextSize.font20(context)),
        if (provider.showCommunityField) ...[
          DropDownField(
            headLine: 'Community',
            hintText: 'Select',
            isOptional: true,
            popUpHeader: 'Select Community',
            isRequired: false,
            items: provider.communityDropdownItems,
            controller: provider.communityController,
            onTap: provider.loadLocationData,
            onConfirm: (value) => provider.onCommunitySelected(value?.toString()),
            isSearch: true,
          ),
          SizedBox(height: TextSize.font20(context)),
        ],
        Column(
          children: [
            PrimaryTextField(
              headLine: 'Where do you live',
              hintText: 'Select',
              controller: provider.livingInController,
              errorText: '',
              noPrefix: true,
              readOnly: true,
              isRequired: true,
              onTap: _openCountryPicker,
              suffix: Icon(
                Icons.keyboard_arrow_down_outlined,
                size: TextSize.font20(context),
                color: AppColors.grey,
              ),
            ),
            SizedBox(height: TextSize.font10(context)),
            SizedBox(height: TextSize.font10(context)),
            // Row(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 6.0),
            //       child: Text(
            //         'Select the country you currently live in',
            //         style: TextStyle(
            //           fontSize: TextSize.font12(context),
            //           fontWeight: FontWeight.w400,
            //           color: AppColors.hintTextColor,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        provider.livingInController.text.isEmpty
            ? const SizedBox.shrink()
            : PrimaryTextField(
                headLine: 'City',
                hintText: provider.livingInController.text.isEmpty ? 'Select Living In first' : 'Select',
                controller: provider.cityController,
                errorText: '',
                enabled: provider.livingInController.text.isNotEmpty,
                noPrefix: true,
                isRequired: true,
                readOnly: true,
                onTap: _openCityPicker,
                suffix: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: TextSize.font20(context),
                  color: AppColors.grey,
                ),
              ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle:
          provider.religionController.text.isNotEmpty && provider.cityController.text.isNotEmpty && provider.livingInController.text.isNotEmpty
              ? ButtonsStyle.iconicDynamicButton
              : ButtonsStyle.disableButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: () {
        if (provider.religionController.text.isEmpty || provider.cityController.text.isEmpty || provider.livingInController.text.isEmpty) {
          return;
        }
        provider.setSelectedCountryCode(context);
      },
    );
  }

  Future<void> _openCountryPicker() async {
    await provider.loadCountryData(reset: provider.countryDropdownItems.isEmpty);
    if (!mounted) {
      return;
    }

    final selectedCountry = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Living In',
      searchHintText: 'Search country',
      items: provider.countryDropdownItems,
      isInitialLoading: provider.isCountryLoading && provider.countryDropdownItems.isEmpty,
      isLoadingMore: provider.isCountryLoadingMore,
      hasMoreItems: provider.hasMoreCountries,
      initialQuery: provider.countrySearchQuery,
      emptyStateText: 'No countries found',
      onSearchChanged: provider.setCountrySearchQuery,
      onLoadMore: provider.loadMoreCountries,
    );

    if (!mounted || selectedCountry == null || selectedCountry.trim().isEmpty) {
      return;
    }

    provider.onLivingInSelected(selectedCountry);
  }

  Future<void> _openCityPicker() async {
    if (provider.livingInController.text.isEmpty) {
      return;
    }

    await provider.loadCityData(reset: provider.cityDropdownItems.isEmpty);
    if (!mounted) {
      return;
    }

    final selectedCity = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select City',
      searchHintText: 'Search city',
      items: provider.cityDropdownItems,
      isInitialLoading: provider.isCityLoading && provider.cityDropdownItems.isEmpty,
      isLoadingMore: provider.isCityLoadingMore,
      hasMoreItems: provider.hasMoreCities,
      initialQuery: provider.citySearchQuery,
      emptyStateText: 'No cities found',
      onSearchChanged: provider.setCitySearchQuery,
      onLoadMore: provider.loadMoreCitiesForSelectedCountry,
    );

    if (!mounted || selectedCity == null || selectedCity.trim().isEmpty) {
      return;
    }

    provider.onCitySelected(selectedCity);
  }
}

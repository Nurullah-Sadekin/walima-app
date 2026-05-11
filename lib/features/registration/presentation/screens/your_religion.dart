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

class YourReligion extends ConsumerStatefulWidget {
  const YourReligion({super.key});
  @override
  ConsumerState<YourReligion> createState() => _YourRegionState();
}

class _YourRegionState extends ConsumerState<YourReligion> {
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
    final screenProvider = ref.watch(yourReligionScreenProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor ||
              provider.isReligionDataLoading ||
              provider.isLocationDataLoading,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.religion, totalProgressCount: 5, currentIndexProgress: 2,showProgress: true),
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
      spacing: 20,
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
        provider.religionController.text.isEmpty
            ? const SizedBox.shrink()
            : DropDownField(
                headLine: 'Community',
                hintText: 'Select',
                popUpHeader: 'Select Community',
                isRequired: true,
                items: provider.communityDropdownItems,
                controller: provider.communityController,
                onTap: provider.loadLocationData,
                onConfirm: (value) =>
                    provider.onCommunitySelected(value?.toString()),
                isSearch: true,
              ),
        provider.religionController.text.isEmpty ||
                provider.communityController.text.isEmpty
            ? const SizedBox.shrink()
            : Column(
              children: [
                PrimaryTextField(
                    headLine: 'Living In',
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Text('Select the country you currently live in',
                        style: TextStyle(
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w400,
                          color: AppColors.hintTextColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.religionController.text.isNotEmpty &&
              provider.communityController.text.isNotEmpty &&
              provider.livingInController.text.isNotEmpty
          ? ButtonsStyle.iconicDynamicButton
          : ButtonsStyle.disableButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: () {
        if (provider.religionController.text.isEmpty ||
            provider.communityController.text.isEmpty ||
            provider.livingInController.text.isEmpty) {
          return;
        }
        provider.setSelectedCountryCode(context);
      },
    );
  }

  Future<void> _openCountryPicker() async {
    await provider.loadCountryData(
        reset: provider.countryDropdownItems.isEmpty);
    if (!mounted) {
      return;
    }

    final selectedCountry = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Living In',
      searchHintText: 'Search country',
      items: provider.countryDropdownItems,
      isInitialLoading:
          provider.isCountryLoading && provider.countryDropdownItems.isEmpty,
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
}

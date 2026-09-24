import 'package:flutter/material.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/paginated_search_picker_sheet.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});
  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.loadLocationData();
      provider.initControllersListener();
      await provider.getInitialData();
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
      isLoading: screenProvider.loaderState == RegistrationScreenStates.isProfileFor || provider.isLocationDataLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates == RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.location, totalProgressCount: 10, currentIndexProgress: 6,showProgress: true),
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
            const StaticTextWidget(title: 'Residency Information', subtitle: 'Where do you currently live?'),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // PrimaryTextField(
        //   headLine: 'City',
        //   hintText: provider.livingInController.text.isEmpty ? 'Select Living In first' : 'Select',
        //   controller: provider.cityController,
        //   errorText: '',
        //   enabled: provider.livingInController.text.isNotEmpty,
        //   noPrefix: true,
        //   readOnly: true,
        //   onTap: _openCityPicker,
        //   suffix: Icon(
        //     Icons.keyboard_arrow_down_outlined,
        //     size: TextSize.font20(context),
        //     color: AppColors.grey,
        //   ),
        // ),
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 4,
              children: [
                Text(
                  'You Live with Your Family',
                  style: TextStyle(
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '*',
                  style: TextStyle(
                      fontSize: TextSize.font14(context),
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent),
                ),
              ],
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(provider.isWithFamilyDataList.length, (index) {
                final isWithFamily = provider.isWithFamilyDataList[index];
                double screenWidth = MediaQuery.of(context).size.width - 48;
                double itemWidth = (screenWidth - 10) / 2;
                return SizedBox(
                  width: itemWidth,
                  child: SelectionCard(
                    buttonStyle: isWithFamily.isSelected ? SelectionStyle.selectedRadio : SelectionStyle.unSelectedRadio,
                    onTap: () {
                      provider.selectedIsWithFamily(index);
                    },
                    isSelected: isWithFamily.isSelected,
                    title: isWithFamily.name,
                  ),
                );
              }),
            ),
          ],
        ),
        DropDownField(
          headLine: 'Residency Status',
          hintText: 'Select',
          isRequired: true,
          popUpHeader: 'Select Residency Status',
          items: provider.residencyStatusDropdownItems,
          controller: provider.residencyStatusController,
          onConfirm: (value) => provider.onResidencyStatusSelected(value?.toString()),
          isSearch: true,
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle:
          provider.cityController.text.isNotEmpty && provider.residencyStatusController.text.isNotEmpty && provider.selectedIsWithFamilyStatus != null
              ? ButtonsStyle.iconicDynamicButton
              : ButtonsStyle.disableButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: () {
        if (provider.cityController.text.isEmpty || provider.residencyStatusController.text.isEmpty || provider.selectedIsWithFamilyStatus == null) {
          return;
        }
        context.push(Paths.maritalStatus);
      },
    );
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

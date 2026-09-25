import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/matches/presentation/widgets/setting_switcher_title.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class ProfessionScreen extends ConsumerStatefulWidget {
  const ProfessionScreen({super.key});
  @override
  ConsumerState<ProfessionScreen> createState() => _ProfessionScreenState();
}

class _ProfessionScreenState extends ConsumerState<ProfessionScreen> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.initControllersListener();
      provider.loadProfessionLookupData();
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
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor ||
              provider.isLookupDataLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(
                        imagePath: AppImages.profession,
                        totalProgressCount: 11,
                        currentIndexProgress: 9,
                        showProgress: true),
                    Expanded(child: body()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          spacing: 10,
          children: [
            const StaticTextWidget(
                title: 'Work Details',
                subtitle: 'Tell us about your career & income'),
            dataInsertField(),
            const SizedBox(height: 20),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    Text(
                      'Income',
                      style: TextStyle(
                        fontSize: TextSize.font14(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '(optional)',
                      style: TextStyle(
                          fontSize: TextSize.font10(context),
                          fontWeight: FontWeight.w400,
                          color: AppColors.hintTextColor),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border:
                          Border.all(width: 1, color: AppColors.disableText)),
                  child: Row(
                    children: List.generate(
                      provider.incomePeriodDataList.length,
                      (index) {
                        final incomePeriod =
                            provider.incomePeriodDataList[index];

                        return GestureDetector(
                          onTap: () {
                            provider.selectedIncomePeriod(index);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: incomePeriod.isSelected
                                  ? const Color(0xFFE83E7A)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              incomePeriod.name,
                              style: TextStyle(
                                fontSize: TextSize.font12(context),
                                fontWeight: FontWeight.w600,
                                color: incomePeriod.isSelected
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
            // Income Range Dropdown
            DropDownField(
              hintText: 'Select',
              popUpHeader: 'Select Income Range',
              items: provider.incomeRangeDropdownItems,
              controller: provider.incomeRangeController,
              onTap: provider.loadProfessionLookupData,
              onConfirm: (value) =>
                  provider.selectIncomeRange(value?.toString()),
              isSearch: true,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.disableBackground,
              ),
              child: SettingsSwitchTile(
                title: 'Hide income from others',
                subtitle:
                    'Income helps us find better matches but won\'t be shown to others',
                value: provider.hideIncome,
                onChanged: (bool value) {
                  provider.hideIncome = value;
                  provider.notifyListeners();
                },
              ),
            )
            // Wrap(
            //   spacing: 10,
            //   runSpacing: 10,
            //   children:
            //       List.generate(provider.incomePeriodDataList.length, (index) {
            //     final incomePeriod = provider.incomePeriodDataList[index];
            //
            //     double screenWidth = MediaQuery.of(context).size.width - 48;
            //     double itemWidth = (screenWidth - 10) / 2;
            //
            //     return SizedBox(
            //       width: itemWidth,
            //       child: SelectionCard(
            //         buttonStyle: incomePeriod.isSelected
            //             ? SelectionStyle.selectedRadio
            //             : SelectionStyle.unSelectedRadio,
            //         onTap: () {
            //           provider.selectedIncomePeriod(index);
            //         },
            //         isSelected: incomePeriod.isSelected,
            //         title: incomePeriod.name,
            //       ),
            //     );
            //   }),
            // ),
          ],
        ),

        // Work sector is selected in two levels when the lookup API supplies
        // parent/child relationships. Selecting a category clears any prior
        // leaf from a different branch.
        DropDownField(
          headLine: 'Work Sector',
          hintText: 'Select',
          isRequired: true,
          popUpHeader: 'Select Work Sector',
          items: provider.workSectorCategoryItems,
          controller: provider.workSectorCategoryController,
          onTap: provider.loadProfessionLookupData,
          onConfirm: (value) =>
              provider.selectWorkSectorCategory(value?.toString()),
          isSearch: false,
        ),

        if (provider.workSectorNeedsSubcategory)
          DropDownField(
            headLine: 'Work Category',
            hintText: 'Select',
            isRequired: true,
            popUpHeader: 'Select Work Category',
            items: provider.workSectorSubcategoryItems,
            controller: provider.yourWorkController,
            onConfirm: (value) => provider.selectYourWork(value?.toString()),
            isSearch: false,
          ),

        // You Work As Dropdown
        DropDownField(
          headLine: 'Your Profession',
          hintText: 'Select',
          isRequired: true,
          popUpHeader: 'Select Profession',
          items: provider.professionDropdownItems,
          controller: provider.youWorkAsController,
          onTap: provider.loadProfessionLookupData,
          onConfirm: (value) => provider.selectYouWorkAs(value?.toString()),
          isSearch: true,
        ),

        PrimaryTextField(
          controller: provider.currentCompanyNameController,
          headLine: 'Company / Organisation',
          hintText: 'e.g. BRAC Bank, Grameenphone',
          isOptional: true,
          errorText: null,
          noPrefix: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget bottomAction() {
    final hasAnyValue = provider.youWorkAsController.text.isEmpty ||
        !provider.hasSelectedWorkSector;

    return PrimaryButtons(
      buttonStyle: provider.youWorkAsController.text.isNotEmpty &&
              provider.hasSelectedWorkSector
          ? ButtonsStyle.iconicDynamicButton
          : ButtonsStyle.disableButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: () {
        if (hasAnyValue) return;
        context.push(Paths.aboutYourself);
        // proceed
      },
    );
  }
}

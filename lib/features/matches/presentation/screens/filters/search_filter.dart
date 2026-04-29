import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/search_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/setting_switcher_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';

class SearchFilterScreen extends ConsumerStatefulWidget {
  const SearchFilterScreen({super.key});
  @override
  ConsumerState<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> {
  late SearchFilterProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(searchFilterProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.loadLookupData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(searchFilterProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              _appbar(),
              const SizedBox(height: 16),
              _body(),
            ],
          ),
        ),
      ),
      floatingActionButton: BottomBorderedWidget(
        widget: bottomAction(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _appbar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: TextSize.font16(context),
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                hintText: 'Enter Profile ID',
                border: InputBorder.none, // No border
                enabledBorder: InputBorder.none, // No border when enabled
                focusedBorder: InputBorder.none, // No border when focused
                errorBorder: InputBorder.none, // No border when error
                disabledBorder: InputBorder.none, // No border when disabled
                hintStyle: TextStyle(
                  fontSize: TextSize.font14(context),
                  color: AppColors.hintTextColor,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: ShowImage(
                    imagePath: AppImages.searchSvgIcon,
                    width: TextSize.font16(context),
                    height: TextSize.font16(context),
                    color: AppColors.hintTextColor,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 0,
                ),
                isDense: true,
              ),
              controller: provider.profileIdController,
              cursorColor: AppColors.primary, // Optional: set cursor color
            ),
          ),
        ),
      ],
    );
  }

  Widget _body() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            personalizeYourSearch(),
            additionalSearchOption(),
            lifeStyle(),
            otherDetails(),
            const SizedBox(height: 65),
          ],
        ),
      ),
    );
  }

  Widget personalizeYourSearch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headLineText(
            'Personalize Your Search',
            fontSize: TextSize.font16(context),
          ),
          SizedBox(height: TextSize.font16(context)),
          headLineText('Age'),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: DropDownField(
                  hintText: 'From',
                  popUpHeader: 'Age From',
                  items: provider.ageRangeDropdownItems,
                  controller: provider.ageFromController,
                  //  onConfirm: (value) => provider.onResidencyStatusSelected(value?.toString()),
                  isSearch: true,
                ),
              ),
              Expanded(
                child: DropDownField(
                  hintText: 'To',
                  popUpHeader: 'Age To',
                  items: provider.ageRangeDropdownItems,
                  controller: provider.ageToController,
                  // onConfirm: (value) => provider.onResidencyStatusSelected(value?.toString()),
                  isSearch: true,
                ),
              ),
            ],
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Height'),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: DropDownField(
                  hintText: 'From',
                  popUpHeader: 'Height From',
                  items: provider.heightRangeDropdownItems,
                  controller: provider.heightFromController,
                  isSearch: true,
                ),
              ),
              Expanded(
                child: DropDownField(
                  hintText: 'To',
                  popUpHeader: 'Height To',
                  items: provider.heightRangeDropdownItems,
                  controller: provider.heightToController,
                  isSearch: true,
                ),
              ),
            ],
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Marital Status'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Marital Status',
            items: provider.maritalStatusDropdownItems,
            controller: provider.maritalStatusController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Have Children'),
          SizedBox(height: TextSize.font10(context)),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: List.generate(provider.haveChildren.length, (index) {
              final haveChildren = provider.haveChildren[index];

              return SelectionCard(
                buttonStyle: haveChildren.isSelected
                    ? SelectionStyle.selectedRadio
                    : SelectionStyle.unSelectedRadio,
                onTap: () {
                  provider.selectedHaveChildren(index);
                },
                isSelected: haveChildren.isSelected,
                title: haveChildren.name,
                isExpand: false,
              );
            }),
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Your Religion'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Your Religion',
            items: provider.religionDropdownItems,
            controller: provider.religionController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Community'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Community',
            items: provider.communityDropdownItems,
            controller: provider.communityController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Mother Tongue'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Mother Tongue',
            items: provider.motherTongueDropdownItems,
            controller: provider.motherTongueController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Country Living In'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Country Living In',
            items: provider.countryDropdownItems,
            controller: provider.countryLivingController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('State Living In'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'State Living In',
            items: provider.ageRangeDropdownItems,
            controller: provider.stateLivingController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Country Grew Up In'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Country Grew Up In',
            items: provider.countryDropdownItems,
            controller: provider.grewUpController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Residency Status'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Residency Status',
            items: provider.residencyStatusDropdownItems,
            controller: provider.residencyStatusController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Photo Setting'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Photo Setting',
            items: provider.photoVisibilityDropdownItems,
            controller: provider.photoSettingController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
        ],
      ),
    );
  }

  Widget additionalSearchOption() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headLineText(
            'Education & Profession Details',
            fontSize: TextSize.font16(context),
          ),
          SizedBox(height: TextSize.font16(context)),
          headLineText('Qualification'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Qualification',
            items: provider.qualificationDropdownItems,
            controller: provider.qualificationController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Education Area'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Education Area',
            items: provider.ageRangeDropdownItems,
            controller: provider.educationAreaController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Working With'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Working With',
            items: provider.workingWithDropdownItems,
            controller: provider.workingWithController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Profession Area'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Profession Area',
            items: provider.ageRangeDropdownItems,
            controller: provider.professionAreaController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font12(context)),
          headLineText('Annual Income'),
          SizedBox(height: TextSize.font10(context)),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: List.generate(provider.annualIncomeRange.length, (index) {
              final incomeRange = provider.annualIncomeRange[index];

              return SelectionCard(
                buttonStyle: incomeRange.isSelected
                    ? SelectionStyle.selectedRadio
                    : SelectionStyle.unSelectedRadio,
                onTap: () {
                  provider.selectedAnnualIncome(index);
                },
                isSelected: incomeRange.isSelected,
                title: incomeRange.name,
                isExpand: false,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget lifeStyle() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headLineText('Life Style', fontSize: TextSize.font16(context)),
          SizedBox(height: TextSize.font16(context)),
          headLineText('Diet'),
          SizedBox(height: TextSize.font10(context)),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: List.generate(provider.dietData.length, (index) {
              final diet = provider.dietData[index];

              return SelectionCard(
                buttonStyle: diet.isSelected
                    ? SelectionStyle.selectedRadio
                    : SelectionStyle.unSelectedRadio,
                onTap: () {
                  provider.selectedDiet(index);
                },
                isSelected: diet.isSelected,
                title: diet.name,
                isExpand: false,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget otherDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headLineText(
            'Other Details Style',
            fontSize: TextSize.font16(context),
          ),
          SizedBox(height: TextSize.font16(context)),
          headLineText('Profile Managed By'),
          DropDownField(
            hintText: 'Select',
            popUpHeader: 'Profile Managed By',
            items: provider.profileManagedByDropdownItems,
            controller: provider.profileManageByController,
            isSearch: true,
          ),
          SizedBox(height: TextSize.font16(context)),
          SettingsSwitchTile(
            title: 'Include Filtered Profiles',
            subtitle: 'Include profiles that filtered me out as well.',
            value: provider.filteredProfiles ?? false,
            onChanged: (newValue) {
              provider.filteredProfiles = newValue;
              provider.updateViewState();
            },
          ),
          SizedBox(height: TextSize.font16(context)),
          SettingsSwitchTile(
            title: 'Include Viewed Profiles',
            subtitle: 'Include profiles that i have already viewed',
            value: provider.viewedProfile ?? false,
            onChanged: (newValue) {
              provider.viewedProfile = newValue;
              provider.updateViewState();
            },
          ),
        ],
      ),
    );
  }

  Widget headLineText(String text, {double? fontSize}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? TextSize.font14(context),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Search Now',
      onTap: () {
        Navigator.pop(context, {
          'profileId': provider.profileIdController.text.trim(),
          'ageMin': int.tryParse(provider.ageFromController.text.trim()),
          'ageMax': int.tryParse(provider.ageToController.text.trim()),
          'heightMin': int.tryParse(provider.heightFromController.text.trim()),
          'heightMax': int.tryParse(provider.heightToController.text.trim()),
          'maritalStatus': provider.maritalStatusController.text.trim(),
          'religion': provider.religionController.text.trim(),
          'community': provider.communityController.text.trim().isEmpty
              ? <String>[]
              : <String>[provider.communityController.text.trim()],
          'motherTongue': provider.motherTongueController.text.trim(),
          'countryLivingIn': provider.countryLivingController.text.trim().isEmpty
              ? <String>[]
              : <String>[provider.countryLivingController.text.trim()],
          'stateLivingIn': provider.stateLivingController.text.trim().isEmpty
              ? <String>[]
              : <String>[provider.stateLivingController.text.trim()],
          'countryGrewUpIn': provider.grewUpController.text.trim(),
          'residencyStatus': provider.residencyStatusController.text.trim(),
          'photoVisibility': provider.photoSettingController.text.trim(),
          'qualification': provider.qualificationController.text.trim().isEmpty
              ? <String>[]
              : <String>[provider.qualificationController.text.trim()],
          'educationArea': provider.educationAreaController.text.trim().isEmpty
              ? <String>[]
              : <String>[provider.educationAreaController.text.trim()],
          'workingWith': provider.workingWithController.text.trim(),
          'professionArea': provider.professionAreaController.text.trim(),
          'annualIncome': provider.selectedAnnualIncomeRangeStatus,
          'eatingHabits': provider.selectedDietStatus,
          'haveChildren': provider.selectedHaveChildrenStatus,
          'searchTitle': provider.profileManageByController.text.trim(),
          'includeFilteredProfiles': provider.filteredProfiles ?? false,
          'includeViewedProfiles': provider.viewedProfile ?? false,
        });
      },
    );
  }
}

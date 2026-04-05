import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/contact_filter/presentation/providers/contact_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/domain/enums/match_filter_type.dart';
import 'package:flutter_boilerplate/features/matches/domain/enums/match_marital_status.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactFilterScreen extends ConsumerStatefulWidget {
  const ContactFilterScreen({super.key});

  @override
  ConsumerState<ContactFilterScreen> createState() => _ContactFilterScreenState();
}

class _ContactFilterScreenState extends ConsumerState<ContactFilterScreen> {
  late ContactFilterProvider provider;
  FilterStep _step = FilterStep.contactFilterScreen;

  @override
  void initState() {
    super.initState();
    provider = ref.read(contactFilterProvider);
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(contactFilterProvider);

    return PopScope(
      canPop: _step == FilterStep.contactFilterScreen,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _step != FilterStep.contactFilterScreen) {
          setState(() => _step = FilterStep.contactFilterScreen);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: _appBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _body(provider),
          ),
        ),
        floatingActionButton: BottomBorderedWidget(widget: bottomAction(provider)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomBackAppBar(
      title: Text(_step == FilterStep.contactFilterScreen ? 'Contact Filter' : _getAppBarTitle(_step)),
      backgroundColor: Colors.transparent,
      onBackPressed: () {
        if (_step != FilterStep.contactFilterScreen) {
          setState(() => _step = FilterStep.contactFilterScreen);
        } else {
          Navigator.of(context).maybePop();
        }
      },
    );
  }

  String _getAppBarTitle(FilterStep step) {
    switch (step) {
      case FilterStep.contactFilterScreen:
        return 'Refine';
      case FilterStep.ageRange:
        return 'Age Range';
      case FilterStep.heightRange:
        return 'Height Range';
      case FilterStep.maritalStatus:
        return 'Marital Status';
      case FilterStep.religion:
        return 'Religion';
      case FilterStep.community:
        return 'Community';
      case FilterStep.motherTongue:
        return 'Mother Tongue';
      case FilterStep.countryLivingIn:
        return 'Country Living In';
      case FilterStep.workingWith:
        return 'Working With';
      case FilterStep.annualIncome:
      return 'Annual Income';
    }
  }

  Widget _body(ContactFilterProvider provider) {
    switch (_step) {
      case FilterStep.contactFilterScreen:
        return _contactFilterBody(provider);
      case FilterStep.ageRange:
        return _ageRange(provider);
      case FilterStep.heightRange:
      // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.maritalStatus:
        return _maritalStatusBody(provider);
      case FilterStep.religion:
      // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.community:
        return _communityBody(provider);
      case FilterStep.motherTongue:
        return _motherTongueBody(provider);
      case FilterStep.countryLivingIn:
        return _countryBody(provider);
      case FilterStep.workingWith:
      // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.annualIncome:
      // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Widget _contactFilterBody(ContactFilterProvider provider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          const SizedBox(height: 6),
          InfoTile(
            title: 'Age Range',
            value: _singleSelectedName(provider.selectedCountries, '20 -26'),
            onTap: () => setState(() => _step = FilterStep.ageRange),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.calendarSvgIcon,
          ),
          InfoTile(
            title: 'Height Range',
            value: _singleSelectedName(provider.selectedCountries, '5\'0" - 6\'0" '),
            onTap: () => setState(() => _step = FilterStep.heightRange),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.heightSvgIcon,
          ),
          InfoTile(
            title: 'Marital Status',
            value: _multiSelectedNames(provider.selectedMaritalStatus, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.maritalStatus),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.weddingSvgIcon,
          ),
          InfoTile(
            title: 'Religion',
            value: _multiSelectedNames(provider.selectedCommunities, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.religion),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.quranSvgIcon,
          ),
          InfoTile(
            title: 'Community',
            value: _multiSelectedNames(provider.selectedCommunities, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.community),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.groupsIcon,
          ),


          InfoTile(
            title: 'Mother Tongue',
            value: _multiSelectedNames(provider.selectedMotherTongues, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.motherTongue),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.languageSvgIcon,
          ),
          InfoTile(
            title: 'Country Living In',
            value: _singleSelectedName(provider.selectedCountries, 'Bangladesh'),
            onTap: () => setState(() => _step = FilterStep.countryLivingIn),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.locationSvgIcon,
          ),

          InfoTile(
            title: 'Working With',
            value: _multiSelectedNames(provider.selectedCommunities, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.workingWith),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.workSvgIcon,
          ),

          InfoTile(
            title: 'Annual Income',
            value: _multiSelectedNames(provider.selectedCommunities, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.annualIncome),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.propertySvgIcon,
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _ageRange(ContactFilterProvider provider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const SizedBox(height: 6),
          Text('Select Age Range',
            style:  TextStyle(fontSize: TextSize.font16(context), color: AppColors.textPrimaryLight, fontWeight: FontWeight.w500)
            ),
          Text('Select a 2-year minimum age range',
            style:  TextStyle(fontSize: TextSize.font12(context), color: AppColors.textSecondaryLight, fontWeight: FontWeight.w400)
          ),
          const SizedBox(height: 20),
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
        ],
      ),
    );
  }

  Widget _countryBody(ContactFilterProvider provider) {
    return _wrapSelection(
      provider.countries,
      (index) => _runSectionAction(() => ref.read(contactFilterProvider).toggleCountry(index)),
    );
  }

  Widget _communityBody(ContactFilterProvider provider) {
    return _wrapSelection(
      provider.communities,
      (index) => _runSectionAction(() => ref.read(contactFilterProvider).toggleCommunity(index)),
    );
  }

  Widget _maritalStatusBody(ContactFilterProvider provider) {
    return _wrapSelection(
      provider.maritalStatusList,
      (index) => _runSectionAction(() => ref.read(contactFilterProvider).toggleMaritalStatus(index)),
    );
  }

  Widget _motherTongueBody(ContactFilterProvider provider) {
    return _wrapSelection(
      provider.motherTongues,
      (index) => _runSectionAction(() => ref.read(contactFilterProvider).toggleMotherTongue(index)),
    );
  }

  Widget _wrapSelection(List<dynamic> items, void Function(int index) onTap) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(items.length, (index) {
          final item = items[index];
          return SelectionCard(
            buttonStyle: item.isSelected ? SelectionStyle.selectedCheckbox : SelectionStyle.unSelectedCheckbox,
            onTap: () => onTap(index),
            isSelected: item.isSelected,
            title: item.name,
            isExpand: true,
          );
        }),
      ),
    );
  }

  void _runSectionAction(VoidCallback action) {
    action();
    if (mounted) setState(() {});
  }

  Widget bottomAction(ContactFilterProvider provider) {
    if (_step == FilterStep.contactFilterScreen) {
      return PrimaryButtons(
        buttonStyle: ButtonsStyle.activePrimaryButton,
        title: 'Show Matches',
        onTap: () {
        },
      );
    }

    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Save Changes',
      onTap: () => setState(() => _step = FilterStep.contactFilterScreen),
    );
  }

  String _singleSelectedName(List<String> items, String fallback) {
    return items.isEmpty ? fallback : items.first;
  }

  String _multiSelectedNames(List<String> items, String fallback) {
    return items.isEmpty ? fallback : items.join(', ');
  }
}

enum FilterStep {
  contactFilterScreen,
  ageRange,
  heightRange,
  maritalStatus,
  religion,
  community,
  motherTongue,
  countryLivingIn,
  workingWith,
  annualIncome,
}

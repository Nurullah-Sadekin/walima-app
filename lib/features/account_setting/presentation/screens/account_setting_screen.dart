import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/matches/domain/enums/match_education_level.dart';
import 'package:flutter_boilerplate/features/matches/domain/enums/match_filter_type.dart';
import 'package:flutter_boilerplate/features/matches/domain/enums/match_marital_status.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/my_match_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSettingScreen extends ConsumerStatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  ConsumerState<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends ConsumerState<AccountSettingScreen> {
  late MyMatchFilterProvider provider;
  FilterStep _step = FilterStep.refine;

  @override
  void initState() {
    super.initState();
    provider = ref.read(myMatchFilterProvider);
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(myMatchFilterProvider);

    return PopScope(
      canPop: _step == FilterStep.refine,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _step != FilterStep.refine) {
          setState(() => _step = FilterStep.refine);
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
        floatingActionButton:
            BottomBorderedWidget(widget: bottomAction(provider)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  String _getAppBarTitle(FilterStep step) {
    switch (step) {
      case FilterStep.refine:
        return 'Refine';
      case FilterStep.photoSetting:
        return 'Photo Setting';
      case FilterStep.recentlyJoined:
        return 'Recently Joined';
      case FilterStep.activeMembers:
        return 'Active Members';
      case FilterStep.annualIncome:
        return 'Annual Income';
      case FilterStep.maritalStatus:
        return 'Marital Status';
      case FilterStep.religion:
        return 'Religion';
      case FilterStep.motherTongue:
        return 'Mother Tongue';
      case FilterStep.countryLivingIn:
        return 'Country Living In';
      case FilterStep.stateLivingIn:
        return 'State Living In';
      case FilterStep.countryGrewUpIn:
        return 'Country Grew Up In';
      case FilterStep.educationLevel:
        return 'Education Level';
      case FilterStep.educationArea:
        return 'Education Area';
      case FilterStep.workingWith:
        return 'Working With';
      case FilterStep.professionArea:
        return 'Profession Area';
      case FilterStep.profileManagedBy:
        return 'Profile Managed By';
      case FilterStep.eatingHabits:
        return 'Eating Habits';
      case FilterStep.community:
        return 'Community';
    }
  }

  PreferredSizeWidget _appBar() {
    return CustomBackAppBar(
      title: Text(_getAppBarTitle(_step)),
      backgroundColor: Colors.transparent,
      trailingText: _step == FilterStep.refine ? 'More Matches' : null,
      isTrailing: _step == FilterStep.refine,
      trailingWidget: _step == FilterStep.refine
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ON',
                style: TextStyle(
                  fontSize: TextSize.font12(context),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      onTrailingTap: () {
        if (_step == FilterStep.refine) {
          Navigator.of(context).maybePop();
        }
      },
      onBackPressed: () {
        if (_step != FilterStep.refine) {
          setState(() => _step = FilterStep.refine);
        } else {
          Navigator.of(context).maybePop();
        }
      },
    );
  }

  Widget _body(MyMatchFilterProvider provider) {
    switch (_step) {
      case FilterStep.refine:
        return _refineBody(provider);
      case FilterStep.countryLivingIn:
        return _countryBody(provider);
      case FilterStep.community:
        return _communityBody(provider);
      case FilterStep.photoSetting:
        return _photoSettingBody(provider);
      case FilterStep.recentlyJoined:
        return _recentlyJoinedBody(provider);
      case FilterStep.activeMembers:
        return _activeMembersBody(provider);
      case FilterStep.annualIncome:
        return _annualIncomeBody(provider);
      case FilterStep.maritalStatus:
        return _maritalStatusBody(provider);
      case FilterStep.religion:
        return _religionBody(provider);
      case FilterStep.motherTongue:
        return _motherTongueBody(provider);
      case FilterStep.stateLivingIn:
        return _stateLivingInBody(provider);
      case FilterStep.countryGrewUpIn:
        return _countryGrewUpInBody(provider);
      case FilterStep.educationLevel:
        return _educationLevelBody(provider);
      case FilterStep.educationArea:
        return _educationAreaBody(provider);
      case FilterStep.workingWith:
        return _workingWithBody(provider);
      case FilterStep.professionArea:
        return _professionAreaBody(provider);
      case FilterStep.profileManagedBy:
        return _profileManagedByBody(provider);
      case FilterStep.eatingHabits:
        return _eatingHabitsBody(provider);
    }
  }

  Widget _refineBody(MyMatchFilterProvider provider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          InfoTile(
            title: 'Photo Setting',
            value: _singleSelectedName(provider.photoSettingOptions, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.photoSetting),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.albumSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Recently Joined',
            value: _singleSelectedName(provider.recentlyJoinedOptions, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.recentlyJoined),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.propertySvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Active Members',
            value: _singleSelectedName(provider.activeMembersOptions, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.activeMembers),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.radioactiveSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Annual Income',
            value: _multiSelectedNames(provider.incomeRangeList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.annualIncome),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.walletSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Marital Status',
            value: _multiSelectedNames(provider.maritalStatusList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.maritalStatus),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.weddingSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Religion',
            value: _singleSelectedName(provider.religionList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.religion),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.quranSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Mother Tongue',
            value: _multiSelectedNames(provider.motherTongues, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.motherTongue),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.languageSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Country Living In',
            value: _singleSelectedName(provider.countries, 'Bangladesh'),
            onTap: () => setState(() => _step = FilterStep.countryLivingIn),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.locationSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'State Living In',
            value: _singleSelectedName(provider.countries, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.stateLivingIn),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.mapsSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Country Grew Up In',
            value: _singleSelectedName(provider.countries, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.countryGrewUpIn),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.userLocationSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Education Level',
            value: _singleSelectedName(provider.educationLevelList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.educationLevel),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.educationSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Education Area',
            value: _singleSelectedName(provider.educationLevelList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.educationArea),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.schoolSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Working With',
            value: _multiSelectedNames(provider.yourWorkList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.workingWith),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.workSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Profession Area',
            value: _multiSelectedNames(provider.youWorkAsList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.professionArea),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.officeSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Profile Managed By',
            value: _singleSelectedName(provider.profileManagedByList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.profileManagedBy),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.userAiSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Eating Habits',
            value: _singleSelectedName(provider.eatingHabitsList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.eatingHabits),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.habitSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Community',
            value: _multiSelectedNames(provider.communities, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.community),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.groupsIcon,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _countryBody(MyMatchFilterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(provider.countries.length, (index) {
              final item = provider.countries[index];
              return SelectionCard(
                buttonStyle: item.isSelected
                    ? SelectionStyle.selectedCheckbox
                    : SelectionStyle.unSelectedCheckbox,
                onTap: () => ref.read(myMatchFilterProvider).toggleCountry(index),
                isSelected: item.isSelected,
                title: item.name,
                isExpand: true,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _photoSettingBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.photoSettingOptions,
      (i) => ref.read(myMatchFilterProvider).selectPhotoSettingOption(i),
    );
  }

  Widget _communityBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.communities,
      (i) => ref.read(myMatchFilterProvider).toggleCommunity(i),
    );
  }

  Widget _recentlyJoinedBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.recentlyJoinedOptions,
      (i) => ref.read(myMatchFilterProvider).selectRecentlyJoinedOption(i),
    );
  }

  Widget _activeMembersBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.activeMembersOptions,
      (i) => ref.read(myMatchFilterProvider).selectActiveMembersOption(i),
    );
  }

  Widget _annualIncomeBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.incomeRangeList,
      (i) => ref.read(myMatchFilterProvider).selectIncomeRange(i),
    );
  }

  Widget _maritalStatusBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.maritalStatusList,
      (i) => ref.read(myMatchFilterProvider).toggleMaritalStatus(i),
    );
  }

  Widget _religionBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.religionList,
      (i) => ref.read(myMatchFilterProvider).selectReligion(i),
    );
  }

  Widget _motherTongueBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.motherTongues,
      (i) => ref.read(myMatchFilterProvider).toggleMotherTongue(i),
    );
  }

  Widget _stateLivingInBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.countries,
      (i) => ref.read(myMatchFilterProvider).selectCountry(i),
    );
  }

  Widget _countryGrewUpInBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.countries,
      (i) => ref.read(myMatchFilterProvider).selectCountry(i),
    );
  }

  Widget _educationLevelBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.educationLevelList,
      (i) => ref.read(myMatchFilterProvider).selectEducationLevel(i),
    );
  }

  Widget _educationAreaBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.educationLevelList,
      (i) => ref.read(myMatchFilterProvider).selectEducationLevel(i),
    );
  }

  Widget _workingWithBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.yourWorkList,
      (i) => ref.read(myMatchFilterProvider).toggleYourWork(i),
    );
  }

  Widget _professionAreaBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.youWorkAsList,
      (i) => ref.read(myMatchFilterProvider).toggleYouWorkAs(i),
    );
  }

  Widget _profileManagedByBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.profileManagedByList,
      (i) => ref.read(myMatchFilterProvider).selectProfileManagedBy(i),
    );
  }

  Widget _eatingHabitsBody(MyMatchFilterProvider p) {
    return _wrapSelection(
      p.eatingHabitsList,
      (i) => ref.read(myMatchFilterProvider).selectEatingHabits(i),
    );
  }

  Widget _wrapSelection(List<dynamic> items, void Function(int) onTap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;

        return SingleChildScrollView(
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: List.generate(items.length, (index) {
              final item = items[index];
              return SelectionCard(
                buttonStyle: item.isSelected
                    ? SelectionStyle.selectedCheckbox
                    : SelectionStyle.unSelectedCheckbox,
                onTap: () => onTap(index),
                isSelected: item.isSelected,
                title: item.name,
                isExpand: true,
              );
            }),
          ),
        );
      },
    );
  }

  Widget bottomAction(MyMatchFilterProvider p) {
    final isRefine = _step == FilterStep.refine;

    if (isRefine) {
      return PrimaryButtons(
        buttonStyle: ButtonsStyle.activePrimaryButton,
        title: 'Show Matches',
        onTap: () {
          final result = {
            'countryLivingIn': p.selectedCountries,
            'community': p.selectedCommunities,
            'maritalStatus': p.selectedMaritalStatus.isEmpty
                ? null
                : MatchMaritalStatus.fromLabel(
                    p.selectedMaritalStatus.first,
                  )?.apiValue,
            'annualIncome': p.selectedIncomeRanges.isEmpty
                ? null
                : p.selectedIncomeRanges.join(','),
            'religion': p.selectedReligion.isEmpty ? null : p.selectedReligion.first,
            'motherTongue': p.selectedMotherTongues.isEmpty
                ? null
                : p.selectedMotherTongues.join(','),
            'stateLivingIn': p.selectedCountries,
            'countryGrewUpIn': p.selectedCountries.isEmpty ? null : p.selectedCountries.first,
            'qualification': p.educationLevelList
                .where((item) => item.isSelected)
                .map((item) => MatchEducationLevel.fromLabel(item.name)?.apiValue)
                .whereType<String>()
                .toList(),
            'workingWith': p.selectedYourWork.isEmpty ? null : p.selectedYourWork.join(','),
            'professionArea': p.selectedYouWorkAs.isEmpty ? null : p.selectedYouWorkAs.join(','),
            'eatingHabits': p.selectedEatingHabits.isEmpty ? null : p.selectedEatingHabits.first,
            'photoVisibility': _singleSelectedName(p.photoSettingOptions, ''),
            'recentlyJoined': _singleSelectedName(p.recentlyJoinedOptions, ''),
            'activeMembers': _singleSelectedName(p.activeMembersOptions, ''),
            'matchFilterType': MatchFilterType.openToAll.apiValue,
          };
          Navigator.pop(context, result);
        },
      );
    }

    return Row(
      children: [
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.cancelButton,
            title: 'Cancel',
            onTap: () {
              setState(() => _step = FilterStep.refine);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.activePrimaryButton,
            title: 'Apply',
            onTap: () {
              setState(() => _step = FilterStep.refine);
            },
          ),
        ),
      ],
    );
  }

  String _singleSelectedName(List<dynamic> list, String fallback) {
    try {
      final sel = list.firstWhere((e) => e.isSelected, orElse: () => null);
      return sel != null ? sel.name as String : fallback;
    } catch (_) {
      return fallback;
    }
  }

  String _multiSelectedNames(List<dynamic> list, String fallback) {
    try {
      final sel =
          list.where((e) => e.isSelected).map((e) => e.name as String).toList();
      return sel.isEmpty ? fallback : sel.join(', ');
    } catch (_) {
      return fallback;
    }
  }
}

enum FilterStep {
  refine,
  photoSetting,
  recentlyJoined,
  activeMembers,
  annualIncome,
  maritalStatus,
  religion,
  motherTongue,
  countryLivingIn,
  stateLivingIn,
  countryGrewUpIn,
  educationLevel,
  educationArea,
  workingWith,
  professionArea,
  profileManagedBy,
  eatingHabits,
  community
}

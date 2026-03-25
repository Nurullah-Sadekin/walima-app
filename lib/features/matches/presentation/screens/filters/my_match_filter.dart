import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/my_match_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';

class MyMatchFilterScreen extends ConsumerStatefulWidget {
  const MyMatchFilterScreen({super.key});
  @override
  ConsumerState<MyMatchFilterScreen> createState() => _MyMatchFilterScreenState();
}

class _MyMatchFilterScreenState extends ConsumerState<MyMatchFilterScreen> {
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

    return WillPopScope(
      onWillPop: () async {
        if (_step != FilterStep.refine) {
          setState(() => _step = FilterStep.refine);
          return false;
        }
        return true;
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
      onBackPressed: () {
        if (_step != FilterStep.refine) {
          setState(() => _step = FilterStep.refine);
        } else {
          Navigator.of(context).maybePop();
        }
      },
    );
  }

  Widget _body(MyMatchFilterProvider p) {
    switch (_step) {
      case FilterStep.refine:
        return _refineBody(p);
      case FilterStep.countryLivingIn:
        return _countryBody(p);
      case FilterStep.community:
        return _communityBody(p);

      case FilterStep.photoSetting:
        return _photoSettingBody(p);
      case FilterStep.recentlyJoined:
        return _recentlyJoinedBody(p);
      case FilterStep.activeMembers:
        return _activeMembersBody(p);

      case FilterStep.annualIncome:
        return _annualIncomeBody(p);
      case FilterStep.maritalStatus:
        return _maritalStatusBody(p);
      case FilterStep.religion:
        return _religionBody(p);
      case FilterStep.motherTongue:
        return _motherTongueBody(p);

      case FilterStep.stateLivingIn:
        return _stateLivingInBody(p);
      case FilterStep.countryGrewUpIn:
        return _countryGrewUpInBody(p);

      case FilterStep.educationLevel:
        return _educationLevelBody(p);
      case FilterStep.educationArea:
        return _educationAreaBody(p);

      case FilterStep.workingWith:
        return _workingWithBody(p);
      case FilterStep.professionArea:
        return _professionAreaBody(p);
      case FilterStep.profileManagedBy:
        return _profileManagedByBody(p);
      case FilterStep.eatingHabits:
        return _eatingHabitsBody(p);
    }
    // All enum cases are handled above; return a fallback
    return const SizedBox.shrink();
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
            leadingImagePath: AppImages.cameraSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Recently Joined',
            value: _singleSelectedName(provider.recentlyJoinedOptions, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.recentlyJoined),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.calendarSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Active Members',
            value: _singleSelectedName(provider.activeMembersOptions, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.activeMembers),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.matchSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Annual Income',
            value: _multiSelectedNames(provider.incomeRangeList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.annualIncome),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.contactSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Marital Status',
            value: _multiSelectedNames(provider.maritalStatusList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.maritalStatus),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.groupsIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Religion',
            value: _singleSelectedName(provider.religionList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.religion),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.religionSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Mother Tongue',
            value: _multiSelectedNames(provider.motherTongues, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.motherTongue),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.profileSvgIcon,
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
            leadingImagePath: AppImages.locationSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Country Grew Up In',
            value: _singleSelectedName(provider.countries, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.countryGrewUpIn),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.locationSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Education Level',
            value: _singleSelectedName(provider.educationLevelList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.educationLevel),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.editUserSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Education Area',
            value: _singleSelectedName(provider.educationLevelList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.educationArea),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.editUserSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Working With',
            value: _multiSelectedNames(provider.yourWorkList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.workingWith),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.editUserSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Profession Area',
            value: _multiSelectedNames(provider.youWorkAsList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.professionArea),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.editUserSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Profile Managed By',
            value: _singleSelectedName(provider.profileManagedByList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.profileManagedBy),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.profileSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Eating Habits',
            value: _singleSelectedName(provider.eatingHabitsList, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.eatingHabits),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.photoIcon,
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
                buttonStyle: item.isSelected ? SelectionStyle.selectedCheckbox : SelectionStyle.unSelectedCheckbox,
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

  Widget _photoSettingBody(MyMatchFilterProvider newFilter) {
    return _wrapSelection(newFilter.photoSettingOptions, (i) => ref.read(myMatchFilterProvider).selectPhotoSettingOption(i));
  }

  Widget _communityBody(MyMatchFilterProvider newFilter) {
    return _wrapSelection(newFilter.communities, (i) => ref.read(myMatchFilterProvider).toggleCommunity(i));
  }

  Widget _recentlyJoinedBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.recentlyJoinedOptions, (i) => ref.read(myMatchFilterProvider).selectRecentlyJoinedOption(i));
  }

  Widget _activeMembersBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.activeMembersOptions, (i) => ref.read(myMatchFilterProvider).selectActiveMembersOption(i));
  }

  Widget _annualIncomeBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.incomeRangeList, (i) => ref.read(myMatchFilterProvider).selectIncomeRange(i));
  }

  Widget _maritalStatusBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.maritalStatusList, (i) => ref.read(myMatchFilterProvider).toggleMaritalStatus(i));
  }

  Widget _religionBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.religionList, (i) => ref.read(myMatchFilterProvider).selectReligion(i));
  }

  Widget _motherTongueBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.motherTongues, (i) => ref.read(myMatchFilterProvider).toggleMotherTongue(i));
  }

  Widget _stateLivingInBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.countries, (i) => ref.read(myMatchFilterProvider).selectCountry(i));
  }

  Widget _countryGrewUpInBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.countries, (i) => ref.read(myMatchFilterProvider).selectCountry(i));
  }

  Widget _educationLevelBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.educationLevelList, (i) => ref.read(myMatchFilterProvider).selectEducationLevel(i));
  }

  Widget _educationAreaBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.educationLevelList, (i) => ref.read(myMatchFilterProvider).selectEducationLevel(i));
  }

  Widget _workingWithBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.yourWorkList, (i) => ref.read(myMatchFilterProvider).toggleYourWork(i));
  }

  Widget _professionAreaBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.youWorkAsList, (i) => ref.read(myMatchFilterProvider).toggleYouWorkAs(i));
  }

  Widget _profileManagedByBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.profileManagedByList, (i) => ref.read(myMatchFilterProvider).selectProfileManagedBy(i));
  }

  Widget _eatingHabitsBody(MyMatchFilterProvider p) {
    return _wrapSelection(p.eatingHabitsList, (i) => ref.read(myMatchFilterProvider).selectEatingHabits(i));
  }

  Widget _wrapSelection(List<dynamic> items, void Function(int) onTap) {
    return LayoutBuilder(builder: (context, constraints) {
      const spacing = 10.0;
      final maxWidth = constraints.maxWidth;
      final itemWidth = (maxWidth - spacing) / 2;

      return SingleChildScrollView(
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(items.length, (index) {
            final item = items[index];
            return SizedBox(
              width: itemWidth,
              child: SelectionCard(
                buttonStyle: item.isSelected ? SelectionStyle.selectedCheckbox : SelectionStyle.unSelectedCheckbox,
                onTap: () => onTap(index),
                isSelected: item.isSelected,
                title: item.name,
                isExpand: true,
              ),
            );
          }),
        ),
      );
    });
  }

  Widget bottomAction(MyMatchFilterProvider newFilter) {
    final isRefine = _step == FilterStep.refine;

    if (isRefine) {
      return PrimaryButtons(
        buttonStyle: ButtonsStyle.activePrimaryButton,
        title: 'Show Matches',
        onTap: () {
          final result = {
            'countries': newFilter.selectedCountries,
            'communities': newFilter.selectedCommunities,
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
      final sel = list.where((e) => e.isSelected).map((e) => e.name as String).toList();
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

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
  ConsumerState<MyMatchFilterScreen> createState() =>
      _MyMatchFilterScreenState();
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
        floatingActionButton: BottomBorderedWidget(
          widget: bottomAction(provider),
        ),
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
      case FilterStep.countryLivingIn:
        return 'Country Living In';
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

  Widget _body(MyMatchFilterProvider provider) {
    switch (_step) {
      case FilterStep.countryLivingIn:
        return _countryBody(provider);
      case FilterStep.community:
        return _communityBody(provider);
      case FilterStep.refine:
        return _refineBody(provider);
      case FilterStep.photoSetting:
        return _photoSettingBody(provider);
      case FilterStep.recentlyJoined:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.activeMembers:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.annualIncome:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.maritalStatus:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.religion:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.motherTongue:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.stateLivingIn:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.countryGrewUpIn:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.educationLevel:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.educationArea:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.workingWith:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.professionArea:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.profileManagedBy:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FilterStep.eatingHabits:
        // TODO: Handle this case.
        throw UnimplementedError();
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
            value: provider.photoSettingOpenToAll ? 'Open to All' : 'Custom',
            onTap: () => setState(() => _step = FilterStep.photoSetting),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.cameraSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Recently Joined',
            value: provider.recentlyJoinedOpenToAll ? 'Open to All' : 'Custom',
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.calendarSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Active Members',
            value: provider.activeMembersOpenToAll ? 'Open to All' : 'Custom',
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.matchSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Annual Income',
            value: provider.annualIncome,
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.contactSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Marital Status',
            value: provider.maritalStatus.isEmpty
                ? 'Open to All'
                : provider.maritalStatus.join(', '),
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.groupsIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Religion',
            value: provider.religion,
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.religionSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Mother Tongue',
            value: provider.motherTongueSelected.isEmpty
                ? 'Multiple Selected'
                : provider.motherTongueSelected.join(', '),
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.profileSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Country Living In',
            value: provider.countryLivingIn,
            onTap: () => setState(() => _step = FilterStep.countryLivingIn),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.locationSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'State Living In',
            value: provider.stateLivingIn,
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.locationSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Country Grew Up In',
            value: provider.countryGrewUpIn,
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.locationSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Education Level',
            value: provider.educationLevel,
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.editUserSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Education Area',
            value: provider.educationArea,
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.editUserSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Working With',
            value: provider.workingWith,
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.editUserSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Profession Area',
            value: provider.professionArea,
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.editUserSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Profile Managed By',
            value: provider.profileManagedBy,
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.profileSvgIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Eating Habits',
            value: provider.eatingHabits,
            onTap: () {},
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.photoIcon,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Community',
            value: provider.selectedCommunities.isEmpty
                ? 'Multiple Selected'
                : provider.selectedCommunities.join(', '),
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
                onTap: () =>
                    ref.read(myMatchFilterProvider).toggleCountry(index),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectionCard(
          buttonStyle: newFilter.photoSettingOpenToAll
              ? SelectionStyle.selectedCheckbox
              : SelectionStyle.unSelectedCheckbox,
          onTap: () => ref.read(myMatchFilterProvider).photoSettingOpenToAll =
              !newFilter.photoSettingOpenToAll,
          isSelected: newFilter.photoSettingOpenToAll,
          title: 'Open to All',
          isExpand: true,
        ),
        const SizedBox(height: 10),
        SelectionCard(
          buttonStyle: !newFilter.photoSettingOpenToAll
              ? SelectionStyle.selectedCheckbox
              : SelectionStyle.unSelectedCheckbox,
          onTap: () => ref.read(myMatchFilterProvider).photoSettingOpenToAll =
              !newFilter.photoSettingOpenToAll,
          isSelected: !newFilter.photoSettingOpenToAll,
          title: 'Custom',
          isExpand: true,
        ),
      ],
    );
  }

  Widget _communityBody(MyMatchFilterProvider newFilter) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final maxWidth = constraints.maxWidth;
        final twoColumnItemWidth = (maxWidth - spacing) / 2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children:
                      List.generate(newFilter.communities.length, (index) {
                    final item = newFilter.communities[index];

                    if (index == 0) {
                      return SizedBox(
                        width: maxWidth,
                        child: SelectionCard(
                          buttonStyle: item.isSelected
                              ? SelectionStyle.selectedCheckbox
                              : SelectionStyle.unSelectedCheckbox,
                          onTap: () => ref
                              .read(myMatchFilterProvider)
                              .toggleCommunity(index),
                          isSelected: item.isSelected,
                          title: item.name,
                          isExpand: true,
                        ),
                      );
                    }

                    return SizedBox(
                      width: twoColumnItemWidth,
                      child: SelectionCard(
                        buttonStyle: item.isSelected
                            ? SelectionStyle.selectedCheckbox
                            : SelectionStyle.unSelectedCheckbox,
                        onTap: () => ref
                            .read(myMatchFilterProvider)
                            .toggleCommunity(index),
                        isSelected: item.isSelected,
                        title: item.name,
                        isExpand: true,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );
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

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/my_match_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart' as providers;
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
    provider = ref.read(providers.myMatchFilterProvider);
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(providers.myMatchFilterProvider);

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
        floatingActionButton: BottomBorderedWidget(widget: bottomAction(provider),),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  String _getAppBarTitle(FilterStep step) {
    switch (step) {
      case FilterStep.countryLivingIn:
        return 'Country Living In';
      case FilterStep.community:
        return 'Community';
      case FilterStep.refine:
        return 'Refine';
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

  Widget _body(MyMatchFilterProvider newFilter) {
    switch (_step) {
      case FilterStep.countryLivingIn:
        return _countryBody(newFilter);
      case FilterStep.community:
        return _communityBody(newFilter);
      case FilterStep.refine:
        return _refineBody(newFilter);
    }
  }

  Widget _refineBody(MyMatchFilterProvider p) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            InfoTile(
              title: 'Photo Setting',
              value: p.photoSettingOpenToAll ? 'Open to All' : 'Custom',
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.cameraSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Recently Joined',
              value: p.recentlyJoinedOpenToAll ? 'Open to All' : 'Custom',
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.calendarSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Active Members',
              value: p.activeMembersOpenToAll ? 'Open to All' : 'Custom',
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.matchSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Annual Income',
              value: p.annualIncome,
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.contactSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Marital Status',
              value: p.maritalStatus.isEmpty ? 'Open to All' : p.maritalStatus.join(', '),
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.groupsIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Religion',
              value: p.religion,
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.religionSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Mother Tongue',
              value: p.motherTongueSelected.isEmpty ? 'Multiple Selected' : p.motherTongueSelected.join(', '),
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.profileSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Country Living In',
              value: p.countryLivingIn,
              onTap: () => setState(() => _step = FilterStep.countryLivingIn),
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.locationSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'State Living In',
              value: p.stateLivingIn,
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.locationSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Country Grew Up In',
              value: p.countryGrewUpIn,
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.locationSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Education Level',
              value: p.educationLevel,
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.editUserSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Education Area',
              value: p.educationArea,
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.editUserSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Working With',
              value: p.workingWith,
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.editUserSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Profession Area',
              value: p.professionArea,
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.editUserSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Profile Managed By',
              value: p.profileManagedBy,
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.profileSvgIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Eating Habits',
              value: p.eatingHabits,
              onTap: () {},
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.photoIcon,
            ),
            const SizedBox(height: 8),
            InfoTile(
              title: 'Community',
              value: p.selectedCommunities.isEmpty ? 'Multiple Selected' : p.selectedCommunities.join(', '),
              onTap: () => setState(() => _step = FilterStep.community),
              trailingImagePath: AppImages.editWrite,
              leadingImagePath: AppImages.groupsIcon,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _countryBody(MyMatchFilterProvider newFilter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(newFilter.countries.length, (index) {
                final item = newFilter.countries[index];
                return SelectionCard(
                  buttonStyle: item.isSelected ? SelectionStyle.selectedCheckbox : SelectionStyle.unSelectedCheckbox,
                  onTap: () => ref.read(providers.myMatchFilterProvider).toggleCountry(index),
                  isSelected: item.isSelected,
                  title: item.name,
                  isExpand: true,
                );
              }),
            ),
          ),
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
                  children: List.generate(newFilter.communities.length, (index) {
                    final item = newFilter.communities[index];

                    if (index == 0) {
                      return SizedBox(
                        width: maxWidth,
                        child: SelectionCard(
                          buttonStyle: item.isSelected ? SelectionStyle.selectedCheckbox : SelectionStyle.unSelectedCheckbox,
                          onTap: () => ref.read(providers.myMatchFilterProvider).toggleCommunity(index),
                          isSelected: item.isSelected,
                          title: item.name,
                          isExpand: true,
                        ),
                      );
                    }

                    return SizedBox(
                      width: twoColumnItemWidth,
                      child: SelectionCard(
                        buttonStyle: item.isSelected ? SelectionStyle.selectedCheckbox : SelectionStyle.unSelectedCheckbox,
                        onTap: () => ref.read(providers.myMatchFilterProvider).toggleCommunity(index),
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
  countryLivingIn,
  community
}

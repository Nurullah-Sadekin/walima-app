import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/new_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';

class NewFilterScreen extends ConsumerStatefulWidget {
  const NewFilterScreen({super.key});
  @override
  ConsumerState<NewFilterScreen> createState() => _NewFilterScreenState();
}

class _NewFilterScreenState extends ConsumerState<NewFilterScreen> {
  late NewFilterProvider provider;
  FilterStep _step = FilterStep.refine;

  @override
  void initState() {
    super.initState();
    provider = ref.read(newFilterProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(newFilterProvider);
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

  Widget _body(NewFilterProvider newFilter) {
    switch (_step) {
      case FilterStep.countryLivingIn:
        return _countryBody(newFilter);
      case FilterStep.community:
        return _communityBody(newFilter);
      case FilterStep.refine:
        return _refineBody(newFilter);
    }
  }

  Widget _refineBody(NewFilterProvider newFilter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        InfoTile(
          title: 'Country Living In',
          value: newFilter.selectedCountries.isEmpty ? 'Not selected' : newFilter.selectedCountries.join(', '),
          onTap: () => setState(() => _step = FilterStep.countryLivingIn),
          trailingImagePath: AppImages.editWrite,
          leadingImagePath: AppImages.locationSvgIcon,
        ),
        const SizedBox(height: 8),
        InfoTile(
          title: 'Community',
          value: newFilter.selectedCommunities.isEmpty ? 'Not selected' : newFilter.selectedCommunities.join(', '),
          onTap: () => setState(() => _step = FilterStep.community),
          trailingImagePath: AppImages.editWrite,
          leadingImagePath: AppImages.profileSvgIcon,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _countryBody(NewFilterProvider newFilter) {
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
                  onTap: () => ref.read(newFilterProvider).toggleCountry(index),
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

  Widget _communityBody(NewFilterProvider newFilter) {
    // First item full width, then two items per row for the rest.
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final maxWidth = constraints.maxWidth;

        // For two columns after the first item.
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

                    // First item: full width
                    if (index == 0) {
                      return SizedBox(
                        width: maxWidth,
                        child: SelectionCard(
                          buttonStyle: item.isSelected ? SelectionStyle.selectedCheckbox : SelectionStyle.unSelectedCheckbox,
                          onTap: () => ref.read(newFilterProvider).toggleCommunity(index),
                          isSelected: item.isSelected,
                          title: item.name,
                          isExpand: true,
                        ),
                      );
                    }

                    // Other items: two per row
                    return SizedBox(
                      width: twoColumnItemWidth,
                      child: SelectionCard(
                        buttonStyle: item.isSelected ? SelectionStyle.selectedCheckbox : SelectionStyle.unSelectedCheckbox,
                        onTap: () => ref.read(newFilterProvider).toggleCommunity(index),
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

  Widget bottomAction(NewFilterProvider newFilter) {
    final isRefine = _step == FilterStep.refine;
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: isRefine ? 'Show Matches' : 'Apply',
      onTap: () {
        if (isRefine) {
          final result = {
            'countries': newFilter.selectedCountries,
            'communities': newFilter.selectedCommunities,
          };
          Navigator.pop(context, result);
          return;
        }
        setState(() => _step = FilterStep.refine);
      },
    );
  }

}

enum FilterStep {
  refine,
  countryLivingIn,
  community
}

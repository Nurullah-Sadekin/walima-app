import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/search_filter_provider.dart';
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

enum FilterStep { refine, countryLivingIn, community }

class _NewFilterScreenState extends ConsumerState<NewFilterScreen> {
  late SearchFilterProvider provider;
  FilterStep _step = FilterStep.refine;

  @override
  void initState() {
    super.initState();
    provider = ref.read(searchFilterProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(searchFilterProvider);
    final newFilter = ref.watch(newFilterProvider);

    // Dynamic title based on step
    String appBarTitle;
    switch (_step) {
      case FilterStep.countryLivingIn:
        appBarTitle = 'Country Living In';
        break;
      case FilterStep.community:
        appBarTitle = 'Community';
        break;
      case FilterStep.refine:
        appBarTitle = 'Refine';
        break;
    }

    // Intercept system back to go back to refine step first
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
        appBar: CustomBackAppBar(
          title: Text(appBarTitle),
          backgroundColor: Colors.transparent,
          onBackPressed: () {
            if (_step != FilterStep.refine) {
              setState(() => _step = FilterStep.refine);
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Expanded(child: _body(newFilter)),
              ],
            ),
          ),
        ),
        floatingActionButton: BottomBorderedWidget(
          widget: bottomAction(newFilter),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(newFilter.communities.length, (index) {
                final item = newFilter.communities[index];
                return SelectionCard(
                  buttonStyle: item.isSelected ? SelectionStyle.selectedCheckbox : SelectionStyle.unSelectedCheckbox,
                  onTap: () => ref.read(newFilterProvider).toggleCommunity(index),
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

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/search_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';

class NewFilterScreen extends ConsumerStatefulWidget {
  const NewFilterScreen({super.key});
  @override
  ConsumerState<NewFilterScreen> createState() => _NewFilterScreenState();
}

class _NewFilterScreenState extends ConsumerState<NewFilterScreen> {
  late SearchFilterProvider provider;
  FilterStep _step = FilterStep.refine;

  // local selections (kept simple and safe so we don't depend on provider API)
  String? _selectedCountry;
  String? _selectedCommunity;

  // sample lists - replace with provider data if available
  final List<String> _countries = [
    'Bangladesh',
    'India',
    'Pakistan',
    'United Kingdom',
    'United States'
  ];

  final List<String> _communities = [
    'Community A',
    'Community B',
    'Community C',
    'Community D'
  ];

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
          // If CustomBackAppBar supports onBack, use it; otherwise it will pop.
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
                Expanded(child: _body()),
              ],
            ),
          ),
        ),
        floatingActionButton: BottomBorderedWidget(
          widget: bottomAction(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _body() {
    switch (_step) {
      case FilterStep.countryLivingIn:
        return _countryBody();
      case FilterStep.community:
        return _communityBody();
      case FilterStep.refine:
        return _refineBody();
    }
  }

  Widget _refineBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Column(
          spacing: 10,
          children: [
            // We will build the tiles with tappable behavior below (can't use const for that)
          ],
        ),
        // Build the interactive tiles (not const)
        InfoTile(
          title: 'Country Living In',
          value: _selectedCountry ?? 'Not selected',
          onTap: () => setState(() => _step = FilterStep.countryLivingIn),
          trailingImagePath: AppImages.editWrite,
          leadingImagePath: AppImages.locationSvgIcon,
        ),
        const SizedBox(height: 8),
        InfoTile(
          title: 'Community',
          value: _selectedCommunity ?? 'Not selected',
          onTap: () => setState(() => _step = FilterStep.community),
          trailingImagePath: AppImages.editWrite,
          leadingImagePath: AppImages.profileSvgIcon,
        ),
        const SizedBox(height: 12),
        // You can add more overview tiles here if required
      ],
    );
  }

  Widget _countryBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(
          'Country Living In',
          style: TextStyle(fontSize: TextSize.font16(context), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          hint: 'Select country',
          value: _selectedCountry,
          items: _countries,
          onChanged: (v) => setState(() => _selectedCountry = v),
        ),
        const SizedBox(height: 12),
        // show a quick list as alternative selection
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: _countries.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final country = _countries[index];
              final selected = country == _selectedCountry;
              return ListTile(
                title: Text(country),
                trailing: selected ? Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () => setState(() => _selectedCountry = country),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _communityBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(
          'Community',
          style: TextStyle(fontSize: TextSize.font16(context), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          hint: 'Select community',
          value: _selectedCommunity,
          items: _communities,
          onChanged: (v) => setState(() => _selectedCommunity = v),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: _communities.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final community = _communities[index];
              final selected = community == _selectedCommunity;
              return ListTile(
                title: Text(community),
                trailing: selected ? Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () => setState(() => _selectedCommunity = community),
              );
            },
          ),
        ),
      ],
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

    final isRefine = _step == FilterStep.refine;
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: isRefine ? 'Show Matches' : 'Apply',
      onTap: () {
        // If we are in refine, return the selected filters and pop to caller.
        if (isRefine) {
          final result = {
            'country': _selectedCountry,
            'community': _selectedCommunity,
          };
          Navigator.pop(context, result);
          return;
        }

        // If we are in a sub-step (Apply), save selection and go back to refine view.
        setState(() => _step = FilterStep.refine);
      },
    );
  }

  // Local dropdown helper to avoid depending on missing app widget
  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.greyLight)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.greyLight)),
        filled: true,
        fillColor: AppColors.white,
      ),
      items: items.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}

enum FilterStep {
  refine,
  countryLivingIn,
  community
}


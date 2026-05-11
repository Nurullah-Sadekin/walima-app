import 'package:flutter/material.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:go_router/go_router.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});
  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  late RecommendedPreferencesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(recommendedPreferencesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.initControllersListener();
    });
  }

  @override
  void dispose() {
    provider.disposeControllersListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(recommendedPreferencesProvider);
    return TransparentLoading(
      isLoading: provider.loaderState == RecommendedPreferencesScreenStates.preferences,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates == RecommendedPreferencesScreenStates.preferences
              ? const Loading()
              : Column(
            children: [
              const UpperLayer(
                  imagePath: AppImages.recommendedPreferences,
                  isShowAppbar: true,
                  isBackButton: true,
              ),
              body(),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          spacing: 10,
          children: [
            dropdownSelection(),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget dropdownSelection() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropDownField(
          headLine: 'Partner Religion',
          hintText: 'Select',
          popUpHeader: 'Select Religion',
          items: provider.religionDropdownItems,
          controller: provider.religionPreferenceController,
          onTap: provider.loadReligionData,
          onConfirm: (value) =>
              provider.onReligionPreferenceSelected(value?.toString()),
          isSearch: true,
        ),
        provider.religionPreferenceController.text.isEmpty
            ? const SizedBox.shrink()
            : DropDownField(
          headLine: 'Partner Community',
          hintText: 'Select',
          popUpHeader: 'Select Community',
          isRequired: true,
          items: provider.communityDropdownItems,
          controller: provider.communityPreferenceController,
          onTap: () {},
          onConfirm: (value) =>
              provider.onCommunityPreferenceSelected(value?.toString()),
          isSearch: true,
        ),
        provider.religionPreferenceController.text.isEmpty || provider.communityPreferenceController.text.isEmpty
            ? const SizedBox.shrink()
            : DropDownField(
          headLine: 'Partner Mother Tongue',
          hintText: 'Select',
          popUpHeader: 'Select Mother Tongue',
          items: const ['Bangla', 'English', 'Dutch', 'Hindi'],
          controller: provider.motherTonguePreferenceController,
          onTap: () {},
          isSearch: true,
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.religionPreferenceController.text.isNotEmpty &&
          provider.communityPreferenceController.text.isNotEmpty &&
          provider.motherTonguePreferenceController.text.isNotEmpty
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () {
        if (provider.religionPreferenceController.text.isEmpty ||
            provider.communityPreferenceController.text.isEmpty ||
            provider.motherTonguePreferenceController.text.isEmpty) {
          return;
        }
        context.push(Paths.preferenceLocation);
      },
    );
  }
}

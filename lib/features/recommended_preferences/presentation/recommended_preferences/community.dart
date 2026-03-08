import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart' as regp;
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/upper_layer.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart' as rn;

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
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.customBackgroundGradient,
          ),
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
          headLine: 'Your Religion',
          hintText: 'Select',
          popUpHeader: 'Select Religion',
          items: const ['Islam', 'Hinduism', 'Buddhism', 'Christianity'],
          controller: provider.religionPreferenceController,
          onTap: () {
          },
          isSearch: true,
        ),
        provider.religionPreferenceController.text.isEmpty
            ? const SizedBox.shrink()
            : DropDownField(
          headLine: 'Community',
          hintText: 'Select',
          popUpHeader: 'Select Community',
          headLineInfoIcon: true,
          items: const ['Islam', 'Hinduism', 'Buddhism', 'Christianity'],
          controller: provider.communityPreferenceController,
          onTap: () {
          },
          isSearch: true,
        ),
        provider.religionPreferenceController.text.isEmpty || provider.communityPreferenceController.text.isEmpty
            ? const SizedBox.shrink()
            : DropDownField(
          headLine: 'Mother Tongue',
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

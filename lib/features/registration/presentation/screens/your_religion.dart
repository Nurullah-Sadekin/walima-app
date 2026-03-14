import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:go_router/go_router.dart';

class YourReligion extends ConsumerStatefulWidget {
  const YourReligion({super.key});
  @override
  ConsumerState<YourReligion> createState() => _YourRegionState();
}

class _YourRegionState extends ConsumerState<YourReligion> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.initControllersListener();
      provider.loadReligionData();
      provider.loadLocationData();
    });
  }

  @override
  void dispose() {
    provider.disposeControllersListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(registrationProvider);
    final screenProvider = ref.watch(yourReligionScreenProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor ||
              provider.isReligionDataLoading ||
              provider.isLocationDataLoading,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.religion),
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
            dataInsertField(),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget dataInsertField() {
    return Column(
      spacing: 20,
      children: [
        DropDownField(
          headLine: 'Your Religion',
          hintText: 'Select',
          popUpHeader: 'Select Religion',
          items: provider.religionDropdownItems,
          controller: provider.religionController,
          onTap: provider.loadReligionData,
          onConfirm: (value) => provider.onReligionSelected(value?.toString()),
          isSearch: true,
        ),
        provider.religionController.text.isEmpty
            ? const SizedBox.shrink()
            : DropDownField(
                headLine: 'Community',
                hintText: 'Select',
                popUpHeader: 'Select Community',
                headLineInfoIcon: true,
                items: provider.communityDropdownItems,
                controller: provider.communityController,
                onTap: () {},
                onConfirm: (value) =>
                    provider.onCommunitySelected(value?.toString()),
                isSearch: true,
              ),
        provider.religionController.text.isEmpty ||
                provider.communityController.text.isEmpty
            ? const SizedBox.shrink()
            : DropDownField(
                headLine: 'Living In',
                hintText: 'Select',
                popUpHeader: 'Select Living In',
                items: provider.countryDropdownItems,
                controller: provider.livingInController,
                onTap: provider.loadLocationData,
                onConfirm: (value) =>
                    provider.onLivingInSelected(value?.toString()),
                isSearch: true,
              ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.religionController.text.isNotEmpty &&
              provider.communityController.text.isNotEmpty &&
              provider.livingInController.text.isNotEmpty
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () {
        if (provider.religionController.text.isEmpty ||
            provider.communityController.text.isEmpty ||
            provider.livingInController.text.isEmpty) {
          return;
        }
        provider.setSelectedCountryCode(context);
      },
    );
  }
}

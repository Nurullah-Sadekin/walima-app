import 'package:flutter/material.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class FamilyDetailsScreen extends ConsumerStatefulWidget {
  const FamilyDetailsScreen({super.key});
  @override
  ConsumerState<FamilyDetailsScreen> createState() =>
      _FamilyDetailsScreenState();
}

class _FamilyDetailsScreenState extends ConsumerState<FamilyDetailsScreen> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);
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
    provider = ref.watch(registrationProvider);
    final screenProvider = ref.watch(registrationScreenStateProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    UpperLayer(
                      imagePath: AppImages.familyDetails,
                      trailingText: 'Skip',
                      isTrailing: true,
                      onTrailingTap: () {
                        context.push(Paths.financialStatus);
                      },
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          spacing: 10,
          children: [
            const StaticTextWidget(
                title: 'Family Details',
                subtitle: 'This is optional - you can add later',
                isOptional: true),
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
          headLine: 'Family Type',
          hintText: 'Select',
          popUpHeader: 'Select Family Type',
          items: const ['Joint Family', 'Nuclear Family', 'Other'],
          controller: provider.familyTypeController,
          isSearch: false,
        ),
        // Income Range Dropdown
        DropDownField(
          headLine: 'Mother\'s Details',
          hintText: 'Select',
          popUpHeader: 'Mother\'s Details',
          items: provider.motherDetailsItemList,
          controller: provider.motherDetailsController,
          isSearch: false,
        ),

        DropDownField(
          headLine: 'Father\'s Details',
          hintText: 'Select',
          popUpHeader: 'Father\'s Details',
          items: provider.fatherDetailsItemList,
          controller: provider.fatherDetailsController,
          isSearch: false,
        ),

        Row(
          spacing: 10,
          children: [
            Expanded(
              child: DropDownField(
                headLine: 'No. of Sisters',
                hintText: 'Select',
                popUpHeader: 'Select No. of Sisters',
                items: provider.siblingCountList,
                controller: provider.noOfSisterController,
                isSearch: false,
              ),
            ),
            Expanded(
              child: DropDownField(
                headLine: 'No. of Brothers',
                hintText: 'Select',
                popUpHeader: 'Select No. of Brothers',
                items: provider.siblingCountList,
                controller: provider.noOfBrotherController,
                isSearch: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget bottomAction() {
    final hasAnyValue = provider.motherDetailsController.text.isNotEmpty ||
        provider.fatherDetailsController.text.isNotEmpty ||
        provider.noOfSisterController.text.isNotEmpty ||
        provider.noOfBrotherController.text.isNotEmpty ||
        provider.familyTypeController.text.isNotEmpty;

    return PrimaryButtons(
      buttonStyle: provider.motherDetailsController.text.isNotEmpty ||
              provider.fatherDetailsController.text.isNotEmpty ||
              provider.noOfSisterController.text.isNotEmpty ||
              provider.noOfBrotherController.text.isNotEmpty ||
              provider.familyTypeController.text.isNotEmpty
          ? ButtonsStyle.iconicDynamicButton
          : ButtonsStyle.disableButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: () async {
        if (!hasAnyValue) return;
        final screenProvider = ref.read(registrationScreenStateProvider);
        screenProvider.updateViewState(
            loadingState: RegistrationScreenStates.isProfileFor);
        final updated = await provider.updateFamilyDetails(context);
        screenProvider.updateViewState(
            screenStates: RegistrationScreenStates.loadingComplete);
        if (updated && mounted) {
          context.push(Paths.financialStatus);
        }
        // proceed
      },
    );
  }
}

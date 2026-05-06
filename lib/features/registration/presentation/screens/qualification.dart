import 'package:flutter/material.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';

class QualificationScreen extends ConsumerStatefulWidget {
  const QualificationScreen({super.key});
  @override
  ConsumerState<QualificationScreen> createState() =>
      _QualificationScreenState();
}

class _QualificationScreenState extends ConsumerState<QualificationScreen> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.initControllersListener();
      provider.loadEducationLookupData();
      
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
    final screenProvider = ref.watch(qualificationScreenProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor ||
              provider.isLookupDataLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.qualification),
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
          controller: provider.highestQualification,
          headLine: 'Highest Qualification',
          hintText: 'Select',
          popUpHeader: 'Select Highest Qualification',
          items: provider.educationLevelDropdownItems,
          onTap: provider.loadEducationLookupData,
          onConfirm: (value) {
            if (value == null) return;
            provider.highestQualification.text = value.toString();
          },
          isSearch: true,
        ),
        PrimaryTextField(
          controller: provider.instituteController,
          headLine: 'Institute Name',
          hintText: 'Write here',
          errorText: null,
          noPrefix: true,
          onTap: () {},
        ),
        PrimaryTextField(
          controller: provider.anotherInstituteController,
          headLine: 'Another Institute Name',
          hintText: 'Write here',
          errorText: null,
          noPrefix: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.highestQualification.text.isNotEmpty &&
              provider.instituteController.text.isNotEmpty
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () {
        if (provider.highestQualification.text.isEmpty ||
            provider.instituteController.text.isEmpty) {
          return;
        }
        context.push(Paths.profession);
        // proceed
      },
    );
  }
}

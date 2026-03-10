import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';

class QualificationScreen extends ConsumerStatefulWidget {
  const QualificationScreen({super.key});
  @override
  ConsumerState<QualificationScreen> createState() => _QualificationScreenState();
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
    return TransparentLoading(
      isLoading: provider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates == RegistrationScreenStates.isProfileFor
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
        PrimaryTextField(
          controller: provider.highestQualification,
          headLine: 'Highest Qualification',
          hintText: 'Write here',
          errorText: null,
          noPrefix: true,
          onTap: () {},
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
      buttonStyle: provider.highestQualification.text.isNotEmpty &&  provider.instituteController.text.isNotEmpty && provider.anotherInstituteController.text.isNotEmpty
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () {
        if (provider.highestQualification.text.isEmpty ||
            provider.instituteController.text.isEmpty ||  provider.anotherInstituteController.text.isEmpty) {
          return;
        }
        context.push(Paths.profession);
        // proceed
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';

class AboutYouScreen extends ConsumerStatefulWidget {
  const AboutYouScreen({super.key});
  @override
  ConsumerState<AboutYouScreen> createState() => _AboutYourScreenState();
}

class _AboutYourScreenState extends ConsumerState<AboutYouScreen> {
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
    final screenProvider = ref.watch(aboutYouScreenProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.aboutYou),
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
      spacing: 10,
      children: [
        PrimaryTextField(
          controller: provider.firstNameController,
          headLine: 'Your Name',
          hintText: 'First Name',
          noPrefix: true,
          errorText: null,
          onTap: () {},
        ),
        PrimaryTextField(
          controller: provider.lastNameController,
          hideHeadline: true,
          hintText: 'Last Name',
          noPrefix: true,
          errorText: null,
          onTap: () {},
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: PrimaryTextField(
                controller: provider.dateOfBirthController,
                headLine: 'Date of Birth',
                hintText: 'DD/MM/YYYY',
                errorText: null,
                onTap: () {},
                datePicker: true,
                readOnly: true,
                noPrefix: true,
                suffix: ShowImage(
                  imagePath: AppImages.calendarSvgIcon,
                  width: TextSize.font20(context),
                  height: TextSize.font20(context),
                  color: provider.dateOfBirthController.text.isNotEmpty
                      ? AppColors.textPrimaryLight
                      : AppColors.hintTextColor,
                ),
              ),
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: AppColors.disableBackground,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.greyLight, width: 1)),
                child: Text(
                  provider.ageText(),
                  style: TextStyle(
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500,
                    color: provider.dateOfBirthController.text.isNotEmpty
                        ? AppColors.textPrimaryLight
                        : AppColors.grey,
                  ),
                ))
          ],
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.firstNameController.text.isNotEmpty &&
              provider.lastNameController.text.isNotEmpty &&
              provider.dateOfBirthController.text.isNotEmpty
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () {
        if (provider.firstNameController.text.isEmpty ||
            provider.lastNameController.text.isEmpty ||
            provider.dateOfBirthController.text.isEmpty) {
          return;
        }
        context.push(Paths.yourReligion);
      },
    );
  }
}

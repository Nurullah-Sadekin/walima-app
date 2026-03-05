import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';

class AboutYou extends ConsumerStatefulWidget {
  const AboutYou({super.key});
  @override
  ConsumerState<AboutYou> createState() => _IsProfileForScreenState();
}

class _IsProfileForScreenState extends ConsumerState<AboutYou> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrationProvider).getInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(registrationProvider);
    return TransparentLoading(
      isLoading: provider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.customBackgroundGradient,
          ),
          child: provider.screenStates == RegistrationScreenStates.isProfileFor
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
            textField(),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget textField() {
    return Column(
      spacing: 10,
      children: [
        PrimaryTextField(
          controller: provider.firstName,
          headLine: 'Your Name',
          hintText: 'First Name',
          noPrefix: true,
          errorText: null,
          onTap: () {},
        ),
        PrimaryTextField(
          controller: provider.lastName,
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
                controller: provider.dateOfBirth,
                headLine: 'Date of Birth',
                hintText: 'DD/MM/YYYY',
                errorText: null,
                onTap: () {},
                datePicker: true,
                readOnly: true,
                noPrefix: true,
                suffix: ShowImage(
                  imagePath: AppImages.calendarSvg,
                  width: TextSize.font20(context),
                  height: TextSize.font20(context),
                  color: AppColors.primary,
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
                  '0 Years Age',
                  style: TextStyle(
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                  ),
                ))
          ],
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.firstName.text.isNotEmpty &&
              provider.lastName.text.isNotEmpty &&
              provider.dateOfBirth.text.isNotEmpty
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () {
        if (provider.firstName.text.isEmpty &&
                provider.lastName.text.isEmpty &&
                provider.dateOfBirth.text.isEmpty) {
          return;
        }
        context.push(Paths.yourReligion);
        // Handle continue action
      },
    );
  }
}

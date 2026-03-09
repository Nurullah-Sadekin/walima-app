import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';

class EmailPhoneScreen extends ConsumerStatefulWidget {
  const EmailPhoneScreen({super.key});
  @override
  ConsumerState<EmailPhoneScreen> createState() => _EmailPhoneScreenState();
}

class _EmailPhoneScreenState extends ConsumerState<EmailPhoneScreen> {
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
        body: GradientBackground(
          child: provider.screenStates == RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.emailPhone),
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
          controller: provider.emailController,
          headLine: 'Email Address',
          hintText: 'hello@aliguni.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: ShowImage(
            imagePath: AppImages.emailSvgIcon,
            width: TextSize.font18(context),
            height: TextSize.font18(context),
            color: provider.emailController.text.isNotEmpty ? AppColors.textPrimaryLight : AppColors.hintTextColor,
          ),
          errorText: null,
          onTap: () {},
        ),
        PrimaryTextField(
          controller: provider.phoneController,
          headLine: 'Phone Number',
          keyboardType: TextInputType.phone,
          hintText: '(555) 000-0000',
          errorText: null,
          noPrefix: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.emailController.text.isNotEmpty &&
              provider.phoneController.text.isNotEmpty
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () {

        if (provider.emailController.text.isEmpty ||
            provider.phoneController.text.isEmpty ) {
          return;
        }
        context.push(Paths.location);
      },
    );
  }
}

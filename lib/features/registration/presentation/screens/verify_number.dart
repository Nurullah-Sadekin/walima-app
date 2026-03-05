import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';

class VerifyNumberScreen extends ConsumerStatefulWidget {
  const VerifyNumberScreen({super.key});
  @override
  ConsumerState<VerifyNumberScreen> createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends ConsumerState<VerifyNumberScreen> {
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
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.customBackgroundGradient,
          ),
          child: provider.screenStates == RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.verifyNumber),
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
            Text(
              'Verify Number',
              style: TextStyle(
                  fontSize: TextSize.font18(context),
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w500),
            ),
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'We\'ve sent a code to ' '+${provider.phoneController.text}',
                  style: TextStyle(
                      fontSize: TextSize.font14(context),
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w400),
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    spacing: 2,
                    children: [
                      Icon(Icons.edit_outlined,
                          size: TextSize.font14(context),
                          color: AppColors.primary),
                      Text(
                        'Edit',
                        style: TextStyle(
                            fontSize: TextSize.font14(context),
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            ),
            textField(),
            Text(
              'Experiencing issues receiving the code?',
              style: TextStyle(
                  fontSize: TextSize.font14(context),
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w400),
            ),
            Text(
              'Resend Code',
              style: TextStyle(
                fontSize: TextSize.font14(context),
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.textPrimaryLight,
                decorationThickness: 2,
              ),
            ),

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
      spacing: 20,
      children: [
        PrimaryTextField(
          controller: provider.phoneController,
          headLine: 'Verification Code',
          hintText: 'Enter code',
          errorText: null,
          onTap: () {},
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.phoneController.text.isNotEmpty
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Verify',
      onTap: () {},
    );
  }
}

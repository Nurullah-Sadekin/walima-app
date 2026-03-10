import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/login/presentation/providers/login_provider.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OtpVerifySignUpScreen extends ConsumerStatefulWidget {
  const OtpVerifySignUpScreen({super.key});

  @override
  ConsumerState<OtpVerifySignUpScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifySignUpScreen> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.initControllersListener();
      provider.initOtpFields(length: 6);
    });
  }

  @override
  void dispose() {
    provider.disposeControllersListener();
    provider.disposeOtpFields(notify: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(registrationProvider);
    final screenProvider = ref.watch(verifyOtpForSignUp);
    return TransparentLoading(
      isLoading: screenProvider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates == RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.otp),
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
            loginDataField(),
            const SizedBox(height: 10),
            Text(
              'Experiencing issues receiving the code?',
              style: TextStyle(
                fontSize: TextSize.font14(context),
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w400,
              ),
            ),
            InkWell(
              onTap: () async {
                final screenProvider = ref.read(verifyOtpForSignUp);
                screenProvider.updateViewState(loadingState: RegistrationScreenStates.isProfileFor);
                await provider.resendOtp(context);
                screenProvider.updateViewState(loadingState: RegistrationScreenStates.loadingComplete);
              },
              child: Text(
                'Resend Code',
                style: TextStyle(
                  fontSize: TextSize.font14(context),
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.textPrimaryLight,
                  decorationThickness: 1,
                ),
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

  Widget loginDataField() {
    return Column(
      spacing: 20,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(provider.otpControllers.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 42,
                  height: 40,
                  child: TextField(
                    controller: provider.otpControllers[index],
                    focusNode: provider.otpFocusNodesController[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 1,
                    style: TextStyle(
                      fontSize: TextSize.font18(context),
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.greyLight),
                      ),
                    ),
                    onChanged: (value) {
                      // Handle paste (multiple chars) and normal single char entry
                      if (value.length > 1) {
                        final chars = value.split('');
                        for (var i = 0; i < chars.length && (index + i) < provider.otpControllers.length; i++) {
                          provider.otpControllers[index + i].text = chars[i];
                        }
                        final next = index + chars.length;
                        if (next >= provider.otpFocusNodesController.length) {
                          provider.otpFocusNodesController.last.requestFocus();
                          provider.otpFocusNodesController.last.unfocus();
                        } else {
                          provider.otpFocusNodesController[next].requestFocus();
                        }
                        setState(() {});
                        return;
                      }

                      if (value.isNotEmpty) {
                        if (index + 1 < provider.otpFocusNodesController.length) {
                          provider.otpFocusNodesController[index + 1].requestFocus();
                        } else {
                          provider.otpFocusNodesController[index].unfocus();
                        }
                      } else if (index - 1 >= 0) {
                        provider.otpFocusNodesController[index - 1].requestFocus();
                      }
                      setState(() {});
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Done',
      onTap: () async {
        final screenProvider = ref.read(verifyOtpForSignUp);
        screenProvider.updateViewState(loadingState: RegistrationScreenStates.isProfileFor);
        final validate = await provider.submitRegistration(context);
        if (!validate) {
          screenProvider.updateViewState(loadingState: RegistrationScreenStates.loadingComplete);
          return;
        } else {
          screenProvider.updateViewState(screenStates: RegistrationScreenStates.loadingComplete);
        }
      },
    );
  }
}

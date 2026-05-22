import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/firebase_messaging_service.dart';
import 'package:walima_llc/features/login/presentation/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late LoginProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(loginProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.initControllersListener();
      FirebaseMessagingService.instance.requestPermissionOnce();
    });
  }

  @override
  void dispose() {
    provider.disposeControllersListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(loginProvider);
    return TransparentLoading(
      isLoading: provider.loaderState == LoginScreenStates.transparentLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates == LoginScreenStates.loading
              ? const Loading()
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const CustomBackAppBar(
                      backIconBackground: Colors.transparent,
                    ),
                    Expanded(child: body()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        spacing: 10,
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          staticText(),
          const SizedBox(height: 20),
          continueWithButton(),
          loginWithOtp(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 6,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: AppColors.hintTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: TextSize.font14(context),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // context.pop();
                        context.pushNamed(Routes.onboarding);
                      },
                      child: Row(
                        spacing: 4,
                        children: [
                          Text(
                            'Sign Up Free',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: TextSize.font16(context),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,color: AppColors.primary, size:8)
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.005),
        ],
      ),
    );
  }

  Widget staticText() {
    return Column(spacing: 10, children: [
      Column(
        children: [
          Text(
            'Welcome Back!',
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: TextSize.font28(context),
              fontFamily: FontFamily.timesNewRoman,
            ),
          ),
          Row(
            spacing: 6,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please',
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: TextSize.font28(context),
                  fontFamily: FontFamily.timesNewRoman,
                ),
              ),
              Text(
                'Login',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: TextSize.font28(context),
                  fontFamily: FontFamily.timesNewRoman,
                ),
              ),
            ],
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Text(
          'Use the same Email or Mobile No. That you used to create your profile on Walima.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.hintTextColor,
            fontWeight: FontWeight.w400,
            fontSize: TextSize.font14(context),
          ),
        ),
      ),
    ]);
  }

  Widget continueWithButton() {
    return Column(
      spacing: 12,
      children: [
        PrimaryButtons(
          buttonStyle: ButtonsStyle.authButton2,
          svgIconPath: AppImages.apple,
          svgIconColor: AppColors.textPrimaryLight,
          textColor: AppColors.textPrimaryLight,
          borderRadius: 50,
          borderColor: AppColors.inputBorderColor,
          bgColor: Colors.white,
          onTap: () {
            //context.push(Paths.isProfileFor);
          },
          title: 'Continue with Apple',
        ),
        PrimaryButtons(
          buttonStyle: ButtonsStyle.authButton2,
          svgIconPath: AppImages.google,
          textColor: AppColors.textPrimaryLight,
          borderRadius: 50,
          borderColor: AppColors.inputBorderColor,
          bgColor: Colors.white,
          onTap: () {
            //context.push(Paths.isProfileFor);
          },
          title: 'Continue with Google',
        ),
        PrimaryButtons(
          buttonStyle: ButtonsStyle.authButton2,
          svgIconPath: AppImages.emailSvgIcon,
          svgIconColor: AppColors.primary,
          textColor: AppColors.textPrimaryLight,
          borderRadius: 50,
          borderColor: AppColors.inputBorderColor,
          bgColor: Colors.white,
          onTap: () {
            context.push(Paths.loginWithEmail);
          },
          title: 'Continue with Email',
        ),
      ],
    );
  }

  Widget loginWithOtp() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Row(
            children: [
              const Expanded(
                  child: Divider(color: AppColors.inputBorderColor, thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR LOGIN WITH OTP',
                  style: TextStyle(
                    color: AppColors.hintTextColor,
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Expanded(
                  child:
                      Divider(color: AppColors.inputBorderColor, thickness: 1)),
            ],
          ),
        ),
        PrimaryTextField(
          controller: provider.mobileNoOrEmailController,
          headLine: 'Mobile No. / Email ID',
          hintText: 'Enter mobile or email',
          noPrefix: true,
          errorText: provider.mobileOrEmailError,
          onTap: null,
          borderRadius: 50,
        ),
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
        PrimaryButtons(
          buttonStyle: ButtonsStyle.authButton,
          svgIconPath: AppImages.safetySvgIcon,
          svgIconColor: AppColors.white,
          textColor: AppColors.white,
          borderRadius: 50,
          borderColor: AppColors.inputBorderColor,
          bgColor: AppColors.primary,
          onTap: () {
            provider.loginWithOtp(context);
          },
          title: 'Continue with OTP',
        ),
      ],
    );
  }

}

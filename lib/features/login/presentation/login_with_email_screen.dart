import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/firebase_messaging_service.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/validators.dart';
import 'package:walima_llc/features/login/presentation/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginWithEmailScreen extends ConsumerStatefulWidget {
  const LoginWithEmailScreen({super.key});

  @override
  ConsumerState<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends ConsumerState<LoginWithEmailScreen> {
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

          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          loginDataField(),

          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
          loginButton(),

          continueWith(),

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
          Row(
            spacing: 6,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login with',
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: TextSize.font28(context),
                  fontFamily: FontFamily.timesNewRoman,
                ),
              ),
              Text(
                'Email',
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
          'Enter your registered email and password',
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

  Widget loginDataField() {
    return Column(
      spacing: 10,
      children: [
        PrimaryTextField(
          controller: provider.mobileNoOrEmailController,
          headLine: 'Mobile No. / Email address',
          hintText: 'you@example.com',
          borderRadius: 50,
          prefixIcon: ShowImage(
            imagePath: AppImages.emailSvgIcon,
            color: provider.mobileNoOrEmailController.text.isEmpty ? AppColors.hintTextColor : AppColors.primary,
            width: TextSize.font16(context),
            height: TextSize.font16(context),
          ),
          errorText: provider.mobileOrEmailError,
          validator: Validators.validateMobileOrEmail,
          onTap: () {},
        ),
        PrimaryTextField(
          controller: provider.passwordController,
          headLine: 'Password',
          hintText: 'Enter your password',
          prefixIcon: ShowImage(
            imagePath: AppImages.lockPasswordSvgIcon,
            color: provider.passwordController.text.isEmpty ? AppColors.hintTextColor : AppColors.primary,
            width: TextSize.font16(context),
            height: TextSize.font16(context),
          ),
          borderRadius: 50,
          errorText: provider.passwordError,
          showPassIcon: true,
          onTap: () {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  provider.keepMeLoggedIn = !provider.keepMeLoggedIn;
                  provider.notifyListeners();
                },
                child: Row(
                  children: [
                    Container(
                      height: TextSize.font16(context),
                      width: TextSize.font16(context),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: provider.keepMeLoggedIn
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: provider.keepMeLoggedIn
                              ? AppColors.primary
                              : AppColors.textSecondaryLight,
                          width: 1,
                        ),
                      ),
                      child: provider.keepMeLoggedIn
                          ? Icon(
                        Icons.check,
                        size: TextSize.font12(context),
                        color: Colors.white,
                      )
                          : null,
                    ),
                    Text(
                      'Keep me logged in',
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w400,
                        fontSize: TextSize.font12(context),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    provider.forgotPassword = true;
                    provider.updateViewState();
                    context.push(Paths.sendOtp);
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: TextSize.font13(context),
                    ),
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget loginButton() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.iconicDynamicButton,
      svgIconPath: AppImages.arrowRightSvgIcon,
      svgIconColor: AppColors.white,
      iconLeftPosition: false,
      iconSize: 20,
      bgColor: AppColors.primary,
      textColor: AppColors.white,
      verticalPadding: 14,
      borderRadius: 50,
      title: 'Log In',
      onTap: () async {
        await provider.login(context);
        //context.push(Paths.yourReligion);
      },
    );
  }

  Widget continueWith() {
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
                  'OR CONTINUE WITH',
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

        SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            InkWell(
              onTap: (){},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(width: 1, color: AppColors.inputBorderColor),
                ),
                child: const Center(
                  child: ShowImage(
                    imagePath: AppImages.google,
                    width: 22,
                    height: 22,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(width: 1, color: AppColors.inputBorderColor),
                ),
                child: const Center(
                  child: ShowImage(
                    imagePath: AppImages.apple,
                    color: AppColors.black,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(width: 1, color: AppColors.inputBorderColor),
                ),
                child: const Center(
                  child: ShowImage(
                    imagePath: AppImages.mobile,
                    color: AppColors.primary,
                    width: 24,
                    height: 22,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

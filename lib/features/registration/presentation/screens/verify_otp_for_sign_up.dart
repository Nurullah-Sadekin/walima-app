import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:walima_llc/core/config/size_config.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/resend_code_timer.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OtpVerifySignUpScreen extends ConsumerStatefulWidget {
  const OtpVerifySignUpScreen({super.key, this.fromScreen});

  static const String debugOtpFlowSource = 'debugOtpSignup';
  final String? fromScreen;

  @override
  ConsumerState<OtpVerifySignUpScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifySignUpScreen> {
  late RegistrationProvider provider;

  bool get _isDebugOtpFlow {
    return kDebugMode &&
        widget.fromScreen?.trim() == OtpVerifySignUpScreen.debugOtpFlowSource;
  }

  @override
  void initState() {
    super.initState();
    // provider = ref.watch(registrationProvider);
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
                      imagePath: AppImages.otp,
                      trailingText: 'Skip',
                      totalProgressCount: 10,
                      showProgress: true,
                      currentIndexProgress: 9,
                      isTrailing: false,
                      onTrailingTap: () async {},
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  spacing: 10,
                  children: [
                    staticText(),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                    loginDataField(),
                    const SizedBox(height: 10),
                    ResendCodeTimer(
                      onResend: () async {
                        final screenProvider = ref.read(registrationScreenStateProvider);
                        screenProvider.updateViewState(
                          loadingState: RegistrationScreenStates.isProfileFor,
                        );
                        await provider.resendOtp(context);
                        screenProvider.updateViewState(
                          loadingState:
                              RegistrationScreenStates.loadingComplete,
                        );
                      },
                    ),
                    bottomAction(),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                    contactSupport(),
                    const Spacer(),
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
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primary,
                                size: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.005),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget contactSupport() {
    return Column(
      children: [
        Text(
          'Did\'nt receive the SMS?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.hintTextColor,
            fontWeight: FontWeight.w400,
            fontSize: TextSize.font14(context),
          ),
        ),
        Row(
          spacing: 6,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Check your number or',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.hintTextColor,
                fontWeight: FontWeight.w400,
                fontSize: TextSize.font14(context),
              ),
            ),
            InkWell(
              onTap: () => context.pushNamed(Routes.helpDesk),
              child: Text(
                'Contact support',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: TextSize.font14(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget staticText() {
    return Column(
      spacing: 12,
      children: [
        Column(
          spacing: 6,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Verify your',
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.bold,
                fontSize: TextSize.font24(context),
                fontFamily: FontFamily.timesNewRoman,
              ),
            ),
            Text(
              provider.selectedVerificationType.toLowerCase() == 'email'
                  ? 'email address'
                  : 'phone number',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: TextSize.font24(context),
                fontFamily: FontFamily.timesNewRoman,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              'We\'ve sent a 6-digit code to',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.hintTextColor,
                fontWeight: FontWeight.w400,
                fontSize: TextSize.font14(context),
              ),
            ),
            Row(
              spacing: 6,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (provider.selectedVerificationType.toLowerCase() == 'email')
                  Text(
                    provider.emailController.text,
                    style: TextStyle(
                      fontSize: TextSize.font14(context),
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                else
                  Text(
                    '+${provider.selectedCountryCodeForNumber} ${provider.phoneController.text}',
                    style: TextStyle(
                      fontSize: TextSize.font14(context),
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                InkWell(
                  onTap: () {
                    context.pushNamed(
                      Routes.emailPhone,
                      queryParameters: const {'fromScreen': 'otpScreen'},
                      extra: 'otpScreen',
                    );
                  },
                  child: Text(
                    'Edit'.localized(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: TextSize.font14(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget loginDataField() {
    // SizeConfig().init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(provider.otpControllers.length, (index) {
        return SizedBox(
          width: SizeConfig.screenWidth! * 0.12,
          height: SizeConfig.screenWidth! * 0.12,
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
              color: AppColors.textPrimaryLight,
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
                for (var i = 0;
                    i < chars.length &&
                        (index + i) < provider.otpControllers.length;
                    i++) {
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
    );
  }

  Widget bottomAction() {
    final otpCode = provider.otpControllers.map((c) => c.text).join();
    final isComplete = otpCode.length == provider.otpControllers.length &&
        provider.otpControllers.isNotEmpty;
    return PrimaryButtons(
      buttonStyle: isComplete
          ? ButtonsStyle.iconicDynamicButton
          : ButtonsStyle.disableButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Done',
      onTap: isComplete
          ? () async {
              final screenProvider = ref.read(registrationScreenStateProvider);
              screenProvider.updateViewState(
                loadingState: RegistrationScreenStates.isProfileFor,
              );
              final validate = await provider.submitRegistration(
                context,
                useDebugTemplate: _isDebugOtpFlow,
              );
              if (!validate) {
                screenProvider.updateViewState(
                  loadingState: RegistrationScreenStates.loadingComplete,
                );
                return;
              } else {
                screenProvider.updateViewState(
                  screenStates: RegistrationScreenStates.loadingComplete,
                );
                if (mounted) {
                  _navigateAfterRegistrationSuccess();
                }
              }
            }
          : () {},
    );
  }

  void _navigateAfterRegistrationSuccess() {
    provider.cleanAllValue();
    final destination =
        _isDebugOtpFlow ? Paths.connectMatches : Paths.photoUpload;
    context.pushReplacement(destination);
  }
}

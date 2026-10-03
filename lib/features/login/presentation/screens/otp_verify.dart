import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
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
import 'package:walima_llc/features/login/presentation/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  late LoginProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(loginProvider);

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
    provider = ref.watch(loginProvider);
    return TransparentLoading(
      isLoading: provider.loaderState == LoginScreenStates.transparentLoading,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates == LoginScreenStates.loading
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.otp),
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
          staticText(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          loginDataField(),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: verificationActions(),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
          contactSupport(),
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
              ],
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.005),
        ],
      ),
    );
  }

  /// Keeps the resend control and primary action visually grouped while
  /// preserving a predictable touch-target gap on every screen size.
  Widget verificationActions() {
    return Column(
      children: [
        ResendCodeTimer(
          onResend: () async {
            await provider.resendOtp(context);
          },
        ),
        const SizedBox(height: 18),
        bottomAction(),
      ],
    );
  }

  Widget staticText() {
    final identifier = provider.mobileNoOrEmailController.text.trim();
    final isEmail = identifier.contains('@');
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
              isEmail ? 'email address' : 'phone number',
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
                Text(
                  isEmail ? _maskEmail(identifier) : provider.authIdentifier,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w500,
                    fontSize: TextSize.font16(context),
                  ),
                ),
                Text(
                  'Edit'.localized(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: TextSize.font14(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget contactSupport() {
    final isEmail = provider.mobileNoOrEmailController.text.contains('@');
    return Column(
      children: [
        Text(
          isEmail ? 'Didn\'t receive the email?' : 'Didn\'t receive the SMS?',
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

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts.first.isEmpty) return email;
    final local = parts.first;
    final visible = local.substring(0, local.length > 2 ? 2 : 1);
    return '$visible***@${parts.last}';
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
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
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
                          borderSide:
                              const BorderSide(color: AppColors.greyLight),
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
                            provider.otpFocusNodesController.last
                                .requestFocus();
                            provider.otpFocusNodesController.last.unfocus();
                          } else {
                            provider.otpFocusNodesController[next]
                                .requestFocus();
                          }
                          setState(() {});
                          return;
                        }

                        if (value.isNotEmpty) {
                          if (index + 1 <
                              provider.otpFocusNodesController.length) {
                            provider.otpFocusNodesController[index + 1]
                                .requestFocus();
                          } else {
                            provider.otpFocusNodesController[index].unfocus();
                          }
                        } else if (index - 1 >= 0) {
                          provider.otpFocusNodesController[index - 1]
                              .requestFocus();
                        }
                        setState(() {});
                      },
                    ),
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
    final otpCode = provider.otpControllers.map((c) => c.text).join();
    final isComplete = otpCode.length == provider.otpControllers.length &&
        provider.otpControllers.isNotEmpty;
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.iconicDynamicButton,
      svgIconPath: AppImages.arrowRightSvgIcon,
      svgIconColor: isComplete ? AppColors.white : AppColors.disableText,
      iconLeftPosition: false,
      iconSize: 20,
      bgColor: isComplete ? AppColors.primary : AppColors.disableBackground,
      textColor: isComplete ? AppColors.white : AppColors.disableText,
      verticalPadding: 14,
      borderRadius: 50,
      title: 'Verify & Log In',
      onTap: isComplete ? () => provider.otpValidate(context) : () {},
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/resend_code_timer.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/login/presentation/providers/login_provider.dart';
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
            ResendCodeTimer(
              onResend: () async {
                await provider.resendOtp(context);
              },
            ),
            bottomAction(),
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
    final otpCode =
        provider.otpControllers.map((c) => c.text).join();
    final isComplete = otpCode.length == provider.otpControllers.length &&
        provider.otpControllers.isNotEmpty;
    return PrimaryButtons(
      buttonStyle: isComplete
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Done',
      onTap: isComplete
          ? () => provider.otpValidate(context)
          : () {},
    );
  }
}

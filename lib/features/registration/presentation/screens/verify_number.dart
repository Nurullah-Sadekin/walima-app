import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/resend_code_timer.dart';
import 'package:go_router/go_router.dart';

class VerifyNumberScreen extends ConsumerStatefulWidget {
  const VerifyNumberScreen({super.key, this.fromScreen});

  static const String completeProfileSource = 'completeProfile';

  final String? fromScreen;

  @override
  ConsumerState<VerifyNumberScreen> createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends ConsumerState<VerifyNumberScreen> {
  late RegistrationProvider provider;

  bool get _isFromCompleteProfile {
    return widget.fromScreen?.trim() == VerifyNumberScreen.completeProfileSource;
  }

  final List<TextEditingController> _otpControllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(5, (_) => FocusNode());

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
    for (final otpControllers in _otpControllers) {
      otpControllers.dispose();
    }
    for (final otpFocusNodes in _otpFocusNodes) {
      otpFocusNodes.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(registrationProvider);
    final screenProvider = ref.watch(verifyNumberScreenProvider);
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
                    const UpperLayer(
                      imagePath: AppImages.verifyNumber,
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
                fontWeight: FontWeight.w500,
              ),
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
                    fontWeight: FontWeight.w400,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    spacing: 2,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: TextSize.font14(context),
                        color: AppColors.primary,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: TextSize.font14(context),
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: textField(),
            ),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 52,
                  height: 52,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _otpFocusNodes[index],
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
                                (index + i) < _otpControllers.length;
                            i++) {
                          _otpControllers[index + i].text = chars[i];
                        }
                        final next = index + chars.length;
                        if (next >= _otpFocusNodes.length) {
                          _otpFocusNodes.last.requestFocus();
                          _otpFocusNodes.last.unfocus();
                        } else {
                          _otpFocusNodes[next].requestFocus();
                        }
                        setState(() {});
                        return;
                      }

                      if (value.isNotEmpty) {
                        if (index + 1 < _otpFocusNodes.length) {
                          _otpFocusNodes[index + 1].requestFocus();
                        } else {
                          _otpFocusNodes[index].unfocus();
                        }
                      } else if (index - 1 >= 0) {
                        _otpFocusNodes[index - 1].requestFocus();
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
    final otpCode = _otpControllers.map((c) => c.text).join();
    return Column(
      children: [
        PrimaryButtons(
          buttonStyle: otpCode.length == 5
              ? ButtonsStyle.activePrimaryButton
              : ButtonsStyle.disableButton,
          title: 'Continue',
          onTap: otpCode.length != 5
              ? () {}
              : () {
                  if (_isFromCompleteProfile) {
                    context.pop();
                    return;
                  }
                  context.pushNamed(Routes.photoUpload);
                },
        ),
      ],
    );
  }
}

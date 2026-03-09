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
import 'package:go_router/go_router.dart';

class VerifyNumberScreen extends ConsumerStatefulWidget {
  const VerifyNumberScreen({super.key});
  @override
  ConsumerState<VerifyNumberScreen> createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends ConsumerState<VerifyNumberScreen> {
  late RegistrationProvider provider;
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
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
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
                    UpperLayer(
                      imagePath: AppImages.verifyNumber,
                      isTrailing: true,
                      trailingText: 'Skip',
                      onTrailingTap: () => context.push(Paths.photoUpload),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: textField(),
            ),
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
          onTap: otpCode.length != 5 ? () => provider.updateViewState() : () {
            context.push(Paths.photoUpload);
          },
        ),
      ],
    );
  }
}

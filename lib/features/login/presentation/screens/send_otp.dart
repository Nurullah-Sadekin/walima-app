import 'package:flutter/material.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/features/login/presentation/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SendOtpScreen extends ConsumerStatefulWidget {
  const SendOtpScreen({super.key});

  @override
  ConsumerState<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends ConsumerState<SendOtpScreen> {
  late LoginProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(loginProvider);

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
                    UpperLayer(
                      imagePath: provider.forgotPassword ? AppImages.forgotPassword : AppImages.login,
                      backCancelMood: provider.forgotPassword,
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
            loginDataField(),
            bottomAction(),
          ],
        ),
      ),
    );
  }

  Widget loginDataField() {
    return Column(
      spacing: 10,
      children: [
        PrimaryTextField(
          controller: provider.mobileNoOrEmailController,
          headLine: 'Mobile No. / Email ID',
          hintText: 'Write here',
          noPrefix: true,
          errorText: provider.mobileOrEmailError,
          onTap: null,
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Send OTP',
      onTap: () {
        provider.loginWithOtp(context);
      },
    );
  }
}

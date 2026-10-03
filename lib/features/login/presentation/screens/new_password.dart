// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/login/presentation/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
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
              const UpperLayer(
                imagePath: AppImages.password,
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
            const Spacer(),
      bottomAction(),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
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
          controller: provider.createPasswordController,
          headLine: 'Create Password',
          hintText: 'Write here',
          noPrefix: true,
          errorText: provider.createPasswordError,
          showPassIcon: true,
          onTap: () {},
        ),
        PrimaryTextField(
          controller: provider.confirmPasswordController,
          headLine: 'Confirm Password',
          hintText: 'Write here',
          noPrefix: true,
          errorText: provider.confirmPasswordError,
          showPassIcon: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Continue',
      onTap: () async {
        final response = await provider.setNewPassword(context);
        if (!mounted) return;

        provider.hideLoading();

        if (response.code == 'SUCCESS') {
          await DialogUtils.showSuccessDialog(
            context: context,
            title: 'Success',
            message: response.message ?? 'Password changed successfully',
            buttonText: 'OK',
            autoClose: false,
            onClose: () {
              if (mounted) {
                context.go(Paths.onboarding);
              }
            },
          );
          return;
        }

        final currentContext = context;
        await DialogUtils.showErrorDialog(
          context: currentContext,
          title: 'Error',
          message: response.message ?? 'Unable to set password. Please try again.',
          buttonText: 'Try again',
        );
      },
    );
  }
}

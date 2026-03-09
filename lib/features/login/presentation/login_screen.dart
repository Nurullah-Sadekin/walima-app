import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/login/presentation/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      isLoading: provider.loaderState == LoginScreenStates.loginSuccess,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates == LoginScreenStates.loginSuccess
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.login),
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
          errorText: null,
          onTap: () {},
        ),
        PrimaryTextField(
          controller: provider.passwordController,
          headLine: 'Password',
          hintText: 'Write here',
          noPrefix: true,
          errorText: null,
          showPassIcon: true,
          onTap: () {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 8,
                children: [
                  InkWell(
                    onTap: () {
                      provider.keepMeLoggedIn == !provider.keepMeLoggedIn;
                    },
                    child: Container(
                      height: TextSize.font16(context),
                      width: TextSize.font16(context),
                      decoration: BoxDecoration(
                        color: provider.keepMeLoggedIn ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: provider.keepMeLoggedIn ? AppColors.primary : AppColors.greyLight, width: 1),
                      ),
                      child: provider.keepMeLoggedIn
                          ? Icon(Icons.check, size: TextSize.font12(context), color: Colors.white)
                          : null,
                    ),
                  ),
                  Text('Keep me logged in',
                      style: TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w400,
                        fontSize: TextSize.font12(context),
                      )),
                ],
              ),
              Text(
                'Forgot password?',
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w400,
                  fontSize: TextSize.font12(context),
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget bottomAction() {
    return Column(
      spacing: 10,
      children: [
        PrimaryButtons(
          buttonStyle:  ButtonsStyle.activePrimaryButton,
          title: 'Login',
          onTap: () {
            if (provider.mobileNoOrEmailController.text.isEmpty ||
                provider.passwordController.text.isEmpty) {
              return;
            }
            context.push(Paths.yourReligion);
          },
        ),
        PrimaryButtons(
          buttonStyle: ButtonsStyle.activeSecondaryButton,
          title: 'Login with OTP',
          onTap: () {
            context.push(Paths.yourReligion);
          },
        ),
      ],
    );
  }
}

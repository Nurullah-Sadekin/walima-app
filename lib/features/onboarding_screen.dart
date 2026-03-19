import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ShowImage(
          imagePath: 'assets/svgs/login_bg.svg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.15),
                    child: const ShowImage(
                      imagePath: 'assets/svgs/walima.svg',
                      width: 270,
                      height: 72,
                    ),
                  ),
                  Column(
                    children: [
                      PrimaryButtons(
                        buttonStyle: ButtonsStyle.authButton,
                        svgIconPath: AppImages.emailSvgIcon,
                        svgIconColor: AppColors.primary,
                        textColor: AppColors.primary,
                        bgColor: Colors.white,
                        onTap: () {
                          context.push(Paths.isProfileFor);
                        },
                        title: 'Sign Up with Email',
                      ),
                      const SizedBox(height: 16),
                      PrimaryButtons(
                        buttonStyle: ButtonsStyle.authButton,
                        svgIconPath: AppImages.logoutSvgIcon,
                        borderColor: Colors.white,
                        bgColor: Colors.black12,
                        onTap: () {
                          if (kDebugMode) {
                            context.pushNamed(
                              Routes.emailPhone,
                              queryParameters: const {
                                'fromScreen': 'debugOtpSignup',
                              },
                              extra: 'debugOtpSignup',
                            );
                            return;
                          }
                          context.push(Paths.isProfileFor);
                        },
                        title: 'Sign Up with OTP',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: TextSize.font16(context),
                                    fontWeight: FontWeight.w500)),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  context.push(Paths.login);
                                },
                                child: Text('Login',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: TextSize.font16(context),
                                        fontWeight: FontWeight.w500)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

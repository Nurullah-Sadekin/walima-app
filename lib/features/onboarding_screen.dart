import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/firebase_messaging_service.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseMessagingService.instance.requestPermissionOnce();
    });
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2,),
                    child:  Column(
                      children: [
                        const ShowImage(
                          imagePath: 'assets/svgs/walima.svg',
                          width: 270,
                          height: 72,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'MATCH',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.65),
                                fontSize: TextSize.font14(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.circle, color: AppColors.white.withOpacity(0.35), size: 6),
                            Text(
                              'MEET',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.65),
                                fontSize: TextSize.font14(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.circle, color: AppColors.white.withOpacity(0.35), size: 6),
                            Text(
                              'MARRY ',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.65),
                                fontSize: TextSize.font14(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'New to Walima?',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.65),
                          fontSize: TextSize.font15(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      PrimaryButtons(
                        buttonStyle: ButtonsStyle.authButton,
                        svgIconPath: AppImages.emailSvgIcon,
                        svgIconColor: AppColors.primary,
                        textColor: AppColors.primary,
                        borderRadius: 50,
                        bgColor: Colors.white,
                        onTap: () {
                          context.push(Paths.isProfileFor);
                        },
                        title: 'Get Started',
                      ),
                      const SizedBox(height: 16),
                      // PrimaryButtons(
                      //   buttonStyle: ButtonsStyle.authButton,
                      //   svgIconPath: AppImages.logoutSvgIcon,
                      //   borderColor: Colors.white,
                      //   bgColor: Colors.black12,
                      //   onTap: () {
                      //     context.push(Paths.isProfileFor);
                      //   },
                      //   title: 'Sign Up',
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already a member?',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.65),
                                fontSize: TextSize.font15(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  context.push(Paths.login);
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: TextSize.font16(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

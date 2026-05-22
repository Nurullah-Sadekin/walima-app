import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/firebase_messaging_service.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/utils/link_opener.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Future<void> _openHelpModal() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE8447A).withValues(alpha: 0.10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFE8447A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Need Help?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "We're here to help you on your journey to finding the right match.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF888888),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _HelpItem(
                    icon: Icons.policy_outlined,
                    title: 'Terms & Privacy',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _HelpItem(
                    icon: Icons.support_agent_outlined,
                    title: 'Contact Support',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _HelpItem(
                    icon: Icons.info_outline,
                    title: 'About Walima',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseMessagingService.instance.requestPermissionOnce();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const ShowImage(
            imagePath: 'assets/images/login_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0xFF500F23).withValues(alpha: 0.10),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.58,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.0, 0.30, 0.60, 1.0],
                    colors: [
                      Color.fromRGBO(10, 2, 5, 0.97),
                      Color.fromRGBO(10, 2, 5, 0.88),
                      Color.fromRGBO(10, 2, 5, 0.50),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _PillButton(
                        icon: Icons.language,
                        label: 'English',
                        onTap: () {},
                      ),
                      _CircleButton(
                        icon: Icons.help_outline,
                        onTap: _openHelpModal,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      const ShowImage(
                        imagePath: 'assets/svgs/walima.svg',
                        width: 270,
                        height: 72,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'MATCH · MEET · MARRY',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 3.2,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      _CtaButton(
                        backgroundColor: const Color(0xFFE8447A),
                        foregroundColor: Colors.white,
                        icon: Icons.phone_iphone,
                        label: 'Continue with Phone',
                        onTap: () => context.push(Paths.isProfileFor),
                      ),
                      const SizedBox(height: 10),
                      _CtaButton(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A1A1A),
                        icon: Icons.email_outlined,
                        label: 'Continue with Email',
                        onTap: () => context.push(Paths.login),
                      ),
                      const SizedBox(height: 12),
                      continueWithButton(),
                      const SizedBox(height: 12),
                      // Text(
                      //   'By continuing you agree to our Terms and Privacy Policy',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     color: Colors.white.withValues(alpha: 0.40),
                      //     fontSize: TextSize.font10(context),
                      //     fontWeight: FontWeight.w300,
                      //   ),
                      // ),
                      //
                      RichText(
                          text: TextSpan(
                        text: 'By continuing you agree to our ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.40),
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w300,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: TextSize.font12(context),
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                // open terms page
                                await LinkOpener.openLink(context, 'Terms & Conditions', AppUrls.termsUrl);
                              },
                          ),
                          TextSpan(
                            text: ' and ',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.40),
                              fontSize: TextSize.font12(context),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextSpan(
                            text: 'Privacy policy',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: TextSize.font12(context),
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await LinkOpener.openLink(context, 'Privacy Policy', AppUrls.privacyPolicyUrl);
                              },
                          ),
                        ],
                      )),
                      const SizedBox(height: 12),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget continueWithButton() {
    return Column(
      spacing: 12,
      children: [
        PrimaryButtons(
          buttonStyle: ButtonsStyle.authButton,
          svgIconPath: AppImages.apple,
          svgIconColor: AppColors.textPrimaryLight,
          textColor: AppColors.textPrimaryLight,
          borderRadius: 50,
          borderColor: AppColors.inputBorderColor,
          bgColor: Colors.white,
          onTap: () {
            //context.push(Paths.isProfileFor);
          },
          title: 'Continue with Apple',
        ),
        PrimaryButtons(
          buttonStyle: ButtonsStyle.authButton,
          svgIconPath: AppImages.google,
          textColor: AppColors.textPrimaryLight,
          borderRadius: 50,
          borderColor: AppColors.inputBorderColor,
          bgColor: Colors.white,
          onTap: () {
            //context.push(Paths.isProfileFor);
          },
          title: 'Continue with Google',
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap,
        child: Container(
          height: 54,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: TextSize.font15(context),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  const _HelpItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFF2F2F2))),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF1A1A1A)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFAAAAAA)),
            ],
          ),
        ),
      ),
    );
  }
}

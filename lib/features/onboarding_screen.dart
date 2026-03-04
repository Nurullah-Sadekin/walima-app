import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShowImage(
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowImage(
                    imagePath: 'assets/svgs/walima.svg',
                    width: 270,
                    height: 72,
                  ),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Please login to your account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButtons(
                    buttonStyle: ButtonsStyle.activePrimaryButton,
                    onTap: () {
                      context.push('/login');
                    },
                    title: 'Login',
                  ),
                  const SizedBox(height: 16),
                  PrimaryButtons(
                    buttonStyle: ButtonsStyle.activePrimaryButton,
                    onTap: () {
                      context.push('/isProfileFor');
                    },
                    title: 'Sign Up',
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

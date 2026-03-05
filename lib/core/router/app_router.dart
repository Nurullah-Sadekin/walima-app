import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/features/onboarding_screen.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/about_you.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/email_phone.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/profile_is_for_screen.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/your_religion.dart';
import 'package:flutter_boilerplate/features/settings/presentation/screens/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_boilerplate/features/splash_screen.dart';
import 'package:flutter_boilerplate/features/anchor_point/anchor_point.dart';
import 'package:flutter_boilerplate/features/login/presentation/login_screen.dart';

import 'route_name.dart';

part 'app_router.g.dart';

/// GoRouter configuration
@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: Paths.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Paths.splash,
        name: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Paths.anchor,
        name: Routes.anchor,
        builder: (context, state) => const AnchorPointScreen(),
      ),
      GoRoute(
        path: Paths.login,
        name: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Paths.settings,
        name: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Paths.onboarding,
        name: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Paths.isProfileFor,
        name: Routes.isProfileFor,
        builder: (context, state) => const IsProfileForScreen(),
      ),
      GoRoute(
        path: Paths.aboutYou,
        name: Routes.aboutYou,
        builder: (context, state) => const AboutYou(),
      ),
      GoRoute(
        path: Paths.yourReligion,
        name: Routes.yourReligion,
        builder: (context, state) => const YourReligion(),
      ),
      GoRoute(
        path: Paths.emailPhone,
        name: Routes.emailPhone,
        builder: (context, state) => const EmailPhone(),
      ),
      GoRoute(
        path: Paths.location,
        name: Routes.location,
        builder: (context, state) => const YourReligion(),
      ),
      GoRoute(
        path: Paths.maritalStatus,
        name: Routes.maritalStatus,
        builder: (context, state) => const YourReligion(),
      ),
      GoRoute(
        path: Paths.qualification,
        name: Routes.qualification,
        builder: (context, state) => const YourReligion(),
      ),
      GoRoute(
        path: Paths.profession,
        name: Routes.profession,
        builder: (context, state) => const YourReligion(),
      ),
      GoRoute(
        path: Paths.aboutYourself,
        name: Routes.aboutYourself,
        builder: (context, state) => const YourReligion(),
      ),
      GoRoute(
        path: Paths.verifyNumber,
        name: Routes.verifyNumber,
        builder: (context, state) => const YourReligion(),
      ),
      GoRoute(
        path: Paths.photoUpload,
        name: Routes.photoUpload,
        builder: (context, state) => const YourReligion(),
      ),
      GoRoute(
        path: Paths.hobbiesInterests,
        name: Routes.hobbiesInterests,
        builder: (context, state) => const YourReligion(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(Paths.splash),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

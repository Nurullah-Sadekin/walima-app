import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/features/onboarding_screen.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_boilerplate/features/resistration/presentation/screens/profile_is_for_screen.dart';
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

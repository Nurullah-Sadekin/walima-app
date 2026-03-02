import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/anchor_point/anchor_point.dart';
import 'package:flutter_boilerplate/features/login/presentation/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _tokenKey = 'token'; // Assumption: token is stored under this key

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      // Small delay so splash is visible for a moment
      await Future.delayed(const Duration(milliseconds: 350));

      if (token != null && token.isNotEmpty) {
        // Apply token to Dio client so subsequent requests are authenticated
        try {
          DioClient().setAuthToken(token);
        } catch (_) {}

        // Navigate to the anchor point (main app)
        if (!mounted) return;
        context.go('/anchor');
      } else {
        if (!mounted) return;
        context.go('/login');
      }
    } catch (e) {
      // In case of any error, go to login
      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            FlutterLogo(size: 88),
            SizedBox(height: 16),
            Text(
              'Walima',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

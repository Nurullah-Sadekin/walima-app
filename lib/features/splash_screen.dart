import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      debugPrint('SplashScreen: AccessToken : $token');

      if (token != null && token.isNotEmpty) {
        try {
          DioClient().setAuthToken(token);
        } catch (_) {}

        // Navigate to the anchor point (main app)
        if (!mounted) return;
        context.go(Paths.anchor);
      } else {
        if (!mounted) return;
        context.go(Paths.onboarding);
      }
    } catch (e) {
      // In case of any error, go to login
      if (!mounted) return;
      context.go(Paths.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        alignment: Alignment.center,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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

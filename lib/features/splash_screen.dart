import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:walima_llc/core/constants/storage_keys.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color _splashPink = Color(0xFFFF2E86);
  String _versionLabel = 'Version';

  @override
  void initState() {
    super.initState();
    _loadVersion();
    _checkAuth();
  }

  Future<void> _loadVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _versionLabel = 'Version: ${packageInfo.version}.${packageInfo.buildNumber}';
      });
    } catch (_) {}
  }

  Future<void> _checkAuth() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1400));
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
        width: double.infinity,
        height: double.infinity,
        color: _splashPink,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SvgPicture.asset(
                    AppImages.walimaSvg,
                    width: 270,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 72,
                child: Text(
                  _versionLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

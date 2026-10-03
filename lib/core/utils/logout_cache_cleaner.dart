import 'package:flutter/painting.dart';
import 'package:walima_llc/core/utils/prefs_helper.dart';
import 'package:walima_llc/core/utils/social_sign_in_service.dart';

class LogoutCacheCleaner {
  LogoutCacheCleaner._();

  static Future<void> clear() async {
    await PrefsHelper.clearForLogout();
    await SocialSignInService.signOutFirebase();
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
  }
}

import 'package:flutter/painting.dart';
import 'package:walima_llc/core/utils/prefs_helper.dart';

class LogoutCacheCleaner {
  LogoutCacheCleaner._();

  static Future<void> clear() async {
    await PrefsHelper.clearForLogout();
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
  }
}

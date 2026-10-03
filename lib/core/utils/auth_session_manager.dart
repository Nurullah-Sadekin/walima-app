import 'dart:async';

import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/core/utils/app_error_reporting_service.dart';
import 'package:walima_llc/core/utils/firebase_messaging_service.dart';
import 'package:walima_llc/core/utils/prefs_helper.dart';
import 'package:walima_llc/features/chat/data/socket/socket_service.dart';
import 'package:walima_llc/features/login/data/models/login_response.dart';

class AuthSessionManager {
  AuthSessionManager._();

  static Future<bool> applyLoginResponse(LoginResponse response) async {
    final accessToken = response.response?.accessToken?.trim() ?? '';
    final refreshToken = response.response?.refreshToken?.trim() ?? '';

    if (accessToken.isEmpty || refreshToken.isEmpty) {
      return false;
    }

    await PrefsHelper.setAccessToken(accessToken);
    await PrefsHelper.setRefreshToken(refreshToken);

    try {
      DioClient().setAuthToken(accessToken);
    } catch (_) {}

    try {
      await SocketService.instance.connect(token: accessToken);
    } catch (_) {}

    await AppErrorReportingService.instance.setUserContext(
      userId: response.response?.user?.id,
      email: response.response?.user?.email,
      phone: response.response?.user?.phoneNumber?.toString(),
    );

    unawaited(FirebaseMessagingService.instance.registerDeviceToken());
    return true;
  }
}

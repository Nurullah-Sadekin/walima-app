import 'package:flutter_boilerplate/core/global/models/refresh_token_request_body.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/utils/prefs_helper.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_response.dart';

class GlobalRepository {
  Future<String> getAppVersion() async {
    await Future.delayed(const Duration(seconds: 1));
    return '1.0.0';
  }

  static Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await PrefsHelper.getRefreshToken();
      if (refreshToken.isEmpty) {
        return false;
      }

      final requestBody = RefreshRequestBody(refreshToken: refreshToken);
      final response = await DioClient().post(AppUrls.getAccessToken, data: requestBody.toJson());
      final data = LoginResponse.fromJson(response.data);
      if (data.code == 'SUCCESS' && data.response != null) {
        final accessToken = data.response?.accessToken ?? '';
        final newRefreshToken = data.response?.refreshToken ?? '';

        await PrefsHelper.setAccessToken(accessToken);
        await PrefsHelper.setRefreshToken(newRefreshToken);

        if (accessToken.isNotEmpty) {
          DioClient().setAuthToken(accessToken);
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

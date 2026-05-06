import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/profile/data/model/response/logout_response.dart';

class LogoutRepository {
  static Future<LogoutResponse> logout() async {
    try {
      final response = await DioClient().post(
        AppUrls.logout,
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return LogoutResponse.fromJson(data);
      }

      if (data is Map) {
        return LogoutResponse.fromJson(Map<String, dynamic>.from(data));
      }

      return LogoutResponse(
        code: 'FAILED',
        message: response.message,
      );
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return LogoutResponse(
        code: 'FAILED',
        message: errorMessage,
      );
    }
  }
}

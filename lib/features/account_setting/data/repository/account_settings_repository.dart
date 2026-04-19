import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/account_settings.dart';

class AccountSettingsRepository {
  static Future<ApiResponse<AccountSettings>> getAccountSettings() async {
    try {
      final response = await DioClient().get(
        AppUrls.updateNameAndEmail,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.success(
        data: AccountSettings.fromAny(response.data),
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is DioException) {
        return ApiResponse.error(
          message: e.response?.data['message'] ?? e.message ?? 'Request failed',
          statusCode: e.response?.statusCode ?? 0,
        );
      }

      return ApiResponse.error(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }

  static Future<ApiResponse> updateAccountSettings(
    AccountSettings settings,
  ) async {
    try {
      final response = await DioClient().put(
        AppUrls.updateNameAndEmail,
        isTokenRequired: true,
        data: settings.toRequestJson(),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        return ApiResponse.error(
          message: e.response?.data['message'] ?? e.message ?? 'Request failed',
          statusCode: e.response?.statusCode ?? 0,
        );
      }

      return ApiResponse.error(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }
}

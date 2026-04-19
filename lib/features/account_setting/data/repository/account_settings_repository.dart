import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/account_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/contact_settings.dart';

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
      return _mapError(e);
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
      return _withApiMessage(response);
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse<ContactSettings>> getContactSettings() async {
    try {
      final response = await DioClient().get(
        AppUrls.contactSettings,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.success(
        data: ContactSettings.fromAny(response.data),
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse> updateContactDisplayStatus(
    String contactDisplayStatus,
  ) async {
    try {
      final response = await DioClient().put(
        AppUrls.contactSettings,
        isTokenRequired: true,
        data: <String, dynamic>{
          'contactDisplayStatus': contactDisplayStatus,
        },
      );
      return _withApiMessage(response);
    } catch (e) {
      return _mapError(e);
    }
  }

  static ApiResponse _withApiMessage(ApiResponse response) {
    final apiMessage = _extractMessage(response.data);
    if (apiMessage == null || apiMessage.isEmpty) return response;
    return response.isSuccess
        ? ApiResponse.success(
            data: response.data,
            message: apiMessage,
            statusCode: response.statusCode,
          )
        : ApiResponse.error(
            message: apiMessage,
            statusCode: response.statusCode,
            data: response.data,
          );
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map && data['message'] is String) {
      final msg = (data['message'] as String).trim();
      if (msg.isNotEmpty) return msg;
    }
    return null;
  }

  static ApiResponse<T> _mapError<T>(Object e) {
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

import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/account_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/contact_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/messages_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/notification_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/premium_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/privacy_settings.dart';

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

      // Extract the nested 'response' object if it exists
      final data = response.data is Map ? (response.data['response'] ?? response.data) : response.data;

      return ApiResponse.success(
        data: AccountSettings.fromAny(data),
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

      // Extract the nested 'response' object if it exists
      final data = response.data is Map ? (response.data['response'] ?? response.data) : response.data;

      return ApiResponse.success(
        data: ContactSettings.fromAny(data),
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

  static Future<ApiResponse<PremiumSettings>> getPremiumSettings() async {
    try {
      final response = await DioClient().get(
        AppUrls.premiumSettings,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      // Extract the nested 'response' object if it exists
      final data = response.data is Map ? (response.data['response'] ?? response.data) : response.data;

      return ApiResponse.success(
        data: PremiumSettings.fromAny(data),
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse> updatePremiumSettings(
    PremiumSettings settings,
  ) async {
    try {
      final response = await DioClient().put(
        AppUrls.premiumSettings,
        isTokenRequired: true,
        data: settings.toRequestJson(),
      );
      return _withApiMessage(response);
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse> updatePremiumAutoRenew(bool autoRenew) async {
    try {
      final response = await DioClient().put(
        AppUrls.premiumSettings,
        isTokenRequired: true,
        data: <String, dynamic>{'autoRenew': autoRenew},
      );
      return _withApiMessage(response);
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse> updateMessagesSettings(
    MessagesSettings settings,
  ) async {
    try {
      final response = await DioClient().put(
        AppUrls.messagesSettings,
        isTokenRequired: true,
        data: settings.toRequestJson(),
      );
      return _withApiMessage(response);
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse<MessagesSettings>> getMessagesSettings() async {
    try {
      final response = await DioClient().get(
        AppUrls.messagesSettings,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      // Extract the nested 'response' object if it exists
      final data = response.data is Map ? (response.data['response'] ?? response.data) : response.data;

      return ApiResponse.success(
        data: MessagesSettings.fromAny(data),
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse<NotificationSettings>>
      getNotificationSettings() async {
    try {
      final response = await DioClient().get(
        AppUrls.getNotificationSettings,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      // Extract the nested 'response' object if it exists
      final data = response.data is Map ? (response.data['response'] ?? response.data) : response.data;

      return ApiResponse.success(
        data: NotificationSettings.fromAny(data),
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse> updateNotificationSetting(
    String key,
    dynamic value,
  ) async {
    try {
      final response = await DioClient().put(
        AppUrls.updateNotificationSettings,
        isTokenRequired: true,
        data: <String, dynamic>{
          key: value,
        },
      );
      return _withApiMessage(response);
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final response = await DioClient().post(
        AppUrls.changePassword,
        isTokenRequired: true,
        data: <String, dynamic>{
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
      return _withApiMessage(response);
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse> createPassword(
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final response = await DioClient().post(
        AppUrls.createPassword,
        isTokenRequired: true,
        data: <String, dynamic>{
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
      return _withApiMessage(response);
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse<PrivacySettings>> getPrivacySettings() async {
    try {
      final response = await DioClient().get(
        AppUrls.getPrivacySettings,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      // Extract the nested 'response' object from the API response
      final data = response.data is Map ? response.data['response'] : response.data;

      return ApiResponse.success(
        data: PrivacySettings.fromAny(data),
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _mapError(e);
    }
  }

  static Future<ApiResponse> updatePrivacySettings(
    PrivacySettings settings, {
    String? changedKey,
  }) async {
    try {
      final response = await DioClient().put(
        AppUrls.updatePrivacySettings,
        isTokenRequired: true,
        data: changedKey != null 
            ? settings.toRequestJsonForKey(changedKey)
            : settings.toRequestJson(),
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

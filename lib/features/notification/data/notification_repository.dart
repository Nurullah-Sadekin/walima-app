import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/utils/prefs_helper.dart';
import 'package:flutter_boilerplate/features/home/data/model/response/unread_notification_count.dart';
import 'package:flutter_boilerplate/features/notification/data/notification_response.dart';

class NotificationRepository {
  static Future<NotificationResponse> getNotifications({
    int page = 1,
    int limit = 10,
    String filter = 'all_activities',
    String type = 'connection',
  }) async {
    try {
      final response = await DioClient().get(
        AppUrls.getNotifications,
        isTokenRequired: true,
        queryParameters: {
          'page': page,
          'limit': limit,
          // 'filter': filter,
          // 'type': type,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return NotificationResponse.fromJson(
          data,
          statusCode: response.statusCode,
        );
      }

      if (data is Map) {
        return NotificationResponse.fromJson(
          Map<String, dynamic>.from(data),
          statusCode: response.statusCode,
        );
      }

      return NotificationResponse(
        code: 'FAILED',
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return NotificationResponse(
        code: 'FAILED',
        message: errorMessage.toString(),
        statusCode: e is DioException ? e.response?.statusCode : 0,
      );
    }
  }

  static Future<NotificationResponse> markNotificationsAsRead({
    required List<String> notificationIds,
    String? userId,
  }) async {
    try {
      final resolvedUserId = userId?.trim().isNotEmpty == true
          ? userId!.trim()
          : await _resolveUserIdFromAccessToken();

      final response = await DioClient().patch(
        AppUrls.bulkReadNotifications,
        isTokenRequired: true,
        data: {
          'notificationIds': notificationIds,
          if (resolvedUserId.isNotEmpty) 'userId': resolvedUserId,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return NotificationResponse.fromJson(
          data,
          statusCode: response.statusCode,
        );
      }
      if (data is Map) {
        return NotificationResponse.fromJson(
          Map<String, dynamic>.from(data),
          statusCode: response.statusCode,
        );
      }

      return NotificationResponse(
        code: response.statusCode >= 200 && response.statusCode < 300
            ? 'SUCCESS'
            : 'FAILED',
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return NotificationResponse(
        code: 'FAILED',
        message: errorMessage.toString(),
        statusCode: e is DioException ? e.response?.statusCode : 0,
      );
    }
  }

  static Future<NotificationResponse> markAllNotificationsAsRead({
    String? userId,
  }) async {
    return markNotificationsAsRead(
      notificationIds: const <String>[],
      userId: userId,
    );
  }

  static Future<String> _resolveUserIdFromAccessToken() async {
    try {
      final token = await PrefsHelper.getAccessToken();
      if (token.isEmpty) return '';

      final segments = token.split('.');
      if (segments.length < 2) return '';

      final payload = segments[1];
      final normalized = base64Url.normalize(payload);
      final decodedBytes = base64Url.decode(normalized);
      final decoded = utf8.decode(decodedBytes);
      final payloadMap = json.decode(decoded);

      if (payloadMap is Map<String, dynamic>) {
        final userId = payloadMap['userId']?.toString().trim();
        if (userId?.isNotEmpty == true) return userId!;

        final sub = payloadMap['sub']?.toString().trim();
        if (sub?.isNotEmpty == true) return sub!;
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  static Future<UnreadNotificationCount> getUnReadNotificationCount() async {
    try {
      final response = await DioClient().get(
        AppUrls.getUnreadNotificationCount,
        isTokenRequired: true,
      );
      return UnreadNotificationCount.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return UnreadNotificationCount(
        code: 'FAILED',
        message: errorMessage,
      );
    }
  }
}

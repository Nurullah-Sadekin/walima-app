import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
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
          'filter': filter,
          'type': type,
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
        message: response.message ?? 'Unexpected response format.',
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

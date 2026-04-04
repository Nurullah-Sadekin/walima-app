import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/inbox/data/models/received_connection_response.dart';

class InboxRepository {
  static Future<ReceivedConnectionResponse> getRequestedConnections({
    int page = 1,
    int size = 10,
    String responseFormat = 'short',
  }) async {
    try {
      final response = await DioClient().get(
        AppUrls.getRequestedConnections,
        isTokenRequired: true,
        queryParameters: {
          'page': page,
          'size': size,
          'responseFormat': responseFormat,
        },
      );
      return ReceivedConnectionResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return ReceivedConnectionResponse(
        code: 'FAILED',
        message: errorMessage,
      );
    }
  }
}


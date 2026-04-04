import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/inbox/data/models/accepted_connection_response.dart';
import 'package:flutter_boilerplate/features/inbox/data/models/received_connection_response.dart';

class InboxRepository {
  static Future<ReceivedConnectionResponse> getRequestedConnections({
    int? page,
    int? size,
    String? responseFormat,
    String? sortBy,
    String? sortOrder,
    String? search,
    String? filter,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'size': size,
        'responseFormat': responseFormat,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
        'search': search,
        'filter': filter,
      }..removeWhere((_, value) => value == null);

      final response = await DioClient().get(
        AppUrls.getRequestedConnections,
        isTokenRequired: true,
        queryParameters: queryParameters,
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

  static Future<AcceptedConnectionResponse> getAcceptedConnections({
    int page = 1,
    int size = 10,
    String responseFormat = 'short',
  }) async {
    try {
      final response = await DioClient().get(
        AppUrls.getAcceptedConnections,
        isTokenRequired: true,
        queryParameters: {
          'page': page,
          'size': size,
          'responseFormat': responseFormat,
        },
      );
      return AcceptedConnectionResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return AcceptedConnectionResponse(
        code: 'FAILED',
        message: errorMessage,
      );
    }
  }
}

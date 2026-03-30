import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/connections/data/models/request/get_requested_connections_query_params.dart';
import 'package:flutter_boilerplate/features/connections/data/models/response/get_requested_connections_response.dart';

class ConnectionsRepository {
  static Future<GetRequestedConnectionsResponse> getRequestedConnections(
    GetRequestedConnectionsQueryParams params,
  ) async {
    try {
      final response = await DioClient().get(
        AppUrls.getRequestedConnections,
        queryParameters: params.toJson(),
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return GetRequestedConnectionsResponse.fromJson(
          data,
          statusCode: response.statusCode,
        );
      }

      if (data is Map) {
        return GetRequestedConnectionsResponse.fromJson(
          Map<String, dynamic>.from(data),
          statusCode: response.statusCode,
        );
      }

      return GetRequestedConnectionsResponse(
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return GetRequestedConnectionsResponse(
        message: errorMessage,
        statusCode: e is DioException ? e.response?.statusCode : 0,
      );
    }
  }
}

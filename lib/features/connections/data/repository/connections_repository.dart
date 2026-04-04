import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/connections/data/models/request/get_requested_connections_query_params.dart';
import 'package:flutter_boilerplate/features/connections/data/models/request/perform_connection_action_request_body.dart';
import 'package:flutter_boilerplate/features/connections/data/models/response/get_accepted_connection_response.dart';
import 'package:flutter_boilerplate/features/connections/data/models/response/get_requested_connections_response.dart';
import 'package:flutter_boilerplate/features/connections/data/models/response/get_sent_connection_response.dart';

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

  static Future<GetAcceptedConnectionResponse> getAcceptedConnections(
    GetRequestedConnectionsQueryParams params,
  ) async {
    try {
      final response = await DioClient().get(
        AppUrls.getAcceptedConnections,
        queryParameters: params.toJson(),
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return GetAcceptedConnectionResponse.fromJson(data);
      }

      if (data is Map) {
        return GetAcceptedConnectionResponse.fromJson(
          Map<String, dynamic>.from(data),
        );
      }

      return GetAcceptedConnectionResponse(message: response.message);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return GetAcceptedConnectionResponse(message: errorMessage);
    }
  }

  static Future<GetSentConnectionResponse> getSentConnections(
    GetRequestedConnectionsQueryParams params,
  ) async {
    try {
      final response = await DioClient().get(
        AppUrls.getSentConnections,
        queryParameters: params.toJson(),
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return GetSentConnectionResponse.fromJson(data);
      }

      if (data is Map) {
        return GetSentConnectionResponse.fromJson(
          Map<String, dynamic>.from(data),
        );
      }

      return GetSentConnectionResponse(message: response.message);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return GetSentConnectionResponse(message: errorMessage);
    }
  }

  static Future<ApiResponse> deleteConnection(String connectionId) async {
    try {
      return await DioClient().delete(
        AppUrls.deleteConnection.replaceFirst('{id}', connectionId),
        isTokenRequired: true,
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

  static Future<ApiResponse> performConnectionAction(
    String connectionId,
    PerformConnectionActionRequestBody body,
  ) async {
    try {
      return await DioClient().patch(
        AppUrls.performConnectionAction.replaceFirst('{id}', connectionId),
        isTokenRequired: true,
        data: body.toJson(),
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
}

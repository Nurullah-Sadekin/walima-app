import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/connections/data/models/request/get_requested_connections_query_params.dart';
import 'package:walima_llc/features/connections/data/models/request/perform_connection_action_request_body.dart';
import 'package:walima_llc/features/connections/data/models/response/get_accepted_connection_response.dart';
import 'package:walima_llc/features/connections/data/models/response/get_blocked_connection_response.dart';
import 'package:walima_llc/features/connections/data/models/response/get_requested_connections_response.dart';
import 'package:walima_llc/features/connections/data/models/response/get_sent_connection_response.dart';
import 'package:walima_llc/features/connections/data/models/response/view_contact_info.dart';

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

  static Future<GetSentConnectionResponse> getDeletedConnections(
    GetRequestedConnectionsQueryParams params,
  ) async {
    try {
      final response = await DioClient().get(
        AppUrls.getDeletedConnections,
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

  static Future<GetBlockedConnectionResponse> getBlockedConnections(
    GetRequestedConnectionsQueryParams params,
  ) async {
    try {
      final response = await DioClient().get(
        AppUrls.getBlockedConnections,
        queryParameters: params.toJson(),
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return GetBlockedConnectionResponse.fromJson(data);
      }

      if (data is Map) {
        return GetBlockedConnectionResponse.fromJson(
          Map<String, dynamic>.from(data),
        );
      }

      return GetBlockedConnectionResponse(message: response.message);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return GetBlockedConnectionResponse(message: errorMessage);
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

  static Future<ApiResponse> sendReminder(String connectionId) async {
    try {
      return await DioClient().post(
        AppUrls.sendReminder.replaceFirst('{id}', connectionId),
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
        AppUrls.performConnectionAction(connectionId),
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

  static Future<ApiResponse<ViewContactInfo>> viewContact(String userId) async {
    final endpoint = '${AppUrls.viewContact}$userId';
    try {
      final response = await DioClient().get(
        endpoint,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.success(
        data: ViewContactInfo.fromAny(response.data),
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
}

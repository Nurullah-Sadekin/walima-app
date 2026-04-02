import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/matches/data/models/request/get_matches_query_params.dart';
import 'package:flutter_boilerplate/features/matches/data/models/response/connect_response.dart';
import 'package:flutter_boilerplate/features/matches/data/models/response/get_matches_response.dart';
import 'package:flutter_boilerplate/features/matches/data/models/response/get_public_matches_response.dart';
import 'package:flutter_boilerplate/features/matches/domain/request/create_connection_request_body.dart';

class MatchesRepository {
  static Future<GetMatchesResponse> getMatches(
    GetMatchesQueryParams params,
  ) async {
    try {
      final response = await DioClient().get(
        AppUrls.getMatches,
        queryParameters: params.toJson(),
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return GetMatchesResponse.fromJson(
          data,
          statusCode: response.statusCode,
        );
      }

      if (data is Map) {
        return GetMatchesResponse.fromJson(
          Map<String, dynamic>.from(data),
          statusCode: response.statusCode,
        );
      }

      return GetMatchesResponse(
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return GetMatchesResponse(
        message: errorMessage,
        statusCode: e is DioException ? e.response?.statusCode : 0,
      );
    }
  }

  static Future<GetPublicMatchesResponse> getPublicMatches(
    GetMatchesQueryParams params,
  ) async {
    try {
      final response = await DioClient().get(
        AppUrls.getPublicMatches,
        queryParameters: params.toJson(),
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return GetPublicMatchesResponse.fromJson(
          data,
          statusCode: response.statusCode,
        );
      }

      if (data is Map) {
        return GetPublicMatchesResponse.fromJson(
          Map<String, dynamic>.from(data),
          statusCode: response.statusCode,
        );
      }

      return GetPublicMatchesResponse(
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return GetPublicMatchesResponse(
        message: errorMessage,
        statusCode: e is DioException ? e.response?.statusCode : 0,
      );
    }
  }

  // create connection request

  Future<ConnectResponse> createConnectionRequest(
    CreateConnectionRequestBody? body,
  ) async {
    try {
      final response = await DioClient().post(
        AppUrls.getConnections,
        data: body?.toJson(),
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ConnectResponse.fromJson(
          data,
          statusCode: response.statusCode,
        );
      }

      if (data is Map) {
        return ConnectResponse.fromJson(
          Map<String, dynamic>.from(data),
          statusCode: response.statusCode,
        );
      }

      return ConnectResponse(
        code: response.statusCode >= 200 && response.statusCode < 300
            ? 'SUCCESS'
            : 'FAILED',
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final dioException = e is DioException ? e : null;
      final errorMessage = dioException != null
          ? dioException.response?.data['message'] ?? dioException.message
          : e.toString();

      final data = dioException?.response?.data;
      if (data is Map<String, dynamic>) {
        return ConnectResponse.fromJson(
          data,
          statusCode: dioException?.response?.statusCode,
        );
      }
      if (data is Map) {
        return ConnectResponse.fromJson(
          Map<String, dynamic>.from(data),
          statusCode: dioException?.response?.statusCode,
        );
      }

      return ConnectResponse(
        code: 'FAILED',
        message: errorMessage.toString(),
        statusCode: dioException?.response?.statusCode ?? 0,
      );
    }

    // Implement the logic to create a connection request
  }
}

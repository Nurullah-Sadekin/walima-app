import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/matches/data/models/request/get_matches_query_params.dart';
import 'package:flutter_boilerplate/features/matches/data/models/response/get_matches_response.dart';
import 'package:flutter_boilerplate/features/matches/data/models/response/get_public_matches_response.dart';

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
}

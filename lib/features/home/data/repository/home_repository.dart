import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/home/data/model/response/homepage_top_matches_response.dart';
import 'package:walima_llc/features/home/data/model/response/profile_strength_response.dart';
import 'package:walima_llc/features/home/data/model/response/recent_visitors_response.dart';

class HomeRepository {
  static Future<HomepageTopMatchesResponse> getHomepageTopMatches() async {
    try {
      final response = await DioClient().get(
        AppUrls.getHomepageTopMatches,
        isTokenRequired: false,
      );
      return HomepageTopMatchesResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage =
          e is DioException ? _messageFromException(e) : e.toString();
      return HomepageTopMatchesResponse(
        code: 'FAILED',
        message: errorMessage,
      );
    }
  }

  static Future<RecentVisitorsResponse> getRecentVisitors({
    int page = 1,
    int size = 10,
    String responseFormat = 'short',
  }) async {
    try {
      final response = await DioClient().get(
        AppUrls.getRecentVisitors,
        isTokenRequired: true,
        queryParameters: {
          'page': page,
          'size': size,
          'responseFormat': responseFormat,
        },
      );
      return RecentVisitorsResponse.fromJson(
        response.data,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return RecentVisitorsResponse(
        code: 'FAILED',
        message: errorMessage,
        traceId: _traceIdFromException(e),
        statusCode: e is DioException ? e.response?.statusCode : 0,
      );
    }
  }

  static Future<RecentVisitorsResponse> getRecentlyViewed({
    int page = 1,
    int size = 10,
    String responseFormat = 'short',
  }) async {
    try {
      final response = await DioClient().get(
        AppUrls.getRecentlyViewed,
        isTokenRequired: true,
        queryParameters: {
          'page': page,
          'size': size,
          'responseFormat': responseFormat,
        },
      );
      return RecentVisitorsResponse.fromJson(
        response.data,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final errorMessage =
          e is DioException ? _messageFromException(e) : e.toString();
      return RecentVisitorsResponse(
        code: 'FAILED',
        message: errorMessage,
        traceId: _traceIdFromException(e),
        statusCode: e is DioException ? e.response?.statusCode : 0,
      );
    }
  }

  static Future<ProfileStrengthResponse> getProfileStrength() async {
    dynamic rawResponseData;
    try {
      final response = await DioClient().get(
        AppUrls.getProfileStrength,
        isTokenRequired: true,
      );
      rawResponseData = response.data;
      return ProfileStrengthResponse.fromJson(rawResponseData);
    } catch (e) {
      final responseData =
          e is DioException ? e.response?.data : rawResponseData;
      final responseMap = responseData is Map
          ? Map<String, dynamic>.from(responseData)
          : const <String, dynamic>{};
      final errorMessage = responseMap['message']?.toString() ??
          (e is DioException ? e.message : null) ??
          e.toString();
      return ProfileStrengthResponse(
        code: 'FAILED',
        message: errorMessage.toString(),
        traceId: responseMap['traceId']?.toString(),
      );
    }
  }
}

String? _traceIdFromException(Object error) {
  if (error is! DioException || error.response?.data is! Map) return null;
  return (error.response!.data as Map)['traceId']?.toString();
}

String _messageFromException(DioException error) {
  final data = error.response?.data;
  if (data is Map && data['message'] != null) {
    return data['message'].toString();
  }
  return error.message ?? 'Request failed';
}

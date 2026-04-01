import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/home/data/model/response/homepage_top_matches_response.dart';
import 'package:flutter_boilerplate/features/home/data/model/response/recent_visitors_response.dart';

class HomeRepository {
  static Future<HomepageTopMatchesResponse> getHomepageTopMatches() async {
    try {
      final response = await DioClient().get(
        AppUrls.getHomepageTopMatches,
        isTokenRequired: true,
      );
      return HomepageTopMatchesResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
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
      return RecentVisitorsResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return RecentVisitorsResponse(
        code: 'FAILED',
        message: errorMessage,
      );
    }
  }
}

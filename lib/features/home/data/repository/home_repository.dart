import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/home/data/model/response/homepage_top_matches_response.dart';

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
}

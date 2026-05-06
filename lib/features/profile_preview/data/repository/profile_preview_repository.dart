import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/profile_preview/data/models/profile_compare_response.dart';
import 'package:walima_llc/features/profile_preview/data/models/profile_preview_response.dart';

class ProfilePreviewRepository {
  static Future<ProfilePreviewResponse> getProfilePreview(String userId) async {
    try {
      final endpoint =
          AppUrls.getMatchPreview.replaceFirst('{userId}', userId);
      final response = await DioClient().get(
        endpoint,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ProfilePreviewResponse(
          code: 'FAILED',
          message: response.message,
        );
      }

      return ProfilePreviewResponse.fromJson(response.data);
    } catch (e) {
      return ProfilePreviewResponse(
        code: 'FAILED',
        message: _extractErrorMessage(e),
      );
    }
  }

  static Future<ProfileCompareResponse> getProfileCompare(String userId) async {
    try {
      final endpoint =
          AppUrls.getMatchCompare.replaceFirst('{userId}', userId);
      final response = await DioClient().get(
        endpoint,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ProfileCompareResponse(
          code: 'FAILED',
          message: response.message,
        );
      }

      return ProfileCompareResponse.fromJson(response.data);
    } catch (e) {
      return ProfileCompareResponse(
        code: 'FAILED',
        message: _extractErrorMessage(e),
      );
    }
  }

  static String? _extractErrorMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return e.message;
    }
    return e.toString();
  }
}

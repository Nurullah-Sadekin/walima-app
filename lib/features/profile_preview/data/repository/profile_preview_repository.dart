import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/profile_preview/data/models/profile_preview_response.dart';

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
      String? errorMessage;
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'].toString();
        } else {
          errorMessage = e.message;
        }
      } else {
        errorMessage = e.toString();
      }
      return ProfilePreviewResponse(
        code: 'FAILED',
        message: errorMessage,
      );
    }
  }
}

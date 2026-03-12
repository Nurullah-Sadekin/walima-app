import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/profile/data/model/get_complete_profile_response.dart';

class ProfileRepository {
  static Future<GetCompleteProfileResponse> getCompleteProfile() async {
    try {
      final response = await DioClient().get(AppUrls.getCompleteProfile, isTokenRequired: true);
      return GetCompleteProfileResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return GetCompleteProfileResponse(code: 'FAILED', message: errorMessage);
    }
  }
}

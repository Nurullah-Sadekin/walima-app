import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/dashboard_response.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/get_complete_profile_response.dart';

class ProfileRepository {
  static Future<GetCompleteProfileResponse> getCompleteProfile() async {
    try {
      final response = await DioClient()
          .get(AppUrls.getCompleteProfile, isTokenRequired: true);
      return GetCompleteProfileResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return GetCompleteProfileResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<DashboardResponse> getDashboard() async {
    try {
      final response = await DioClient().get(AppUrls.getUserDashboard, isTokenRequired: true);
      return DashboardResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return DashboardResponse(code: 'FAILED', message: errorMessage);
    }
  }
}

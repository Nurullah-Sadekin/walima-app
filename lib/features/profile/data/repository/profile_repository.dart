import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/profile/data/model/request/update_profile_section_request_body.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/dashboard_response.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/update_profile_section_response.dart';

class ProfileRepository {
  static Future<GetCompleteProfileResponse> getCompleteProfile() async {
    try {
      final response = await DioClient().get(AppUrls.getCompleteProfile,
          isTokenRequired: true);
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
      final response = await DioClient()
          .get(AppUrls.getUserDashboard, isTokenRequired: true);
      return DashboardResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return DashboardResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<UpdateProfileSectionResponse> updateUniversalProfile(
    UpdateProfileSectionRequestBody body,
  ) async {
    return updateProfileByEndpoint(
      endpoint: AppUrls.universalProfileUpdate,
      body: body,
    );
  }

  static Future<UpdateProfileSectionResponse> updateProfileByEndpoint({
    required String endpoint,
    required UpdateProfileSectionRequestBody body,
  }) async {
    try {
      final payload = body.toJson();
      if (payload.isEmpty) {
        return UpdateProfileSectionResponse(
          code: 'SUCCESS',
          message: 'No changes to update',
        );
      }

      final response = await DioClient().put(
        endpoint,
        data: payload,
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return UpdateProfileSectionResponse.fromJson(data);
      }

      if (data is Map) {
        return UpdateProfileSectionResponse.fromJson(
          Map<String, dynamic>.from(data),
        );
      }

      return UpdateProfileSectionResponse(
        code: 'FAILED',
        message: 'Failed to update profile',
      );
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return UpdateProfileSectionResponse(
        code: 'FAILED',
        message: errorMessage,
      );
    }
  }
}

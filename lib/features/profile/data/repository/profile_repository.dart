import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/profile/data/model/request/update_profile_photo_request.dart';
import 'package:walima_llc/features/profile/data/model/request/update_profile_section_request_body.dart';
import 'package:walima_llc/features/profile/data/model/response/dashboard_response.dart';
import 'package:walima_llc/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:walima_llc/features/profile/data/model/response/update_profile_section_response.dart';

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

  static Future<UpdateProfileSectionResponse> updateProfilePhotos(
    List<UpdateProfilePhotoRequest> photos,
  ) async {
    try {
      final payload = photos.map((photo) => photo.toJson()).toList();
      final response = await DioClient().put(
        AppUrls.updateProfilePhotos,
        data: payload,
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final normalized = <String, dynamic>{...data};
        normalized['code'] = normalized['code']?.toString() ?? 'SUCCESS';
        normalized['response'] = normalized['response'] ?? normalized['data'];
        return UpdateProfileSectionResponse.fromJson(normalized);
      }

      if (data is Map) {
        final normalized = Map<String, dynamic>.from(data);
        normalized['code'] = normalized['code']?.toString() ?? 'SUCCESS';
        normalized['response'] = normalized['response'] ?? normalized['data'];
        return UpdateProfileSectionResponse.fromJson(
          normalized,
        );
      }

      return UpdateProfileSectionResponse(
        code: 'FAILED',
        message: 'Failed to update profile photos',
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

  static Future<UpdateProfileSectionResponse> updateProfileContacts(
    List<Map<String, dynamic>> contacts,
  ) async {
    try {
      final response = await DioClient().put(
        AppUrls.updateProfileContacts,
        data: contacts,
        isTokenRequired: true,
      );
      final data = response.data;
      if (data is Map) {
        final normalized = Map<String, dynamic>.from(data);
        normalized['code'] = normalized['code']?.toString() ?? 'SUCCESS';
        normalized['response'] = normalized['response'] ?? normalized['data'];
        return UpdateProfileSectionResponse.fromJson(normalized);
      }
      return UpdateProfileSectionResponse(
        code: 'FAILED',
        message: 'Failed to update contact information',
      );
    } catch (e) {
      final responseData = e is DioException ? e.response?.data : null;
      final message =
          responseData is Map ? responseData['message']?.toString() : null;
      return UpdateProfileSectionResponse(
        code: 'FAILED',
        message:
            message ?? (e is DioException ? e.message : null) ?? e.toString(),
      );
    }
  }
}

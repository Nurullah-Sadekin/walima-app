import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/recommended_preferences/data/models/request/update_preferences_request_body.dart';
import 'package:walima_llc/features/recommended_preferences/data/models/response/update_preferences_response.dart';

class PreferencesRepository {
  Future<UpdatePreferencesResponse> updatePreferences(
      UpdatePreferencesRequestBody body) async {
    try {
      final response = await DioClient().put(
        AppUrls.updatePreferences,
        data: body.toJson(),
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return UpdatePreferencesResponse.fromJson(data);
      }
      if (data is Map) {
        return UpdatePreferencesResponse.fromJson(
            Map<String, dynamic>.from(data));
      }

      return UpdatePreferencesResponse(
        code: 'FAILED',
        message: 'Failed to update preferences',
      );
    } catch (e) {
      return UpdatePreferencesResponse(
        code: 'FAILED',
        message: e.toString(),
      );
    }
  }
}

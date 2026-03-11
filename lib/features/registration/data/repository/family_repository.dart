import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/update_family_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/response/update_family_response.dart';

class FamilyRepository {
  Future<UpdateFamilyResponse> updateFamily(
      UpdateFamilyRequestBody body) async {
    try {
      final response = await DioClient().put(
        AppUrls.updateFamily,
        data: body.toJson(),
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return UpdateFamilyResponse.fromJson(data);
      }
      if (data is Map) {
        return UpdateFamilyResponse.fromJson(Map<String, dynamic>.from(data));
      }

      return UpdateFamilyResponse(
        code: 'FAILED',
        message: 'Failed to update family information',
      );
    } catch (e) {
      return UpdateFamilyResponse(
        code: 'FAILED',
        message: e.toString(),
      );
    }
  }
}

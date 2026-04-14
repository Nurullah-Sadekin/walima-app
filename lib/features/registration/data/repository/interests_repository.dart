import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/update_interests_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/response/update_interests_response.dart';

class InterestsRepository {
  Future<UpdateInterestsResponse> updateInterests(
      UpdateInterestsRequestBody body) async {
    try {
      final response = await DioClient().put(
        AppUrls.updateHobbiesInterest,
        data: body.toJson(),
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return UpdateInterestsResponse.fromJson(data);
      }
      if (data is Map) {
        return UpdateInterestsResponse.fromJson(
            Map<String, dynamic>.from(data));
      }

      return UpdateInterestsResponse(
        code: 'FAILED',
        message: 'Failed to update interests',
      );
    } catch (e) {
      return UpdateInterestsResponse(
        code: 'FAILED',
        message: e.toString(),
      );
    }
  }
}

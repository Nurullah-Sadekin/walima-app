import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/plans/data/models/get_plans_response.dart';

class PlanRepository {
  static Future<GetPlansResponse> getAllPlans() async {
    try {
      final response = await DioClient().get(AppUrls.getAllPlans);
      return GetPlansResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return GetPlansResponse(code: 'FAILED', message: errorMessage);
    }
  }
}
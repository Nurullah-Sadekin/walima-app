import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/plans/data/models/get_plans_response.dart';
import 'package:flutter_boilerplate/features/plans/data/models/initiate_payment_request.dart';
import 'package:flutter_boilerplate/features/plans/data/models/initiate_payment_response.dart';
import 'package:flutter_boilerplate/features/plans/data/models/upgrade_quote_request.dart';
import 'package:flutter_boilerplate/features/plans/data/models/upgrade_quote_response.dart';

class PlanRepository {
  static Future<GetPlansResponse> getAllPlans() async {
    try {
      final response = await DioClient().get(AppUrls.getAllPlans);
      return GetPlansResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return GetPlansResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<UpgradeQuoteResponse> getUpgradeQuote(
    UpgradeQuoteRequestBody body,
  ) async {
    try {
      final response = await DioClient().post(
        AppUrls.paymentsUpgradeQuote,
        data: body.toJson(),
        isTokenRequired: true,
      );
      return UpgradeQuoteResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return UpgradeQuoteResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<InitiatePaymentResponse> initiatePayment(
    InitiatePaymentRequestBody body,
  ) async {
    try {
      final response = await DioClient().post(
        AppUrls.paymentsInitiate,
        data: body.toJson(),
        isTokenRequired: true,
      );
      return InitiatePaymentResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return InitiatePaymentResponse(code: 'FAILED', message: errorMessage);
    }
  }
}

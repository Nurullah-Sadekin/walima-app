import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/plans/data/models/get_current_subscription_response.dart';
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

  static Future<InitiatePaymentResponse> initiateUpgradePayment(
    InitiatePaymentRequestBody body,
  ) async {
    try {
      final response = await DioClient().post(
        AppUrls.paymentsInitiateUpgrade,
        data: <String, dynamic>{
          'gateway': body.gateway,
          'targetPlanId': body.planId,
          'billingCycle': body.billingCycle,
        },
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

  static Future<GetCurrentSubscriptionResponse> getCurrentSubscription() async {
    try {
      final response = await DioClient().get(
        AppUrls.paymentsSubscription,
        isTokenRequired: true,
      );
      return GetCurrentSubscriptionResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return GetCurrentSubscriptionResponse(
        code: 'FAILED',
        message: errorMessage,
      );
    }
  }

  static Future<bool> confirmSslCommerzCallback({
    required String transactionId,
    required String valId,
    required String tranId,
    String status = 'success',
    String tranType = 'success',
  }) async {
    try {
      final response = await DioClient().get(
        AppUrls.paymentsSslCommerzCallback,
        queryParameters: <String, dynamic>{
          'transactionId': transactionId,
          'val_id': valId,
          'tran_id': tranId,
          'status': status,
          'tran_type': tranType,
        },
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final code = (data['code'] as String?)?.trim().toUpperCase();
        if (code != null && code.isNotEmpty && code != 'SUCCESS') {
          return false;
        }

        final directReceived = data['received'];
        if (directReceived is bool) {
          return directReceived;
        }

        final nestedResponse = data['response'];
        if (nestedResponse is Map<String, dynamic>) {
          final nestedReceived = nestedResponse['received'];
          if (nestedReceived is bool) {
            return nestedReceived;
          }
        }

        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> notifySslCommerzWebhook({
    required String transactionId,
    required String status,
  }) async {
    try {
      final response = await DioClient().post(
        AppUrls.paymentsSslCommerzWebhook,
        data: <String, dynamic>{
          'tran_id': transactionId,
          'status': status,
        },
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final nestedResponse = data['response'];
        final receivedValue = data['received'] ??
            (nestedResponse is Map<String, dynamic>
                ? nestedResponse['received']
                : null);
        return receivedValue == true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}

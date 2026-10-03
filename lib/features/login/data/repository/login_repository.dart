import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/login/data/models/get_me_response_body.dart';
import 'package:walima_llc/features/login/data/models/login_body.dart';
import 'package:walima_llc/features/login/data/models/login_response.dart';
import 'package:walima_llc/features/login/data/models/login_with_otp_body.dart';
import 'package:walima_llc/features/login/data/models/otp_verify_body.dart';
import 'package:walima_llc/features/login/data/models/resend_otp_body.dart';
import 'package:walima_llc/features/login/data/models/set_password_body.dart';

class LoginRepository {
  static Future<LoginResponse> login(LoginBody body) async {
    try {
      final response =
          await DioClient().post(AppUrls.login, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<GetMeResponseBody> getMe() async {
    try {
      final response =
          await DioClient().get(AppUrls.getMe, isTokenRequired: true);
      return GetMeResponseBody.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return GetMeResponseBody(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> loginWithOtp(
    LoginWithOtpBody body, {
    bool isForgotPass = false,
  }) async {
    try {
      final response = await DioClient().post(
        isForgotPass ? AppUrls.forgotPassword : AppUrls.loginWithOTP,
        data: body.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> verifyOtp(OtVerifyBody body) async {
    try {
      final response =
          await DioClient().post(AppUrls.verifyOTP, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> resendOtp(ResendOtpBody body) async {
    try {
      final response =
          await DioClient().post(AppUrls.resendOTP, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> setNewPassword(SetPasswordBody body) async {
    try {
      final response = await DioClient()
          .post(
            AppUrls.setPasswordWithOTP,
            data: body.toJson(),
            acceptedStatusCodes: {400},
          );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> signInWithGoogle({
    required String idToken,
  }) async {
    try {
      final response = await DioClient().post(
        AppUrls.googleSignin,
        data: <String, dynamic>{
          'idToken': idToken.trim(),
          'provider': 'google',
        },
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> signInWithApple({
    required String idToken,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await DioClient().post(
        AppUrls.appleSignin,
        data: <String, dynamic>{
          'idToken': idToken.trim(),
          if (firstName != null && firstName.trim().isNotEmpty)
            'firstName': _limit(firstName.trim(), 100),
          if (lastName != null && lastName.trim().isNotEmpty)
            'lastName': _limit(lastName.trim(), 100),
          'registrationSource': 'apple',
        },
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      return LoginResponse(code: 'FAILED', message: _appleErrorMessage(e));
    }
  }

  static String _limit(String value, int maxLength) =>
      value.length > maxLength ? value.substring(0, maxLength) : value;

  static String _appleErrorMessage(Object error) {
    if (error is! DioException) {
      return 'Apple sign-in failed. Please try again.';
    }
    final data = error.response?.data;
    final serverMessage = data is Map && data['message'] is String
        ? data['message'] as String
        : null;
    final statusCode = error.response?.statusCode;
    if (statusCode == null) {
      return 'Unable to reach the server. '
          'Please check your connection and try again.';
    }
    if (statusCode == 429) {
      return 'Too many sign-in attempts. Please wait a moment and try again.';
    }
    if (statusCode >= 500) {
      return 'Something went wrong on our side. Please try again later.';
    }
    if (statusCode == 401) {
      return serverMessage ?? 'Your Apple sign-in could not be accepted.';
    }
    return serverMessage ?? 'Apple sign-in failed. Please try again.';
  }
}

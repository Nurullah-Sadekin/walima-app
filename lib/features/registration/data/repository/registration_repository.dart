import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_response.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/register_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/sign_up_otp_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/sign_up_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/response/email_availability_response.dart';
import 'package:flutter_boilerplate/features/registration/data/models/response/onboarding_response.dart';
import 'package:flutter_boilerplate/features/registration/data/models/response/phone_availability_response.dart';
import 'package:flutter_boilerplate/features/registration/data/models/response/sign_up_otp_response.dart';

class RegistrationRepository {
  late final DioClient dioClient;

  static Future<LoginResponse> signUpWithEmail(RegisterBody body) async {
    try {
      final response = await DioClient().post(AppUrls.register, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<SignUpOtpResponse> signUpWithOTP(SignUpOtpBody body) async {
    try {
      final response = await DioClient().post(AppUrls.signUpWithOTP, data: body.toJson());
      return SignUpOtpResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return SignUpOtpResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<OnboardingResponse> signUpCreateUserProfile(SignUpRequestBody body) async {
    try {
      final response = await DioClient().post(AppUrls.signUpCreateUserProfile, data: body.toJson());
      return OnboardingResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return OnboardingResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<EmailAvailAbilityResponse> checkEmail(String email) async {
    try {
      final response = await DioClient().get(AppUrls.checkEmailAvailability, queryParameters: {'email': email});
      return EmailAvailAbilityResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return EmailAvailAbilityResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> checkUserName(String userName) async {
    try {
      final response = await DioClient().get(AppUrls.checkUserNameAvailability, queryParameters: {'keyword': userName});
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<PhoneAvailabilityResponse> checkMobile(String mobile) async {
    try {
      final response = await DioClient().get(AppUrls.checkNumberAvailability, queryParameters: {'phoneNumber': mobile});
      return PhoneAvailabilityResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return PhoneAvailabilityResponse(code: 'FAILED', message: errorMessage);
    }
  }
}

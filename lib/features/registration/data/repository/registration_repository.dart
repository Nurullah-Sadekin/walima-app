import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_response.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/register_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/sign_up_otp_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/sign_up_request_body.dart';

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

  static Future<LoginResponse> signUpWithOTP(SignUpOtpBody body) async {
    try {
      final response = await DioClient().post(AppUrls.signUpWithOTP, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> signUpCreateUserProfile(SignUpRequestBody body) async {
    try {
      final response = await DioClient().post(AppUrls.signUpCreateUserProfile, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }
  static Future<LoginResponse> checkEmail(String email) async {
    try {
      final response = await DioClient().get(AppUrls.checkEmailAvailability);
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }
  static Future<LoginResponse> checkUserName(String userName) async {
    try {
      final response = await DioClient().get(AppUrls.checkUserNameAvailability);
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }
  static Future<LoginResponse> checkMobile(String mobile) async {
    try {
      final response = await DioClient().get(AppUrls.checkNumberAvailability);
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }
}

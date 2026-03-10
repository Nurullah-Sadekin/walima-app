import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_body.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_response.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_with_otp_body.dart';

class LoginRepository {
  late final DioClient dioClient;
  
  static Future<LoginResponse> login(LoginBody body) async {
    try {
      final response = await DioClient().post(AppUrls.login, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage =  e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> getMe() async {
    try {
      final response = await DioClient().get(AppUrls.getMe, isTokenRequired: true);
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage =  e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> loginWithOtp(LoginWithOtpBody body) async {
    try {
      final response = await DioClient().post(AppUrls.loginWithOTP, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage =  e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }
}

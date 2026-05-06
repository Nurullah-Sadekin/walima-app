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
  late final DioClient dioClient;

  static Future<LoginResponse> login(LoginBody body) async {
    try {
      final response = await DioClient().post(AppUrls.login, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<GetMeResponseBody> getMe() async {
    try {
      final response = await DioClient().get(AppUrls.getMe, isTokenRequired: true);
      return GetMeResponseBody.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return GetMeResponseBody(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> loginWithOtp(LoginWithOtpBody body,{bool isForgotPass = false}) async {
    try {
      final response = await DioClient().post(isForgotPass? AppUrls.forgotPassword: AppUrls.loginWithOTP, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> verifyOtp(OtVerifyBody body) async {
    try {
      final response = await DioClient().post(AppUrls.verifyOTP, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> resendOtp(ResendOtpBody body) async {
    try {
      final response = await DioClient().post(AppUrls.resendOTP, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<LoginResponse> setNewPassword(SetPasswordBody body) async {
    try {
      final response = await DioClient().post(AppUrls.setPasswordWithOTP, data: body.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return LoginResponse(code: 'FAILED', message: errorMessage);
    }
  }
}

class AppUrls{
  static const String baseUrl = 'https://dev.walima.app';
  static const String login = '$baseUrl/api/v1/auth/signin-with-password';
  static const String getMe = '$baseUrl/api/v1/auth/me';
  static const String register = '$baseUrl/api/v1/auth/register';
  static const String signinWithPassword = '$baseUrl/api/v1/auth/signin-with-password';
  static const String signinWithOTP = '$baseUrl/api/v1/auth/signin-with-otp';
  static const String signUpWithOTP = '$baseUrl/api/v1/auth/sign-up-with-otp';
  static const String verifyOTP = '$baseUrl/api/v1/auth/verify-otp';
  static const String resendOTP = '$baseUrl/api/v1/auth/resend-otp';
  static const String forgotPassword = '$baseUrl/api/v1/auth/forgot-password';
  static const String setPasswordWithOTP = '$baseUrl/api/v1/auth/set-password-with-otp';
  static const String createPassword = '$baseUrl/api/v1/auth/create-password';
  static const String changePassword = '$baseUrl/api/v1/auth/change-password';
  static const String refreshToken = '$baseUrl/api/v1/auth/refresh-token';
  static const String googleSignin = '$baseUrl/api/v1/auth/google/signin';
}
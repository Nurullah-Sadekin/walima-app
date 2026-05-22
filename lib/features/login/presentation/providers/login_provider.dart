import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/app_error_reporting_service.dart';
import 'package:walima_llc/core/utils/firebase_messaging_service.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/core/utils/social_sign_in_service.dart';
import 'package:walima_llc/core/utils/validators.dart';
import 'package:walima_llc/features/login/data/models/login_body.dart';
import 'package:walima_llc/features/login/data/models/login_response.dart';
import 'package:walima_llc/features/login/data/models/login_with_otp_body.dart';
import 'package:walima_llc/features/login/data/models/otp_verify_body.dart';
import 'package:walima_llc/features/login/data/models/resend_otp_body.dart';
import 'package:walima_llc/features/login/data/models/set_password_body.dart';
import 'package:walima_llc/features/login/data/repository/login_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walima_llc/core/constants/storage_keys.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/chat/data/socket/socket_service.dart';

class LoginProvider extends BaseChangeNotifier {
  static const String _mobileOrEmailRequiredMessage =
      'Please enter your mobile number or email ID';
  static const String _passwordRequiredMessage = 'Please enter your password';
  static const String _otpIncompleteMessage = 'Please enter the complete OTP';

  LoginScreenStates screenStates = LoginScreenStates.defaultState;
  LoginScreenStates loaderState = LoginScreenStates.defaultState;
  bool isLoading = false;
  VoidCallback? _controllersListener;

  bool keepMeLoggedIn = false;
  bool forgotPassword = false;

  final TextEditingController mobileNoOrEmailController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController createPasswordController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String mobileOrEmailError = '';
  String passwordError = '';
  List<TextEditingController> otpControllers = [];
  List<FocusNode> otpFocusNodesController = [];
  String createPasswordError = '';
  String confirmPasswordError = '';
  String otpCode = '';

  List<TextEditingController> get _managedControllers => [
        mobileNoOrEmailController,
        passwordController,
        otpController,
        createPasswordController,
        confirmPasswordController,
      ];

  Future<void> getInitialData() async {
    _clearValidationErrors();
  }

  void initOtpFields({int length = 5}) {
    disposeOtpFields();

    otpControllers = List.generate(length, (_) => TextEditingController());
    otpFocusNodesController = List.generate(length, (_) => FocusNode());

    for (final c in otpControllers) {
      _addListenerSafely(c, notifyListeners);
    }

    notifyListeners();
  }

  void disposeOtpFields({bool notify = true}) {
    for (final c in otpControllers) {
      _disposeSafely(c);
    }

    for (final f in otpFocusNodesController) {
      _disposeSafely(f);
    }

    otpControllers = [];
    otpFocusNodesController = [];

    if (notify) {
      notifyListeners();
    }
  }

  void initControllersListener() {
    if (_controllersListener != null) return;

    _controllersListener = () => notifyListeners();

    for (final controller in _managedControllers) {
      _addListenerSafely(controller, _controllersListener!);
    }
  }

  void disposeControllersListener() {
    if (_controllersListener == null) return;

    for (final controller in _managedControllers) {
      _removeListenerSafely(controller, _controllersListener!);
    }

    _controllersListener = null;
  }

  void updateViewState({
    LoginScreenStates? screenStates,
    LoginScreenStates? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = LoginScreenStates.defaultState;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    _setRequiredFieldErrors();
    final canSubmit = _validateInputsForSubmit();
    updateViewState();
    if (!canSubmit) {
      return;
    }

    _showLoading();
    final response = await _performLoginRequest();
    if (!context.mounted) return;
    await _handleLoginResult(context, response);
  }

  Future<void> otpValidate(BuildContext context) async {
    if (otpControllers.any((c) => c.text.isEmpty)) {
      DialogUtils.showErrorDialog(
        context: context,
        message: _otpIncompleteMessage,
      );
      return;
    }

    final otp = otpControllers.map((c) => c.text).join();
    _showLoading();
    final body = OtVerifyBody(
      identifier: mobileNoOrEmailController.text,
      otpCode: otp,
      purpose: _authPurpose,
    );
    final response = await LoginRepository.verifyOtp(body);
    if (!context.mounted) return;
    if (response.code != 'SUCCESS') {
      _handleLoginFailure(context, response.message);
      return;
    }
    if (context.mounted && forgotPassword) {
      otpCode = otp;
      createPasswordController.clear();
      confirmPasswordController.clear();
      _hideLoading();
      context.push(Paths.newPassword);
    } else if (context.mounted && !forgotPassword) {
      await _handleLoginResult(context, response);
    }
  }

  Future<void> setNewPassword(BuildContext context) async {
    _showLoading();
    if (validateNewPassword() == false) {
      _hideLoading();
      return;
    }
    final body = SetPasswordBody(
      identifier: mobileNoOrEmailController.text,
      otpCode: otpCode,
      newPassword: createPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );
    final response = await LoginRepository.setNewPassword(body);
    if (!context.mounted) return;
    _handleLoginResult(context, response);
  }

  Future<void> resendOtp(BuildContext context) async {
    otpCode = '';
    otpController.clear();
    for (final c in otpControllers) {
      c.clear();
    }
    _showLoading();
    final body = ResendOtpBody(
      identifier: mobileNoOrEmailController.text,
      purpose: _authPurpose,
    );
    final response = await LoginRepository.resendOtp(body);
    _hideLoading();
    if (!context.mounted) return;
    final isSuccess = response.code == 'SUCCESS';
    _showResendSnackBar(
      context,
      message:
          response.message ?? (isSuccess ? 'OTP sent' : 'Failed to resend OTP'),
      isSuccess: isSuccess,
    );
  }

  void _showResendSnackBar(
    BuildContext context, {
    required String message,
    required bool isSuccess,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isSuccess ? AppColors.success : AppColors.error,
          duration: const Duration(seconds: 2),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  Future<void> loginWithOtp(BuildContext context) async {
    _setRequiredFieldErrors();
    final canSubmit = validateOtpInputs();
    updateViewState();
    if (!canSubmit) {
      return;
    }
    _showLoading();
    final body = LoginWithOtpBody(identifier: mobileNoOrEmailController.text);
    final response =
        await LoginRepository.loginWithOtp(body, isForgotPass: forgotPassword);
    if (!context.mounted) return;
    if (response.code != 'SUCCESS') {
      mobileOrEmailError = '';
      _handleLoginFailure(context, response.message);
      return;
    }
    await _gotoOtpVerificationScreen(context);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    _showLoading();
    try {
      final result = await SocialSignInService.signInWithGoogle();
      if (result == null) {
        _hideLoading();
        return;
      }

      final response = await LoginRepository.signInWithGoogle(
        idToken: result.idToken,
        accessToken: result.accessToken,
        serverAuthCode: result.serverAuthCode,
      );
      if (!context.mounted) return;
      await _handleLoginResult(context, response);
    } catch (e) {
      _hideLoading();
      if (!context.mounted) return;
      DialogUtils.showErrorDialog(
        context: context,
        message: e.toString(),
      );
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    if (kIsWeb || !(Platform.isIOS || Platform.isMacOS)) {
      DialogUtils.showErrorDialog(
        context: context,
        message: 'Apple sign-in is only available on iOS devices.',
      );
      return;
    }

    _showLoading();
    try {
      final result = await SocialSignInService.signInWithApple();
      if (result == null) {
        _hideLoading();
        return;
      }

      final response = await LoginRepository.signInWithApple(
        identityToken: result.identityToken,
        authorizationCode: result.authorizationCode,
        nonce: result.nonce,
        email: result.email,
        givenName: result.givenName,
        familyName: result.familyName,
      );
      if (!context.mounted) return;
      await _handleLoginResult(context, response);
    } on SignInWithAppleAuthorizationException catch (e) {
      _hideLoading();
      if (!context.mounted) return;
      if (e.code == AuthorizationErrorCode.canceled) return;
      final message = e.message;
      DialogUtils.showErrorDialog(
        context: context,
        message: message.isNotEmpty
            ? message
            : 'Apple sign-in failed. Please try again.',
      );
    } catch (e) {
      _hideLoading();
      if (!context.mounted) return;
      DialogUtils.showErrorDialog(
        context: context,
        message: e.toString(),
      );
    }
  }

  Future<void> _gotoOtpVerificationScreen(BuildContext context) async {
    _hideLoading();
    if (context.mounted) {
      context.push(Paths.otpVerify);
    }
  }

  bool validateOtpInputs() {
    if (_hasEmptyMobileOrEmail()) {
      mobileOrEmailError = _mobileOrEmailRequiredMessage;
      updateViewState();
      return false;
    }
    final mobileOrEmailValidation =
        Validators.validateMobileOrEmail(mobileNoOrEmailController.text);
    if (mobileOrEmailValidation != null) {
      mobileOrEmailError = mobileOrEmailValidation;
      updateViewState();
      return false;
    }

    return true;
  }

  void _setRequiredFieldErrors() {
    if (_hasEmptyMobileOrEmail()) {
      mobileOrEmailError = _mobileOrEmailRequiredMessage;
    } else {
      mobileOrEmailError = '';
    }
    if (passwordController.text.isEmpty) {
      passwordError = _passwordRequiredMessage;
    }
  }

  bool _validateInputsForSubmit() {
    return validateInputs();
  }

  LoginBody _buildLoginBody() {
    return LoginBody(
      identifier: mobileNoOrEmailController.text,
      password: passwordController.text,
    );
  }

  Future<LoginResponse> _performLoginRequest() async {
    final body = _buildLoginBody();
    return LoginRepository.login(body);
  }

  Future<void> _handleLoginResult(
    BuildContext context,
    LoginResponse response,
  ) async {
    final hasAuthTokens = _hasAuthTokens(response);

    if (response.code == 'SUCCESS' && hasAuthTokens) {
      await _persistAuthTokens(response);
      await AppErrorReportingService.instance.setUserContext(
        userId: response.response?.user?.id,
        email: response.response?.user?.email,
        phone: response.response?.user?.phoneNumber?.toString(),
      );
      if (!context.mounted) return;
      unawaited(FirebaseMessagingService.instance.registerDeviceToken());
      _handleLoginSuccess(context);
      return;
    }

    _handleLoginFailure(
      context,
      response.message ?? 'Login failed. Please try again.',
    );
  }

  bool _hasAuthTokens(LoginResponse response) {
    final accessToken = response.response?.accessToken?.trim() ?? '';
    final refreshToken = response.response?.refreshToken?.trim() ?? '';
    return accessToken.isNotEmpty && refreshToken.isNotEmpty;
  }

  Future<void> _persistAuthTokens(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = response.response?.accessToken?.trim() ?? '';
    final refreshToken = response.response?.refreshToken?.trim() ?? '';

    await _saveAccessToken(prefs, accessToken);
    await _saveRefreshToken(prefs, refreshToken);
  }

  Future<void> _saveAccessToken(
    SharedPreferences prefs,
    String accessToken,
  ) async {
    await prefs.setString(StorageKeys.accessToken, accessToken);
    try {
      DioClient().setAuthToken(accessToken);
    } catch (_) {}
    await SocketService.instance.connect(token: accessToken);
  }

  Future<void> _saveRefreshToken(
    SharedPreferences prefs,
    String refreshToken,
  ) async {
    await prefs.setString(StorageKeys.refreshToken, refreshToken);
  }

  void _handleLoginSuccess(BuildContext context) {
    clearControllers();
    updateViewState(screenStates: LoginScreenStates.defaultState);
    if (context.mounted) {
      context.push(Paths.anchor);
    }
  }

  void clearControllers() {
    mobileNoOrEmailController.clear();
    passwordController.clear();
    otpController.clear();
    createPasswordController.clear();
    confirmPasswordController.clear();
    otpCode = '';
  }

  void _handleLoginFailure(BuildContext context, String? message) {
    _hideLoading();
    if (context.mounted) {
      DialogUtils.showErrorDialog(
        context: context,
        message: message ?? 'Login failed. Please try again.',
      );
    }
  }

  bool validateInputs() {
    final hasValidMobileOrEmail = _validateMobileOrEmail();
    if (!hasValidMobileOrEmail) {
      return false;
    }

    final hasValidPassword = _validatePassword();
    if (!hasValidPassword) {
      return false;
    }

    _clearValidationErrors();
    return true;
  }

  bool _validateMobileOrEmail() {
    final mobileOrEmailValidation =
        Validators.validateMobileOrEmail(mobileNoOrEmailController.text);
    if (mobileOrEmailValidation != null) {
      mobileOrEmailError = mobileOrEmailValidation;
      updateViewState();
      return false;
    }
    return true;
  }

  bool _hasEmptyMobileOrEmail() {
    return mobileNoOrEmailController.text.isEmpty;
  }

  bool _validatePassword() {
    final passwordValidation =
        Validators.validatePassword(passwordController.text);
    if (passwordValidation != null) {
      passwordError = passwordValidation;
      updateViewState();
      return false;
    }
    return true;
  }

  void _clearValidationErrors() {
    mobileOrEmailError = '';
    passwordError = '';
  }

  String get _authPurpose => forgotPassword ? 'password_reset' : 'signin';

  void _showLoading() {
    updateViewState(loadingState: LoginScreenStates.transparentLoading);
  }

  void _hideLoading() {
    updateViewState(loadingState: LoginScreenStates.defaultState);
  }

  void _addListenerSafely(
    TextEditingController controller,
    VoidCallback listener,
  ) {
    try {
      controller.addListener(listener);
    } catch (_) {}
  }

  void _removeListenerSafely(
    TextEditingController controller,
    VoidCallback listener,
  ) {
    try {
      controller.removeListener(listener);
    } catch (_) {}
  }

  void _disposeSafely(ChangeNotifier notifier) {
    try {
      notifier.dispose();
    } catch (_) {}
  }

  bool validateNewPassword() {
    final createPasswordValidation =
        Validators.validatePassword(createPasswordController.text);
    if (createPasswordValidation != null) {
      createPasswordError = createPasswordValidation;
      updateViewState();
      return false;
    }
    createPasswordError = '';
    if (createPasswordController.text != confirmPasswordController.text) {
      confirmPasswordError = 'Confirm password does not match';
      updateViewState();
      return false;
    }
    confirmPasswordError = '';
    return true;
  }
}

enum LoginScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}

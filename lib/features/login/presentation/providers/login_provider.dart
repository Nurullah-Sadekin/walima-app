import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/core/utils/validators.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_body.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_response.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_with_otp_body.dart';
import 'package:flutter_boilerplate/features/login/data/models/otp_verify_body.dart';
import 'package:flutter_boilerplate/features/login/data/models/resend_otp_body.dart';
import 'package:flutter_boilerplate/features/login/data/models/set_password_body.dart';
import 'package:flutter_boilerplate/features/login/data/repository/login_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_boilerplate/core/constants/storage_keys.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';

class LoginProvider extends BaseChangeNotifier {
  LoginScreenStates screenStates = LoginScreenStates.defaultState;
  LoginScreenStates loaderState = LoginScreenStates.defaultState;
  bool isLoading = false;
  VoidCallback? _controllersListener;

  bool keepMeLoggedIn = false;
  bool forgotPassword = false;

  final TextEditingController mobileNoOrEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController createPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String mobileOrEmailError = '';
  String passwordError = '';
  List<TextEditingController> otpControllers = [];
  List<FocusNode> otpFocusNodesController = [];
  String createPasswordError = '';
  String confirmPasswordError = '';
  String otpCode = '';

  Future<void> getInitialData() async {
    _clearValidationErrors();
  }

  void initOtpFields({int length = 5}) {
    disposeOtpFields();

    otpControllers = List.generate(length, (_) => TextEditingController());
    otpFocusNodesController = List.generate(length, (_) => FocusNode());

    for (final c in otpControllers) {
      try {
        c.addListener(() => notifyListeners());
      } catch (_) {}
    }

    notifyListeners();
  }

  void disposeOtpFields({bool notify = true}) {
    if (otpControllers.isNotEmpty) {
      for (final c in otpControllers) {
        try {
          c.dispose();
        } catch (_) {}
      }
      otpControllers = [];
    }
    if (otpFocusNodesController.isNotEmpty) {
      for (final f in otpFocusNodesController) {
        try {
          f.dispose();
        } catch (_) {}
      }
      otpFocusNodesController = [];
    }

    if (notify) {
      notifyListeners();
    }
  }

  void initControllersListener() {
    if (_controllersListener != null) return;

    _controllersListener = () => notifyListeners();

    try {
      mobileNoOrEmailController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      passwordController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      // single otpController listener if needed
      otpController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      createPasswordController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      confirmPasswordController.addListener(_controllersListener!);
    } catch (_) {}
  }

  void disposeControllersListener() {
    if (_controllersListener == null) return;
    try {
      mobileNoOrEmailController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      passwordController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      otpController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      createPasswordController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      confirmPasswordController.removeListener(_controllersListener!);
    } catch (_) {}

    _controllersListener = null;
  }

  void updateViewState({LoginScreenStates? screenStates, LoginScreenStates? loadingState}) {
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

    updateViewState(loadingState: LoginScreenStates.transparentLoading);
    final response = await _performLoginRequest();
    await _handleLoginResult(context, response);
  }

  Future<void> otpValidate(BuildContext context) async {
    if (otpControllers.any((c) => c.text.isEmpty)) {
      DialogUtils.showErrorDialog(
        ctx: context,
        message: 'Please enter the complete OTP',
      );
      return;
    }

    final otp = otpControllers.map((c) => c.text).join();
    updateViewState(loadingState: LoginScreenStates.transparentLoading);
    final body = OtVerifyBody(
        identifier: mobileNoOrEmailController.text,
        otpCode: otp,
        purpose: forgotPassword 
            ? 'password_reset'
            : 'signin',
    );
    final response = await LoginRepository.verifyOtp(body);
    if (response.code != 'SUCCESS') {
      _handleLoginFailure(context, response.message);
      return;
    }
    if (context.mounted && forgotPassword) {
      otpCode = otp;
      createPasswordController.clear();
      confirmPasswordController.clear();
      updateViewState(loadingState: LoginScreenStates.defaultState);
      context.push(Paths.newPassword);
    } 
    else if (context.mounted && !forgotPassword) {
      await _handleLoginResult(context, response);
    }
  }

  Future<void> setNewPassword(BuildContext context) async {
    updateViewState(loadingState: LoginScreenStates.transparentLoading);
    if(validateNewPassword()==false) {
      updateViewState(loadingState: LoginScreenStates.defaultState);
      return;
    }
    final body = SetPasswordBody(
        identifier: mobileNoOrEmailController.text,
        otpCode: otpCode,
        newPassword: createPasswordController.text,
        confirmPassword: confirmPasswordController.text);
    final response = await LoginRepository.setNewPassword(body);
    _handleLoginResult(context, response);
  }

  Future<void> resendOtp(BuildContext context) async {
    otpCode = '';
    otpController.clear();
    for (var c in otpControllers) {
      c.clear();
    }
    updateViewState(loadingState: LoginScreenStates.transparentLoading);
    final body = ResendOtpBody(identifier: mobileNoOrEmailController.text, purpose: forgotPassword
        ?'password_reset'
        :'signin',);
    final response = await LoginRepository.resendOtp(body);
    if (response.code != 'SUCCESS') {
      _handleLoginFailure(context, response.message);
      return;
    }
    updateViewState(loadingState: LoginScreenStates.defaultState);
    await DialogUtils.showSuccessDialog(context: context, message: response.message, autoClose: true, autoCloseDuration: const Duration(seconds: 2));
  }

  Future<void> loginWithOtp(BuildContext context) async {
    updateViewState(loadingState: LoginScreenStates.transparentLoading);
    final body = LoginWithOtpBody(identifier: mobileNoOrEmailController.text);
    final response = await LoginRepository.loginWithOtp(body, isForgotPass: forgotPassword);
    if (response.code != 'SUCCESS') {
      mobileOrEmailError = '';
      _handleLoginFailure(context, response.message);
      return;
    }
    await _gotoOtpVerificationScreen(context);
  }

  Future<void> _gotoOtpVerificationScreen(BuildContext context) async {
    updateViewState(loadingState: LoginScreenStates.defaultState);
    if (context.mounted) {
      context.push(Paths.otpVerify);
    }
  }

  bool validateOtpInputs() {
    if (mobileNoOrEmailController.text.isEmpty) {
      mobileOrEmailError = 'Please enter your mobile number or email ID';
      updateViewState();
      return false;
    }
    if (mobileNoOrEmailController.text.isNotEmpty) {
      final mobileOrEmailValidation = Validators.validateMobileOrEmail(mobileNoOrEmailController.text);
      if (mobileOrEmailValidation != null) {
        mobileOrEmailError = mobileOrEmailValidation;
        updateViewState();
        return false;
      }
    }

    return true;
  }

  void _setRequiredFieldErrors() {
    if (mobileNoOrEmailController.text.isEmpty) {
      mobileOrEmailError = 'Please enter your mobile number or email ID';
    }
    if (passwordController.text.isEmpty) {
      passwordError = 'Please enter your password';
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

  Future<void> _handleLoginResult(BuildContext context, LoginResponse response) async {
    if (response.code == 'SUCCESS') {
      await _persistAuthTokens(response);
      _handleLoginSuccess(context);
      return;
    }

    _handleLoginFailure(context, response.message);
  }

  Future<void> _persistAuthTokens(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = response.response?.accessToken;
    final refreshToken = response.response?.refreshToken;

    if (accessToken != null && accessToken.isNotEmpty) {
      await _saveAccessToken(prefs, accessToken);
    }

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _saveRefreshToken(prefs, refreshToken);
    }
  }

  Future<void> _saveAccessToken(SharedPreferences prefs, String accessToken) async {
    await prefs.setString(StorageKeys.accessToken, accessToken);
    try {
      DioClient().setAuthToken(accessToken);
    } catch (_) {}
  }

  Future<void> _saveRefreshToken(SharedPreferences prefs, String refreshToken) async {
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
    updateViewState(loadingState: LoginScreenStates.defaultState);
    if (context.mounted) {
      DialogUtils.showErrorDialog(
        ctx: context,
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
    final mobileOrEmailValidation = Validators.validateMobileOrEmail(mobileNoOrEmailController.text);
    if (mobileOrEmailValidation != null) {
      mobileOrEmailError = mobileOrEmailValidation;
      updateViewState();
      return false;
    }
    return true;
  }

  bool _validatePassword() {
    final passwordValidation = Validators.validatePassword(passwordController.text);
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
  
  bool validateNewPassword() {
    final createPasswordValidation = Validators.validatePassword(createPasswordController.text);
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

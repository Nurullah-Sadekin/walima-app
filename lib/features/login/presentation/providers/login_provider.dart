import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/core/utils/validators.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_body.dart';
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
  // OTP controllers and focus nodes (for multi-digit OTP fields)
  List<TextEditingController> otpControllers = [];
  List<FocusNode> otpFocusNodesController = [];

  Future<void> getInitialData() async {}

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
    if (mobileNoOrEmailController.text.isEmpty) {
      mobileOrEmailError = 'Please enter your mobile number or email ID';
    }
    if (passwordController.text.isEmpty) {
      passwordError = 'Please enter your password';
    }
    final canSubmit = validateInputs();
    updateViewState();
    if (canSubmit) {
      updateViewState(loadingState: LoginScreenStates.transparentLoading);
      final body = LoginBody(
        identifier: mobileNoOrEmailController.text,
        password: passwordController.text,
      );
      final response = await LoginRepository.login(body);
      if (response.code == 'SUCCESS') {
        final prefs = await SharedPreferences.getInstance();
        // Save access & refresh tokens for later use
        final accessToken = response.response?.accessToken;
        final refreshToken = response.response?.refreshToken;
        if (accessToken != null && accessToken.isNotEmpty) {
          await prefs.setString(StorageKeys.accessToken, accessToken);
          try {
            DioClient().setAuthToken(accessToken);
          } catch (_) {}
        }
        if (refreshToken != null && refreshToken.isNotEmpty) {
          await prefs.setString(StorageKeys.refreshToken, refreshToken);
        }
        updateViewState(screenStates: LoginScreenStates.defaultState);
        if (context.mounted) {
          context.push(Paths.anchor); // Return true to indicate successful login
        }
      } else {
        updateViewState(loadingState: LoginScreenStates.defaultState);
        if (context.mounted) {
          DialogUtils.showErrorDialog(ctx: context, message: response.message ?? 'Login failed. Please try again.');
        }
      }
    }
  }

  bool validateInputs() {
    if (Validators.validateMobileOrEmail(mobileNoOrEmailController.text) != null) {
      mobileOrEmailError = Validators.validateMobileOrEmail(mobileNoOrEmailController.text)!;
      updateViewState();
      return false;
    }
    if (Validators.validatePassword(passwordController.text) != null) {
      passwordError = Validators.validatePassword(passwordController.text)!;
      updateViewState();
      return false;
    }
    mobileOrEmailError = '';
    passwordError = '';
    return true;
  }
}

enum LoginScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}

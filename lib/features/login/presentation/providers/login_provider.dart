import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';

class LoginProvider extends BaseChangeNotifier {
  LoginScreenStates screenStates = LoginScreenStates.defaultLoading;
  LoginScreenStates loaderState = LoginScreenStates.defaultLoading;
  bool isLoading = false;
  VoidCallback? _controllersListener;

  bool keepMeLoggedIn = false;
  bool forgotPassword = false;


  final TextEditingController mobileNoOrEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController createPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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

  void updateViewState(
      {LoginScreenStates? screenStates,
        LoginScreenStates? loadingState}) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = LoginScreenStates.defaultLoading;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }

}

enum LoginScreenStates {
  defaultLoading,
  loadingComplete,
  loginSuccess,
}

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
  final TextEditingController createPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final List<TextEditingController> otpController = List.generate(5, (_) => TextEditingController(),);
  final List<FocusNode> otpFocusNodesController = List.generate(5, (_) => FocusNode());
  Future<void> getInitialData() async {}

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

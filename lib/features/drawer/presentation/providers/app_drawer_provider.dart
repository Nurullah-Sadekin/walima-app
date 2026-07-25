import 'package:flutter/material.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/core/utils/app_error_reporting_service.dart';
import 'package:walima_llc/core/utils/firebase_messaging_service.dart';
import 'package:walima_llc/core/utils/prefs_helper.dart';
import 'package:walima_llc/features/chat/data/socket/socket_service.dart';
import 'package:walima_llc/features/drawer/data/repository/logout_repository.dart';

class DrawerProvider extends BaseChangeNotifier {
  DrawerScreenStates screenStates = DrawerScreenStates.defaultState;
  DrawerScreenStates loaderState = DrawerScreenStates.defaultState;

  Future<void> logout(VoidCallback onLogout) async {
    updateViewState(loadingState: DrawerScreenStates.transparentLoading);
    await LogoutRepository.logout();
    DioClient().removeAuthToken();
    SocketService.instance.disconnect(reason: 'user logout');
    await FirebaseMessagingService.instance.dispose();
    await AppErrorReportingService.instance.clearUserContext();
    await PrefsHelper.clearTokens(); // clears access + refresh + FCM token
    await PrefsHelper
        .clearMeSnapshot(); // prevents stale user on next cold start
    await PrefsHelper.clearQuotaSnapshot();
    updateViewState(loadingState: DrawerScreenStates.defaultState);
    onLogout();
  }

  void updateViewState({
    DrawerScreenStates? screenStates,
    DrawerScreenStates? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = DrawerScreenStates.defaultState;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }
}

enum DrawerScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_boilerplate/core/constants/storage_keys.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/utils/app_error_reporting_service.dart';
import 'package:flutter_boilerplate/features/chat/data/socket/socket_service.dart';
import 'package:flutter_boilerplate/features/drawer/data/repository/logout_repository.dart';

class DrawerProvider extends BaseChangeNotifier {
  DrawerScreenStates screenStates = DrawerScreenStates.defaultState;
  DrawerScreenStates loaderState = DrawerScreenStates.defaultState;

  Future<void> logout(
    VoidCallback onLogout, {
    VoidCallback? onBeforeLogout,
  }) async {
    updateViewState(loadingState: DrawerScreenStates.loading);
    onBeforeLogout?.call();
    await LogoutRepository.logout();
    SocketService.instance.disconnect(reason: 'user logout');
    DioClient().removeAuthToken();
    await AppErrorReportingService.instance.clearUserContext();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.refreshToken);
    await prefs.remove(StorageKeys.accessToken);
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

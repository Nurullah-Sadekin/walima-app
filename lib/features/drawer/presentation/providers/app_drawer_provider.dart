import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_boilerplate/core/constants/storage_keys.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/chat/data/socket/socket_service.dart';

class DrawerProvider extends BaseChangeNotifier {
  DrawerScreenStates screenStates = DrawerScreenStates.defaultState;
  DrawerScreenStates loaderState = DrawerScreenStates.defaultState;

  Future<void> logout(VoidCallback onLogout) async {
   updateViewState(loadingState: DrawerScreenStates.loading);
    SocketService.instance.disconnect(reason: 'user logout');
    DioClient().removeAuthToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.refreshToken);
    await prefs.remove(StorageKeys.accessToken);
   updateViewState(loadingState: DrawerScreenStates.defaultState);
   onLogout();
  }

  void updateViewState({DrawerScreenStates? screenStates, DrawerScreenStates? loadingState}) {
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

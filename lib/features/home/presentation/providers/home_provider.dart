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

class HomeProvider extends BaseChangeNotifier {
  LoginScreenStates screenStates = LoginScreenStates.defaultState;
  LoginScreenStates loaderState = LoginScreenStates.defaultState;

  Future<void> getInitialData() async {
    final response = await LoginRepository.getMe();
    if (response.code == 'SUCCESS') {
      // Handle successful response, e.g., store user data
    } else {
      // Handle error, e.g., show a dialog
      // DialogUtils.showErrorDialog(message: response.message);
    }
  }
}

enum LoginScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}

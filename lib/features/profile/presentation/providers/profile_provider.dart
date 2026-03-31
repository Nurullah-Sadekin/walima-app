import 'package:flutter/cupertino.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/dashboard_response.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:flutter_boilerplate/features/profile/data/repository/profile_repository.dart';

class ProfileProvider extends BaseChangeNotifier {
  ProfileScreenStates screenStates = ProfileScreenStates.defaultState;
  ProfileScreenStates loaderState = ProfileScreenStates.defaultState;
  CompleteProfile? profile;
  DashboardData? dashboard;

  Future<void> getProfile(BuildContext context) async {
    final data = await ProfileRepository.getCompleteProfile();
    if (data.code == 'SUCCESS') {
      profile = data.response;
      updateViewState();
    } else {
      await DialogUtils.showErrorDialog(context:context , message: data.message ?? 'Failed to load profile');
      profile = null;
    }
  }

  Future<void> getDashboard() async {
    final data = await ProfileRepository.getDashboard();
    if (data.code == 'SUCCESS') {
      dashboard = data.response;
      updateViewState();
    } else {
      dashboard = null;
    }
  }

  void updateViewState({
    ProfileScreenStates? screenStates,
    ProfileScreenStates? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = ProfileScreenStates.defaultState;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }
}

enum ProfileScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}

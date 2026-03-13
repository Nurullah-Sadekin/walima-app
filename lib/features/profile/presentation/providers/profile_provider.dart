import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:flutter_boilerplate/features/profile/data/repository/profile_repository.dart';

class ProfileProvider extends BaseChangeNotifier {
  ProfileScreenStates screenStates = ProfileScreenStates.defaultState;
  ProfileScreenStates loaderState = ProfileScreenStates.defaultState;
  CompleteProfile? profile;

  Future<void> getProfile() async {
    final response = await ProfileRepository.getCompleteProfile();
    if (response.code == 'SUCCESS') {
      profile = response.response;
      updateViewState();
    } else {
      // DialogUtils.showErrorDialog(context:message: response.message);
    }
  }

  void updateViewState(
      {ProfileScreenStates? screenStates, ProfileScreenStates? loadingState}) {
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

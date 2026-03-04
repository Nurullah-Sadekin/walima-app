import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/resistration/domain/profile_for_model.dart';

class RegistrationProvider extends BaseChangeNotifier {

  RegistrationScreenStates screenStates = RegistrationScreenStates.defaultLoading;
  RegistrationScreenStates loaderState = RegistrationScreenStates.defaultLoading;
  bool isLoading = false;

  String? selectedProfileName;
  String? selectedGenderName;

  List<ProfileFor> profileForList = profileForListInserted;
  List<ProfileFor> genderForList = genderForListInserted;


  Future<void> getInitialData() async {
    // Simulate a delay for fetching data
    // updateViewState(screenStates: RegistrationScreenStates.isProfileFor);
    // await Future.delayed(const Duration(seconds: 2));
    // updateViewState(screenStates: RegistrationScreenStates.loadingComplete);
    // await Future.delayed(const Duration(seconds: 3));
    // updateViewState(loadingState: RegistrationScreenStates.isProfileFor);
    // await Future.delayed(const Duration(seconds: 2));
    // updateViewState(loadingState: RegistrationScreenStates.loadingComplete);
  }

  void selectedProfileFor(int index) {
    if (index < 0 || index >= profileForList.length) return;
    for (var i = 0; i < profileForList.length; i++) {
      profileForList[i].isSelected = i == index;
    }
    selectedProfileName = profileForList[index].name;
    notifyListeners();
  }

  void selectedGender(int index) {
    if (index < 0 || index >= genderForList.length) return;
    for (var i = 0; i < genderForList.length; i++) {
      genderForList[i].isSelected = i == index;
    }
    selectedGenderName = genderForList[index].name;
    notifyListeners();
  }

  void updateViewState({RegistrationScreenStates? screenStates, RegistrationScreenStates? loadingState}) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = RegistrationScreenStates.defaultLoading;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }
}

enum RegistrationScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}

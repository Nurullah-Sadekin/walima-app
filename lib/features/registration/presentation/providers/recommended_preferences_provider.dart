import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';

class RecommendedPreferencesProvider extends BaseChangeNotifier {
  RecommendedPreferencesScreenStates screenStates = RecommendedPreferencesScreenStates.defaultLoading;
  RecommendedPreferencesScreenStates loaderState = RecommendedPreferencesScreenStates.defaultLoading;
  bool isLoading = false;
  VoidCallback? _controllersListener;

  Future<void> getInitialData() async {}

  String? selectedDietStatus;

  final TextEditingController religionController = TextEditingController();


  List<SingleStringModel> maritalStatusDataList = maritalStatusListDataInserted;


  void selectedDiet(int index) {
    if (index < 0 || index >= maritalStatusDataList.length) return;
    for (var i = 0; i < maritalStatusDataList.length; i++) {
      maritalStatusDataList[i].isSelected = i == index;
    }
    selectedDietStatus = maritalStatusDataList[index].name;

    notifyListeners();
  }

  void initControllersListener() {
    if (_controllersListener != null) return;

    _controllersListener = () => notifyListeners();

    try {
      religionController.addListener(_controllersListener!);
    } catch (_) {}

  }

  void disposeControllersListener() {
    if (_controllersListener == null) return;
    try {
      religionController.removeListener(_controllersListener!);
    } catch (_) {}

    _controllersListener = null;

  }

  void updateViewState(
      {RecommendedPreferencesScreenStates? screenStates,
        RecommendedPreferencesScreenStates? loadingState}) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = RecommendedPreferencesScreenStates.defaultLoading;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }
}

enum RecommendedPreferencesScreenStates {
  defaultLoading,
  loadingComplete,
  preferences,
}

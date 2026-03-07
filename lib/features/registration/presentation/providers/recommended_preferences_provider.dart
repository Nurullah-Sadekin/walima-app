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

  List<SingleStringModel> maritalStatusDataList = maritalStatusListDataInserted;
  final List<String> selectedMaritalStatuses = [];


  final TextEditingController religionController = TextEditingController();
  final TextEditingController communityController = TextEditingController();
  final TextEditingController motherTongueController = TextEditingController();


  final int ageMinLimit = 18;
  final int ageMaxLimit = 70;
  int ageStart = 25;
  int ageEnd = 35;
  final int heightMinLimit = 120;
  final int heightMaxLimit = 220;
  int heightStart = 160;
  int heightEnd = 180;

  void toggleMaritalStatus(int index) {
    if (index < 0 || index >= maritalStatusDataList.length) return;
    final item = maritalStatusDataList[index];
    item.isSelected = !item.isSelected;
    if (item.isSelected) {
      if (!selectedMaritalStatuses.contains(item.name)) selectedMaritalStatuses.add(item.name);
    } else {
      selectedMaritalStatuses.remove(item.name);
    }
    notifyListeners();
  }

  void setAgeRange(RangeValues values) {
    ageStart = values.start.round().clamp(ageMinLimit, ageMaxLimit);
    ageEnd = values.end.round().clamp(ageMinLimit, ageMaxLimit);
    if (ageStart > ageEnd) {
      final tmp = ageStart;
      ageStart = ageEnd;
      ageEnd = tmp;
    }
    notifyListeners();
  }

  void setHeightRange(RangeValues values) {
    heightStart = values.start.round().clamp(heightMinLimit, heightMaxLimit);
    heightEnd = values.end.round().clamp(heightMinLimit, heightMaxLimit);
    if (heightStart > heightEnd) {
      final tmp = heightStart;
      heightStart = heightEnd;
      heightEnd = tmp;
    }
    notifyListeners();
  }

  void initControllersListener() {
    if (_controllersListener != null) return;

    _controllersListener = () => notifyListeners();

    try {
      religionController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      communityController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      motherTongueController.addListener(_controllersListener!);
    } catch (_) {}


  }

  void disposeControllersListener() {
    if (_controllersListener == null) return;
    try {
      religionController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      communityController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      motherTongueController.removeListener(_controllersListener!);
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

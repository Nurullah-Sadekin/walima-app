
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
  List<SingleStringModel> countryDataList =  countryListDataInserted;
  List<SingleStringModel> dietDataList =  dietDataListInserted;
  List<SingleStringModel> incomeRangeDataList =  incomeRangeListInserted;
  List<SingleStringModel> professionDataList =  fatherDetailsItemListDataInserted;

  final List<String> preferableMaritalStatuses = [];
  final List<String> preferableCity = [];
  final List<String> preferableDiet = [];


  final TextEditingController religionPreferenceController = TextEditingController();
  final TextEditingController communityPreferenceController = TextEditingController();
  final TextEditingController motherTonguePreferenceController = TextEditingController();
  final TextEditingController countryPreferenceController = TextEditingController();
  final TextEditingController professionPreferenceController = TextEditingController();
  final TextEditingController annualIncomePreferenceController = TextEditingController();
  final TextEditingController profileManagePreferenceController = TextEditingController();
  final TextEditingController dietPreferenceController = TextEditingController();


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
      if (!preferableMaritalStatuses.contains(item.name)) preferableMaritalStatuses.add(item.name);
    } else {
      preferableMaritalStatuses.remove(item.name);
    }
    notifyListeners();
  }

  void toggleCity(int index) {
    if (index < 0 || index >= countryDataList.length) return;
    final item = countryDataList[index];
    item.isSelected = !item.isSelected;
    if (item.isSelected) {
      if (!preferableCity.contains(item.name)) preferableCity.add(item.name);
    } else {
      preferableCity.remove(item.name);
    }
    notifyListeners();
  }
  void toggleDiet(int index) {
    if (index < 0 || index >= dietDataList.length) return;
    final item = dietDataList[index];
    item.isSelected = !item.isSelected;
    if (item.isSelected) {
      if (!preferableDiet.contains(item.name)) preferableDiet.add(item.name);
    } else {
      preferableDiet.remove(item.name);
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
      religionPreferenceController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      communityPreferenceController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      motherTonguePreferenceController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      countryPreferenceController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      professionPreferenceController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      annualIncomePreferenceController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      profileManagePreferenceController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      dietPreferenceController.addListener(_controllersListener!);
    } catch (_) {}


  }

  void disposeControllersListener() {
    if (_controllersListener == null) return;
    try {
      religionPreferenceController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      communityPreferenceController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      motherTonguePreferenceController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      countryPreferenceController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      professionPreferenceController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      annualIncomePreferenceController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      profileManagePreferenceController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      dietPreferenceController.removeListener(_controllersListener!);
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/data/models/request/update_preferences_request_body.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/data/repository/preferences_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/location_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/religion_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/domain/location_data_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/profile_for_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/religion_option_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/location_data_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/religion_data_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';

const List<String> _educationShortNameOptions = <String>[
  'SSC/O-Level',
  'HSC/A-Level',
  'Cert/Cert I-IV',
  'Dip/Diploma',
  'AA/AS',
  'BA',
  'BS/BSc',
  'BBA',
  'BEd',
  'BTech/BE',
  'LLB',
  'MBBS',
  'PG',
  'MA',
  'MS/MSc',
  'MBA',
  'MEd',
  'MTech/ME',
  'LLM',
  'MD/DMD',
  'PhD/DPhil',
  'GPA',
  'CGPA',
  'STEM',
];

class RecommendedPreferencesProvider extends BaseChangeNotifier {
  RecommendedPreferencesScreenStates screenStates =
      RecommendedPreferencesScreenStates.defaultLoading;
  RecommendedPreferencesScreenStates loaderState =
      RecommendedPreferencesScreenStates.defaultLoading;
  bool isLoading = false;

  final PreferencesRepository _preferencesRepository = PreferencesRepository();
  final ReligionDataRepository _religionDataRepository =
      ReligionDataRepositoryImpl();
  final LocationDataRepository _locationDataRepository =
      LocationDataRepositoryImpl();
  VoidCallback? _controllersListener;

  List<ReligionOptionModel> religionOptions = <ReligionOptionModel>[];
  List<String> religionDropdownItems = <String>[];
  List<String> communityDropdownItems = <String>[];
  bool isReligionDataLoading = false;
  String? religionDataError;

  List<CountryLocationModel> countryOptions = <CountryLocationModel>[];
  List<String> countryDropdownItems = <String>[];
  List<String> cityDropdownItems = <String>[];
  bool isLocationDataLoading = false;
  String? locationDataError;

  Future<void> getInitialData() async {
    await loadReligionData();
  }

  Future<void> loadReligionData() async {
    if (isReligionDataLoading) return;

    if (religionOptions.isNotEmpty) {
      _syncCommunityOptions();
      notifyListeners();
      return;
    }

    isReligionDataLoading = true;
    religionDataError = null;
    notifyListeners();

    try {
      religionOptions = await _religionDataRepository.getReligionOptions();
      religionDropdownItems =
          religionOptions.map((item) => item.name).toList(growable: false);
      _syncCommunityOptions();
    } catch (e) {
      religionDataError = e.toString();
    } finally {
      isReligionDataLoading = false;
      notifyListeners();
    }
  }

  void onReligionPreferenceSelected(String? value) {
    final selected = value?.trim() ?? '';
    if (selected.isEmpty) return;

    if (religionPreferenceController.text != selected) {
      religionPreferenceController.text = selected;
      communityPreferenceController.clear();
    }

    _syncCommunityOptions();
    notifyListeners();
  }

  void onCommunityPreferenceSelected(String? value) {
    final selected = value?.trim() ?? '';
    if (selected.isEmpty) return;
    communityPreferenceController.text = selected;
    notifyListeners();
  }

  void _syncCommunityOptions() {
    final selectedReligion = religionPreferenceController.text.trim();
    if (selectedReligion.isEmpty) {
      communityDropdownItems = <String>[];
      return;
    }

    final normalized = selectedReligion.toLowerCase();
    ReligionOptionModel? matched;
    for (final option in religionOptions) {
      if (option.name.toLowerCase() == normalized ||
          option.value.toLowerCase() == normalized) {
        matched = option;
        break;
      }
    }

    if (matched == null) {
      communityDropdownItems = <String>[];
      return;
    }

    communityDropdownItems = matched.community.flattenCommunityLabels();
    if (communityDropdownItems.isEmpty) {
      communityDropdownItems = matched.community.topLevelLabels();
    }

    if (communityPreferenceController.text.isNotEmpty) {
      final selectedCommunity =
          communityPreferenceController.text.trim().toLowerCase();
      final exists = communityDropdownItems
          .any((item) => item.toLowerCase() == selectedCommunity);
      if (!exists) communityPreferenceController.clear();
    }
  }

  Future<void> loadLocationData() async {
    if (isLocationDataLoading) return;

    if (countryOptions.isNotEmpty) {
      await _syncCityOptionsFromSelectedCountry(notify: false);
      notifyListeners();
      return;
    }

    isLocationDataLoading = true;
    locationDataError = null;
    notifyListeners();

    try {
      countryOptions = await _locationDataRepository.getCountries();
      countryDropdownItems =
          countryOptions.map((item) => item.name).toList(growable: false);
      await _syncCityOptionsFromSelectedCountry(notify: false);
    } catch (e) {
      locationDataError = e.toString();
    } finally {
      isLocationDataLoading = false;
      notifyListeners();
    }
  }

  void onCountryPreferenceSelected(String? value) {
    final selected = value?.trim() ?? '';
    if (selected.isEmpty) return;

    final previous = countryPreferenceController.text;
    countryPreferenceController.text = selected;

    if (previous.toLowerCase() != selected.toLowerCase()) {
      cityDropdownItems = <String>[];
      preferableCity.clear();
    }

    unawaited(_syncCityOptionsFromSelectedCountry());
    notifyListeners();
  }

  Future<void> _syncCityOptionsFromSelectedCountry({bool notify = true}) async {
    final selectedCountry = countryPreferenceController.text.trim();
    if (selectedCountry.isEmpty) {
      cityDropdownItems = <String>[];
      if (notify) notifyListeners();
      return;
    }

    if (countryOptions.isEmpty) {
      if (notify) notifyListeners();
      return;
    }

    final normalized = selectedCountry.toLowerCase();
    CountryLocationModel? matched;
    for (final option in countryOptions) {
      if (option.name.toLowerCase() == normalized) {
        matched = option;
        break;
      }
    }

    if (matched == null) {
      cityDropdownItems = <String>[];
      if (notify) notifyListeners();
      return;
    }

    try {
      cityDropdownItems = await _locationDataRepository.getCitiesByCountry(
        country: matched.name,
      );
      locationDataError = null;
    } catch (e) {
      locationDataError = e.toString();
    }

    // Remove any city selections that are no longer valid
    preferableCity.removeWhere(
      (city) => !cityDropdownItems
          .any((item) => item.toLowerCase() == city.toLowerCase()),
    );

    if (notify) notifyListeners();
  }

  void togglePreferableCity(String cityName) {
    if (preferableCity.contains(cityName)) {
      preferableCity.remove(cityName);
    } else {
      preferableCity.add(cityName);
    }
    notifyListeners();
  }

  List<SingleStringModel> maritalStatusDataList = maritalStatusListDataInserted;
  List<SingleStringModel> educationDataList = _educationShortNameOptions
      .map(
        (name) => SingleStringModel(name: name),
      )
      .toList(growable: false);
  List<SingleStringModel> profileManageByDataList = profileForListInserted
      .map(
        (item) => SingleStringModel(name: item.name),
      )
      .toList(growable: false);
  List<SingleStringModel> countryDataList = countryListDataInserted;
  List<SingleStringModel> dietDataList = dietDataListInserted;
  List<SingleStringModel> incomeRangeDataList = incomeRangeListInserted;
  List<SingleStringModel> professionDataList =
      fatherDetailsItemListDataInserted;

  final List<String> preferableMaritalStatuses = [];
  final List<String> preferableEducations = [];
  final List<String> preferableProfileManagedBy = [];
  final List<String> preferableCity = [];
  final List<String> preferableDiet = [];

  final TextEditingController religionPreferenceController =
      TextEditingController();
  final TextEditingController communityPreferenceController =
      TextEditingController();
  final TextEditingController motherTonguePreferenceController =
      TextEditingController();
  final TextEditingController countryPreferenceController =
      TextEditingController();
  final TextEditingController professionPreferenceController =
      TextEditingController();
  final TextEditingController annualIncomePreferenceController =
      TextEditingController();
  final TextEditingController profileManagePreferenceController =
      TextEditingController();
  final TextEditingController dietPreferenceController =
      TextEditingController();

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
      if (!preferableMaritalStatuses.contains(item.name))
        preferableMaritalStatuses.add(item.name);
    } else {
      preferableMaritalStatuses.remove(item.name);
    }
    notifyListeners();
  }

  void toggleEducation(int index) {
    if (index < 0 || index >= educationDataList.length) return;
    final item = educationDataList[index];
    item.isSelected = !item.isSelected;
    if (item.isSelected) {
      if (!preferableEducations.contains(item.name)) {
        preferableEducations.add(item.name);
      }
    } else {
      preferableEducations.remove(item.name);
    }
    notifyListeners();
  }

  void toggleProfileManageBy(int index) {
    if (index < 0 || index >= profileManageByDataList.length) return;
    final item = profileManageByDataList[index];
    item.isSelected = !item.isSelected;
    if (item.isSelected) {
      if (!preferableProfileManagedBy.contains(item.name)) {
        preferableProfileManagedBy.add(item.name);
      }
    } else {
      preferableProfileManagedBy.remove(item.name);
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

  Future<bool> updatePreferences(BuildContext context) async {
    try {
      updateViewState(
          loadingState: RecommendedPreferencesScreenStates.preferences);

      List<String>? _toListOrNull(String text) {
        final t = text.trim();
        return t.isEmpty ? null : [t];
      }

      final body = UpdatePreferencesRequestBody(
        ageMin: ageStart,
        ageMax: ageEnd,
        heightMin: heightStart,
        heightMax: heightEnd,
        maritalStatusPreference: preferableMaritalStatuses.isNotEmpty
            ? List<String>.from(preferableMaritalStatuses)
            : null,
        educationPreference: preferableEducations.isNotEmpty
            ? List<String>.from(preferableEducations)
            : null,
        dietPreference: preferableDiet.isNotEmpty
            ? List<String>.from(preferableDiet)
            : null,
        preferredCities: preferableCity.isNotEmpty
            ? List<String>.from(preferableCity)
            : null,
        religionPreference: _toListOrNull(religionPreferenceController.text),
        communityPreference: _toListOrNull(communityPreferenceController.text),
        motherTonguePreference:
            _toListOrNull(motherTonguePreferenceController.text),
        preferredCountries: _toListOrNull(countryPreferenceController.text),
        professionPreference:
            _toListOrNull(professionPreferenceController.text),
        annualIncomePreference:
            _toListOrNull(annualIncomePreferenceController.text),
        profileManagedByPreference: preferableProfileManagedBy.isNotEmpty
            ? List<String>.from(preferableProfileManagedBy)
            : _toListOrNull(profileManagePreferenceController.text),
      );

      if (body.toJson().isEmpty) {
        updateViewState(
            loadingState: RecommendedPreferencesScreenStates.defaultLoading);
        return true;
      }

      final response = await _preferencesRepository.updatePreferences(body);
      updateViewState(
          loadingState: RecommendedPreferencesScreenStates.defaultLoading);

      if (response.code == 'SUCCESS') {
        return true;
      }

      await DialogUtils.showErrorDialog(
        context: context,
        message: response.message ?? 'Failed to update preferences',
      );
      return false;
    } catch (e) {
      updateViewState(
          loadingState: RecommendedPreferencesScreenStates.defaultLoading);
      await DialogUtils.showErrorDialog(
        context: context,
        message: 'Failed to update preferences',
      );
      return false;
    }
  }
}

enum RecommendedPreferencesScreenStates {
  defaultLoading,
  loadingComplete,
  preferences,
}

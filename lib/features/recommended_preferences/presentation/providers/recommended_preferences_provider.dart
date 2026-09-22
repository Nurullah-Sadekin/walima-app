import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/connectivity/connectivity_keys.dart';
import 'package:walima_llc/core/global/enums/enums.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/features/matches/data/models/request/get_matches_query_params.dart';
import 'package:walima_llc/features/matches/data/models/response/get_matches_response.dart';
import 'package:walima_llc/features/matches/data/repository/matches_repository.dart';
import 'package:walima_llc/features/matches/domain/enums/match_education_level.dart';
import 'package:walima_llc/features/matches/domain/enums/match_marital_status.dart';
import 'package:walima_llc/features/matches/domain/request/bulk_send_connections_request_body.dart';
import 'package:walima_llc/features/recommended_preferences/data/models/request/update_preferences_request_body.dart';
import 'package:walima_llc/features/recommended_preferences/data/repository/preferences_repository.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';
import 'package:walima_llc/features/registration/data/repository/location_data_repository_impl.dart';
import 'package:walima_llc/features/registration/data/repository/lookup_repository.dart';
import 'package:walima_llc/features/registration/domain/location_data_model.dart';
import 'package:walima_llc/features/registration/domain/repository/location_data_repository.dart';
import 'package:walima_llc/features/registration/domain/single_string_model.dart';

class RecommendedPreferencesProvider extends BaseChangeNotifier {
  RecommendedPreferencesScreenStates screenStates =
      RecommendedPreferencesScreenStates.defaultLoading;
  RecommendedPreferencesScreenStates loaderState =
      RecommendedPreferencesScreenStates.defaultLoading;
  bool isLoading = false;

  final PreferencesRepository _preferencesRepository = PreferencesRepository();
  final LocationDataRepository _locationDataRepository =
      LocationDataRepositoryImpl();
  final LookupRepository _lookupRepository = LookupRepository();
  VoidCallback? _controllersListener;

  List<LookupOption> religionOptions = <LookupOption>[];
  List<LookupOption> communityOptions = <LookupOption>[];
  List<String> religionDropdownItems = <String>[];
  List<String> communityDropdownItems = <String>[];
  bool isReligionDataLoading = false;
  String? religionDataError;
  bool isEducationLookupLoading = false;
  String? educationLookupError;
  bool isCareerLookupLoading = false;
  String? careerLookupError;
  bool isConnectMatchesLoading = false;
  String? connectMatchesError;
  bool isBulkSendingConnections = false;
  bool isDrawerEditFlow = false;

  List<CountryLocationModel> countryOptions = <CountryLocationModel>[];
  List<String> countryDropdownItems = <String>[];
  List<String> cityDropdownItems = <String>[];
  bool isCityLoading = false;
  bool isCityLoadingMore = false;
  bool hasMoreCities = true;
  int _cityPage = 1;
  String? _selectedCityCountry;
  bool isLocationDataLoading = false;
  String? locationDataError;

  Future<void> getInitialData() async {
    await loadReligionData();
  }

  /// Religion is a static enum shared with web — only the dependent community
  /// list comes from the API.
  Future<void> loadReligionData() async {
    if (isReligionDataLoading) return;

    religionOptions = List<LookupOption>.from(religionLookupOptions);
    religionDropdownItems =
        religionOptions.map((item) => item.label).toList(growable: false);
    await _syncCommunityOptions();
  }

  void onReligionPreferenceSelected(String? value) {
    final selected = value?.trim() ?? '';
    if (selected.isEmpty) return;

    if (religionPreferenceController.text != selected) {
      religionPreferenceController.text = selected;
      communityPreferenceController.clear();
    }

    unawaited(_syncCommunityOptions());
  }

  void onCommunityPreferenceSelected(String? value) {
    final selected = value?.trim() ?? '';
    if (selected.isEmpty) return;
    communityPreferenceController.text = selected;
    notifyListeners();
  }

  /// Whether the community field should be shown at all — web hides it for
  /// `open_to_all` and `others`, which have no community category.
  bool get showCommunityField =>
      religionHasCommunityOptions(_selectedReligionKey);

  String? get _selectedReligionKey {
    final selected = religionPreferenceController.text.trim();
    if (selected.isEmpty) return null;

    final normalized = selected.toLowerCase();
    for (final option in religionOptions) {
      if (option.key.toLowerCase() == normalized ||
          option.label.toLowerCase() == normalized) {
        return option.key;
      }
    }
    return null;
  }

  Future<void> _syncCommunityOptions() async {
    final religionKey = _selectedReligionKey;
    if (religionKey == null || !religionHasCommunityOptions(religionKey)) {
      communityOptions = <LookupOption>[];
      communityDropdownItems = <String>[];
      communityPreferenceController.clear();
      notifyListeners();
      return;
    }

    isReligionDataLoading = true;
    religionDataError = null;
    notifyListeners();

    try {
      communityOptions = await _lookupRepository.getLookupsBySlug(religionKey);
      communityDropdownItems =
          communityOptions.map((item) => item.label).toList(growable: false);
    } catch (e) {
      communityOptions = <LookupOption>[];
      communityDropdownItems = <String>[];
      religionDataError = e.toString();
    } finally {
      isReligionDataLoading = false;
    }

    if (communityPreferenceController.text.isNotEmpty) {
      final selectedCommunity =
          communityPreferenceController.text.trim().toLowerCase();
      final exists = communityDropdownItems
          .any((item) => item.toLowerCase() == selectedCommunity);
      if (!exists) communityPreferenceController.clear();
    }
    notifyListeners();
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

    final previousCountry = _selectedCityCountry?.trim() ?? '';
    final isSameCountry =
        previousCountry.toLowerCase() == selected.toLowerCase();
    countryPreferenceController.text = selected;

    if (!isSameCountry) {
      cityDropdownItems = <String>[];
      preferableCity.clear();
      hasMoreCities = true;
      _cityPage = 1;
      _selectedCityCountry = selected;
    }

    if (isSameCountry && cityDropdownItems.isNotEmpty) {
      notifyListeners();
      return;
    }

    unawaited(_syncCityOptionsFromSelectedCountry(reset: !isSameCountry));
    notifyListeners();
  }

  Future<void> _syncCityOptionsFromSelectedCountry({
    bool notify = true,
    bool reset = true,
  }) async {
    final selectedCountry = countryPreferenceController.text.trim();
    if (selectedCountry.isEmpty) {
      cityDropdownItems = <String>[];
      hasMoreCities = false;
      if (notify) notifyListeners();
      return;
    }

    if (countryOptions.isEmpty) {
      if (notify) notifyListeners();
      return;
    }

    if (isCityLoading || isCityLoadingMore) {
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
      hasMoreCities = false;
      if (notify) notifyListeners();
      return;
    }

    try {
      if (reset ||
          _selectedCityCountry?.toLowerCase() != matched.name.toLowerCase()) {
        _selectedCityCountry = matched.name;
        _cityPage = 1;
        hasMoreCities = true;
        cityDropdownItems = <String>[];
        isCityLoading = true;
      } else {
        isCityLoadingMore = true;
      }
      if (notify) notifyListeners();

      final result = await _locationDataRepository.getCitiesByCountryPage(
        country: matched.name,
        page: _cityPage,
        size: 100,
      );

      if (_selectedCityCountry?.toLowerCase() != matched.name.toLowerCase()) {
        return;
      }

      final merged = reset ? <String>[] : List<String>.from(cityDropdownItems);
      for (final city in result.items) {
        if (!merged.any((item) => item.toLowerCase() == city.toLowerCase())) {
          merged.add(city);
        }
      }

      cityDropdownItems = merged;
      hasMoreCities = result.hasNextPage;
      if (result.hasNextPage) {
        _cityPage++;
      }
      locationDataError = null;
    } catch (e) {
      locationDataError = e.toString();
    } finally {
      isCityLoading = false;
      isCityLoadingMore = false;
    }

    // Remove any city selections that are no longer valid
    preferableCity.removeWhere(
      (city) => !cityDropdownItems
          .any((item) => item.toLowerCase() == city.toLowerCase()),
    );

    if (notify) notifyListeners();
  }

  Future<void> loadMoreCitiesForSelectedCountry() async {
    if (!hasMoreCities || isCityLoading || isCityLoadingMore) return;
    await _syncCityOptionsFromSelectedCountry(reset: false);
  }

  void togglePreferableCity(String cityName) {
    if (preferableCity.contains(cityName)) {
      preferableCity.remove(cityName);
    } else {
      preferableCity.add(cityName);
    }
    notifyListeners();
  }

  List<SingleStringModel> maritalStatusDataList = maritalStatusListDataInserted
      .where(
        (item) => !<String>{
          RegistrationMaritalStatus.openToAll.apiValue,
          RegistrationMaritalStatus.awaitingDivorce.apiValue,
          RegistrationMaritalStatus.annulled.apiValue,
        }.contains(item.value),
      )
      .toList(growable: false);
  List<LookupOption> educationLookupOptions = <LookupOption>[];
  List<SingleStringModel> educationDataList = <SingleStringModel>[];
  List<SingleStringModel> profileManageByDataList =
      RegistrationProfileManagedBy.values
          .map(
            (item) => SingleStringModel(
              name: item.label,
              value: item.apiValue,
            ),
          )
          .toList(growable: false);
  List<SingleStringModel> countryDataList = countryListDataInserted;
  List<SingleStringModel> dietDataList = dietDataListInserted;
  List<LookupOption> professionLookupOptions = <LookupOption>[];
  List<LookupOption> workSectorLookupOptions = <LookupOption>[];
  List<LookupOption> incomeRangeLookupOptions = <LookupOption>[];
  List<SingleStringModel> incomeRangeDataList = <SingleStringModel>[];
  List<SingleStringModel> workSectorDataList = <SingleStringModel>[];
  List<SingleStringModel> professionDataList = <SingleStringModel>[];
  List<MatchProfile> connectMatches = <MatchProfile>[];
  final Set<String> selectedConnectMatchIds = <String>{};
  final MatchesRepository _matchesRepository = MatchesRepository();

  void setPreferenceFlowSource({required bool isFromDrawer}) {
    if (isDrawerEditFlow == isFromDrawer) return;
    isDrawerEditFlow = isFromDrawer;
    notifyListeners();
  }

  final List<String> preferableMaritalStatuses = [];
  final List<String> preferableEducations = [];
  final List<String> preferableProfileManagedBy = [];
  final List<String> preferableCity = [];
  final List<String> preferableWorkingAs = [];
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
  final TextEditingController workSectorPreferenceController =
      TextEditingController();
  final TextEditingController annualIncomePreferenceController =
      TextEditingController();
  final TextEditingController profileManagePreferenceController =
      TextEditingController();
  final TextEditingController dietPreferenceController =
      TextEditingController();

  final int ageMinLimit = 18;
  final int ageMaxLimit = 60;
  int ageStart = 25;
  int ageEnd = 35;
  final int heightMinLimit = 122;
  final int heightMaxLimit = 213;
  int heightStart = 152;
  int heightEnd = 180;

  Future<void> loadEducationLookupData() async {
    if (isEducationLookupLoading) return;

    if (educationLookupOptions.isNotEmpty) {
      notifyListeners();
      return;
    }

    isEducationLookupLoading = true;
    educationLookupError = null;
    notifyListeners();

    try {
      educationLookupOptions = await _lookupRepository.getLookups(
        LookupCategory.educationLevels,
      );
      // if(educationLevelOptions.isEmpty) {
      //   educationLevelOptions = EducationLevel.values.map((e) => LookupOption(key: e.apiValue, label: e.label)).toList(growable: false);
      // }

      educationDataList = educationLookupOptions
          .map(
            (item) => SingleStringModel(
              name: item.label,
              value: item.key,
            ),
          )
          .toList(growable: false);

      if (educationLookupOptions.isEmpty) {
        educationDataList = EducationLevel.values
            .map((e) => SingleStringModel(value: e.apiValue, name: e.label))
            .toList(growable: false);
      }
    } catch (e) {
      educationLookupError = e.toString();
    } finally {
      isEducationLookupLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCareerLookupData() async {
    if (isCareerLookupLoading) return;

    if (workSectorLookupOptions.isNotEmpty &&
        professionLookupOptions.isNotEmpty &&
        incomeRangeLookupOptions.isNotEmpty) {
      notifyListeners();
      return;
    }

    isCareerLookupLoading = true;
    careerLookupError = null;
    notifyListeners();

    try {
      final results = await Future.wait<List<LookupOption>>([
        _lookupRepository.getLookups(LookupCategory.workSector),
        _lookupRepository.getLookups(LookupCategory.professions),
        _lookupRepository.getLookups(LookupCategory.incomeRange),
      ]);

      workSectorLookupOptions = results[0];
      professionLookupOptions = results[1];
      incomeRangeLookupOptions = results[2];
      workSectorDataList = workSectorLookupOptions
          .map(
            (item) => SingleStringModel(
              name: item.label,
              value: item.key,
            ),
          )
          .toList(growable: false);
      professionDataList = professionLookupOptions
          .map(
            (item) => SingleStringModel(
              name: item.label,
              value: item.key,
            ),
          )
          .toList(growable: false);
      incomeRangeDataList = incomeRangeLookupOptions
          .map(
            (item) => SingleStringModel(
              name: item.label,
              value: item.key,
            ),
          )
          .toList(growable: false);
    } catch (e) {
      careerLookupError = e.toString();
    } finally {
      isCareerLookupLoading = false;
      notifyListeners();
    }
  }

  void toggleMaritalStatus(int index) {
    if (index < 0 || index >= maritalStatusDataList.length) return;
    final item = maritalStatusDataList[index];
    final itemValue = (item.value ?? item.name).trim();
    item.isSelected = !item.isSelected;
    if (item.isSelected) {
      if (!preferableMaritalStatuses.contains(itemValue)) {
        preferableMaritalStatuses.add(itemValue);
      }
    } else {
      preferableMaritalStatuses.remove(itemValue);
    }
    notifyListeners();
  }

  void toggleEducation(int index) {
    if (index < 0 || index >= educationDataList.length) return;
    final item = educationDataList[index];
    final itemValue = (item.value ?? item.name).trim();
    item.isSelected = !item.isSelected;
    if (item.isSelected) {
      if (!preferableEducations.contains(itemValue)) {
        preferableEducations.add(itemValue);
      }
    } else {
      preferableEducations.remove(itemValue);
    }
    notifyListeners();
  }

  void toggleProfileManageBy(int index) {
    if (index < 0 || index >= profileManageByDataList.length) return;
    final item = profileManageByDataList[index];
    final itemValue = (item.value ?? item.name).trim();
    item.isSelected = !item.isSelected;
    if (item.isSelected) {
      if (!preferableProfileManagedBy.contains(itemValue)) {
        preferableProfileManagedBy.add(itemValue);
      }
    } else {
      preferableProfileManagedBy.remove(itemValue);
    }
    notifyListeners();
  }

  void toggleWorkSector(int index) {
    if (index < 0 || index >= workSectorDataList.length) return;
    final item = workSectorDataList[index];
    final itemValue = (item.value ?? item.name).trim();

    for (final option in workSectorDataList) {
      option.isSelected = false;
    }
    preferableWorkingAs
      ..clear()
      ..add(itemValue);
    item.isSelected = true;
    notifyListeners();
  }

  void selectWorkSector(String? value) {
    final selected = value?.trim();
    if (selected == null || selected.isEmpty) return;

    workSectorPreferenceController.text = selected;
    professionPreferenceController.clear();
    annualIncomePreferenceController.clear();
    preferableWorkingAs
      ..clear()
      ..add(_resolveWorkSectorPreference());
    notifyListeners();
  }

  void selectProfession(String? value) {
    final selected = value?.trim();
    if (selected == null || selected.isEmpty) return;

    professionPreferenceController.text = selected;
    annualIncomePreferenceController.clear();
    notifyListeners();
  }

  void selectAnnualIncome(String? value) {
    final selected = value?.trim();
    if (selected == null || selected.isEmpty) return;

    annualIncomePreferenceController.text = selected;
    notifyListeners();
  }

  void toggleProfession(int index) {
    if (index < 0 || index >= professionDataList.length) return;
    final item = professionDataList[index];
    final itemValue = (item.value ?? item.name).trim();
    item.isSelected = !item.isSelected;
    if (item.isSelected) {
      if (!preferableWorkingAs.contains(itemValue)) {
        preferableWorkingAs.add(itemValue);
      }
    } else {
      preferableWorkingAs.remove(itemValue);
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
    final itemValue = (item.value ?? item.name).trim();
    item.isSelected = !item.isSelected;
    if (item.isSelected) {
      if (!preferableDiet.contains(itemValue)) preferableDiet.add(itemValue);
    } else {
      preferableDiet.remove(itemValue);
    }
    notifyListeners();
  }

  Future<void> loadConnectMatches() async {
    if (isConnectMatchesLoading) return;

    isConnectMatchesLoading = true;
    connectMatchesError = null;
    notifyListeners();

    try {
      final response = await MatchesRepository.getMatches(
        GetMatchesQueryParams(
          type: 'today',
          page: 1,
          size: 10,
          ageMin: ageStart,
          ageMax: ageEnd,
          heightMin: heightStart,
          heightMax: heightEnd,
          maritalStatus: _resolveMaritalStatusPreference(),
          religion: _resolveReligionPreference(),
          motherTongue: _trimmedOrNull(motherTonguePreferenceController.text),
          countryLivingIn: _singleListOrNull(countryPreferenceController.text),
          community: _singleListOrNull(_resolveCommunityPreference() ?? ''),
          stateLivingIn: preferableCity.isNotEmpty
              ? List<String>.from(preferableCity)
              : null,
          qualification: _resolveEducationPreferences(),
          professionArea: _resolveProfessionPreference(),
          annualIncome: _resolveAnnualIncomePreference(),
          eatingHabits: preferableDiet.isNotEmpty ? preferableDiet.first : null,
        ),
      );

      if (response.isSuccess) {
        connectMatches = response.data ?? <MatchProfile>[];
        selectedConnectMatchIds
          ..clear()
          ..addAll(
            connectMatches
                .map((match) => match.id?.trim() ?? '')
                .where((id) => id.isNotEmpty),
          );
      } else {
        connectMatches = <MatchProfile>[];
        selectedConnectMatchIds.clear();
        connectMatchesError = response.message ?? 'Failed to load matches.';
      }
    } catch (e) {
      connectMatches = <MatchProfile>[];
      connectMatchesError = e.toString();
    } finally {
      isConnectMatchesLoading = false;
      notifyListeners();
    }
  }

  void toggleConnectMatchSelection(String matchId) {
    final normalized = matchId.trim();
    if (normalized.isEmpty) return;
    if (!selectedConnectMatchIds.add(normalized)) {
      selectedConnectMatchIds.remove(normalized);
    }
    notifyListeners();
  }

  BuildContext? get _dialogContext => rootNavigatorKey.currentContext;

  Future<BulkConnectionSendResult?> sendBulkConnectionRequests() async {
    if (isBulkSendingConnections) return null;

    final matchUserIds = selectedConnectMatchIds.toList(growable: false);
    if (matchUserIds.isEmpty) {
      final dialogContext = _dialogContext;
      if (dialogContext == null) return null;
      await DialogUtils.showErrorDialog(
        context: dialogContext,
        title: 'No Selection',
        message: 'Select at least one match to send a connection request.',
      );
      return null;
    }

    isBulkSendingConnections = true;
    notifyListeners();

    try {
      final response = await _matchesRepository.bulkSendConnectionRequests(
        BulkSendConnectionsRequestBody(
          matchUserIds: matchUserIds,
          requestType: 'connection',
          message: 'I would like to connect with you.',
          isPriority: false,
        ),
      );

      if (response.hasPartialOrFullSuccess) {
        selectedConnectMatchIds.clear();
        notifyListeners();
        return BulkConnectionSendResult(
          isSuccessDialog: true,
          message: response.message ??
              'Your connection requests have been sent successfully.',
        );
      }

      if (response.isFullyFailed) {
        return BulkConnectionSendResult(
          isSuccessDialog: false,
          message: response.message ??
              'Unable to send connection requests right now.',
        );
      }

      final dialogContext = _dialogContext;
      if (dialogContext == null) return null;
      await DialogUtils.showErrorDialog(
        context: dialogContext,
        title: 'Connection Failed',
        message:
            response.message ?? 'Unable to send connection requests right now.',
      );
      return null;
    } catch (e) {
      final dialogContext = _dialogContext;
      if (dialogContext == null) return null;
      await DialogUtils.showErrorDialog(
        context: dialogContext,
        title: 'Connection Failed',
        message: e.toString(),
      );
      return null;
    } finally {
      isBulkSendingConnections = false;
      notifyListeners();
    }
  }

  String? _trimmedOrNull(String text) {
    final trimmed = text.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  List<String>? _singleListOrNull(String text) {
    final trimmed = _trimmedOrNull(text);
    return trimmed == null ? null : <String>[trimmed];
  }

  String? _resolveReligionPreference() {
    final selected = religionPreferenceController.text.trim();
    if (selected.isEmpty) return null;
    return _selectedReligionKey ?? selected.toLowerCase();
  }

  /// The dropdown writes the display label into the controller, but the API
  /// matches on the lookup key.
  String? _resolveCommunityPreference() {
    final selected = communityPreferenceController.text.trim();
    if (selected.isEmpty) return null;

    final normalized = selected.toLowerCase();
    for (final option in communityOptions) {
      if (option.label.toLowerCase() == normalized ||
          option.key.toLowerCase() == normalized) {
        return option.key;
      }
    }
    return selected;
  }

  String? _resolveMaritalStatusPreference() {
    if (preferableMaritalStatuses.isEmpty) return null;

    final resolved = preferableMaritalStatuses
        .map((item) {
          final normalized = item.trim().toLowerCase();
          for (final status in MatchMaritalStatus.values) {
            if (status.apiValue == normalized) return status.apiValue;
          }
          return MatchMaritalStatus.fromLabel(item)?.apiValue;
        })
        .whereType<String>()
        .toList();

    return resolved.isEmpty ? null : resolved.first;
  }

  List<String>? _resolveEducationPreferences() {
    if (preferableEducations.isEmpty) return null;

    final resolved = preferableEducations
        .map(_resolveEducationPreferenceValue)
        .whereType<String>()
        .toList();

    return resolved.isEmpty ? null : resolved;
  }

  String? _resolveEducationPreferenceValue(String rawValue) {
    final normalized = rawValue.trim().toLowerCase();
    if (normalized.isEmpty) return null;

    const allowed = <String>{
      'no_formal_education',
      'primary',
      'secondary',
      'higher_secondary',
      'diploma',
      'bachelor',
      'masters',
      'phd',
      'doctorate',
      'professional_degree',
      'vocational_training',
      'certificate',
      'others',
    };

    if (allowed.contains(normalized)) {
      return normalized;
    }

    final enumMatch = MatchEducationLevel.fromLabel(rawValue)?.apiValue;
    if (enumMatch != null &&
        enumMatch != MatchEducationLevel.openToAll.apiValue) {
      return enumMatch == MatchEducationLevel.highSchool.apiValue
          ? 'secondary'
          : enumMatch;
    }

    if (normalized.contains('no formal')) return 'no_formal_education';
    if (normalized.contains('primary')) return 'primary';
    if (normalized.contains('higher secondary') ||
        normalized.contains('high secondary') ||
        normalized.contains('hsc') ||
        normalized.contains('a-level') ||
        normalized.contains('intermediate')) {
      return 'higher_secondary';
    }
    if (normalized.contains('secondary') ||
        normalized.contains('ssc') ||
        normalized.contains('o-level') ||
        normalized == 'high_school') {
      return 'secondary';
    }
    if (normalized.contains('diploma') || normalized.startsWith('dip')) {
      return 'diploma';
    }
    if (normalized.contains('bachelor') ||
        normalized == 'ba' ||
        normalized == 'bsc' ||
        normalized == 'bs/bsc' ||
        normalized == 'bba' ||
        normalized == 'bed' ||
        normalized == 'btech/be' ||
        normalized == 'llb') {
      return 'bachelor';
    }
    if (normalized.contains('master') ||
        normalized == 'ma' ||
        normalized == 'msc' ||
        normalized == 'ms/msc' ||
        normalized == 'mba' ||
        normalized == 'med' ||
        normalized == 'mtech/me' ||
        normalized == 'llm') {
      return 'masters';
    }
    if (normalized.contains('phd')) return 'phd';
    if (normalized.contains('doctorate')) return 'doctorate';
    if (normalized.contains('professional') ||
        normalized == 'mbbs' ||
        normalized == 'md/dmd') {
      return 'professional_degree';
    }
    if (normalized.contains('vocational')) return 'vocational_training';
    if (normalized.contains('cert')) return 'certificate';

    return null;
  }

  String? _resolveProfessionPreference() {
    final selected = professionPreferenceController.text.trim().toLowerCase();
    if (selected.isEmpty) return null;

    for (final option in professionLookupOptions) {
      if (option.label.toLowerCase() == selected ||
          option.key.toLowerCase() == selected) {
        return option.key;
      }
    }

    return selected;
  }

  String _resolveWorkSectorPreference() {
    final selected = workSectorPreferenceController.text.trim();
    if (selected.isEmpty) return '';

    for (final option in workSectorLookupOptions) {
      if (option.label.toLowerCase() == selected.toLowerCase() ||
          option.key.toLowerCase() == selected.toLowerCase()) {
        return option.key;
      }
    }

    return selected;
  }

  String? _resolveAnnualIncomePreference() {
    final selected = annualIncomePreferenceController.text.trim().toLowerCase();
    if (selected.isEmpty) return null;

    for (final option in incomeRangeLookupOptions) {
      if (option.label.toLowerCase() == selected ||
          option.key.toLowerCase() == selected) {
        return option.key;
      }
    }

    return selected;
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
        // Send api values / lookup keys, not the display labels the dropdown
        // writes into the controllers.
        religionPreference: _singleListOrNull(_resolveReligionPreference() ?? ''),
        communityPreference:
            _singleListOrNull(_resolveCommunityPreference() ?? ''),
        motherTonguePreference:
            _toListOrNull(motherTonguePreferenceController.text),
        preferredCountries: _toListOrNull(countryPreferenceController.text),
        professionPreference:
            _toListOrNull(professionPreferenceController.text),
        workingAsPreference: workSectorPreferenceController.text.trim().isEmpty
            ? null
            : <String>[_resolveWorkSectorPreference()],
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

class BulkConnectionSendResult {
  const BulkConnectionSendResult({
    required this.isSuccessDialog,
    required this.message,
  });

  final bool isSuccessDialog;
  final String message;
}

enum RecommendedPreferencesScreenStates {
  defaultLoading,
  loadingComplete,
  preferences,
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/global/enums/enums.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/contact_filter/data/models/contact_filters_settings.dart';
import 'package:walima_llc/features/contact_filter/data/repository/contact_filters_repository.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';
import 'package:walima_llc/features/registration/data/repository/location_data_repository_impl.dart';
import 'package:walima_llc/features/registration/data/repository/lookup_repository.dart';
import 'package:walima_llc/features/registration/data/repository/religion_data_repository_impl.dart';
import 'package:walima_llc/features/registration/domain/repository/location_data_repository.dart';
import 'package:walima_llc/features/registration/domain/repository/religion_data_repository.dart';
import 'package:walima_llc/features/registration/domain/single_string_model.dart';

class ContactFilterProvider extends BaseChangeNotifier {
  ContactFilterProvider();

  final LookupRepository _lookupRepository = LookupRepository();
  final LocationDataRepository _locationDataRepository =
      LocationDataRepositoryImpl();
  final ReligionDataRepository _religionDataRepository =
      ReligionDataRepositoryImpl();

  List<SingleStringModel> religionOptions = <SingleStringModel>[];

  List<SingleStringModel> maritalStatusOptions = <SingleStringModel>[];

  List<SingleStringModel> motherTongueOptions = <SingleStringModel>[];

  List<SingleStringModel> communityOptions = <SingleStringModel>[];
  List<SingleStringModel> countryOptions = <SingleStringModel>[];
  List<SingleStringModel> workingWithOptions = <SingleStringModel>[];
  List<SingleStringModel> annualIncomeOptions = <SingleStringModel>[];

  bool isReligionDataLoading = false;
  bool isCareerLookupLoading = false;
  bool isLocationDataLoading = false;
  bool isBaseLookupLoading = false;
  bool _didLoadBaseLookupData = false;
  bool isRemoteFilterLoading = false;
  bool isApplying = false;
  String? remoteFilterError;
  ContactFiltersSettings? _remoteSnapshot;

  final int ageMinLimit = 18;
  final int ageMaxLimit = 70;
  int ageStart = 25;
  int ageEnd = 35;

  final int heightMinLimit = 120;
  final int heightMaxLimit = 220;
  int heightStart = 160;
  int heightEnd = 180;

  String get ageRangeSummary => '$ageStart - $ageEnd';
  String get heightRangeSummary =>
      '${formatHeight(heightStart)} - ${formatHeight(heightEnd)}';
  String get maritalStatusSummary =>
      _selectedSummary(maritalStatusOptions, fallback: 'Not Set');
  String get religionSummary =>
      _selectedSummary(religionOptions, fallback: 'Not Set');
  String get communitySummary =>
      _selectedSummary(communityOptions, fallback: 'Not Set');
  String get motherTongueSummary =>
      _selectedSummary(motherTongueOptions, fallback: 'Not Set');
  String get countryLivingInSummary =>
      _selectedSummary(countryOptions, fallback: 'Not Set');
  String get workingWithSummary =>
      _selectedSummary(workingWithOptions, fallback: 'Not Set');
  String get annualIncomeSummary =>
      _selectedSummary(annualIncomeOptions, fallback: 'Not Set');

  List<String> get selectedCommunities => _selectedValues(communityOptions);

  Future<void> loadInitialData() async {
    if (isRemoteFilterLoading) return;
    isRemoteFilterLoading = true;
    remoteFilterError = null;
    notifyListeners();

    try {
      // Fetch remote settings and lookup data in parallel.
      final remoteFuture = ContactFiltersRepository.getContactFilters();
      await Future.wait<void>([
        loadBaseLookupData(),
        loadCareerLookupData(),
        loadLocationData(),
      ]);
      final remoteResponse = await remoteFuture;

      ContactFiltersSettings? remote;
      if (remoteResponse.isSuccess) {
        remote = remoteResponse.data;
        _remoteSnapshot = remote;
      } else {
        remoteFilterError = remoteResponse.message;
      }

      // Clear existing selections so stale state from a previous session
      // doesn't leak into the new view.
      _clearSelections(maritalStatusOptions);
      _clearSelections(religionOptions);
      _clearSelections(motherTongueOptions);
      _clearSelections(countryOptions);
      _clearSelections(workingWithOptions);
      _clearSelections(annualIncomeOptions);
      _clearSelections(communityOptions);

      if (remote != null) {
        _applyRanges(remote);
        _applySelection(religionOptions, remote.religion);
      }

      // Community options depend on the selected religions — load them now
      // that religion selection is applied.
      await loadCommunityData();

      if (remote != null) {
        _applySelection(maritalStatusOptions, remote.maritalStatus);
        _applySelection(communityOptions, remote.community);
        _applySelection(motherTongueOptions, remote.motherTongue);
        _applySelection(countryOptions, remote.countryLivingIn);
        _applySelection(workingWithOptions, remote.workingWith);
        _applySelection(annualIncomeOptions, remote.annualIncome);
      }
    } finally {
      isRemoteFilterLoading = false;
      notifyListeners();
    }
  }

  void _clearSelections(List<SingleStringModel> items) {
    for (final item in items) {
      item.isSelected = false;
    }
  }

  Future<void> loadCommunityData() async {
    final selectedReligions = religionOptions
        .where((item) => item.isSelected)
        .map((item) => item.value ?? item.name.toLowerCase())
        .toList(growable: false);

    if (selectedReligions.isEmpty) {
      communityOptions = <SingleStringModel>[];
      notifyListeners();
      return;
    }

    isReligionDataLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait<List<LookupOption>>(
        selectedReligions.map(
          (slug) => _lookupRepository.getLookupsBySlug(slug),
        ),
      );

      final previouslySelected = selectedCommunities;
      final merged = <String, SingleStringModel>{};

      for (final result in results) {
        for (final option in result) {
          final normalized = option.label.trim().toLowerCase();
          merged[normalized] = SingleStringModel(
            name: option.label,
            value: option.key,
            isSelected: previouslySelected.any(
              (selected) => selected.toLowerCase() == normalized,
            ),
          );
        }
      }

      communityOptions = merged.values.toList(growable: false);
    } catch (_) {
      communityOptions = <SingleStringModel>[];
    } finally {
      isReligionDataLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBaseLookupData() async {
    if (isBaseLookupLoading) return;
    if (_didLoadBaseLookupData) return;

    isBaseLookupLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait<List<SingleStringModel>>([
        _loadReligionOptions(),
        _loadLookupItemsByPrioritySlugs(
          const <String>[
            'marital-status',
            'maritalStatus',
            'marital_status',
          ],
          fallback: RegistrationMaritalStatus.values
              .map(
                (status) => SingleStringModel(
                  name: status.label,
                  value: status.apiValue,
                ),
              )
              .toList(growable: false),
        ),
        _loadLookupItemsByPrioritySlugs(
          const <String>['mother-tongue'],
          fallback: <SingleStringModel>[
            SingleStringModel(name: 'Bengali', value: 'bengali'),
            SingleStringModel(name: 'English', value: 'english'),
            SingleStringModel(name: 'Hindi', value: 'hindi'),
          ],
        ),
      ]);

      religionOptions = results[0];
      maritalStatusOptions = results[1];
      motherTongueOptions = results[2];
      _didLoadBaseLookupData = true;
    } finally {
      isBaseLookupLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCareerLookupData() async {
    if (isCareerLookupLoading) return;
    if (workingWithOptions.isNotEmpty && annualIncomeOptions.isNotEmpty) return;

    isCareerLookupLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait<List<LookupOption>>([
        _lookupRepository.getLookups(LookupCategory.professions),
        _lookupRepository.getLookups(LookupCategory.incomeRange),
      ]);

      workingWithOptions =
          results[0].map((item) => _lookupToItem(item)).toList(growable: false);
      annualIncomeOptions =
          results[1].map((item) => _lookupToItem(item)).toList(growable: false);
    } finally {
      isCareerLookupLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLocationData() async {
    if (isLocationDataLoading) return;
    if (countryOptions.isNotEmpty) return;

    isLocationDataLoading = true;
    notifyListeners();

    try {
      final countries = await _locationDataRepository.getCountries();
      countryOptions = countries
          .map(
            (item) => SingleStringModel(
              name: item.name,
              value: item.code2,
            ),
          )
          .toList(growable: false);
    } finally {
      isLocationDataLoading = false;
      notifyListeners();
    }
  }

  Future<List<SingleStringModel>> _loadReligionOptions() async {
    try {
      final options = await _religionDataRepository.getReligionOptions();
      if (options.isNotEmpty) {
        return options
            .map(
              (item) => SingleStringModel(
                name: item.name,
                value: item.value,
              ),
            )
            .toList(growable: false);
      }
    } catch (_) {
      // Fall back to lookup slugs or static options below.
    }

    return _loadLookupItemsByPrioritySlugs(
      const <String>['religion', 'religions'],
      fallback: const <LookupOption>[
        LookupOption(key: 'islam', label: 'Islam'),
        LookupOption(key: 'hinduism', label: 'Hinduism'),
        LookupOption(key: 'christianity', label: 'Christianity'),
        LookupOption(key: 'buddhism', label: 'Buddhism'),
        LookupOption(key: 'others', label: 'Others'),
      ].map(_lookupToItem).toList(growable: false),
    );
  }

  Future<List<SingleStringModel>> _loadLookupItemsByPrioritySlugs(
    List<String> slugs, {
    required List<SingleStringModel> fallback,
  }) async {
    for (final slug in slugs) {
      try {
        final options = await _lookupRepository.getLookupsBySlug(slug);
        if (options.isNotEmpty) {
          return options.map(_lookupToItem).toList(growable: false);
        }
      } catch (_) {
        // Try the next candidate slug.
      }
    }

    return fallback
        .map(
          (item) => SingleStringModel(
            name: item.name,
            value: item.value,
            isSelected: item.isSelected,
          ),
        )
        .toList(growable: false);
  }

  void toggleMaritalStatus(int index) {
    _toggleItem(maritalStatusOptions, index);
  }

  void toggleReligion(int index) {
    _toggleItem(religionOptions, index);
    unawaited(loadCommunityData());
  }

  void toggleCommunity(int index) {
    _toggleItem(communityOptions, index);
  }

  void toggleMotherTongue(int index) {
    _toggleItem(motherTongueOptions, index);
  }

  void toggleCountryLivingIn(int index) {
    _toggleItem(countryOptions, index);
  }

  void toggleWorkingWith(int index) {
    _toggleItem(workingWithOptions, index);
  }

  void toggleAnnualIncome(int index) {
    _toggleItem(annualIncomeOptions, index);
  }

  void setAgeRange(RangeValues values) {
    ageStart = values.start.round().clamp(ageMinLimit, ageMaxLimit);
    ageEnd = values.end.round().clamp(ageMinLimit, ageMaxLimit);
    if (ageStart > ageEnd) {
      final temp = ageStart;
      ageStart = ageEnd;
      ageEnd = temp;
    }
    notifyListeners();
  }

  void setHeightRange(RangeValues values) {
    heightStart = values.start.round().clamp(heightMinLimit, heightMaxLimit);
    heightEnd = values.end.round().clamp(heightMinLimit, heightMaxLimit);
    if (heightStart > heightEnd) {
      final temp = heightStart;
      heightStart = heightEnd;
      heightEnd = temp;
    }
    notifyListeners();
  }

  List<String> get selectedMaritalStatuses =>
      _selectedNames(maritalStatusOptions);
  List<String> get selectedReligions => _selectedNames(religionOptions);
  List<String> get selectedMotherTongues => _selectedNames(motherTongueOptions);
  List<String> get selectedCountries => _selectedNames(countryOptions);
  List<String> get selectedWorkingWith => _selectedNames(workingWithOptions);
  List<String> get selectedAnnualIncome => _selectedNames(annualIncomeOptions);

  List<String> get selectedMaritalStatusValues =>
      _selectedValues(maritalStatusOptions);
  List<String> get selectedReligionValues => _selectedValues(religionOptions);
  List<String> get selectedMotherTongueValues =>
      _selectedValues(motherTongueOptions);
  List<String> get selectedCountryValues => _selectedValues(countryOptions);
  List<String> get selectedWorkingWithValues =>
      _selectedValues(workingWithOptions);
  List<String> get selectedAnnualIncomeValues =>
      _selectedValues(annualIncomeOptions);

  Map<String, dynamic> buildResult() {
    return <String, dynamic>{
      'ageRange': <int>[ageStart, ageEnd],
      'heightRange': <int>[heightStart, heightEnd],
      'maritalStatus': selectedMaritalStatusValues,
      'religion': selectedReligionValues,
      'community': selectedCommunities,
      'motherTongue': selectedMotherTongueValues,
      'countryLivingIn': selectedCountryValues,
      'workingWith': selectedWorkingWithValues,
      'annualIncome': selectedAnnualIncomeValues,
    };
  }

  ContactFiltersSettings buildSettings() {
    return ContactFiltersSettings(
      ageStart: ageStart,
      ageEnd: ageEnd,
      heightStart: heightStart,
      heightEnd: heightEnd,
      maritalStatus: selectedMaritalStatusValues,
      religion: selectedReligionValues,
      community: selectedCommunities,
      motherTongue: selectedMotherTongueValues,
      countryLivingIn: selectedCountryValues,
      workingWith: selectedWorkingWithValues,
      annualIncome: selectedAnnualIncomeValues,
    );
  }

  Future<ApiResponse> applyContactFilters() async {
    if (isApplying) {
      return ApiResponse.error(message: 'Already applying', statusCode: 0);
    }
    isApplying = true;
    notifyListeners();

    final settings = buildSettings();
    final response = await ContactFiltersRepository.updateContactFilters(
      settings,
      previous: _remoteSnapshot,
    );

    if (response.isSuccess) {
      _remoteSnapshot = settings;
    }

    isApplying = false;
    notifyListeners();
    return response;
  }

  void _toggleItem(List<SingleStringModel> items, int index) {
    if (index < 0 || index >= items.length) return;
    items[index].isSelected = !items[index].isSelected;
    notifyListeners();
  }

  List<String> _selectedNames(List<SingleStringModel> items) {
    return items
        .where((item) => item.isSelected)
        .map((item) => item.name)
        .toList(growable: false);
  }

  List<String> _selectedValues(List<SingleStringModel> items) {
    return items
        .where((item) => item.isSelected)
        .map((item) => (item.value ?? item.name))
        .where((value) => value.trim().isNotEmpty)
        .toList(growable: false);
  }

  String _selectedSummary(
    List<SingleStringModel> items, {
    required String fallback,
  }) {
    final selected = _selectedNames(items);
    if (selected.isEmpty) return fallback;
    if (selected.length == 1) return selected.first;
    if (selected.length == 2) return selected.join(', ');
    return '${selected.length} selected';
  }

  static SingleStringModel _lookupToItem(LookupOption option) {
    return SingleStringModel(name: option.label, value: option.key);
  }

  static String formatHeight(int heightCm) {
    final totalInches = (heightCm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet' $inches\"";
  }

  void _applyRanges(ContactFiltersSettings remote) {
    final remoteAgeStart = remote.ageStart;
    final remoteAgeEnd = remote.ageEnd;
    if (remoteAgeStart != null && remoteAgeEnd != null) {
      ageStart = remoteAgeStart.clamp(ageMinLimit, ageMaxLimit);
      ageEnd = remoteAgeEnd.clamp(ageMinLimit, ageMaxLimit);
    }

    final remoteHeightStart = remote.heightStart;
    final remoteHeightEnd = remote.heightEnd;
    if (remoteHeightStart != null && remoteHeightEnd != null) {
      heightStart = remoteHeightStart.clamp(heightMinLimit, heightMaxLimit);
      heightEnd = remoteHeightEnd.clamp(heightMinLimit, heightMaxLimit);
    }
  }

  void _applySelection(
    List<SingleStringModel> options,
    List<String>? selected,
  ) {
    if (selected == null) return;
    final normalizedSelected = selected
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();
    for (final option in options) {
      final value = (option.value ?? '').trim().toLowerCase();
      final name = option.name.trim().toLowerCase();
      option.isSelected = normalizedSelected.contains(value) ||
          normalizedSelected.contains(name);
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/enums/enums.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/data/models/lookup_option.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/location_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/lookup_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/location_data_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';

class ContactFilterProvider extends BaseChangeNotifier {
  ContactFilterProvider();

  final LookupRepository _lookupRepository = LookupRepository();
  final LocationDataRepository _locationDataRepository =
      LocationDataRepositoryImpl();

  final List<SingleStringModel> religionOptions = const <LookupOption>[
    LookupOption(key: 'islam', label: 'Islam'),
    LookupOption(key: 'hinduism', label: 'Hinduism'),
    LookupOption(key: 'christianity', label: 'Christianity'),
    LookupOption(key: 'buddhism', label: 'Buddhism'),
    LookupOption(key: 'others', label: 'Others'),
  ].map(_lookupToItem).toList(growable: false);

  final List<SingleStringModel> maritalStatusOptions =
      RegistrationMaritalStatus.values
          .map(
            (status) => SingleStringModel(
              name: status.label,
              value: status.apiValue,
            ),
          )
          .toList(growable: false);

  final List<SingleStringModel> motherTongueOptions = <SingleStringModel>[
    SingleStringModel(name: 'Bengali', value: 'bengali'),
    SingleStringModel(name: 'English', value: 'english'),
    SingleStringModel(name: 'Hindi', value: 'hindi'),
  ];

  List<SingleStringModel> communityOptions = <SingleStringModel>[];
  List<SingleStringModel> countryOptions = <SingleStringModel>[];
  List<SingleStringModel> workingWithOptions = <SingleStringModel>[];
  List<SingleStringModel> annualIncomeOptions = <SingleStringModel>[];

  bool isReligionDataLoading = false;
  bool isCareerLookupLoading = false;
  bool isLocationDataLoading = false;

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
      _selectedSummary(maritalStatusOptions, fallback: 'Select');
  String get religionSummary =>
      _selectedSummary(religionOptions, fallback: 'Select');
  String get communitySummary =>
      _selectedSummary(communityOptions, fallback: 'Select');
  String get motherTongueSummary =>
      _selectedSummary(motherTongueOptions, fallback: 'Select');
  String get countryLivingInSummary =>
      _selectedSummary(countryOptions, fallback: 'Select');
  String get workingWithSummary =>
      _selectedSummary(workingWithOptions, fallback: 'Select');
  String get annualIncomeSummary =>
      _selectedSummary(annualIncomeOptions, fallback: 'Select');

  List<String> get selectedCommunities => _selectedNames(communityOptions);

  Future<void> loadInitialData() async {
    await Future.wait<void>([
      loadCommunityData(),
      loadCareerLookupData(),
      loadLocationData(),
    ]);
    notifyListeners();
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

      workingWithOptions = results[0]
          .map((item) => _lookupToItem(item))
          .toList(growable: false);
      annualIncomeOptions = results[1]
          .map((item) => _lookupToItem(item))
          .toList(growable: false);
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

  List<String> get selectedMaritalStatuses => _selectedNames(maritalStatusOptions);
  List<String> get selectedReligions => _selectedNames(religionOptions);
  List<String> get selectedMotherTongues => _selectedNames(motherTongueOptions);
  List<String> get selectedCountries => _selectedNames(countryOptions);
  List<String> get selectedWorkingWith => _selectedNames(workingWithOptions);
  List<String> get selectedAnnualIncome => _selectedNames(annualIncomeOptions);

  Map<String, dynamic> buildResult() {
    return <String, dynamic>{
      'ageRange': <int>[ageStart, ageEnd],
      'heightRange': <int>[heightStart, heightEnd],
      'maritalStatus': selectedMaritalStatuses,
      'religion': selectedReligions,
      'community': selectedCommunities,
      'motherTongue': selectedMotherTongues,
      'countryLivingIn': selectedCountries,
      'workingWith': selectedWorkingWith,
      'annualIncome': selectedAnnualIncome,
    };
  }

  void _toggleItem(List<SingleStringModel> items, int index) {
    if (index < 0 || index >= items.length) return;
    items[index].isSelected = !items[index].isSelected;
    notifyListeners();
  }

  List<String> _selectedNames(List<SingleStringModel> items) {
    return items.where((item) => item.isSelected).map((item) => item.name).toList();
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
}

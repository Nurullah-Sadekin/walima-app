import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/enums/enums.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/data/models/lookup_option.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/location_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/lookup_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/location_data_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/location_data_repository.dart';

class ContactFilterProvider extends BaseChangeNotifier {
  ContactFilterProvider();

  final LookupRepository _lookupRepository = LookupRepository();
  final LocationDataRepository _locationDataRepository =
      LocationDataRepositoryImpl();

  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController communityController = TextEditingController();
  final TextEditingController motherTongueController = TextEditingController();
  final TextEditingController countryLivingInController =
      TextEditingController();
  final TextEditingController workingWithController = TextEditingController();
  final TextEditingController annualIncomeController = TextEditingController();

  List<LookupOption> religionOptions = const <LookupOption>[
    LookupOption(key: 'islam', label: 'Islam'),
    LookupOption(key: 'hinduism', label: 'Hinduism'),
    LookupOption(key: 'christianity', label: 'Christianity'),
    LookupOption(key: 'buddhism', label: 'Buddhism'),
    LookupOption(key: 'others', label: 'Others'),
  ];
  List<LookupOption> communityOptions = <LookupOption>[];
  List<LookupOption> professionOptions = <LookupOption>[];
  List<LookupOption> incomeRangeOptions = <LookupOption>[];
  List<CountryLocationModel> countryOptions = <CountryLocationModel>[];

  final List<String> maritalStatusDropdownItems = RegistrationMaritalStatus
      .values
      .map((status) => status.label)
      .toList(growable: false);
  final List<String> motherTongueDropdownItems = const <String>[
    'Bengali',
    'English',
    'Hindi',
  ];

  List<String> religionDropdownItems = <String>[];
  List<String> communityDropdownItems = <String>[];
  List<String> countryDropdownItems = <String>[];
  List<String> workingWithDropdownItems = <String>[];
  List<String> annualIncomeDropdownItems = <String>[];

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

  Future<void> loadInitialData() async {
    religionDropdownItems =
        religionOptions.map((item) => item.label).toList(growable: false);

    await Future.wait<void>([
      loadCommunityData(),
      loadCareerLookupData(),
      loadLocationData(),
    ]);
    notifyListeners();
  }

  Future<void> loadCommunityData() async {
    final selectedReligion = religionController.text.trim();
    if (selectedReligion.isEmpty) {
      communityOptions = <LookupOption>[];
      communityDropdownItems = <String>[];
      notifyListeners();
      return;
    }

    final religion = _findLookupOption(religionOptions, selectedReligion);
    if (religion == null) {
      communityOptions = <LookupOption>[];
      communityDropdownItems = <String>[];
      notifyListeners();
      return;
    }

    isReligionDataLoading = true;
    notifyListeners();

    try {
      communityOptions = await _lookupRepository.getLookupsBySlug(religion.key);
      communityDropdownItems =
          communityOptions.map((item) => item.label).toList(growable: false);
    } catch (_) {
      communityOptions = <LookupOption>[];
      communityDropdownItems = <String>[];
    } finally {
      isReligionDataLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCareerLookupData() async {
    if (isCareerLookupLoading) return;
    if (professionOptions.isNotEmpty && incomeRangeOptions.isNotEmpty) return;

    isCareerLookupLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait<List<LookupOption>>([
        _lookupRepository.getLookups(LookupCategory.professions),
        _lookupRepository.getLookups(LookupCategory.incomeRange),
      ]);

      professionOptions = results[0];
      incomeRangeOptions = results[1];
      workingWithDropdownItems =
          professionOptions.map((item) => item.label).toList(growable: false);
      annualIncomeDropdownItems =
          incomeRangeOptions.map((item) => item.label).toList(growable: false);
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
      countryOptions = await _locationDataRepository.getCountries();
      countryDropdownItems =
          countryOptions.map((item) => item.name).toList(growable: false);
    } finally {
      isLocationDataLoading = false;
      notifyListeners();
    }
  }

  void onMaritalStatusSelected(String? value) {
    _setControllerValue(maritalStatusController, value);
  }

  void onReligionSelected(String? value) {
    final selected = value?.trim() ?? '';
    if (selected.isEmpty) return;

    final changed =
        religionController.text.trim().toLowerCase() != selected.toLowerCase();
    religionController.text = selected;
    if (changed) {
      communityController.clear();
      communityDropdownItems = <String>[];
      unawaited(loadCommunityData());
    }
    notifyListeners();
  }

  void onCommunitySelected(String? value) {
    _setControllerValue(communityController, value);
  }

  void onMotherTongueSelected(String? value) {
    _setControllerValue(motherTongueController, value);
  }

  void onCountryLivingInSelected(String? value) {
    _setControllerValue(countryLivingInController, value);
  }

  void onWorkingWithSelected(String? value) {
    _setControllerValue(workingWithController, value);
  }

  void onAnnualIncomeSelected(String? value) {
    _setControllerValue(annualIncomeController, value);
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

  Map<String, dynamic> buildResult() {
    return <String, dynamic>{
      'ageRange': <int>[ageStart, ageEnd],
      'heightRange': <int>[heightStart, heightEnd],
      'maritalStatus': maritalStatusController.text.trim(),
      'religion': religionController.text.trim(),
      'community': communityController.text.trim(),
      'motherTongue': motherTongueController.text.trim(),
      'countryLivingIn': countryLivingInController.text.trim(),
      'workingWith': workingWithController.text.trim(),
      'annualIncome': annualIncomeController.text.trim(),
    };
  }

  LookupOption? _findLookupOption(List<LookupOption> options, String raw) {
    final normalized = raw.trim().toLowerCase();
    for (final option in options) {
      if (option.label.trim().toLowerCase() == normalized) {
        return option;
      }
    }
    return null;
  }

  void _setControllerValue(TextEditingController controller, String? value) {
    final selected = value?.trim() ?? '';
    if (selected.isEmpty) return;
    controller.text = selected;
    notifyListeners();
  }

  static String formatHeight(int heightCm) {
    final totalInches = (heightCm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet' $inches\"";
  }

  @override
  void dispose() {
    maritalStatusController.dispose();
    religionController.dispose();
    communityController.dispose();
    motherTongueController.dispose();
    countryLivingInController.dispose();
    workingWithController.dispose();
    annualIncomeController.dispose();
    super.dispose();
  }
}

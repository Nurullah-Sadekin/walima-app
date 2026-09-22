import 'dart:async';

import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';
import 'package:walima_llc/features/registration/data/repository/lookup_repository.dart';
import 'package:walima_llc/features/registration/domain/single_string_model.dart';

class MyMatchFilterProvider extends BaseChangeNotifier {
  MyMatchFilterProvider();

  final LookupRepository _lookupRepository = LookupRepository();

  static final List<SingleStringModel> _professionFallbackList =
      <SingleStringModel>[
        SingleStringModel(name: 'Engineer'),
        SingleStringModel(name: 'Doctor'),
        SingleStringModel(name: 'Teacher'),
        SingleStringModel(name: 'Business'),
        SingleStringModel(name: 'Other'),
      ];

  // Lists used for selection UIs
  List<SingleStringModel> countries = List.from(countryListDataInserted);

  /// Populated from `GET /lookups?categorySlug={religion}` once a religion is
  /// picked — same dependency web models via `dependsOn.buildUrl`.
  List<SingleStringModel> communities = <SingleStringModel>[];
  bool isCommunityLoading = false;
  List<SingleStringModel> maritalStatusList = List.from(maritalStatusListDataInserted);
  List<SingleStringModel> incomeRangeList = List.from(incomeRangeListInserted);
  List<SingleStringModel> yourWorkList = List.from(yourWorkListInserted);
  List<SingleStringModel> youWorkAsList = List.from(_professionFallbackList);
  // fallback / small default lists
  List<SingleStringModel> booleanOptionList = [
    SingleStringModel(name: 'Open to All'),
    SingleStringModel(name: 'Custom'),
  ];
  // dedicated boolean option lists (separate instances for each step)
  List<SingleStringModel> photoSettingOptions = [
    SingleStringModel(name: 'Open to All'),
    SingleStringModel(name: 'Custom'),
  ];
  List<SingleStringModel> recentlyJoinedOptions = [
    SingleStringModel(name: 'Open to All'),
    SingleStringModel(name: 'Custom'),
  ];
  List<SingleStringModel> activeMembersOptions = [
    SingleStringModel(name: 'Open to All'),
    SingleStringModel(name: 'Custom'),
  ];
  List<SingleStringModel> educationLevelList = [
    SingleStringModel(name: 'Open to All'),
    SingleStringModel(name: 'High School'),
    SingleStringModel(name: 'Bachelor'),
    SingleStringModel(name: 'Master'),
    SingleStringModel(name: 'PhD'),
  ];
  List<SingleStringModel> religionList = religionLookupOptions
      .map((item) => SingleStringModel(name: item.label, value: item.key))
      .toList();
  List<SingleStringModel> motherTongues = [
    SingleStringModel(name: 'Bengali'),
    SingleStringModel(name: 'English'),
    SingleStringModel(name: 'Hindi'),
  ];
  List<SingleStringModel> profileManagedByList = [
    SingleStringModel(name: 'Open to All'),
    SingleStringModel(name: 'Self Managed'),
    SingleStringModel(name: 'Family Managed'),
  ];
  List<SingleStringModel> eatingHabitsList = [
    SingleStringModel(name: 'Open to All'),
    SingleStringModel(name: 'Veg'),
    SingleStringModel(name: 'Non-Veg'),
    SingleStringModel(name: 'Jain'),
  ];

  void toggleCountry(int index) {
    if (index < 0 || index >= countries.length) return;
    countries[index].isSelected = !countries[index].isSelected;
    notifyListeners();
  }

  void toggleCommunity(int index) {
    if (index < 0 || index >= communities.length) return;
    communities[index].isSelected = !communities[index].isSelected;
    notifyListeners();
  }

  void toggleMaritalStatus(int index) {
    if (index < 0 || index >= maritalStatusList.length) return;
    maritalStatusList[index].isSelected = !maritalStatusList[index].isSelected;
    notifyListeners();
  }

  void toggleIncomeRange(int index) {
    if (index < 0 || index >= incomeRangeList.length) return;
    incomeRangeList[index].isSelected = !incomeRangeList[index].isSelected;
    notifyListeners();
  }

  void toggleYourWork(int index) {
    if (index < 0 || index >= yourWorkList.length) return;
    yourWorkList[index].isSelected = !yourWorkList[index].isSelected;
    notifyListeners();
  }

  void toggleYouWorkAs(int index) {
    if (index < 0 || index >= youWorkAsList.length) return;
    youWorkAsList[index].isSelected = !youWorkAsList[index].isSelected;
    notifyListeners();
  }

  void toggleReligion(int index) {
    if (index < 0 || index >= religionList.length) return;
    religionList[index].isSelected = !religionList[index].isSelected;
    notifyListeners();
    unawaited(loadCommunityData());
  }

  /// Communities depend on the selected religion. `open_to_all` and `others`
  /// have no community category server-side, so nothing is fetched for them.
  Future<void> loadCommunityData() async {
    final slugs = selectedReligion
        .where(religionHasCommunityOptions)
        .toList(growable: false);

    if (slugs.isEmpty) {
      communities = <SingleStringModel>[];
      notifyListeners();
      return;
    }

    isCommunityLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait<List<LookupOption>>(
        slugs.map((slug) => _lookupRepository.getLookupsBySlug(slug)),
      );

      final previouslySelected = selectedCommunities.toSet();
      final merged = <String, SingleStringModel>{};

      for (final result in results) {
        for (final option in result) {
          merged[option.key] = SingleStringModel(
            name: option.label,
            value: option.key,
            isSelected: previouslySelected.contains(option.key),
          );
        }
      }

      communities = merged.values.toList(growable: false);
    } catch (_) {
      communities = <SingleStringModel>[];
    } finally {
      isCommunityLoading = false;
      notifyListeners();
    }
  }

  void toggleMotherTongue(int index) {
    if (index < 0 || index >= motherTongues.length) return;
    motherTongues[index].isSelected = !motherTongues[index].isSelected;
    notifyListeners();
  }

  void toggleProfileManagedBy(int index) {
    if (index < 0 || index >= profileManagedByList.length) return;
    profileManagedByList[index].isSelected = !profileManagedByList[index].isSelected;
    notifyListeners();
  }

  void toggleEatingHabits(int index) {
    if (index < 0 || index >= eatingHabitsList.length) return;
    eatingHabitsList[index].isSelected = !eatingHabitsList[index].isSelected;
    notifyListeners();
  }

  // single-selection helpers
  void _selectSingle(List<SingleStringModel> list, int index) {
    if (index < 0 || index >= list.length) return;
    for (var i = 0; i < list.length; i++) {
      list[i].isSelected = i == index;
    }
    notifyListeners();
  }

  void selectPhotoSettingOption(int index) => _selectSingle(photoSettingOptions, index);
  void selectRecentlyJoinedOption(int index) => _selectSingle(recentlyJoinedOptions, index);
  void selectActiveMembersOption(int index) => _selectSingle(activeMembersOptions, index);
  void selectIncomeRange(int index) => _selectSingle(incomeRangeList, index);
  void selectEducationLevel(int index) => _selectSingle(educationLevelList, index);
  void selectReligion(int index) {
    _selectSingle(religionList, index);
    unawaited(loadCommunityData());
  }

  void selectCountry(int index) => _selectSingle(countries, index);
  void selectCommunity(int index) => _selectSingle(communities, index);
  void selectProfileManagedBy(int index) => _selectSingle(profileManagedByList, index);
  void selectEatingHabits(int index) => _selectSingle(eatingHabitsList, index);

  List<String> get selectedCountries => countries.where((c) => c.isSelected).map((e) => e.name).toList();
  // Religion and community submit their API value (`islam`, `sunni`), never the
  // display label — the backend matches on the lookup key.
  List<String> get selectedCommunities =>
      communities.where((c) => c.isSelected).map((e) => e.value ?? e.name).toList();
  List<String> get selectedMaritalStatus => maritalStatusList.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedIncomeRanges => incomeRangeList.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedYourWork => yourWorkList.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedYouWorkAs => youWorkAsList.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedReligion =>
      religionList.where((c) => c.isSelected).map((e) => e.value ?? e.name).toList();
  List<String> get selectedMotherTongues => motherTongues.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedProfileManagedBy => profileManagedByList.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedEatingHabits => eatingHabitsList.where((c) => c.isSelected).map((e) => e.name).toList();

  void clearAll() {
    for (var c in countries) {
      c.isSelected = false;
    }
    for (var c in communities) {
      c.isSelected = false;
    }
    for (var c in maritalStatusList) {
      c.isSelected = false;
    }
    for (var c in incomeRangeList) {
      c.isSelected = false;
    }
    for (var c in yourWorkList) {
      c.isSelected = false;
    }
    for (var c in youWorkAsList) {
      c.isSelected = false;
    }
    for (var c in religionList) {
      c.isSelected = false;
    }
    for (var c in motherTongues) {
      c.isSelected = false;
    }
    for (var c in profileManagedByList) {
      c.isSelected = false;
    }
    for (var c in eatingHabitsList) {
      c.isSelected = false;
    }
    notifyListeners();
  }
}

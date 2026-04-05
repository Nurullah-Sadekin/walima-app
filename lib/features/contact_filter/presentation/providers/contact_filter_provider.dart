import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';

class ContactFilterProvider extends BaseChangeNotifier {
  ContactFilterProvider();

  static final List<SingleStringModel> _professionFallbackList =
      <SingleStringModel>[
        SingleStringModel(name: 'Engineer'),
        SingleStringModel(name: 'Doctor'),
        SingleStringModel(name: 'Teacher'),
        SingleStringModel(name: 'Business'),
        SingleStringModel(name: 'Other'),
      ];

  List<SingleStringModel> countries = List.from(countryListDataInserted);
  List<SingleStringModel> communities = List.from(communityListDataInserted);
  List<SingleStringModel> maritalStatusList = List.from(maritalStatusListDataInserted);
  List<SingleStringModel> incomeRangeList = List.from(incomeRangeListInserted);
  List<SingleStringModel> yourWorkList = List.from(yourWorkListInserted);
  List<SingleStringModel> youWorkAsList = List.from(_professionFallbackList);
  List<SingleStringModel> booleanOptionList = [
    SingleStringModel(name: 'Open to All'),
    SingleStringModel(name: 'Custom'),
  ];
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
  List<SingleStringModel> religionList = communityListDataInserted
      .where((e) => ['Sunni', 'Shia', 'Ahmadi', 'Islam', 'Hindu', 'Buddhist', 'Christian', 'Jain'].contains(e.name))
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
  void selectReligion(int index) => _selectSingle(religionList, index);
  void selectCountry(int index) => _selectSingle(countries, index);
  void selectCommunity(int index) => _selectSingle(communities, index);
  void selectProfileManagedBy(int index) => _selectSingle(profileManagedByList, index);
  void selectEatingHabits(int index) => _selectSingle(eatingHabitsList, index);

  List<String> get selectedCountries => countries.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedCommunities => communities.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedMaritalStatus => maritalStatusList.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedIncomeRanges => incomeRangeList.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedYourWork => yourWorkList.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedYouWorkAs => youWorkAsList.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedReligion => religionList.where((c) => c.isSelected).map((e) => e.name).toList();
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


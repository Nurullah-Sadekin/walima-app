import 'package:flutter_boilerplate/core/global/enums/enums.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/data/models/lookup_option.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';
import 'package:flutter/material.dart';

class ContactFilterProvider extends BaseChangeNotifier {
  ContactFilterProvider();

  List<SingleStringModel> countries = List.from(countryListDataInserted);
  List<SingleStringModel> communities = List.from(communityListDataInserted);
  List<SingleStringModel> maritalStatusList = [
    ...RegistrationMaritalStatus.values.map(
          (status) => SingleStringModel(
        name: status.label,
        value: status.apiValue,
      ),
    ),
  ];
  List<SingleStringModel> motherTongues = [
    SingleStringModel(name: 'Bengali'),
    SingleStringModel(name: 'English'),
    SingleStringModel(name: 'Hindi'),
  ];

  final int ageMinLimit = 18;
  final int ageMaxLimit = 70;
  int ageStart = 25;
  int ageEnd = 35;
  final int heightMinLimit = 120;
  final int heightMaxLimit = 220;
  int heightStart = 160;
  int heightEnd = 180;

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

  void toggleMotherTongue(int index) {
    if (index < 0 || index >= motherTongues.length) return;
    motherTongues[index].isSelected = !motherTongues[index].isSelected;
    notifyListeners();
  }


  List<String> get selectedCountries => countries.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedCommunities => communities.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedMaritalStatus => maritalStatusList.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedMotherTongues => motherTongues.where((c) => c.isSelected).map((e) => e.name).toList();

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
    for (var c in motherTongues) {
      c.isSelected = false;
    }
    notifyListeners();
  }
}

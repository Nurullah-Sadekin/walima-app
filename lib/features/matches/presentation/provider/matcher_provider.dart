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

class MatchesProvider extends BaseChangeNotifier {
  MatchesProviderScreenStates screenStates =
      MatchesProviderScreenStates.defaultLoading;
  MatchesProviderScreenStates loaderState =
      MatchesProviderScreenStates.defaultLoading;

  bool? switcherValue = false;

  String? selectedIsWithFamilyStatus;
  List<SingleStringModel> sortByDataList = sortByListDataInserted;

  int selectedTabIndex = 0;

  void setSelectedTab(int index) {
    if (index == selectedTabIndex) return;
    if (index < 0) return;
    selectedTabIndex = index;
    notifyListeners();
  }

  bool _isValidIndex(int index, int length) {
    return index >= 0 && index < length;
  }

  void _setSingleSelection<T>(
    List<T> list,
    int selectedIndex,
    void Function(T item, bool selected) applySelection,
  ) {
    for (var i = 0; i < list.length; i++) {
      applySelection(list[i], i == selectedIndex);
    }
  }

  void sortBy(int index) {
    if (!_isValidIndex(index, sortByDataList.length)) return;
    _setSingleSelection(
      sortByDataList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedIsWithFamilyStatus = sortByDataList[index].name;

    notifyListeners();
  }

  void updateViewState(
      {MatchesProviderScreenStates? screenStates,
      MatchesProviderScreenStates? loadingState}) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = MatchesProviderScreenStates.defaultLoading;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }
}

enum MatchesProviderScreenStates {
  defaultLoading,
  loadingComplete,
  preferences,
}

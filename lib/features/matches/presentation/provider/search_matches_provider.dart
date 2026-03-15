import 'dart:async';
import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/core/utils/prefs_helper.dart';
import 'package:flutter_boilerplate/features/login/data/models/resend_otp_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/sign_up_otp_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/sign_up_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/upload_media_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/update_interests_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/update_family_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/response/onboarding_response.dart';
import 'package:flutter_boilerplate/features/registration/data/models/response/upload_media_response.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/interests_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/family_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/location_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/media_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/religion_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/registration_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/location_data_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/religion_option_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/location_data_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/religion_data_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/is_with_family_status_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/profile_for_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SearchMatchesProvider extends BaseChangeNotifier {
    SearchMatchesScreenStates screenStates = SearchMatchesScreenStates.defaultLoading;
    SearchMatchesScreenStates loaderState = SearchMatchesScreenStates.defaultLoading;

    final TextEditingController profileIdController = TextEditingController();
    final TextEditingController ageFromController = TextEditingController();
    final TextEditingController ageToController = TextEditingController();
    final TextEditingController heightFromController = TextEditingController();
    final TextEditingController heightToController = TextEditingController();
    final TextEditingController maritalStatusController = TextEditingController();
    final TextEditingController religionController = TextEditingController();
    final TextEditingController communityController = TextEditingController();
    final TextEditingController motherTongueController = TextEditingController();
    final TextEditingController countryLivingController = TextEditingController();
    final TextEditingController stateLivingController = TextEditingController();
    final TextEditingController grewUpController = TextEditingController();
    final TextEditingController residencyStatusController = TextEditingController();
    final TextEditingController photoSettingController = TextEditingController();

    // Additional controllers for dropdown selections
    final TextEditingController qualificationController = TextEditingController();
    final TextEditingController educationAreaController = TextEditingController();
    final TextEditingController workingWithController = TextEditingController();
    final TextEditingController professionAreaController = TextEditingController();
    final TextEditingController profileManageByController = TextEditingController();


    List<SingleStringModel> ageRangeDropdownItems = ageListDataInserted;
    List<SingleStringModel> haveChildren = haveChildrenDataListInserted;
    List<SingleStringModel> annualIncomeRange = incomeRangeListInserted;
    List<SingleStringModel> dietData = dietDataListInserted;

    String? selectedHaveChildrenStatus;
    String? selectedAnnualIncomeRangeStatus;
    String? selectedDietStatus;
    bool? filteredProfiles = false;
    bool? viewedProfile = false;

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

    void selectedHaveChildren(int index) {
      if (!_isValidIndex(index, haveChildren.length)) return;
      _setSingleSelection(
        haveChildren,
        index,
        (item, selected) => item.isSelected = selected,
      );
      selectedHaveChildrenStatus = haveChildren[index].name;
      notifyListeners();
    }

    void selectedAnnualIncome(int index) {
      if (!_isValidIndex(index, annualIncomeRange.length)) return;
      _setSingleSelection(
        annualIncomeRange,
        index,
        (item, selected) => item.isSelected = selected,
      );
      selectedAnnualIncomeRangeStatus = annualIncomeRange[index].name;
      notifyListeners();
    }

    void selectedDiet(int index) {
      if (!_isValidIndex(index, dietData.length)) return;
      _setSingleSelection(
        dietData,
        index,
        (item, selected) => item.isSelected = selected,
      );
      selectedDietStatus = dietData[index].name;
      notifyListeners();
    }


    void updateViewState({SearchMatchesScreenStates? screenStates,
      SearchMatchesScreenStates? loadingState}) {
      if (screenStates != null) {
        this.screenStates = screenStates;
        loaderState = SearchMatchesScreenStates.defaultLoading;
      }
      if (loadingState != null) loaderState = loadingState;
      notifyListeners();
    }
 }

enum SearchMatchesScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}

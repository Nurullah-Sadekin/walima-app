import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/enums/enums.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';

class SearchFilterProvider extends BaseChangeNotifier {
    SearchFilterScreenStates screenStates = SearchFilterScreenStates.defaultLoading;
    SearchFilterScreenStates loaderState = SearchFilterScreenStates.defaultLoading;

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
    List<SingleStringModel> heightRangeDropdownItems = List.generate(
      121,
      (index) => SingleStringModel(name: '${100 + index}'),
    );
    List<SingleStringModel> maritalStatusDropdownItems = maritalStatusListDataInserted;
    List<SingleStringModel> religionDropdownItems = [
      ...Religion.values.map(
        (item) => SingleStringModel(name: item.label, value: item.apiValue),
      ),
    ];
    List<SingleStringModel> communityDropdownItems = communityListDataInserted;
    List<SingleStringModel> motherTongueDropdownItems = [
      SingleStringModel(name: 'Bengali'),
      SingleStringModel(name: 'English'),
      SingleStringModel(name: 'Hindi'),
      SingleStringModel(name: 'Urdu'),
      SingleStringModel(name: 'Arabic'),
    ];
    List<SingleStringModel> countryDropdownItems = countryListDataInserted;
    List<SingleStringModel> residencyStatusDropdownItems = [
      ...ResidencyStatus.values.map(
        (item) => SingleStringModel(name: item.label, value: item.apiValue),
      ),
    ];
    List<SingleStringModel> photoVisibilityDropdownItems = [
      ...PhotoVisibilityFilter.values.map(
        (item) => SingleStringModel(name: item.label, value: item.apiValue),
      ),
    ];
    List<SingleStringModel> qualificationDropdownItems = [
      ...EducationLevel.values.map(
        (item) => SingleStringModel(name: item.label, value: item.apiValue),
      ),
    ];
    List<SingleStringModel> workingWithDropdownItems = yourWorkListInserted;
    List<SingleStringModel> profileManagedByDropdownItems = [
      ...RegistrationProfileManagedBy.values.map(
        (item) => SingleStringModel(name: item.label, value: item.apiValue),
      ),
    ];
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
      selectedHaveChildrenStatus =
          haveChildren[index].value ?? haveChildren[index].name;
      notifyListeners();
    }

    void selectedAnnualIncome(int index) {
      if (!_isValidIndex(index, annualIncomeRange.length)) return;
      _setSingleSelection(
        annualIncomeRange,
        index,
        (item, selected) => item.isSelected = selected,
      );
      selectedAnnualIncomeRangeStatus =
          annualIncomeRange[index].value ?? annualIncomeRange[index].name;
      notifyListeners();
    }

    void selectedDiet(int index) {
      if (!_isValidIndex(index, dietData.length)) return;
      _setSingleSelection(
        dietData,
        index,
        (item, selected) => item.isSelected = selected,
      );
      selectedDietStatus = dietData[index].value ?? dietData[index].name;
      notifyListeners();
    }


    void updateViewState({
      SearchFilterScreenStates? screenStates,
      SearchFilterScreenStates? loadingState,
    }) {
      if (screenStates != null) {
        this.screenStates = screenStates;
        loaderState = SearchFilterScreenStates.defaultLoading;
      }
      if (loadingState != null) loaderState = loadingState;
      notifyListeners();
    }
 }

enum SearchFilterScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}

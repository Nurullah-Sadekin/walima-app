import 'package:flutter/material.dart';
import 'package:walima_llc/core/global/enums/enums.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';
import 'package:walima_llc/features/registration/data/repository/lookup_repository.dart';
import 'package:walima_llc/features/registration/domain/single_string_model.dart';

class SearchFilterProvider extends BaseChangeNotifier {
    SearchFilterProvider();

    final LookupRepository _lookupRepository = LookupRepository();
    static final List<int> _heightInchOptions = List<int>.generate(
      33,
      (index) => 51 + index,
    );

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
    List<SingleStringModel> heightRangeDropdownItems = _defaultHeightRangeItems();

    List<SingleStringModel> motherTongueDropdownItems = _defaultMotherTongueItems();
    List<SingleStringModel> maritalStatusDropdownItems = maritalStatusListDataInserted;
    List<SingleStringModel> religionDropdownItems = [
      ...Religion.values.map(
        (item) => SingleStringModel(name: item.label, value: item.apiValue),
      ),
    ];
    List<SingleStringModel> communityDropdownItems = communityListDataInserted;
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
    bool _isLookupDataLoading = false;

    Future<void> loadLookupData() async {
      if (_isLookupDataLoading) return;
      _isLookupDataLoading = true;

      try {
        final motherTongueOptions = _lookupToSingleStrings(
          await _loadLookupByPrioritySlugs(
            const <String>['mother-tongue'],
          ),
        );

        if (motherTongueOptions.isNotEmpty) {
          motherTongueDropdownItems = motherTongueOptions;
        }
      } catch (_) {
        // Keep fallback lists when lookup loading fails.
      } finally {
        _isLookupDataLoading = false;
        notifyListeners();
      }
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

    static List<SingleStringModel> _defaultHeightRangeItems() {
      return _heightInchOptions
          .map(
            (heightInches) => SingleStringModel(
              name: _formatHeightDisplay(heightInches),
              value: _heightCmFromInches(heightInches).toString(),
            ),
          )
          .toList(growable: false);
    }

    static List<SingleStringModel> _defaultMotherTongueItems() {
      return <SingleStringModel>[
        SingleStringModel(name: 'Bengali', value: 'bengali'),
        SingleStringModel(name: 'English', value: 'english'),
        SingleStringModel(name: 'Hindi', value: 'hindi'),
        SingleStringModel(name: 'Urdu', value: 'urdu'),
        SingleStringModel(name: 'Arabic', value: 'arabic'),
      ];
    }

    Future<List<LookupOption>> _loadLookupByPrioritySlugs(
      List<String> slugs,
    ) async {
      for (final slug in slugs) {
        try {
          final options = await _lookupRepository.getLookupsBySlug(slug);
          if (options.isNotEmpty) {
            return options;
          }
        } catch (_) {
          // Try the next possible slug.
        }
      }

      return const <LookupOption>[];
    }

    List<SingleStringModel> _lookupToSingleStrings(List<LookupOption> options) {
      return options
          .map(
            (option) => SingleStringModel(
              name: option.label,
              value: option.key,
            ),
          )
          .toList(growable: false);
    }

    static String _formatHeightDisplay(int totalInches) {
      final feet = totalInches ~/ 12;
      final inches = totalInches % 12;
      return '$feet ft $inches in';
    }

    static int _heightCmFromInches(int totalInches) {
      return (totalInches * 2.54).round();
    }
 }

enum SearchFilterScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}

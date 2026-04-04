import 'dart:async';
import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
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
import 'package:flutter_boilerplate/features/registration/data/models/lookup_option.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/interests_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/family_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/lookup_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/location_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/media_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/registration_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/location_data_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/location_data_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/is_with_family_status_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/profile_for_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RegistrationProvider extends BaseChangeNotifier {
  VoidCallback? _controllersListener;
  Timer? _persistDebounce;
  bool _isDraftInitialized = false;
  bool _isRestoringDraft = false;

  String? selectedProfileName;
  String? selectedGenderName;
  String? selectedIsWithFamilyStatus;
  String? selectedDietStatus;
  String? selectedIncomePeriodStatus;
  String? selectedIncomeRange;
  String? selectedYourWork;
  String? selectedYouWorkAs;
  String? selectedFamilyEconomicCondition;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController communityController = TextEditingController();
  final TextEditingController livingInController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController residencyStatusController =
      TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController highestQualification = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController anotherInstituteController =
      TextEditingController();
  final TextEditingController aboutYourselfController = TextEditingController();
  final TextEditingController currentCompanyNameController =
      TextEditingController();
  final TextEditingController incomeRangeController = TextEditingController();
  final TextEditingController yourWorkController = TextEditingController();
  final TextEditingController youWorkAsController = TextEditingController();
  final TextEditingController motherDetailsController = TextEditingController();
  final TextEditingController fatherDetailsController = TextEditingController();
  final TextEditingController noOfSisterController = TextEditingController();
  final TextEditingController noOfBrotherController = TextEditingController();

  List<ProfileForModel> profileForList = profileForListInserted;
  List<GenderProfileForModel> genderForList = genderForListInserted;
  List<IsWithFamilyModel> isWithFamilyDataList = isWithFamilyDataListInserted;
  List<IsWithFamilyModel> incomePeriodDataList = incomePeriodDataListInserted;
  List<SingleStringModel> dietDataList = dietDataListInserted;
  List<SingleStringModel> incomeRangeList = <SingleStringModel>[];
  List<SingleStringModel> yourWorkList = yourWorkListInserted;
  List<SingleStringModel> youWorkAsList = <SingleStringModel>[];
  List<SingleStringModel> creativeItemList = <SingleStringModel>[];
  List<SingleStringModel> funItemList = <SingleStringModel>[];
  List<SingleStringModel> fitnessItemList = <SingleStringModel>[];
  List<SingleStringModel> otherInterestsItemList = <SingleStringModel>[];
  List<SingleStringModel> foodCuisineItemList = <SingleStringModel>[];
  List<SingleStringModel> travelLeisureItemList = <SingleStringModel>[];
  List<SingleStringModel> motherDetailsItemList =
      motherDetailsItemListDataInserted;
  List<SingleStringModel> fatherDetailsItemList =
      fatherDetailsItemListDataInserted;
  List<SingleStringModel> siblingCountList = siblingCountListDataInserted;
  List<SingleStringModel> verificationList = verificationTypeList;
  static const int hobbiesSelectionMax = 5;
  final List<String> selectedHobbies = [];

  bool creativeSectionSelected = false;
  bool funSectionSelected = false;
  bool fitnessSectionSelected = false;
  bool otherInterestsSectionSelected = false;
  bool verificationDone = false;

  String selectedVerificationType = 'email'; // or 'phone'

  final LocationDataRepository _locationDataRepository =
      LocationDataRepositoryImpl();
  final LookupRepository _lookupRepository = LookupRepository();
  final MediaRepository _mediaRepository = MediaRepository();
  final InterestsRepository _interestsRepository = InterestsRepository();
  final FamilyRepository _familyRepository = FamilyRepository();

  List<LookupOption> religionOptions = <LookupOption>[];
  List<LookupOption> communityOptions = <LookupOption>[];
  List<LookupOption> educationLevelOptions = <LookupOption>[];
  List<LookupOption> professionOptions = <LookupOption>[];
  List<LookupOption> incomeRangeOptions = <LookupOption>[];
  List<String> religionDropdownItems = <String>[];
  List<String> communityDropdownItems = <String>[];
  bool isReligionDataLoading = false;
  String? religionDataError;
  bool isLookupDataLoading = false;
  String? lookupDataError;

  List<CountryLocationModel> countryOptions = <CountryLocationModel>[];
  List<ResidencyStatusOptionModel> residencyStatusOptions =
      <ResidencyStatusOptionModel>[];
  List<String> countryDropdownItems = <String>[];
  List<String> cityDropdownItems = <String>[];
  List<String> residencyStatusDropdownItems = <String>[];
  bool isLocationDataLoading = false;
  String? locationDataError;

  UploadMediaData? uploadedProfileMedia;
  String profileImageUploadErrorMessage = '';

  static const List<LookupOption> _staticReligionOptions = <LookupOption>[
    LookupOption(key: 'islam', label: 'Islam'),
    LookupOption(key: 'hinduism', label: 'Hinduism'),
    LookupOption(key: 'christianity', label: 'Christianity'),
    LookupOption(key: 'buddhism', label: 'Buddhism'),
    LookupOption(key: 'others', label: 'Others'),
  ];

  static const Set<String> _allowedResidencyStatusValues = <String>{
    'citizen',
    'permanent_resident',
    'work_permit',
    'student_visa',
    'temporary_visa',
    'visitor',
  };

  static const Set<String> _allowedMaritalStatusValues = <String>{
    'open_to_all',
    'never_married',
    'married',
    'divorced',
    'widowed',
    'separated',
    'awaiting_divorce',
    'annulled',
  };

  static const Set<String> _allowedDietValues = <String>{
    'vegetarian',
    'non_vegetarian',
    'halal_only',
    'vegan',
    'jain_vegetarian',
    'occasionally_non_veg',
  };

  static const Set<String> _allowedEducationValues = <String>{
    'no_formal_education',
    'primary',
    'secondary',
    'higher_secondary',
    'diploma',
    'bachelor',
    'masters',
    'phd',
    'doctorate',
    'professional_degree',
    'vocational_training',
    'certificate',
    'others',
  };

  static const Map<String, String> _residencyStatusAliases = <String, String>{
    'citizen': 'citizen',
    'permanent resident': 'permanent_resident',
    'work permit': 'work_permit',
    'student visa': 'student_visa',
    'temporary visa': 'temporary_visa',
    'visitor': 'visitor',
  };

  static const Map<String, String> _maritalStatusAliases = <String, String>{
    'open to all': 'open_to_all',
    'single': 'never_married',
    'never married': 'never_married',
    'married': 'married',
    'divorced': 'divorced',
    'widowed': 'widowed',
    'separated': 'separated',
    'awaiting divorce': 'awaiting_divorce',
    'annulled': 'annulled',
  };

  static const Map<String, String> _dietAliases = <String, String>{
    'vegetarian': 'vegetarian',
    'non vegetarian': 'non_vegetarian',
    'halal only': 'halal_only',
    'vegan': 'vegan',
    'jain vegetarian': 'jain_vegetarian',
    'occasionally non veg': 'occasionally_non_veg',
    'occasionally non-veg': 'occasionally_non_veg',
    'healthy': 'occasionally_non_veg',
    'modern balanced diet': 'occasionally_non_veg',
    'junk food lover': 'occasionally_non_veg',
    'low carb': 'occasionally_non_veg',
    'low fat': 'occasionally_non_veg',
    'low sodium': 'occasionally_non_veg',
    'low cholesterol': 'occasionally_non_veg',
    'low sugar': 'occasionally_non_veg',
    'low salt': 'occasionally_non_veg',
    'no preferences': 'occasionally_non_veg',
  };

  static const Map<String, String> _familyEconomicConditionAliases =
      <String, String>{
    'elite': 'elite',
    'high': 'high',
    'middle': 'middle_class',
    'middle class': 'middle_class',
    'middle_class': 'middle_class',
    'aspiring': 'aspiring',
  };

  static const Set<String> _maleLockedProfileNames = <String>{
    'my son',
    'my brother',
  };

  static const Set<String> _femaleLockedProfileNames = <String>{
    'my daughter',
    'my sister',
  };

  List<TextEditingController> get _managedControllers => [
        firstNameController,
        lastNameController,
        dateOfBirthController,
        religionController,
        communityController,
        livingInController,
        emailController,
        phoneController,
        passwordController,
        cityController,
        residencyStatusController,
        maritalStatusController,
        heightController,
        highestQualification,
        instituteController,
        anotherInstituteController,
        aboutYourselfController,
        currentCompanyNameController,
        incomeRangeController,
        yourWorkController,
        youWorkAsController,
        motherDetailsController,
        fatherDetailsController,
        noOfSisterController,
        noOfBrotherController,
      ];

  void setCreativeSectionSelected(bool v) {
    creativeSectionSelected = v;
    _notifyAndPersist();
  }

  void setFunSectionSelected(bool v) {
    funSectionSelected = v;
    _notifyAndPersist();
  }

  void setFitnessSectionSelected(bool v) {
    fitnessSectionSelected = v;
    _notifyAndPersist();
  }

  void setOtherInterestsSectionSelected(bool v) {
    otherInterestsSectionSelected = v;
    _notifyAndPersist();
  }

  List<TextEditingController> otpControllers = [];
  List<FocusNode> otpFocusNodesController = [];

  void initOtpFields({int length = 5}) {
    disposeOtpFields();

    otpControllers = List.generate(length, (_) => TextEditingController());
    otpFocusNodesController = List.generate(length, (_) => FocusNode());

    for (final c in otpControllers) {
      _addListenerSafely(c, notifyListeners);
    }

    notifyListeners();
  }

  void _disposeSafely(ChangeNotifier notifier) {
    try {
      notifier.dispose();
    } catch (_) {}
  }

  void disposeOtpFields({bool notify = true}) {
    for (final c in otpControllers) {
      _disposeSafely(c);
    }

    for (final f in otpFocusNodesController) {
      _disposeSafely(f);
    }

    otpControllers = [];
    otpFocusNodesController = [];

    if (notify) {
      notifyListeners();
    }
  }

  static const String _otpIncompleteMessage = 'Please enter the complete OTP';

/*  Future<bool> otpValidate(BuildContext context) async {
    if (otpControllers.any((c) => c.text.isEmpty)) {
      DialogUtils.showErrorDialog(
        context: context,
        message: _otpIncompleteMessage,
      );
      return false;
    }

    final otp = otpControllers.map((c) => c.text).join();
    final body = OtVerifyBody(
      identifier: selectedVerificationType == 'email' ? emailController.text : phoneController.text,
      otpCode: otp,
      purpose: 'signup',
    );
    final response = await LoginRepository.verifyOtp(body);
    if (response.code != 'SUCCESS') {
      return true;
    }
    else {
      DialogUtils.showErrorDialog(
        context: context,
        message: response.message ?? 'OTP verification failed',
      );
      return false;
    }
  }*/

  final TextEditingController otpController = TextEditingController();

  String otpCode = '';

  Future<bool> resendOtp(BuildContext context) async {
    otpCode = '';
    otpController.clear();
    for (var c in otpControllers) {
      c.clear();
    }
    final body = ResendOtpBody(
      identifier: selectedVerificationType == 'email'
          ? emailController.text
          : phoneController.text,
      purpose: 'signup',
    );
    final response = await RegistrationRepository.resendOtp(body);
    if (response.code != 'SUCCESS') {
      DialogUtils.showErrorDialog(
        context: context,
        message: response.message ?? 'Failed to resend OTP',
      );
      return false;
    } else {
      return true;
    }
  }

  void initControllersListener() {
    if (_controllersListener != null) return;

    _controllersListener = () => notifyListeners();

    for (final controller in _managedControllers) {
      _addListenerSafely(controller, _controllersListener!);
    }
  }

  void disposeControllersListener() {
    if (_controllersListener == null) return;

    for (final controller in _managedControllers) {
      _removeListenerSafely(controller, _controllersListener!);
    }

    _controllersListener = null;
  }

  void cleanAllValue() {
    _clearSelectedValues();
    _clearAllControllers();
    _resetAllSelections();
    selectedHobbies.clear();
    verificationDone = false;
    phoneAvailabilityErrorMessage = '';
    emailAvailabilityErrorMessage = '';
    unawaited(PrefsHelper.clearRegistrationDraft());
    notifyListeners();
  }

  void _clearSelectedValues() {
    selectedProfileName = null;
    selectedGenderName = null;
    selectedIsWithFamilyStatus = null;
    selectedDietStatus = null;
    selectedIncomePeriodStatus = null;
    selectedIncomeRange = null;
    selectedYourWork = null;
    selectedYouWorkAs = null;
    selectedFamilyEconomicCondition = null;
    uploadedProfileMedia = null;
    profileImageUploadErrorMessage = '';
  }

  Country selectedCountry = Country.worldWide;
  void setSelectedCountryCode(BuildContext context) async {
    if (livingInController.text.isNotEmpty) {
      try {
        selectedCountry = Country.parse(livingInController.text);
        context.push(Paths.emailPhone);
      } catch (_) {}
    }
  }

  void _clearAllControllers() {
    for (final controller in _managedControllers) {
      controller.clear();
    }
    communityDropdownItems = <String>[];
    cityDropdownItems = <String>[];
  }

  void _resetAllSelections() {
    _resetSelection(
        profileForList, (item, selected) => item.isSelected = selected);
    _resetSelection(
        genderForList, (item, selected) => item.isSelected = selected);
    _resetSelection(
        isWithFamilyDataList, (item, selected) => item.isSelected = selected);
    _resetSelection(
        dietDataList, (item, selected) => item.isSelected = selected);
    _resetSelection(
        incomePeriodDataList, (item, selected) => item.isSelected = selected);

    _resetSelection(
        creativeItemList, (item, selected) => item.isSelected = selected);
    _resetSelection(
        funItemList, (item, selected) => item.isSelected = selected);
    _resetSelection(
        fitnessItemList, (item, selected) => item.isSelected = selected);
    _resetSelection(
        otherInterestsItemList, (item, selected) => item.isSelected = selected);

    _resetSelection(
        motherDetailsItemList, (item, selected) => item.isSelected = selected);
    _resetSelection(
        fatherDetailsItemList, (item, selected) => item.isSelected = selected);
    _resetSelection(
        siblingCountList, (item, selected) => item.isSelected = selected);
  }

  void _resetSelection<T>(
    List<T> list,
    void Function(T item, bool selected) applySelection,
  ) {
    for (final item in list) {
      applySelection(item, false);
    }
  }

  Future<void> getInitialData() async {
    if (_isDraftInitialized) return;
    await _restoreRegistrationDraft();
    await loadReligionData();
    await loadLocationData();
    await loadLookupData();
    _isDraftInitialized = true;
    notifyListeners();
  }

  Future<void> loadReligionData() async {
    religionOptions = List<LookupOption>.from(_staticReligionOptions);
    religionDropdownItems =
        religionOptions.map((item) => item.label).toList(growable: false);
    await _syncCommunityOptionsFromSelectedReligion();
    notifyListeners();
  }

  Future<void> loadCommunityData() async {
    await _syncCommunityOptionsFromSelectedReligion();
  }

  void onReligionSelected(String? value) {
    final selectedValue = value?.trim() ?? '';
    if (selectedValue.isEmpty) return;

    if (religionController.text != selectedValue) {
      religionController.text = selectedValue;
      communityController.clear();
    }

    unawaited(_syncCommunityOptionsFromSelectedReligion());
    _notifyAndPersist();
  }

  void onCommunitySelected(String? value) {
    final selectedValue = value?.trim() ?? '';
    if (selectedValue.isEmpty) return;

    communityController.text = selectedValue;
    _notifyAndPersist();
  }

  Future<void> _syncCommunityOptionsFromSelectedReligion() async {
    final selectedReligion = religionController.text.trim();
    if (selectedReligion.isEmpty) {
      communityOptions = <LookupOption>[];
      communityDropdownItems = <String>[];
      notifyListeners();
      return;
    }

    final matchedReligion = _findReligionOption(selectedReligion);
    if (matchedReligion == null) {
      communityOptions = <LookupOption>[];
      communityDropdownItems = <String>[];
      notifyListeners();
      return;
    }

    isReligionDataLoading = true;
    religionDataError = null;
    notifyListeners();

    try {
      communityOptions = await _lookupRepository.getLookups(matchedReligion.key);
      communityDropdownItems =
          communityOptions.map((item) => item.label).toList(growable: false);
    } catch (e) {
      communityOptions = <LookupOption>[];
      communityDropdownItems = <String>[];
      religionDataError = e.toString();
    } finally {
      isReligionDataLoading = false;
    }

    if (communityController.text.isNotEmpty) {
      final selectedCommunity = communityController.text.trim().toLowerCase();
      final exists = communityDropdownItems.any(
        (item) => item.toLowerCase() == selectedCommunity,
      );

      if (!exists) {
        communityController.clear();
      }
    }
    notifyListeners();
  }

  LookupOption? _findReligionOption(String religion) {
    final normalized = religion.trim().toLowerCase();
    for (final option in religionOptions) {
      final byName = option.label.toLowerCase() == normalized;
      final byValue = option.key.toLowerCase() == normalized;
      if (byName || byValue) {
        return option;
      }
    }
    return null;
  }

  Future<void> loadLookupData() async {
    if (isLookupDataLoading) return;

    if (educationLevelOptions.isNotEmpty &&
        professionOptions.isNotEmpty &&
        incomeRangeOptions.isNotEmpty &&
        creativeItemList.isNotEmpty &&
        funItemList.isNotEmpty &&
        fitnessItemList.isNotEmpty &&
        otherInterestsItemList.isNotEmpty &&
        foodCuisineItemList.isNotEmpty &&
        travelLeisureItemList.isNotEmpty) {
      notifyListeners();
      return;
    }

    isLookupDataLoading = true;
    lookupDataError = null;
    notifyListeners();

    try {
      final results = await Future.wait<List<LookupOption>>([
        _lookupRepository.getLookups('education-levels'),
        _lookupRepository.getLookups('professions'),
        _lookupRepository.getLookups('income-range'),
        _lookupRepository.getLookups('creative-pursuits'),
        _lookupRepository.getLookups('outdoor-activities'),
        _lookupRepository.getLookups('fitness-and-sports'),
        _lookupRepository.getLookups('media-and-learning'),
        _lookupRepository.getLookups('food-and-cuisine'),
        _lookupRepository.getLookups('travel-and-leisure'),
      ]);

      educationLevelOptions = results[0];
      professionOptions = results[1];
      incomeRangeOptions = results[2];
      creativeItemList = _toSingleStringModels(results[3]);
      funItemList = _toSingleStringModels(results[4]);
      fitnessItemList = _toSingleStringModels(results[5]);
      otherInterestsItemList = _toSingleStringModels(results[6]);
      foodCuisineItemList = _toSingleStringModels(results[7]);
      travelLeisureItemList = _toSingleStringModels(results[8]);
      incomeRangeList = _toSingleStringModels(incomeRangeOptions);
      youWorkAsList = _toSingleStringModels(professionOptions);
      _applySingleSelectionByName(
        incomeRangeList,
        selectedIncomeRange,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applySingleSelectionByName(
        youWorkAsList,
        selectedYouWorkAs,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applyMultiSelectionByNames(
        creativeItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applyMultiSelectionByNames(
        funItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applyMultiSelectionByNames(
        fitnessItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applyMultiSelectionByNames(
        otherInterestsItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applyMultiSelectionByNames(
        foodCuisineItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applyMultiSelectionByNames(
        travelLeisureItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
    } catch (e) {
      lookupDataError = e.toString();
    } finally {
      isLookupDataLoading = false;
      notifyListeners();
    }
  }

  List<String> get educationLevelDropdownItems =>
      educationLevelOptions.map((item) => item.label).toList(growable: false);

  List<String> get professionDropdownItems =>
      professionOptions.map((item) => item.label).toList(growable: false);

  List<String> get incomeRangeDropdownItems =>
      incomeRangeOptions.map((item) => item.label).toList(growable: false);

  List<SingleStringModel> _toSingleStringModels(List<LookupOption> items) {
    return items
        .map(
          (item) => SingleStringModel(
            name: item.label,
            value: item.key,
          ),
        )
        .toList(growable: false);
  }

  Future<void> loadLocationData() async {
    if (isLocationDataLoading) return;

    if (countryOptions.isNotEmpty && residencyStatusOptions.isNotEmpty) {
      await _syncCityOptionsFromSelectedCountry(notify: false);
      notifyListeners();
      return;
    }

    isLocationDataLoading = true;
    locationDataError = null;
    notifyListeners();

    try {
      countryOptions = await _locationDataRepository.getCountries();
      residencyStatusOptions =
          await _locationDataRepository.getResidencyStatuses();

      countryDropdownItems =
          countryOptions.map((item) => item.name).toList(growable: false);
      residencyStatusDropdownItems = residencyStatusOptions
          .map((item) => item.name)
          .toList(growable: false);

      await _syncCityOptionsFromSelectedCountry(notify: false);
    } catch (e) {
      locationDataError = e.toString();
    } finally {
      isLocationDataLoading = false;
      notifyListeners();
    }
  }

  void onLivingInSelected(String? value) {
    final selectedValue = value?.trim() ?? '';
    if (selectedValue.isEmpty) return;

    final previousValue = livingInController.text;
    livingInController.text = selectedValue;

    if (previousValue.toLowerCase() != selectedValue.toLowerCase()) {
      cityController.clear();
    }

    unawaited(_syncCityOptionsFromSelectedCountry());
    _notifyAndPersist();
  }

  void onCitySelected(String? value) {
    final selectedValue = value?.trim() ?? '';
    if (selectedValue.isEmpty) return;

    cityController.text = selectedValue;
    _notifyAndPersist();
  }

  void onResidencyStatusSelected(String? value) {
    final selectedValue = value?.trim() ?? '';
    if (selectedValue.isEmpty) return;

    residencyStatusController.text = selectedValue;
    _notifyAndPersist();
  }

  Future<void> _syncCityOptionsFromSelectedCountry({bool notify = true}) async {
    final selectedCountry = livingInController.text.trim();
    if (selectedCountry.isEmpty) {
      cityDropdownItems = <String>[];
      if (notify) {
        notifyListeners();
      }
      return;
    }

    if (countryOptions.isEmpty) {
      if (notify) {
        notifyListeners();
      }
      return;
    }

    final matchedCountry = _findCountryOption(selectedCountry);
    if (matchedCountry == null) {
      cityDropdownItems = <String>[];
      if (notify) {
        notifyListeners();
      }
      return;
    }

    try {
      cityDropdownItems = await _locationDataRepository.getCitiesByCountry(
        country: matchedCountry.name,
      );
      locationDataError = null;
    } catch (e) {
      cityDropdownItems = <String>[];
      locationDataError = e.toString();
    }
    if (cityController.text.isNotEmpty) {
      final selectedCity = cityController.text.trim().toLowerCase();
      final exists = cityDropdownItems.any(
        (item) => item.toLowerCase() == selectedCity,
      );

      if (!exists) {
        cityController.clear();
      }
    }

    if (notify) {
      notifyListeners();
    }
  }

  CountryLocationModel? _findCountryOption(String country) {
    final normalized = country.trim().toLowerCase();
    for (final option in countryOptions) {
      if (option.name.toLowerCase() == normalized) {
        return option;
      }
    }
    return null;
  }

  void selectedProfileFor(int index) {
    if (!_isValidIndex(index, profileForList.length)) return;
    final previousProfile = selectedProfileName?.trim().toLowerCase();

    _setSingleSelection(
      profileForList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedProfileName = profileForList[index].name;

    final currentProfile = selectedProfileName?.trim().toLowerCase();
    final hasProfileChanged = previousProfile != currentProfile;

    final lockedGender = _lockedGenderForProfile(selectedProfileName);
    if (lockedGender != null) {
      _setGenderByName(lockedGender);
    } else if (hasProfileChanged) {
      _clearSelectedGender();
    }

    _notifyAndPersist();
  }

  void selectedGender(int index) {
    if (!_isValidIndex(index, genderForList.length)) return;

    final lockedGender = _lockedGenderForProfile(selectedProfileName);
    if (lockedGender != null) {
      _setGenderByName(lockedGender);
      _notifyAndPersist();
      return;
    }

    _setSingleSelection(
      genderForList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedGenderName = genderForList[index].name;
    _notifyAndPersist();
  }

  void selectedIsWithFamily(int index) {
    if (!_isValidIndex(index, isWithFamilyDataList.length)) return;
    _setSingleSelection(
      isWithFamilyDataList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedIsWithFamilyStatus = isWithFamilyDataList[index].name;

    _notifyAndPersist();
  }

  void onFamilyEconomicConditionSelected(
    String? value, {
    bool selected = true,
  }) {
    final normalizedValue = value?.trim() ?? '';

    if (!selected || normalizedValue.isEmpty) {
      if (selectedFamilyEconomicCondition == null) {
        return;
      }
      selectedFamilyEconomicCondition = null;
      _notifyAndPersist();
      return;
    }

    if (selectedFamilyEconomicCondition?.toLowerCase() ==
        normalizedValue.toLowerCase()) {
      return;
    }

    selectedFamilyEconomicCondition = normalizedValue;
    _notifyAndPersist();
  }

  void selectedDiet(int index) {
    if (!_isValidIndex(index, dietDataList.length)) return;
    _setSingleSelection(
      dietDataList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedDietStatus = dietDataList[index].name;

    _notifyAndPersist();
  }

  void selectedIncomePeriod(int index) {
    if (!_isValidIndex(index, incomePeriodDataList.length)) return;
    _setSingleSelection(
      incomePeriodDataList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedIncomePeriodStatus = incomePeriodDataList[index].name;

    _notifyAndPersist();
  }

  void selectedVerificationTypeIndex(int index) {
    if (!_isValidIndex(index, verificationList.length)) return;
    _setSingleSelection(
      verificationList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedVerificationType = verificationList[index].name;
    _notifyAndPersist();
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

  void selectIncomeRange(String? value) {
    if (value == null) return;
    incomeRangeController.text = value;
    selectedIncomeRange = value;
    _notifyAndPersist();
  }

  void selectYourWork(String? value) {
    if (value == null) return;
    yourWorkController.text = value;
    selectedYourWork = value;
    _notifyAndPersist();
  }

  void selectYouWorkAs(String? value) {
    if (value == null) return;
    youWorkAsController.text = value;
    selectedYouWorkAs = value;
    _notifyAndPersist();
  }

  void toggleHobbySelection(int index, List<SingleStringModel> dataList,
      {BuildContext? context}) {
    if (index < 0 || index >= dataList.length) return;

    final currentlySelected = dataList[index].isSelected;

    if (!currentlySelected) {
      if (selectedHobbies.length >= hobbiesSelectionMax) {
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('You can select up to $hobbiesSelectionMax hobbies.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      dataList[index].isSelected = true;
      selectedHobbies.add(dataList[index].name);
    } else {
      dataList[index].isSelected = false;
      selectedHobbies.remove(dataList[index].name);
    }

    _notifyAndPersist();
  }

  String ageText() {
    final txt = dateOfBirthController.text;
    if (txt.isEmpty) return '0 Year Age';

    DateTime? dob;
    try {
      dob = DateTime.tryParse(txt);
      dob ??= DateFormat('yyyy-MM-dd').parseLoose(txt);
    } catch (_) {
      dob = null;
    }

    if (dob == null) return '0 Year Age';

    final now = DateTime.now();
    int years = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    if (years < 0) years = 0;
    return '$years Years Age'.replaceFirst('\u007f', '');
  }

  int selectedHobbiesCount() {
    return selectedHobbies.length;
  }

  void _notifyAndPersist() {
    notifyListeners();
    _scheduleDraftPersist();
  }

  void _scheduleDraftPersist({bool? verificationDone}) {
    if (_isRestoringDraft) return;
    _persistDebounce?.cancel();
    _persistDebounce = Timer(const Duration(milliseconds: 300), () {
      unawaited(saveRegistrationProgress(verificationDone: verificationDone));
    });
  }

  Future<void> saveRegistrationProgress({bool? verificationDone}) async {
    final draftVerificationDone = verificationDone ?? this.verificationDone;
    this.verificationDone = draftVerificationDone;

    final draft = <String, dynamic>{
      'selectedProfileName': selectedProfileName,
      'selectedGenderName': selectedGenderName,
      'selectedIsWithFamilyStatus': selectedIsWithFamilyStatus,
      'selectedDietStatus': selectedDietStatus,
      'selectedIncomePeriodStatus': selectedIncomePeriodStatus,
      'selectedIncomeRange': selectedIncomeRange,
      'selectedYourWork': selectedYourWork,
      'selectedYouWorkAs': selectedYouWorkAs,
      'selectedFamilyEconomicCondition': selectedFamilyEconomicCondition,
      'selectedVerificationType': selectedVerificationType.toLowerCase(),
      'selectedHobbies': selectedHobbies,
      'creativeSectionSelected': creativeSectionSelected,
      'funSectionSelected': funSectionSelected,
      'fitnessSectionSelected': fitnessSectionSelected,
      'otherInterestsSectionSelected': otherInterestsSectionSelected,
      'verificationDone': draftVerificationDone,
      'controllers': <String, String>{
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'dateOfBirth': dateOfBirthController.text,
        'religion': religionController.text,
        'community': communityController.text,
        'livingIn': livingInController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
        'city': cityController.text,
        'residencyStatus': residencyStatusController.text,
        'maritalStatus': maritalStatusController.text,
        'height': heightController.text,
        'highestQualification': highestQualification.text,
        'institute': instituteController.text,
        'anotherInstitute': anotherInstituteController.text,
        'aboutYourself': aboutYourselfController.text,
        'currentCompanyName': currentCompanyNameController.text,
        'incomeRange': incomeRangeController.text,
        'yourWork': yourWorkController.text,
        'youWorkAs': youWorkAsController.text,
        'motherDetails': motherDetailsController.text,
        'fatherDetails': fatherDetailsController.text,
        'noOfSister': noOfSisterController.text,
        'noOfBrother': noOfBrotherController.text,
      },
    };

    await PrefsHelper.setRegistrationDraft(jsonEncode(draft));
    await PrefsHelper.setRegistrationVerificationDone(draftVerificationDone);
  }

  Future<void> _restoreRegistrationDraft() async {
    final draftJson = await PrefsHelper.getRegistrationDraft();
    verificationDone = await PrefsHelper.getRegistrationVerificationDone();

    if (draftJson.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(draftJson);
      if (decoded is! Map<String, dynamic>) {
        return;
      }

      _isRestoringDraft = true;

      final controllerValues = decoded['controllers'];
      if (controllerValues is Map<String, dynamic>) {
        _restoreControllerText(
            firstNameController, controllerValues['firstName']);
        _restoreControllerText(
            lastNameController, controllerValues['lastName']);
        _restoreControllerText(
            dateOfBirthController, controllerValues['dateOfBirth']);
        _restoreControllerText(
            religionController, controllerValues['religion']);
        _restoreControllerText(
            communityController, controllerValues['community']);
        _restoreControllerText(
            livingInController, controllerValues['livingIn']);
        _restoreControllerText(emailController, controllerValues['email']);
        _restoreControllerText(phoneController, controllerValues['phone']);
        _restoreControllerText(
            passwordController, controllerValues['password']);
        _restoreControllerText(cityController, controllerValues['city']);
        _restoreControllerText(
            residencyStatusController, controllerValues['residencyStatus']);
        _restoreControllerText(
            maritalStatusController, controllerValues['maritalStatus']);
        _restoreControllerText(heightController, controllerValues['height']);
        _restoreControllerText(
            highestQualification, controllerValues['highestQualification']);
        _restoreControllerText(
            instituteController, controllerValues['institute']);
        _restoreControllerText(
            anotherInstituteController, controllerValues['anotherInstitute']);
        _restoreControllerText(
            aboutYourselfController, controllerValues['aboutYourself']);
        _restoreControllerText(currentCompanyNameController,
            controllerValues['currentCompanyName']);
        _restoreControllerText(
            incomeRangeController, controllerValues['incomeRange']);
        _restoreControllerText(
            yourWorkController, controllerValues['yourWork']);
        _restoreControllerText(
            youWorkAsController, controllerValues['youWorkAs']);
        _restoreControllerText(
            motherDetailsController, controllerValues['motherDetails']);
        _restoreControllerText(
            fatherDetailsController, controllerValues['fatherDetails']);
        _restoreControllerText(
            noOfSisterController, controllerValues['noOfSister']);
        _restoreControllerText(
            noOfBrotherController, controllerValues['noOfBrother']);
      }

      selectedProfileName = _asStringOrNull(decoded['selectedProfileName']);
      selectedGenderName = _asStringOrNull(decoded['selectedGenderName']);
      selectedIsWithFamilyStatus =
          _asStringOrNull(decoded['selectedIsWithFamilyStatus']);
      selectedDietStatus = _asStringOrNull(decoded['selectedDietStatus']);
      selectedIncomePeriodStatus =
          _asStringOrNull(decoded['selectedIncomePeriodStatus']);
      selectedIncomeRange = _asStringOrNull(decoded['selectedIncomeRange']) ??
          incomeRangeController.text;
      selectedYourWork = _asStringOrNull(decoded['selectedYourWork']) ??
          yourWorkController.text;
      selectedYouWorkAs = _asStringOrNull(decoded['selectedYouWorkAs']) ??
          youWorkAsController.text;
      selectedFamilyEconomicCondition =
          _asStringOrNull(decoded['selectedFamilyEconomicCondition']);
      selectedVerificationType =
          _asStringOrNull(decoded['selectedVerificationType']) ??
              selectedVerificationType;

      creativeSectionSelected = decoded['creativeSectionSelected'] == true;
      funSectionSelected = decoded['funSectionSelected'] == true;
      fitnessSectionSelected = decoded['fitnessSectionSelected'] == true;
      otherInterestsSectionSelected =
          decoded['otherInterestsSectionSelected'] == true;
      verificationDone =
          decoded['verificationDone'] == true || verificationDone;

      selectedHobbies
        ..clear()
        ..addAll(_asStringList(decoded['selectedHobbies']));

      _applySingleSelectionByName(
        profileForList,
        selectedProfileName,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applySingleSelectionByName(
        genderForList,
        selectedGenderName,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _ensureLockedGenderConsistency();
      _applySingleSelectionByName(
        isWithFamilyDataList,
        selectedIsWithFamilyStatus,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applySingleSelectionByName(
        dietDataList,
        selectedDietStatus,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applySingleSelectionByName(
        incomePeriodDataList,
        selectedIncomePeriodStatus,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applySingleSelectionByName(
        verificationList,
        selectedVerificationType,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );

      _applySingleSelectionByName(
        incomeRangeList,
        selectedIncomeRange,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applySingleSelectionByName(
        yourWorkList,
        selectedYourWork,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applySingleSelectionByName(
        youWorkAsList,
        selectedYouWorkAs,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );

      _applySingleSelectionByName(
        motherDetailsItemList,
        motherDetailsController.text,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applySingleSelectionByName(
        fatherDetailsItemList,
        fatherDetailsController.text,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applySingleSelectionByName(
        siblingCountList,
        noOfSisterController.text,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );

      _applyMultiSelectionByNames(
        creativeItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applyMultiSelectionByNames(
        funItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applyMultiSelectionByNames(
        fitnessItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applyMultiSelectionByNames(
        otherInterestsItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applyMultiSelectionByNames(
        foodCuisineItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );
      _applyMultiSelectionByNames(
        travelLeisureItemList,
        selectedHobbies,
        (item) => item.name,
        (item, selected) => item.isSelected = selected,
      );

      _syncCommunityOptionsFromSelectedReligion();
      await _syncCityOptionsFromSelectedCountry(notify: false);
    } catch (_) {
      // Ignore malformed draft and continue with defaults.
    } finally {
      _isRestoringDraft = false;
    }
  }

  void _restoreControllerText(TextEditingController controller, dynamic value) {
    controller.text = value is String ? value : '';
  }

  String? _asStringOrNull(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return null;
  }

  List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return <String>[];
  }

  String? _lockedGenderForProfile(String? profileName) {
    final normalized = profileName?.trim().toLowerCase() ?? '';
    if (_maleLockedProfileNames.contains(normalized)) {
      return 'Male';
    }
    if (_femaleLockedProfileNames.contains(normalized)) {
      return 'Female';
    }
    return null;
  }

  void _setGenderByName(String genderName) {
    _applySingleSelectionByName(
      genderForList,
      genderName,
      (item) => item.name,
      (item, selected) => item.isSelected = selected,
    );
    selectedGenderName = genderName;
  }

  void _clearSelectedGender() {
    _resetSelection(
      genderForList,
      (item, selected) => item.isSelected = selected,
    );
    selectedGenderName = null;
  }

  void _ensureLockedGenderConsistency() {
    final lockedGender = _lockedGenderForProfile(selectedProfileName);
    if (lockedGender == null) {
      return;
    }
    _setGenderByName(lockedGender);
  }

  void _applySingleSelectionByName<T>(
    List<T> list,
    String? selectedName,
    String Function(T item) getName,
    void Function(T item, bool selected) setSelected,
  ) {
    final normalizedSelected = selectedName?.toLowerCase();
    for (final item in list) {
      final isSelected = normalizedSelected != null &&
          getName(item).toLowerCase() == normalizedSelected;
      setSelected(item, isSelected);
    }
  }

  void _applyMultiSelectionByNames<T>(
    List<T> list,
    List<String> selectedNames,
    String Function(T item) getName,
    void Function(T item, bool selected) setSelected,
  ) {
    final normalized = selectedNames.map((e) => e.toLowerCase()).toSet();
    for (final item in list) {
      setSelected(item, normalized.contains(getName(item).toLowerCase()));
    }
  }

  void _addListenerSafely(
      TextEditingController controller, VoidCallback listener) {
    try {
      controller.addListener(listener);
    } catch (_) {}
  }

  void _removeListenerSafely(
    TextEditingController controller,
    VoidCallback listener,
  ) {
    try {
      controller.removeListener(listener);
    } catch (_) {}
  }

  String _toSnakeCase(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) return '';

    final withUnderscores = normalized.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    return withUnderscores
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  String _resolveReligionValue() {
    final selected = religionController.text.trim();
    if (selected.isEmpty) return '';

    final matchedReligion = _findReligionOption(selected);
    final candidate =
        matchedReligion?.key.trim().toLowerCase() ?? _toSnakeCase(selected);

    if (_staticReligionOptions.any((item) => item.key == candidate)) {
      return candidate;
    }
    return 'others';
  }

  String _resolveResidencyStatusValue() {
    final selected = residencyStatusController.text.trim();
    if (selected.isEmpty) return '';

    final normalized = selected.toLowerCase();
    for (final option in residencyStatusOptions) {
      final byName = option.name.toLowerCase() == normalized;
      final byValue = option.value.toLowerCase() == normalized;
      if (byName || byValue) {
        final optionValue = option.value.toLowerCase();
        if (_allowedResidencyStatusValues.contains(optionValue)) {
          return optionValue;
        }
      }
    }

    final candidate =
        _residencyStatusAliases[normalized] ?? _toSnakeCase(selected);
    if (_allowedResidencyStatusValues.contains(candidate)) {
      return candidate;
    }
    return 'visitor';
  }

  String _resolveMaritalStatusValue() {
    final selected = maritalStatusController.text.trim();
    if (selected.isEmpty) return '';

    final normalized = selected.toLowerCase();
    final candidate =
        _maritalStatusAliases[normalized] ?? _toSnakeCase(selected);
    if (_allowedMaritalStatusValues.contains(candidate)) {
      return candidate;
    }
    return 'open_to_all';
  }

  String _resolveDietValue() {
    final selected = selectedDietStatus?.trim() ?? '';
    if (selected.isEmpty) return '';

    final normalized = selected.toLowerCase();
    final candidate = _dietAliases[normalized] ?? _toSnakeCase(selected);
    if (_allowedDietValues.contains(candidate)) {
      return candidate;
    }
    return 'occasionally_non_veg';
  }

  String? _resolveFamilyEconomicConditionValue() {
    final selected = selectedFamilyEconomicCondition?.trim() ?? '';
    if (selected.isEmpty) {
      return null;
    }

    final normalized = selected.toLowerCase();
    return _familyEconomicConditionAliases[normalized] ??
        _toSnakeCase(selected);
  }

  String _resolveHighestEducationValue() {
    final selected = highestQualification.text.trim();
    if (selected.isEmpty) return '';

    final lookupMatch = _findLookupOption(educationLevelOptions, selected);
    if (lookupMatch != null) {
      return lookupMatch.key;
    }

    final normalized = selected.toLowerCase();

    if (normalized.contains('no formal')) {
      return 'no_formal_education';
    }
    if (RegExp(r'\bprimary\b').hasMatch(normalized)) {
      return 'primary';
    }
    if (normalized.contains('higher secondary') ||
        normalized.contains('high secondary') ||
        RegExp(r'\bhsc\b').hasMatch(normalized) ||
        normalized.contains('intermediate')) {
      return 'higher_secondary';
    }
    if (RegExp(r'\bsecondary\b').hasMatch(normalized) ||
        RegExp(r'\bssc\b').hasMatch(normalized)) {
      return 'secondary';
    }
    if (normalized.contains('diploma')) {
      return 'diploma';
    }
    if (RegExp(
      r"\b(bachelor|bachelors|bachelor's|bsc|b\.sc|ba|b\.a|bcom|b\.com|btech|b\.tech|be|b\.e)\b",
    ).hasMatch(normalized)) {
      return 'bachelor';
    }
    if (RegExp(
      r"\b(master|masters|master's|msc|m\.sc|ma|m\.a|mba|m\.b\.a|mtech|m\.tech|mcom|m\.com|me|m\.e)\b",
    ).hasMatch(normalized)) {
      return 'masters';
    }
    if (RegExp(r'\b(phd|ph\.d)\b').hasMatch(normalized)) {
      return 'phd';
    }
    if (normalized.contains('doctorate')) {
      return 'doctorate';
    }
    if (normalized.contains('professional') ||
        normalized.contains('mbbs') ||
        normalized.contains('llb') ||
        normalized.contains('pharmd')) {
      return 'professional_degree';
    }
    if (normalized.contains('vocational')) {
      return 'vocational_training';
    }
    if (normalized.contains('certificate')) {
      return 'certificate';
    }

    final candidate = _toSnakeCase(selected);
    if (_allowedEducationValues.contains(candidate)) {
      return candidate;
    }
    return 'others';
  }

  String _resolveIncomeRangeValue() {
    final selected = incomeRangeController.text.trim();
    if (selected.isEmpty) return '';

    final lookupMatch = _findLookupOption(incomeRangeOptions, selected);
    return lookupMatch?.key ?? selected;
  }

  String _resolveWorkTypeValue() {
    final selected = selectedYourWork?.trim() ?? yourWorkController.text.trim();
    if (selected.isEmpty) return '';

    for (final option in yourWorkList) {
      final optionName = option.name.trim().toLowerCase();
      final optionValue = (option.value ?? '').trim().toLowerCase();
      if (optionName == selected.toLowerCase() ||
          optionValue == selected.toLowerCase()) {
        return option.value ?? option.name;
      }
    }

    return _toSnakeCase(selected);
  }

  String _resolveWorkingAsValue() {
    final selected = youWorkAsController.text.trim();
    if (selected.isEmpty) return '';

    final lookupMatch = _findLookupOption(professionOptions, selected);
    return lookupMatch?.key ?? _toSnakeCase(selected);
  }

  String _resolveCommunityValue() {
    final selected = communityController.text.trim();
    if (selected.isEmpty) return '';

    final lookupMatch = _findLookupOption(communityOptions, selected);
    return lookupMatch?.key ?? _toSnakeCase(selected);
  }

  LookupOption? _findLookupOption(List<LookupOption> options, String selected) {
    final normalized = selected.trim().toLowerCase();
    for (final option in options) {
      if (option.label.toLowerCase() == normalized ||
          option.key.toLowerCase() == normalized) {
        return option;
      }
    }
    return null;
  }

  String _resolveLocationTypeValue(String residencyStatusValue) {
    if (residencyStatusValue == 'citizen' ||
        residencyStatusValue == 'permanent_resident') {
      return 'permanent';
    }
    return 'present';
  }

  String selectedCountryCodeForNumber = '';
  String _resolveCountryCodeValue() {
    final selectedCountry = livingInController.text.trim();
    if (selectedCountry.isEmpty) return '';

    final matchedCountry = _findCountryOption(selectedCountry);
    if (matchedCountry != null && matchedCountry.code2.trim().isNotEmpty) {
      return matchedCountry.code2.trim().toUpperCase();
    }

    return selectedCountry;
  }

  Future<void> _persistAuthTokens(OnboardingResponse response) async {
    final accessToken = response.response?.accessToken?.trim() ?? '';
    final refreshToken = response.response?.refreshToken?.trim() ?? '';

    if (accessToken.isNotEmpty) {
      await PrefsHelper.setAccessToken(accessToken);
      DioClient().setAuthToken(accessToken);
    }

    if (refreshToken.isNotEmpty) {
      await PrefsHelper.setRefreshToken(refreshToken);
    }
  }

  Future<void> _clearRegistrationDraftCacheOnSuccess() async {
    _persistDebounce?.cancel();
    await PrefsHelper.clearRegistrationDraft();
  }

  Future<bool> uploadProfileImage({
    required String filePath,
    String alt = 'Profile photo',
    String caption = 'My summer photo',
    String description = 'This is my profile photo',
    bool isPrimary = true,
  }) async {
    final normalizedPath = filePath.trim();
    if (normalizedPath.isEmpty) {
      profileImageUploadErrorMessage = 'Please select an image to upload.';
      notifyListeners();
      return false;
    }

    profileImageUploadErrorMessage = '';

    final requestBody = UploadMediaRequestBody(
      filePath: normalizedPath,
      alt: alt,
      caption: caption,
      description: description,
      isPrimary: isPrimary,
    );

    final response = await _mediaRepository.uploadMedia(requestBody);
    final uploadedData = response.response?.data;
    final isSuccess = response.code == 'SUCCESS' && uploadedData != null;

    if (!isSuccess) {
      profileImageUploadErrorMessage =
          response.message ?? 'Failed to upload profile image.';
      notifyListeners();
      return false;
    }

    uploadedProfileMedia = uploadedData;
    notifyListeners();
    return true;
  }

  Future<bool> submitRegistration(
    BuildContext context, {
    bool skipOtp = false,
    bool useDebugTemplate = false,
  }) async {
    if (!skipOtp && otpControllers.any((c) => c.text.isEmpty)) {
      DialogUtils.showErrorDialog(
        context: context,
        message: _otpIncompleteMessage,
      );
      return false;
    }

    final otp = otpControllers.map((c) => c.text).join();
    final shouldUseDebugTemplate = kDebugMode && useDebugTemplate;
    final body = shouldUseDebugTemplate
        ? _buildDebugSignUpRequestBody(skipOtp: skipOtp, otp: otp)
        : _buildDefaultSignUpRequestBody(skipOtp: skipOtp, otp: otp);

    final response = await RegistrationRepository.signUpCreateUserProfile(
      body,
      skipOtp: skipOtp,
    );
    if (response.code == 'SUCCESS') {
      await _persistAuthTokens(response);
      await _clearRegistrationDraftCacheOnSuccess();
      return true;
    } else {
      return false;
    }
  }

  SignUpRequestBody _buildDefaultSignUpRequestBody({
    required bool skipOtp,
    required String otp,
  }) {
    final religionValue = _resolveReligionValue();
    final residencyStatusValue = _resolveResidencyStatusValue();
    final maritalStatusValue = _resolveMaritalStatusValue();
    final dietValue = _resolveDietValue();
    final highestEducationValue = _resolveHighestEducationValue();
    final locationTypeValue = _resolveLocationTypeValue(residencyStatusValue);
    final countryCodeValue = _resolveCountryCodeValue();

    return SignUpRequestBody(
      profileManagedBy: 'self',
      gender: selectedGenderName?.toLowerCase() ?? '',
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      religionName: religionValue,
      community: _resolveCommunityValue(),
      livingIn: livingInController.text,
      cityName: cityController.text,
      dateOfBirth: '1990-01-01',
      email: emailController.text,
      phoneNumber: _resolveSubmissionPhoneNumber(),
      residencyStatus: residencyStatusValue,
      maritalStatus: maritalStatusValue,
      height: num.tryParse(heightController.text),
      diet: dietValue,
      highestLevelOfEducation: highestEducationValue,
      incomeRange: _resolveIncomeRangeValue(),
      incomeRangeFrequency: selectedIncomePeriodStatus?.toLowerCase() ?? '',
      workWith: _resolveWorkTypeValue(),
      workingAs: _resolveWorkingAsValue(),
      currentCompany: currentCompanyNameController.text,
      bio: aboutYourselfController.text,
      termsAndConditionsAccepted: true,
      verificationType: _resolveVerificationTypeValue(),
      otpCode: skipOtp ? null : otp,
      liveWithFamily: selectedIsWithFamilyStatus?.toLowerCase() == 'yes',
      displayName: '${firstNameController.text} ${lastNameController.text}',
      purpose: 'signup',
      countryCode: countryCodeValue,
      locationType: locationTypeValue,
    );
  }

  SignUpRequestBody _buildDebugSignUpRequestBody({
    required bool skipOtp,
    required String otp,
  }) {
    final fallbackCountryName =
        selectedCountry.name.toLowerCase() == 'world wide'
            ? 'Bangladesh'
            : selectedCountry.name;

    final firstName = _valueOrDefault(firstNameController.text, 'Debug');
    final lastName = _valueOrDefault(lastNameController.text, 'User');
    final religionValue =
        _resolveReligionValue().isNotEmpty ? _resolveReligionValue() : 'islam';
    final residencyStatusValue = _resolveResidencyStatusValue().isNotEmpty
        ? _resolveResidencyStatusValue()
        : 'citizen';
    final maritalStatusValue = _resolveMaritalStatusValue().isNotEmpty
        ? _resolveMaritalStatusValue()
        : 'never_married';
    final dietValue =
        _resolveDietValue().isNotEmpty ? _resolveDietValue() : 'non_vegetarian';
    final highestEducationValue = _resolveHighestEducationValue().isNotEmpty
        ? _resolveHighestEducationValue()
        : 'bachelor';

    final verificationType = _resolveVerificationTypeValue();
    final dynamicPhone = _resolveSubmissionPhoneNumber();
    final resolvedPhoneNumber =
        dynamicPhone.isNotEmpty ? dynamicPhone : '+8801700000000';
    final locationTypeValue = _resolveLocationTypeValue(residencyStatusValue);

    return SignUpRequestBody(
      profileManagedBy: 'self',
      gender: _valueOrDefault(selectedGenderName ?? '', 'male').toLowerCase(),
      firstName: firstName,
      lastName: lastName,
      religionName: religionValue,
      community: _resolveCommunityValue().isNotEmpty
          ? _resolveCommunityValue()
          : 'sunni',
      livingIn: _valueOrDefault(livingInController.text, fallbackCountryName),
      cityName: _valueOrDefault(cityController.text, 'Dhaka'),
      dateOfBirth: '1990-01-01',
      email: _valueOrDefault(emailController.text, 'debug@example.com'),
      phoneNumber: resolvedPhoneNumber,
      residencyStatus: residencyStatusValue,
      maritalStatus: maritalStatusValue,
      height: num.tryParse(heightController.text) ?? 170,
      diet: dietValue,
      highestLevelOfEducation: highestEducationValue,
      incomeRange: _resolveIncomeRangeValue().isNotEmpty
          ? _resolveIncomeRangeValue()
          : '50k-100k',
      incomeRangeFrequency:
          _valueOrDefault(selectedIncomePeriodStatus ?? '', 'monthly')
              .toLowerCase(),
      workWith: _resolveWorkTypeValue().isNotEmpty
          ? _resolveWorkTypeValue()
          : 'private_company',
      workingAs: _resolveWorkingAsValue().isNotEmpty
          ? _resolveWorkingAsValue()
          : 'software-engineer',
      currentCompany:
          _valueOrDefault(currentCompanyNameController.text, 'Walima QA'),
      bio: _valueOrDefault(
        aboutYourselfController.text,
        'Debug OTP registration flow',
      ),
      termsAndConditionsAccepted: true,
      verificationType: verificationType,
      otpCode: skipOtp ? null : otp,
      liveWithFamily: selectedIsWithFamilyStatus?.toLowerCase() == 'yes',
      displayName: '$firstName $lastName',
      purpose: 'signup',
      countryCode: _resolveCountryCodeForSubmission(),
      locationType: locationTypeValue,
    );
  }

  String _valueOrDefault(String value, String fallback) {
    final normalized = value.trim();
    if (normalized.isNotEmpty) {
      return normalized;
    }
    return fallback;
  }

  String _resolveVerificationTypeValue() {
    return selectedVerificationType.toLowerCase() == 'email'
        ? 'email'
        : 'phone';
  }

  String _resolveSubmissionPhoneNumber() {
    final cachedPhoneNumber = phoneNumber.trim();
    if (cachedPhoneNumber.isNotEmpty) {
      return cachedPhoneNumber;
    }

    final localNumber = phoneController.text.trim();
    if (localNumber.isEmpty) {
      return '';
    }

    final dialCode = selectedCountry.phoneCode.trim();
    if (dialCode.isNotEmpty) {
      return '+$dialCode$localNumber';
    }

    final selectedCode = selectedCountryCodeForNumber.trim();
    if (selectedCode.isNotEmpty && RegExp(r'^\d+$').hasMatch(selectedCode)) {
      return '+$selectedCode$localNumber';
    }

    if (localNumber.startsWith('+')) {
      return localNumber;
    }

    return '+$localNumber';
  }

  String _resolveCountryCodeForSubmission() {
    final resolvedCountryCode = _resolveCountryCodeValue().trim();
    if (resolvedCountryCode.isNotEmpty) {
      return resolvedCountryCode;
    }

    final selectedCountryCode = selectedCountry.countryCode.trim();
    if (selectedCountryCode.isNotEmpty) {
      return selectedCountryCode;
    }

    return 'BD';
  }

  String phoneAvailabilityErrorMessage = '';
  String emailAvailabilityErrorMessage = '';
  String phoneNumber = '';
  Future<bool> checkEmailAndPhoneAvailability(
      BuildContext context, String countryCode) async {
    final emailRes =
        await RegistrationRepository.checkEmail(emailController.text);
    final phoneRes = await RegistrationRepository.checkMobile(
        '+$countryCode${phoneController.text}');
    if (emailRes.response?.isAvailable == true &&
        phoneRes.response?.isAvailable == true) {
      phoneAvailabilityErrorMessage = '';
      emailAvailabilityErrorMessage = '';
      selectedCountryCodeForNumber = countryCode;
      phoneNumber = '+$countryCode${phoneController.text}';
      _notifyAndPersist();
      return true;
    } else {
      if (emailRes.response?.isAvailable != true) {
        emailAvailabilityErrorMessage =
            emailRes.message ?? 'Email already exists';
        // DialogUtils.showErrorDialog(ctx: context, message: emailRes.message ?? 'Email already exists');
        notifyListeners();
      }
      if (phoneRes.response?.isAvailable != true) {
        phoneAvailabilityErrorMessage =
            phoneRes.message ?? 'Phone number already exists';
        // DialogUtils.showErrorDialog(ctx: context, message: phoneRes.message ?? 'Phone number already exists');
      }
      _notifyAndPersist();
      return false;
    }
  }

  Future<bool> signUpViaOtp(BuildContext context) async {
    final body = SignUpOtpBody(
      registrationSource: 'referral',
      identifier: selectedVerificationType.toLowerCase() == 'email'
          ? emailController.text
          : phoneController.text,
    );
    final response = await RegistrationRepository.signUpWithOTP(body);
    if (response.code == 'SUCCESS') {
      verificationDone = true;
      _notifyAndPersist();
      // cleanAllValue();
      return true;
    } else {
      await DialogUtils.showErrorDialog(
          context: context,
          message: response.message ?? 'Failed to send OTP',
          onButtonPressed: () {
            context.pushReplacement(Paths.login);
          },
          buttonText: 'Go to Login');
      return false;
    }
  }

  @override
  void dispose() {
    _persistDebounce?.cancel();
    super.dispose();
  }

  Future<bool> updateHobies() async {
    try {
      final creativePursuits = _getSelectedHobbiesFromList(creativeItemList);
      final outdoorActivities = _getSelectedHobbiesFromList(funItemList);
      final fitnessAndSports = _getSelectedHobbiesFromList(fitnessItemList);
      final mediaAndLearning =
          _getSelectedHobbiesFromList(otherInterestsItemList);
      final foodAndCuisine = _getSelectedHobbiesFromList(foodCuisineItemList);
      final travelAndLeisure =
          _getSelectedHobbiesFromList(travelLeisureItemList);

      final body = UpdateInterestsRequestBody(
        creativePursuits: creativePursuits,
        outdoorActivities: outdoorActivities,
        fitnessAndSports: fitnessAndSports,
        mediaAndLearning: mediaAndLearning,
        foodAndCuisine: foodAndCuisine,
        travelAndLeisure: travelAndLeisure,
      );

      final response = await _interestsRepository.updateInterests(body);
      return response.code == 'SUCCESS';
    } catch (e) {
      return false;
    }
  }

  List<String> _getSelectedHobbiesFromList(List<SingleStringModel> list) {
    return list
        .where((item) => item.isSelected)
        .map((item) => item.value ?? item.name)
        .toList();
  }

  String? _toTrimmedOrNull(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  int? _parseSiblingCount(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }

    final matched = RegExp(r'\d+').firstMatch(normalized);
    if (matched == null) {
      return null;
    }

    return int.tryParse(matched.group(0)!);
  }

  Future<bool> _submitFamilyUpdate(
    BuildContext context,
    UpdateFamilyRequestBody body, {
    required String fallbackMessage,
  }) async {
    if (body.toJson().isEmpty) {
      return true;
    }

    final response = await _familyRepository.updateFamily(body);
    if (response.code == 'SUCCESS') {
      return true;
    }

    await DialogUtils.showErrorDialog(
      context: context,
      message: response.message ?? fallbackMessage,
    );
    return false;
  }

  Future<bool> updateFamilyDetails(BuildContext context) async {
    try {
      final body = UpdateFamilyRequestBody(
        fatherProfession: _toTrimmedOrNull(fatherDetailsController.text),
        motherProfession: _toTrimmedOrNull(motherDetailsController.text),
        brothers: _parseSiblingCount(noOfBrotherController.text),
        sisters: _parseSiblingCount(noOfSisterController.text),
      );

      return _submitFamilyUpdate(
        context,
        body,
        fallbackMessage: 'Failed to update family details',
      );
    } catch (e) {
      await DialogUtils.showErrorDialog(
        context: context,
        message: 'Failed to update family details',
      );
      return false;
    }
  }

  Future<bool> updateFamilyEarning(BuildContext context) async {
    try {
      final body = UpdateFamilyRequestBody(
        familyEconomicCondition: _resolveFamilyEconomicConditionValue(),
      );

      return _submitFamilyUpdate(
        context,
        body,
        fallbackMessage: 'Failed to update family earning details',
      );
    } catch (e) {
      await DialogUtils.showErrorDialog(
        context: context,
        message: 'Failed to update family earning details',
      );
      return false;
    }
  }
}

enum RegistrationScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}

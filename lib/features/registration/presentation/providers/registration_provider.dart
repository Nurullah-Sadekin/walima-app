import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/core/utils/prefs_helper.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/sign_up_otp_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/sign_up_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/location_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/religion_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/registration_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/location_data_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/religion_option_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/location_data_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/religion_data_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/is_with_family_status_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/profile_for_model.dart';
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
  List<SingleStringModel> incomeRangeList = incomeRangeListInserted;
  List<SingleStringModel> yourWorkList = yourWorkListInserted;
  List<SingleStringModel> youWorkAsList = youWorkAsListInserted;
  List<SingleStringModel> creativeItemList = creativeItemListDataInserted;
  List<SingleStringModel> funItemList = funItemListDataInserted;
  List<SingleStringModel> fitnessItemList = fitnessItemListDataInserted;
  List<SingleStringModel> otherInterestsItemList =
      otherInterestsItemListDataInserted;
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

  final ReligionDataRepository _religionDataRepository =
      ReligionDataRepositoryImpl();
  final LocationDataRepository _locationDataRepository =
      LocationDataRepositoryImpl();

  List<ReligionOptionModel> religionOptions = <ReligionOptionModel>[];
  List<String> religionDropdownItems = <String>[];
  List<String> communityDropdownItems = <String>[];
  bool isReligionDataLoading = false;
  String? religionDataError;

  List<CountryLocationModel> countryOptions = <CountryLocationModel>[];
  List<ResidencyStatusOptionModel> residencyStatusOptions =
      <ResidencyStatusOptionModel>[];
  List<String> countryDropdownItems = <String>[];
  List<String> cityDropdownItems = <String>[];
  List<String> residencyStatusDropdownItems = <String>[];
  bool isLocationDataLoading = false;
  String? locationDataError;

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
    await signUpViaOtp(context);
    notifyListeners();
    return true;
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
    _isDraftInitialized = true;
    notifyListeners();
  }

  Future<void> loadReligionData() async {
    if (isReligionDataLoading) return;

    if (religionOptions.isNotEmpty) {
      _syncCommunityOptionsFromSelectedReligion();
      notifyListeners();
      return;
    }

    isReligionDataLoading = true;
    religionDataError = null;
    notifyListeners();

    try {
      religionOptions = await _religionDataRepository.getReligionOptions();
      religionDropdownItems =
          religionOptions.map((item) => item.name).toList(growable: false);
      _syncCommunityOptionsFromSelectedReligion();
    } catch (e) {
      religionDataError = e.toString();
    } finally {
      isReligionDataLoading = false;
      notifyListeners();
    }
  }

  void onReligionSelected(String? value) {
    final selectedValue = value?.trim() ?? '';
    if (selectedValue.isEmpty) return;

    if (religionController.text != selectedValue) {
      religionController.text = selectedValue;
      communityController.clear();
    }

    _syncCommunityOptionsFromSelectedReligion();
    _notifyAndPersist();
  }

  void onCommunitySelected(String? value) {
    final selectedValue = value?.trim() ?? '';
    if (selectedValue.isEmpty) return;

    communityController.text = selectedValue;
    _notifyAndPersist();
  }

  void _syncCommunityOptionsFromSelectedReligion() {
    final selectedReligion = religionController.text.trim();
    if (selectedReligion.isEmpty) {
      communityDropdownItems = <String>[];
      return;
    }

    final matchedReligion = _findReligionOption(selectedReligion);
    if (matchedReligion == null) {
      communityDropdownItems = <String>[];
      return;
    }

    communityDropdownItems = matchedReligion.community.flattenCommunityLabels();

    if (communityDropdownItems.isEmpty) {
      communityDropdownItems = matchedReligion.community.topLevelLabels();
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
  }

  ReligionOptionModel? _findReligionOption(String religion) {
    final normalized = religion.trim().toLowerCase();
    for (final option in religionOptions) {
      final byName = option.name.toLowerCase() == normalized;
      final byValue = option.value.toLowerCase() == normalized;
      if (byName || byValue) {
        return option;
      }
    }
    return null;
  }

  Future<void> loadLocationData() async {
    if (isLocationDataLoading) return;

    if (countryOptions.isNotEmpty && residencyStatusOptions.isNotEmpty) {
      _syncCityOptionsFromSelectedCountry();
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

      _syncCityOptionsFromSelectedCountry();
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

    _syncCityOptionsFromSelectedCountry();
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

  void _syncCityOptionsFromSelectedCountry() {
    final selectedCountry = livingInController.text.trim();
    if (selectedCountry.isEmpty) {
      cityDropdownItems = <String>[];
      return;
    }

    if (countryOptions.isEmpty) {
      return;
    }

    final matchedCountry = _findCountryOption(selectedCountry);
    if (matchedCountry == null) {
      cityDropdownItems = <String>[];
      return;
    }

    cityDropdownItems = matchedCountry.cityNames();

    if (cityController.text.isNotEmpty) {
      final selectedCity = cityController.text.trim().toLowerCase();
      final exists = cityDropdownItems.any(
        (item) => item.toLowerCase() == selectedCity,
      );

      if (!exists) {
        cityController.clear();
      }
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
    _setSingleSelection(
      profileForList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedProfileName = profileForList[index].name;
    _notifyAndPersist();
  }

  void selectedGender(int index) {
    if (!_isValidIndex(index, genderForList.length)) return;
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
      'selectedVerificationType': selectedVerificationType,
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

      _syncCommunityOptionsFromSelectedReligion();
      _syncCityOptionsFromSelectedCountry();
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

  Future<bool> submitRegistration(BuildContext context) async {
    if (otpControllers.any((c) => c.text.isEmpty)) {
      DialogUtils.showErrorDialog(
        context: context,
        message: _otpIncompleteMessage,
      );
      return false;
    }

    final otp = otpControllers.map((c) => c.text).join();
    final body = SignUpRequestBody(
      profileManagedBy: 'self',
      gender: 'male',
      firstName: 'Nurullah',
      lastName: 'Ansari',
      religionName: 'islam',
      community: 'Ansari',
      livingIn: 'India',
      cityName: 'Mumbai',
      dateOfBirth: '1990-01-01',
      email: emailController.text,
      phoneNumber: phoneController.text,
      residencyStatus: 'citizen',
      maritalStatus: 'open_to_all',
      height: 175,
      diet: 'non_vegetarian',
      highestLevelOfEducation: 'bachelor',
      incomeRange: '2-4 LPA',
      incomeRangeFrequency: 'yearly',
      workWith: 'private',
      workingAs: 'software engineer',
      currentCompany: 'ABC Corp',
      bio: 'Hello, I am Nurullah.',
      termsAndConditionsAccepted: true,
      verificationType: 'phone',
      otpCode: otp,
      liveWithFamily: selectedIsWithFamilyStatus?.toLowerCase() == 'yes',
      displayName: '${firstNameController.text} ${lastNameController.text}',
      purpose: 'signup',
      countryCode: 'IN',
      locationType: 'permanent',
    );
    final response = await RegistrationRepository.signUpCreateUserProfile(body);
    if (response.code == 'SUCCESS') {
      return true;
    } else {
      return false;
    }
  }

  String phoneAvailabilityErrorMessage = '';
  String emailAvailabilityErrorMessage = '';

  Future<bool> checkEmailAndPhoneAvailability(BuildContext context) async {
    final emailRes =
        await RegistrationRepository.checkEmail(emailController.text);
    final phoneRes =
        await RegistrationRepository.checkMobile(phoneController.text);
    if (emailRes.response?.isAvailable == true &&
        phoneRes.response?.isAvailable == true) {
      phoneAvailabilityErrorMessage = '';
      emailAvailabilityErrorMessage = '';
      _notifyAndPersist();
      return true;
    } else {
      if (emailRes.response?.isAvailable != true) {
        emailAvailabilityErrorMessage =
            emailRes.message ?? 'Email already exists';
        // DialogUtils.showErrorDialog(ctx: context, message: emailRes.message ?? 'Email already exists');
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
      return true;
    } else {
      DialogUtils.showErrorDialog(
          context: context, message: response.message ?? 'Failed to send OTP');
      return false;
    }
  }

  @override
  void dispose() {
    _persistDebounce?.cancel();
    super.dispose();
  }
}

enum RegistrationScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}

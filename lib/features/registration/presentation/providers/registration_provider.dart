import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/sign_up_otp_body.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/registration_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/is_with_family_status_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/profile_for_model.dart';
import 'package:intl/intl.dart';

class RegistrationProvider extends BaseChangeNotifier {
  VoidCallback? _controllersListener;

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
  final TextEditingController residencyStatusController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController highestQualification = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController anotherInstituteController = TextEditingController();
  final TextEditingController aboutYourselfController = TextEditingController();
  final TextEditingController currentCompanyNameController = TextEditingController();
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
  List<SingleStringModel> otherInterestsItemList = otherInterestsItemListDataInserted;
  List<SingleStringModel> motherDetailsItemList = motherDetailsItemListDataInserted;
  List<SingleStringModel> fatherDetailsItemList = fatherDetailsItemListDataInserted;
  List<SingleStringModel> siblingCountList = siblingCountListDataInserted;
  List<SingleStringModel> verificationList = verificationTypeList;
  static const int hobbiesSelectionMax = 5;
  final List<String> selectedHobbies = [];

  bool creativeSectionSelected = false;
  bool funSectionSelected = false;
  bool fitnessSectionSelected = false;
  bool otherInterestsSectionSelected = false;
  
  String selectedVerificationType = 'email'; // or 'phone'

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
    notifyListeners();
  }

  void setFunSectionSelected(bool v) {
    funSectionSelected = v;
    notifyListeners();
  }

  void setFitnessSectionSelected(bool v) {
    fitnessSectionSelected = v;
    notifyListeners();
  }

  void setOtherInterestsSectionSelected(bool v) {
    otherInterestsSectionSelected = v;
    notifyListeners();
  }

  void cleanAllValue() {
    _clearSelectedValues();
    _clearAllControllers();
    _resetAllSelections();
    selectedHobbies.clear();
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
  }

  void _resetAllSelections() {
    _resetSelection(profileForList, (item, selected) => item.isSelected = selected);
    _resetSelection(genderForList, (item, selected) => item.isSelected = selected);
    _resetSelection(isWithFamilyDataList, (item, selected) => item.isSelected = selected);
    _resetSelection(dietDataList, (item, selected) => item.isSelected = selected);
    _resetSelection(incomePeriodDataList, (item, selected) => item.isSelected = selected);

    _resetSelection(creativeItemList, (item, selected) => item.isSelected = selected);
    _resetSelection(funItemList, (item, selected) => item.isSelected = selected);
    _resetSelection(fitnessItemList, (item, selected) => item.isSelected = selected);
    _resetSelection(otherInterestsItemList, (item, selected) => item.isSelected = selected);

    _resetSelection(motherDetailsItemList, (item, selected) => item.isSelected = selected);
    _resetSelection(fatherDetailsItemList, (item, selected) => item.isSelected = selected);
    _resetSelection(siblingCountList, (item, selected) => item.isSelected = selected);
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
    // Simulate a delay for fetching data
  }

  void selectedProfileFor(int index) {
    if (!_isValidIndex(index, profileForList.length)) return;
    _setSingleSelection(
      profileForList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedProfileName = profileForList[index].name;
    notifyListeners();
  }

  void selectedGender(int index) {
    if (!_isValidIndex(index, genderForList.length)) return;
    _setSingleSelection(
      genderForList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedGenderName = genderForList[index].name;
    notifyListeners();
  }

  void selectedIsWithFamily(int index) {
    if (!_isValidIndex(index, isWithFamilyDataList.length)) return;
    _setSingleSelection(
      isWithFamilyDataList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedIsWithFamilyStatus = isWithFamilyDataList[index].name;

    notifyListeners();
  }

  void selectedDiet(int index) {
    if (!_isValidIndex(index, dietDataList.length)) return;
    _setSingleSelection(
      dietDataList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedDietStatus = dietDataList[index].name;

    notifyListeners();
  }

  void selectedIncomePeriod(int index) {
    if (!_isValidIndex(index, incomePeriodDataList.length)) return;
    _setSingleSelection(
      incomePeriodDataList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedIncomePeriodStatus = incomePeriodDataList[index].name;

    notifyListeners();
  }

  
  void selectedVerificationTypeIndex(int index) {
    if (!_isValidIndex(index, verificationList.length)) return;
    _setSingleSelection(
      verificationList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    selectedVerificationType = verificationList[index].name;

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

  void selectIncomeRange(String? value) {
    if (value == null) return;
    incomeRangeController.text = value;
    selectedIncomeRange = value;
    notifyListeners();
  }

  void selectYourWork(String? value) {
    if (value == null) return;
    yourWorkController.text = value;
    selectedYourWork = value;
    notifyListeners();
  }

  void selectYouWorkAs(String? value) {
    if (value == null) return;
    youWorkAsController.text = value;
    selectedYouWorkAs = value;
    notifyListeners();
  }

  void toggleHobbySelection(int index, List<SingleStringModel> dataList, {BuildContext? context}) {
    if (index < 0 || index >= dataList.length) return;

    final currentlySelected = dataList[index].isSelected;

    if (!currentlySelected) {
      if (selectedHobbies.length >= hobbiesSelectionMax) {
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can select up to $hobbiesSelectionMax hobbies.'),
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

    notifyListeners();
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
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    if (years < 0) years = 0;
    return '$years Years Age'.replaceFirst('\u007f', '');
  }

  int selectedHobbiesCount() {
    return selectedHobbies.length;
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

  void _addListenerSafely(TextEditingController controller, VoidCallback listener) {
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

  Future<void> submitRegistration() async {
    // Simulate a delay for submitting registration data
    await Future.delayed(const Duration(seconds: 2));
  }

  String phoneAvailabilityErrorMessage = '';
  String emailAvailabilityErrorMessage = '';

    Future<bool> checkEmailAndPhoneAvailability(BuildContext context) async {
      final emailRes = await RegistrationRepository.checkEmail(emailController.text);
      final phoneRes = await RegistrationRepository.checkMobile(phoneController.text);
      if (emailRes.response?.isAvailable == true && phoneRes.response?.isAvailable == true) {
        phoneAvailabilityErrorMessage = '';
        emailAvailabilityErrorMessage = '';
        notifyListeners();
        return true;
      } else {
        if (emailRes.response?.isAvailable != true) {
          emailAvailabilityErrorMessage = emailRes.message ?? 'Email already exists';
          // DialogUtils.showErrorDialog(ctx: context, message: emailRes.message ?? 'Email already exists');
        }
        if (phoneRes.response?.isAvailable != true) {
          phoneAvailabilityErrorMessage = phoneRes.message ?? 'Phone number already exists';
          // DialogUtils.showErrorDialog(ctx: context, message: phoneRes.message ?? 'Phone number already exists');
        }
        notifyListeners();
        return false;
      }
    }    
    Future<bool> signUpViaOtp(BuildContext context) async {
      final body = SignUpOtpBody(
        registrationSource: 'referral',
            identifier: selectedVerificationType == 'email' ? emailController.text : phoneController.text,
      ) ;
      final response = await RegistrationRepository.signUpWithOTP(body);
      // if (emailRes.response?.isAvailable == true && phoneRes.response?.isAvailable == true) {
      //   phoneAvailabilityErrorMessage = '';
      //   emailAvailabilityErrorMessage = '';
      //   notifyListeners();
      //   return true;
      // } else {
      //   if (emailRes.response?.isAvailable != true) {
      //     emailAvailabilityErrorMessage = emailRes.message ?? 'Email already exists';
      //   }
      //   if (phoneRes.response?.isAvailable != true) {
      //     phoneAvailabilityErrorMessage = phoneRes.message ?? 'Phone number already exists';
      //   }
        notifyListeners();
        return false;
    }
}

enum RegistrationScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/is_with_family_status_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/profile_for_model.dart';
import 'package:intl/intl.dart';

class RegistrationProvider extends BaseChangeNotifier {
  RegistrationScreenStates screenStates = RegistrationScreenStates.defaultLoading;
  RegistrationScreenStates loaderState = RegistrationScreenStates.defaultLoading;
  bool isLoading = false;
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
  List<IsWithFamilyModel> incomePeriodDataList= incomePeriodDataListInserted;
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

  static const int hobbiesSelectionMax = 5;
  final List<String> selectedHobbies = [];

  bool creativeSectionSelected = false;
  bool funSectionSelected = false;
  bool fitnessSectionSelected = false;
  bool otherInterestsSectionSelected = false;

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

  Future<void> getInitialData() async {
    // Simulate a delay for fetching data
  }

  void selectedProfileFor(int index) {
    if (index < 0 || index >= profileForList.length) return;
    for (var i = 0; i < profileForList.length; i++) {
      profileForList[i].isSelected = i == index;
    }
    selectedProfileName = profileForList[index].name;
    notifyListeners();
  }

  void selectedGender(int index) {
    if (index < 0 || index >= genderForList.length) return;
    for (var i = 0; i < genderForList.length; i++) {
      genderForList[i].isSelected = i == index;
    }
    selectedGenderName = genderForList[index].name;
    notifyListeners();
  }

  void selectedIsWithFamily(int index) {
    if (index < 0 || index >= isWithFamilyDataList.length) return;
    for (var i = 0; i < isWithFamilyDataList.length; i++) {
      isWithFamilyDataList[i].isSelected = i == index;
    }
    selectedIsWithFamilyStatus = isWithFamilyDataList[index].name;

    notifyListeners();
  }

  void selectedDiet(int index) {
    if (index < 0 || index >= dietDataList.length) return;
    for (var i = 0; i < dietDataList.length; i++) {
      dietDataList[i].isSelected = i == index;
    }
    selectedDietStatus = dietDataList[index].name;

    notifyListeners();
  }

  void selectedIncomePeriod(int index) {
    if (index < 0 || index >= incomePeriodDataList.length) return;
    for (var i = 0; i < incomePeriodDataList.length; i++) {
      incomePeriodDataList[i].isSelected = i == index;
    }
    selectedIncomePeriodStatus = incomePeriodDataList[index].name;

    notifyListeners();
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

    try {
      firstNameController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      lastNameController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      dateOfBirthController.addListener(_controllersListener!);
    } catch (_) {}
    // additional controllers used across registration screens
    try {
      religionController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      communityController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      livingInController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      emailController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      passwordController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      cityController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      residencyStatusController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      maritalStatusController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      heightController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      highestQualification.addListener(_controllersListener!);
    } catch (_) {}
    try {
      instituteController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      anotherInstituteController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      phoneController.addListener(_controllersListener!);
    } catch (_) {}
    // new dropdown controllers
    try {
      incomeRangeController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      yourWorkController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      youWorkAsController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      currentCompanyNameController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      aboutYourselfController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      motherDetailsController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      fatherDetailsController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      noOfSisterController.addListener(_controllersListener!);
    } catch (_) {}
    try {
      noOfBrotherController.addListener(_controllersListener!);
    } catch (_) {}
  }

  void disposeControllersListener() {
    if (_controllersListener == null) return;
    try {
      firstNameController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      lastNameController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      dateOfBirthController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      religionController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      communityController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      livingInController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      emailController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      passwordController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      cityController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      residencyStatusController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      maritalStatusController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      heightController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      highestQualification.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      instituteController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      anotherInstituteController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      phoneController.removeListener(_controllersListener!);
    } catch (_) {}
    // new dropdown controllers
    try {
      incomeRangeController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      yourWorkController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      youWorkAsController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      currentCompanyNameController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      aboutYourselfController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      motherDetailsController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      fatherDetailsController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      noOfSisterController.removeListener(_controllersListener!);
    } catch (_) {}
    try {
      noOfBrotherController.removeListener(_controllersListener!);
    } catch (_) {}

    _controllersListener = null;

  }

  void updateViewState(
      {RegistrationScreenStates? screenStates,
      RegistrationScreenStates? loadingState}) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = RegistrationScreenStates.defaultLoading;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }
}

enum RegistrationScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}

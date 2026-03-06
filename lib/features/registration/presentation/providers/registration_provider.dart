import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/is_with_family_status_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/profile_for_model.dart';

class RegistrationProvider extends BaseChangeNotifier {
  RegistrationScreenStates screenStates =
      RegistrationScreenStates.defaultLoading;
  RegistrationScreenStates loaderState =
      RegistrationScreenStates.defaultLoading;
  bool isLoading = false;

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

  VoidCallback? _controllersListener;

  List<ProfileForModel> profileForList = profileForListInserted;
  List<GenderProfileForModel> genderForList = genderForListInserted;
  List<IsWithFamilyModel> isWithFamilyDataList = isWithFamilyDataListInserted;
  List<IsWithFamilyModel> incomePeriodDataList= incomePeriodDataListInserted;
  List<SingleStringModel> dietDataList = dietDataListInserted;
  List<SingleStringModel> incomeRangeList = incomeRangeListInserted;
  List<SingleStringModel> yourWorkList = yourWorkListInserted;
  List<SingleStringModel> youWorkAsList = youWorkAsListInserted;
  // Hobbies / interests - initialize with sample categories (re-use SingleStringModel)
  List<SingleStringModel> hobbiesInterestsList = [
    SingleStringModel(name: 'Writing'),
    SingleStringModel(name: 'Cooking'),
    SingleStringModel(name: 'Singing'),
    SingleStringModel(name: 'Photography'),
    SingleStringModel(name: 'Playing instruments'),
    SingleStringModel(name: 'Painting'),
    SingleStringModel(name: 'DIY crafts'),
    SingleStringModel(name: 'Dancing'),
    SingleStringModel(name: 'Acting'),
    SingleStringModel(name: 'Poetry'),
    SingleStringModel(name: 'Gardening'),
    SingleStringModel(name: 'Blogging'),
  ];
  static const int hobbiesSelectionMax = 5;




  Future<void> getInitialData() async {
    // Simulate a delay for fetching data
  }

  /// Call this once (e.g., from a widget's initState via ref.read) to attach
  /// listeners to TextEditingControllers owned by the provider. When any
  /// controller changes, the provider will call notifyListeners().
  void initControllersListener() {
    // avoid attaching multiple times
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
    } catch (_) {} catch (_) {}
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



  }

  /// Remove attached listeners. Call this from the widget's dispose or when
  /// provider no longer needs to forward controller changes.
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

    _controllersListener = null;

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

  // HOBBIES: toggle selection of a hobby by index. Allows multiple selections.
  void toggleHobbySelection(int index) {
    if (index < 0 || index >= hobbiesInterestsList.length) return;
    hobbiesInterestsList[index].isSelected = !hobbiesInterestsList[index].isSelected;
    notifyListeners();
  }

  int selectedHobbiesCount() {
    return hobbiesInterestsList.where((h) => h.isSelected).length;
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

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/domain/diet_model.dart';
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

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController communityController = TextEditingController();
  final TextEditingController livingInController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController currentCompanyNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController residencyStatusController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController highestQualification = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController anotherInstituteController = TextEditingController();

  VoidCallback? _controllersListener;

  List<ProfileForModel> profileForList = profileForListInserted;
  List<GenderProfileForModel> genderForList = genderForListInserted;
  List<IsWithFamilyModel> isWithFamilyDataList = isWithFamilyDataListInserted;
  List<DietModel> dietDataList = dietDataListInserted;

  Future<void> getInitialData() async {
    // Simulate a delay for fetching data
    // updateViewState(screenStates: RegistrationScreenStates.isProfileFor);
    // await Future.delayed(const Duration(seconds: 2));
    // updateViewState(screenStates: RegistrationScreenStates.loadingComplete);
    // await Future.delayed(const Duration(seconds: 3));
    // updateViewState(loadingState: RegistrationScreenStates.isProfileFor);
    // await Future.delayed(const Duration(seconds: 2));
    // updateViewState(loadingState: RegistrationScreenStates.loadingComplete);
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
    } catch (_) {}
    try {
      currentCompanyNameController.addListener(_controllersListener!);
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
      currentCompanyNameController.removeListener(_controllersListener!);
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

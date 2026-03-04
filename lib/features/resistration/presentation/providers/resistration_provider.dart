import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/resistration/domain/profile_for_model.dart';

class RegistrationProvider extends BaseChangeNotifier {
  List<ProfileFor> profileForList = [
    ProfileFor(name: 'Myself', emoji: const Icon(Icons.person)),
    ProfileFor(name: 'Someone else', emoji: const Icon(Icons.people)),
  ];

  RegistrationScreenStates screenStates = RegistrationScreenStates.defaultLoading;
  RegistrationScreenStates loaderState = RegistrationScreenStates.defaultLoading;

  bool isLoading = false;

  Future<void> getInitialData() async {
    // Simulate a delay for fetching data
    updateViewState(screenStates: RegistrationScreenStates.isProfileFor);
    await Future.delayed(const Duration(seconds: 2));
    updateViewState(screenStates: RegistrationScreenStates.loadingComplete);
    await Future.delayed(const Duration(seconds: 3));
    updateViewState(loadingState: RegistrationScreenStates.isProfileFor);
    await Future.delayed(const Duration(seconds: 2));
    updateViewState(loadingState: RegistrationScreenStates.loadingComplete);
  }

  void updateViewState({RegistrationScreenStates? screenStates, RegistrationScreenStates? loadingState}) {
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

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';

class RecommendedPreferencesProvider extends BaseChangeNotifier {
  RecommendedPreferencesScreenStates screenStates = RecommendedPreferencesScreenStates.defaultLoading;
  RecommendedPreferencesScreenStates loaderState = RecommendedPreferencesScreenStates.defaultLoading;
  bool isLoading = false;
  VoidCallback? _controllersListener;


  final TextEditingController religionController = TextEditingController();

  Future<void> getInitialData() async {
    // Simulate a delay for fetching data
  }

  void initControllersListener() {
    // avoid attaching multiple times
    if (_controllersListener != null) return;

    _controllersListener = () => notifyListeners();

    try {
      religionController.addListener(_controllersListener!);
    } catch (_) {}

  }

  void disposeControllersListener() {
    if (_controllersListener == null) return;
    try {
      religionController.removeListener(_controllersListener!);
    } catch (_) {}


    _controllersListener = null;

  }

  void updateViewState(
      {RecommendedPreferencesScreenStates? screenStates,
        RecommendedPreferencesScreenStates? loadingState}) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = RecommendedPreferencesScreenStates.defaultLoading;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }
}

enum RecommendedPreferencesScreenStates {
  defaultLoading,
  loadingComplete,
  preferences,
}

import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';

class RecommendedPreferencesProvider extends BaseChangeNotifier {
  RecommendedPreferencesScreenStates screenStates = RecommendedPreferencesScreenStates.defaultLoading;
  RecommendedPreferencesScreenStates loaderState = RecommendedPreferencesScreenStates.defaultLoading;
  bool isLoading = false;

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

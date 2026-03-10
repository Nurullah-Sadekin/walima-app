import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';

class RegistrationScreenStateProvider extends BaseChangeNotifier {
  RegistrationScreenStates screenStates = RegistrationScreenStates.defaultLoading;
  RegistrationScreenStates loaderState = RegistrationScreenStates.defaultLoading;

  void updateViewState({
    RegistrationScreenStates? screenStates,
    RegistrationScreenStates? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = RegistrationScreenStates.defaultLoading;
    }
    if (loadingState != null) {
      loaderState = loadingState;
    }
    notifyListeners();
  }
}

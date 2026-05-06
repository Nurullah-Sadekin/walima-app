import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';

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

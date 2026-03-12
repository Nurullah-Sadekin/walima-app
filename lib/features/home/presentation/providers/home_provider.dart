import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/login/data/repository/login_repository.dart';

class HomeProvider extends BaseChangeNotifier {
  LoginScreenStates screenStates = LoginScreenStates.defaultState;
  LoginScreenStates loaderState = LoginScreenStates.defaultState;

  Future<void> getInitialData() async {
    final response = await LoginRepository.getMe();
    if (response.code == 'SUCCESS') {
      // Handle successful response, e.g., store user data
    } else {
      // Handle error, e.g., show a dialog
      // DialogUtils.showErrorDialog(message: response.message);
    }
  }
}

enum LoginScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}

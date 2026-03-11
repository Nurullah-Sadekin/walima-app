import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/upgrade_package/presentation/providers/upgrade_package_provider.dart';

class UpgradePackageScreenStateProvider extends BaseChangeNotifier {
  UpgradePackageScreenStates screenStates = UpgradePackageScreenStates.defaultLoading;
  UpgradePackageScreenStates loaderState = UpgradePackageScreenStates.defaultLoading;

  void updateViewState({
    UpgradePackageScreenStates? screenStates,
    UpgradePackageScreenStates? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = UpgradePackageScreenStates.defaultLoading;
    }
    if (loadingState != null) {
      loaderState = loadingState;
    }
    notifyListeners();
  }
}

import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/upgrade_package/domain/upgrade_package_model.dart';

class UpgradePackageProvider extends BaseChangeNotifier {

  // current selected page index for carousel
  int selectedPage = 0;

  void changePage(int value) {
    selectedPage = value;
    notifyListeners();
  }

  final Map<String, String> haveQuestion= {
    'What are the benefits of upgrading?' : 'Upgraded members can send unlimited messages, view more contact numbers, and access additional profile details. You’ll also appear higher in searches, giving you better chances of connecting.',
   'How do I know if profiles are genuine?' : 'Every profile goes through a screening process to ensure authenticity. We also encourage members to report anything suspicious so we can act quickly.',
   'Can I pause my subscription?' : 'Yes, you can temporarily pause your subscription if you need a break. During this time, your profile will not appear in searches until you reactivate it.',
   'What support do you provide?' : 'Our support team is here to assist with account, payment, or profile-related questions. You can contact us anytime through chat, email, or phone support.',
  };

  final List<UpgradePackageItem> packageItems = packageItemsDataInserted;
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



enum UpgradePackageScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}

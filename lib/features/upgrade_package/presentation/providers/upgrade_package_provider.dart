import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/upgrade_package/domain/upgrade_package_model.dart';

class UpgradePackageProvider extends BaseChangeNotifier {

  // current selected page index for carousel
  int selectedPage = 0;

  void changePage(int value) {
    selectedPage = value;
    notifyListeners();
  }

  final List<UpgradePackageItem> packageItems = packageItemsDataInserted;
}



enum UpgradePackageScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}

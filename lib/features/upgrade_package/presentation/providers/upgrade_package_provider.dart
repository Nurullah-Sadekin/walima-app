import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';

class UpgradePackageProvider extends BaseChangeNotifier {

  // current selected page index for carousel
  int selectedPage = 0;

  void changePage(int value) {
    selectedPage = value;
    notifyListeners();
  }

  // Simple model for package item
  final List<UpgradePackageItem> packageItems = [
    UpgradePackageItem(
      packageName: 'Harmony',
      duration: '3 Months',
      packagePrice: '\$2,200',
      perMonthPrice: '\$733',
      messageIsAvailable: true,
      contactIsAvailable: true,
      profileIsAvailable: false,
      matchIsAvailable: false,
      packageThemeColorHex: 0xFF8B5CF6,
      packageBadgeText: 'Recommended',
    ),
    UpgradePackageItem(
      packageName: 'Premium',
      duration: '6 Months',
      packagePrice: '\$3,900',
      perMonthPrice: '\$650',
      messageIsAvailable: true,
      contactIsAvailable: true,
      profileIsAvailable: true,
      matchIsAvailable: true,
      packageThemeColorHex: 0xFF1E88E5,
      packageBadgeText: 'Best Value',
    ),
    UpgradePackageItem(
      packageName: 'Basic',
      duration: '1 Month',
      packagePrice: '\$900',
      perMonthPrice: '\$900',
      messageIsAvailable: true,
      contactIsAvailable: false,
      profileIsAvailable: false,
      matchIsAvailable: false,
      packageThemeColorHex: 0xFF10B981,
      packageBadgeText: null,
    ),
  ];
}

class UpgradePackageItem {
  UpgradePackageItem({
    required this.packageName,
    this.packageThemeColorHex,
    this.duration,
    required this.packagePrice,
    required this.perMonthPrice,
    this.buttonText,
    this.messageIsAvailable,
    this.contactIsAvailable,
    this.profileIsAvailable,
    this.matchIsAvailable,
    this.packageBadgeText,
    this.packageBadgeIcon,
  });

  final String packageName;
  final int? packageThemeColorHex;
  final String? duration;
  final String packagePrice;
  final String perMonthPrice;
  final String? buttonText;

  final bool? messageIsAvailable;
  final bool? contactIsAvailable;
  final bool? profileIsAvailable;
  final bool? matchIsAvailable;

  final String? packageBadgeText;
  final String? packageBadgeIcon;
}

enum UpgradePackageScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}

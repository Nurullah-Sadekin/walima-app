import 'dart:ui';

class UpgradePackageItem {
  UpgradePackageItem({
    required this.packageName,
    this.packageThemeColor,
    this.packageBadgeBackgroundColor,
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
  final Color? packageThemeColor;
  final Color? packageBadgeBackgroundColor;
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


// Simple model for package item
final List<UpgradePackageItem> packageItemsDataInserted = [
  UpgradePackageItem(
    packageName: 'Harmony',
    duration: '3 Months',
    packagePrice: '\৳ 2,200',
    perMonthPrice: '\৳ 733',
    messageIsAvailable: true,
    contactIsAvailable: true,
    profileIsAvailable: false,
    matchIsAvailable: false,
    packageThemeColor: const Color(0xFF7D52F4),
    packageBadgeBackgroundColor: const Color (0xFFEFEBFF),
    packageBadgeText: 'Recommended',
  ),
  UpgradePackageItem(
    packageName: 'Promise',
    duration: '3 Months',
    packagePrice: '\৳ 2,200',
    perMonthPrice: '\৳ 733',
    messageIsAvailable: true,
    contactIsAvailable: true,
    profileIsAvailable: false,
    matchIsAvailable: false,
    packageThemeColor: const Color(0xFFFA7319),
    packageBadgeBackgroundColor: const Color (0xFFFFF3EB),
    packageBadgeText: 'Most Popular',
  ),
  UpgradePackageItem(
    packageName: 'Soulmate',
    duration: '6 Month',
    packagePrice: '\৳ 4,000',
    perMonthPrice: '\৳ 677',
    messageIsAvailable: true,
    contactIsAvailable: true,
    profileIsAvailable: true,
    matchIsAvailable: false,
    packageThemeColor: const Color(0xFF1FC16B),
    packageBadgeBackgroundColor: const Color (0xFFE0FAEC),
    packageBadgeText: 'Member Favorite',
  ),
];
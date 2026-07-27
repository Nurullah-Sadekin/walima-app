// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Walima';

  @override
  String get helloWorld => 'হ্যালো ওয়ার্ল্ড!';

  @override
  String get welcome => 'স্বাগতম';

  @override
  String get home => 'হোম';

  @override
  String get settings => 'সেটিংস';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get logout => 'লগআউট';

  @override
  String get login => 'লগইন';

  @override
  String get register => 'নিবন্ধন';

  @override
  String get email => 'ইমেইল';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get cancel => 'বাতিল';

  @override
  String get delete => 'মুছুন';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get add => 'যোগ করুন';

  @override
  String get update => 'আপডেট';

  @override
  String get confirm => 'নিশ্চিত করুন';

  @override
  String get submit => 'জমা দিন';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get next => 'পরবর্তী';

  @override
  String get back => 'পিছনে';

  @override
  String get skip => 'এড়িয়ে যান';

  @override
  String get finish => 'শেষ';

  @override
  String get retry => 'পুনরায় চেষ্টা করুন';

  @override
  String get refresh => 'রিফ্রেশ';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get noData => 'কোন তথ্য নেই';

  @override
  String get error => 'একটি ত্রুটি ঘটেছে';

  @override
  String get success => 'সফল';

  @override
  String get networkError =>
      'নেটওয়ার্ক ত্রুটি। অনুগ্রহ করে আপনার সংযোগ পরীক্ষা করুন।';

  @override
  String get serverError => 'সার্ভার ত্রুটি। পরে আবার চেষ্টা করুন।';

  @override
  String get unknownError => 'অজানা ত্রুটি ঘটেছে';

  @override
  String get sessionExpired =>
      'আপনার সেশন শেষ হয়ে গেছে। অনুগ্রহ করে আবার লগইন করুন।';

  @override
  String get unauthorized => 'অননুমোদিত প্রবেশাধিকার';

  @override
  String get notFound => 'রিসোর্স পাওয়া যায়নি';

  @override
  String get invalidInput => 'অবৈধ ইনপুট';

  @override
  String get requiredField => 'এই ফিল্ডটি প্রয়োজনীয়';

  @override
  String get invalidEmail => 'অনুগ্রহ করে একটি বৈধ ইমেইল লিখুন';

  @override
  String get passwordTooShort => 'পাসওয়ার্ড কমপক্ষে ৮ অক্ষরের হতে হবে';

  @override
  String get passwordsDoNotMatch => 'পাসওয়ার্ড মিলছে না';

  @override
  String get invalidPhoneNumber => 'অনুগ্রহ করে একটি বৈধ ফোন নম্বর লিখুন';

  @override
  String get noResults => 'কোন ফলাফল পাওয়া যায়নি';

  @override
  String get emptyList => 'তালিকা খালি';

  @override
  String get confirmDelete => 'আপনি কি নিশ্চিত যে আপনি মুছতে চান?';

  @override
  String get confirmLogout => 'আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get lightMode => 'লাইট মোড';

  @override
  String get theme => 'থিম';

  @override
  String get language => 'ভাষা';

  @override
  String get english => 'ইংরেজি';

  @override
  String get bangla => 'বাংলা';

  @override
  String get arabic => 'আরবি';

  @override
  String get changeLanguage => 'ভাষা পরিবর্তন করুন';

  @override
  String get changeTheme => 'থিম পরিবর্তন করুন';

  @override
  String get about => 'সম্পর্কে';

  @override
  String get completeYourProfile => 'আপনার প্রোফাইল সম্পূর্ণ করুন';

  @override
  String profileCompletionPercentage(Object percentage) {
    return 'আপনার প্রোফাইল $percentage% সম্পূর্ণ';
  }

  @override
  String get seeMore => 'আরও দেখুন';

  @override
  String get seeLess => 'কম দেখুন';

  @override
  String completeSectionTitle(Object sectionLabel) {
    return '$sectionLabel সম্পূর্ণ করুন';
  }

  @override
  String get profileSection => 'প্রোফাইল সেকশন';

  @override
  String fieldsLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ফিল্ড বাকি',
      one: '১টি ফিল্ড বাকি',
      zero: 'কোনো ফিল্ড বাকি নেই',
    );
    return '$_temp0';
  }

  @override
  String get profileStrengthTitle => 'প্রোফাইলের পূর্ণতা';

  @override
  String get profileStrengthCompleted => 'সম্পন্ন';

  @override
  String get profileStrengthTips => 'উন্নতির পরামর্শ';

  @override
  String get profileStrengthUnavailable =>
      'প্রোফাইলের পূর্ণতার তথ্য এখন পাওয়া যাচ্ছে না।';

  @override
  String get profileStrengthRefreshFailed =>
      'প্রোফাইলের পূর্ণতার তথ্য হালনাগাদ করা যায়নি।';

  @override
  String get profileStrengthCompletedStatus => 'সম্পন্ন';

  @override
  String get profileStrengthIncompleteStatus => 'অসম্পূর্ণ';

  @override
  String profileStrengthSemantics(Object percentage) {
    return 'প্রোফাইলের পূর্ণতা $percentage শতাংশ।';
  }

  @override
  String profileStrengthSectionSemantics(
      Object sectionLabel, Object percentage, Object status) {
    return '$sectionLabel, $percentage শতাংশ, $status।';
  }

  @override
  String get profileStrengthPreferences => 'জীবনসঙ্গীর পছন্দ';

  @override
  String get profileStrengthBasicProfile => 'প্রাথমিক প্রোফাইল';

  @override
  String get profileStrengthPhotos => 'প্রোফাইল ছবি';

  @override
  String get profileStrengthFamily => 'পারিবারিক তথ্য';

  @override
  String get profileStrengthEducation => 'শিক্ষা';

  @override
  String get profileStrengthProfession => 'পেশা';

  @override
  String get profileStrengthAppearance => 'শারীরিক বিবরণ';

  @override
  String get profileStrengthReligion => 'ধর্ম';

  @override
  String get profileStrengthLifestyle => 'জীবনযাপন';

  @override
  String get profileStrengthLocation => 'অবস্থান';

  @override
  String get profileStrengthInterests => 'আগ্রহ ও শখ';

  @override
  String get profileStrengthContact => 'যোগাযোগের তথ্য';

  @override
  String get profileStrengthTipPreferences =>
      'উন্নত ম্যাচ পেতে জীবনসঙ্গীর পছন্দগুলো পূরণ করুন';

  @override
  String get profileStrengthTipBasic =>
      'অন্যরা আপনাকে ভালোভাবে জানতে প্রাথমিক প্রোফাইলের তথ্য পূরণ করুন';

  @override
  String get profileStrengthTipPhotos =>
      'আরও দৃশ্যমান হতে আপনার প্রোফাইল ছবি যোগ করুন';

  @override
  String get profileStrengthTipFamily =>
      'পারিবারিক তথ্য যোগ করলে সম্ভাব্য ম্যাচের আস্থা বাড়ে';

  @override
  String get profileStrengthTipEducation =>
      'উপযুক্ত ম্যাচ পেতে আপনার শিক্ষাগত পটভূমি শেয়ার করুন';

  @override
  String get profileStrengthTipProfession =>
      'পেশাগত তথ্য যোগ করলে ম্যাচের প্রাসঙ্গিকতা বাড়ে';

  @override
  String get profileStrengthTipAppearance =>
      'আরও নির্ভুল ম্যাচের জন্য শারীরিক বিবরণ পূরণ করুন';

  @override
  String get profileStrengthTipReligion =>
      'উপযুক্ত ম্যাচের জন্য আপনার ধর্মীয় পটভূমি উল্লেখ করুন';

  @override
  String get profileStrengthTipLifestyle =>
      'সমমনা ম্যাচ পেতে আপনার জীবনযাপনের পছন্দগুলো শেয়ার করুন';

  @override
  String get profileStrengthTipLocation =>
      'কাছাকাছি ম্যাচ পেতে আপনার অবস্থান যোগ করুন';

  @override
  String get profileStrengthTipInterests =>
      'মিল খুঁজে পেতে আপনার আগ্রহ ও শখ শেয়ার করুন';

  @override
  String get profileStrengthTipContact =>
      'ম্যাচ যেন আপনার সঙ্গে যোগাযোগ করতে পারে, সে জন্য যোগাযোগের তথ্য যোগ করুন';
}

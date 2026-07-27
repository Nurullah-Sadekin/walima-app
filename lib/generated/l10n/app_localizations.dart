import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Walima'**
  String get appName;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownError;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please login again.'**
  String get sessionExpired;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access'**
  String get unauthorized;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get notFound;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'The list is empty'**
  String get emptyList;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get confirmDelete;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogout;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bangla.
  ///
  /// In en, this message translates to:
  /// **'Bangla'**
  String get bangla;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get changeTheme;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeYourProfile;

  /// No description provided for @profileCompletionPercentage.
  ///
  /// In en, this message translates to:
  /// **'Your profile is {percentage}% complete'**
  String profileCompletionPercentage(Object percentage);

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @seeLess.
  ///
  /// In en, this message translates to:
  /// **'See Less'**
  String get seeLess;

  /// No description provided for @completeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete {sectionLabel}'**
  String completeSectionTitle(Object sectionLabel);

  /// No description provided for @profileSection.
  ///
  /// In en, this message translates to:
  /// **'Profile Section'**
  String get profileSection;

  /// No description provided for @fieldsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No fields left} =1{1 field left} other{{count} fields left}}'**
  String fieldsLeft(num count);

  /// No description provided for @profileStrengthTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Strength'**
  String get profileStrengthTitle;

  /// No description provided for @profileStrengthCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get profileStrengthCompleted;

  /// No description provided for @profileStrengthTips.
  ///
  /// In en, this message translates to:
  /// **'Tips to improve'**
  String get profileStrengthTips;

  /// No description provided for @profileStrengthUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Profile strength is unavailable right now.'**
  String get profileStrengthUnavailable;

  /// No description provided for @profileStrengthRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh profile strength.'**
  String get profileStrengthRefreshFailed;

  /// No description provided for @profileStrengthCompletedStatus.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get profileStrengthCompletedStatus;

  /// No description provided for @profileStrengthIncompleteStatus.
  ///
  /// In en, this message translates to:
  /// **'incomplete'**
  String get profileStrengthIncompleteStatus;

  /// No description provided for @profileStrengthSemantics.
  ///
  /// In en, this message translates to:
  /// **'Profile strength {percentage} percent.'**
  String profileStrengthSemantics(Object percentage);

  /// No description provided for @profileStrengthSectionSemantics.
  ///
  /// In en, this message translates to:
  /// **'{sectionLabel}, {percentage} percent, {status}.'**
  String profileStrengthSectionSemantics(
      Object sectionLabel, Object percentage, Object status);

  /// No description provided for @profileStrengthPreferences.
  ///
  /// In en, this message translates to:
  /// **'Partner Preferences'**
  String get profileStrengthPreferences;

  /// No description provided for @profileStrengthBasicProfile.
  ///
  /// In en, this message translates to:
  /// **'Basic Profile'**
  String get profileStrengthBasicProfile;

  /// No description provided for @profileStrengthPhotos.
  ///
  /// In en, this message translates to:
  /// **'Profile Photos'**
  String get profileStrengthPhotos;

  /// No description provided for @profileStrengthFamily.
  ///
  /// In en, this message translates to:
  /// **'Family Details'**
  String get profileStrengthFamily;

  /// No description provided for @profileStrengthEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get profileStrengthEducation;

  /// No description provided for @profileStrengthProfession.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get profileStrengthProfession;

  /// No description provided for @profileStrengthAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileStrengthAppearance;

  /// No description provided for @profileStrengthReligion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get profileStrengthReligion;

  /// No description provided for @profileStrengthLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get profileStrengthLifestyle;

  /// No description provided for @profileStrengthLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get profileStrengthLocation;

  /// No description provided for @profileStrengthInterests.
  ///
  /// In en, this message translates to:
  /// **'Interests & Hobbies'**
  String get profileStrengthInterests;

  /// No description provided for @profileStrengthContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get profileStrengthContact;

  /// No description provided for @profileStrengthTipPreferences.
  ///
  /// In en, this message translates to:
  /// **'Complete your Partner Preferences to improve match quality'**
  String get profileStrengthTipPreferences;

  /// No description provided for @profileStrengthTipBasic.
  ///
  /// In en, this message translates to:
  /// **'Fill in your basic profile details to help others know you better'**
  String get profileStrengthTipBasic;

  /// No description provided for @profileStrengthTipPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add your profile photo to improve visibility'**
  String get profileStrengthTipPhotos;

  /// No description provided for @profileStrengthTipFamily.
  ///
  /// In en, this message translates to:
  /// **'Adding family details helps build trust with potential matches'**
  String get profileStrengthTipFamily;

  /// No description provided for @profileStrengthTipEducation.
  ///
  /// In en, this message translates to:
  /// **'Share your education background to find compatible matches'**
  String get profileStrengthTipEducation;

  /// No description provided for @profileStrengthTipProfession.
  ///
  /// In en, this message translates to:
  /// **'Adding your profession details improves match relevance'**
  String get profileStrengthTipProfession;

  /// No description provided for @profileStrengthTipAppearance.
  ///
  /// In en, this message translates to:
  /// **'Complete your appearance details for better matching accuracy'**
  String get profileStrengthTipAppearance;

  /// No description provided for @profileStrengthTipReligion.
  ///
  /// In en, this message translates to:
  /// **'Specify your religious background for compatible matches'**
  String get profileStrengthTipReligion;

  /// No description provided for @profileStrengthTipLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Share your lifestyle choices to find like-minded matches'**
  String get profileStrengthTipLifestyle;

  /// No description provided for @profileStrengthTipLocation.
  ///
  /// In en, this message translates to:
  /// **'Add your location to find matches nearby'**
  String get profileStrengthTipLocation;

  /// No description provided for @profileStrengthTipInterests.
  ///
  /// In en, this message translates to:
  /// **'Share your interests and hobbies to find common ground'**
  String get profileStrengthTipInterests;

  /// No description provided for @profileStrengthTipContact.
  ///
  /// In en, this message translates to:
  /// **'Add contact information so matches can reach you'**
  String get profileStrengthTipContact;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

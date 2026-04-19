import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/models/filter_model.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/account_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/contact_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/messages_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/notification_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/premium_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/repository/account_settings_repository.dart';

class NotificationAlertOption {
  const NotificationAlertOption({required this.label, required this.value});
  final String label;
  final String value;
}

class NotificationAlertCategory {
  const NotificationAlertCategory({
    this.title,
    required this.apiKeys,
    required this.options,
  });
  final String? title;
  final List<String> apiKeys;
  final List<NotificationAlertOption> options;
}

class AccountSettingProvider extends BaseChangeNotifier {
  AccountSettingProvider();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String newPasswordError = '';
  String confirmPasswordError = '';
  bool? autoRenew = false;
  bool? hideProfile = false;
  bool? shortlistAlerts = false;
  bool? premiumCalls = false;
  bool? autoMessageConnect = false;

  bool isAccountLoading = false;
  bool isAccountSaving = false;
  String? accountError;

  bool isContactLoading = false;
  bool isContactSaving = false;
  String? contactError;
  ContactSettings? contactSettings;
  String? selectedContactDisplayStatus;

  bool isPremiumLoading = false;
  String? premiumError;
  PremiumSettings? premiumSettings;

  String messageOnConnect = '';
  String messageOnAccept = '';
  String messageOnRemind = '';

  bool isMessagesLoading = false;
  bool isMessagesSaving = false;
  String? messagesError;
  MessagesSettings? messagesSettings;

  bool isNotificationsLoading = false;
  String? notificationsError;
  NotificationSettings? notificationSettings;

  final List<NotificationAlertCategory> notificationCategories = const [
    NotificationAlertCategory(
      title: 'Match Mail & Photo Match Mail',
      apiKeys: [
        'matchMailFrequency',
        'match_mail_frequency',
        'matchMail',
        'match_mail',
      ],
      options: [
        NotificationAlertOption(label: 'Daily', value: 'daily'),
        NotificationAlertOption(label: 'Tri-Weekly', value: 'tri_weekly'),
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      apiKeys: [
        'photoMatchMailFrequency',
        'photo_match_mail_frequency',
        'photoMatchMail',
        'photo_match_mail',
      ],
      options: [
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Recent Visitors Email',
      apiKeys: [
        'recentVisitorsFrequency',
        'recent_visitors_frequency',
        'recentVisitors',
        'recent_visitors',
      ],
      options: [
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Members Who Shortlisted You Email',
      apiKeys: [
        'shortlistedYouFrequency',
        'shortlisted_you_frequency',
        'membersWhoShortlistedFrequency',
        'members_who_shortlisted_frequency',
        'shortlistedYou',
        'shortlisted_you',
        'membersWhoShortlisted',
        'members_who_shortlisted',
      ],
      options: [
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Viewed Profile Email',
      apiKeys: [
        'viewedProfileFrequency',
        'viewed_profile_frequency',
        'viewedProfile',
        'viewed_profile',
      ],
      options: [
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Similar Profiles Email',
      apiKeys: [
        'similarProfilesFrequency',
        'similar_profiles_frequency',
        'similarProfiles',
        'similar_profiles',
      ],
      options: [
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Contact Alert',
      apiKeys: [
        'contactAlertFrequency',
        'contact_alert_frequency',
        'contactAlert',
        'contact_alert',
      ],
      options: [
        NotificationAlertOption(
            label: 'Instant-Email for every reply', value: 'instant'),
        NotificationAlertOption(label: 'Daily - All responses', value: 'daily'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Walima.com Profile Blaster',
      apiKeys: [
        'profileBlasterFrequency',
        'profile_blaster_frequency',
        'profileBlaster',
        'profile_blaster',
      ],
      options: [
        NotificationAlertOption(label: 'Subscribe', value: 'subscribe'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Walima Specials',
      apiKeys: [
        'walimaSpecialsFrequency',
        'walima_specials_frequency',
        'specialsFrequency',
        'specials_frequency',
        'walimaSpecials',
        'walima_specials',
        'specials',
      ],
      options: [
        NotificationAlertOption(
            label: 'Occasionally - Max twice a month', value: 'occasionally'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
  ];

  Future<void> loadNotificationSettings() async {
    isNotificationsLoading = true;
    notificationsError = null;
    notifyListeners();

    final response = await AccountSettingsRepository.getNotificationSettings();

    if (response.isSuccess && response.data != null) {
      notificationSettings = response.data;
    } else {
      notificationsError = response.message;
    }

    isNotificationsLoading = false;
    notifyListeners();
  }

  /// Returns the currently-selected option value for [category] from the
  /// loaded API response (lower-cased), or null if not set.
  String? selectedValueFor(NotificationAlertCategory category) {
    return notificationSettings?.valueOf(category.apiKeys);
  }

  /// Whether [option] is the selected one for [category] based on the API
  /// response (compares option.value case-insensitively).
  bool isOptionSelected(
    NotificationAlertCategory category,
    NotificationAlertOption option,
  ) {
    final current = selectedValueFor(category);
    if (current == null) return false;
    return current == option.value.trim().toLowerCase();
  }

  Future<ApiResponse> saveMessagesSettings() async {
    isMessagesSaving = true;
    notifyListeners();

    final payload = MessagesSettings(
      autoMessageOnConnect: autoMessageConnect ?? false,
      messageOnConnect: messageOnConnect,
      messageOnAccept: messageOnAccept,
      messageOnRemind: messageOnRemind,
    );

    final response =
        await AccountSettingsRepository.updateMessagesSettings(payload);

    if (response.isSuccess) {
      messagesSettings = payload;
    }

    isMessagesSaving = false;
    notifyListeners();

    return response;
  }

  Future<void> loadMessagesSettings() async {
    isMessagesLoading = true;
    messagesError = null;
    notifyListeners();

    final response = await AccountSettingsRepository.getMessagesSettings();

    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      messagesSettings = data;
      autoMessageConnect = data.autoMessageOnConnect ?? autoMessageConnect;
      messageOnConnect = data.messageOnConnect ?? messageOnConnect;
      messageOnAccept = data.messageOnAccept ?? messageOnAccept;
      messageOnRemind = data.messageOnRemind ?? messageOnRemind;
    } else {
      messagesError = response.message;
    }

    isMessagesLoading = false;
    notifyListeners();
  }

  void setMessageOnConnect(String value) {
    messageOnConnect = value;
    notifyListeners();
  }

  void setMessageOnAccept(String value) {
    messageOnAccept = value;
    notifyListeners();
  }

  void setMessageOnRemind(String value) {
    messageOnRemind = value;
    notifyListeners();
  }


  List<Filter> timelineDataList = [
    Filter(label: '1 Week', value: '1_week'),
    Filter(label: '2 Weeks', value: '2_weeks'),
    Filter(label: '1 Month', value: '1_month'),
    Filter(label: 'Until I turn on', value: 'until_i_turn_on'),
  ];
  List<Filter> deleteProfileStatus = [
    Filter(label: 'Taking a break', value: 'test'),
    Filter(label: 'Unsatisfactory experience', value: 'test'),
    Filter(label: 'Reason not mentioned here', value: 'test'),
  ];
  List<Filter> contactDisplayStatus = [
    Filter(label: 'Only Premium Members', value: 'only_premium_members'),
    Filter(label: 'Only Premium Members you like', value: 'only_premium_members_i_like'),
    Filter(label: 'No one (Matches won\'t be able to cal you)', value: 'no_one'),
    Filter(label: 'Only visible to all you Matches (Expires with Membership)', value: 'all_matches'),
  ];


  bool _isValidIndex(int index, int length) => index >= 0 && index < length;

  String? setTimelineValue(int index) {
    if (!_isValidIndex(index, timelineDataList.length)) return null;
    return timelineDataList[index].value;
  }

  String? setDeleteProfileStatus(int index) {
    if (!_isValidIndex(index, deleteProfileStatus.length)) return null;
    return deleteProfileStatus[index].value;
  }

  Future<void> loadAccountSettings() async {
    isAccountLoading = true;
    accountError = null;
    notifyListeners();

    final response = await AccountSettingsRepository.getAccountSettings();

    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      firstNameController.text = data.firstName ?? '';
      lastNameController.text = data.lastName ?? '';
      emailController.text = data.email ?? '';
    } else {
      accountError = response.message;
    }

    isAccountLoading = false;
    notifyListeners();
  }

  Future<void> loadContactSettings() async {
    isContactLoading = true;
    contactError = null;
    notifyListeners();

    final response = await AccountSettingsRepository.getContactSettings();

    if (response.isSuccess && response.data != null) {
      contactSettings = response.data;
      selectedContactDisplayStatus = response.data?.contactDisplayStatus;
    } else {
      contactError = response.message;
    }

    isContactLoading = false;
    notifyListeners();
  }

  int? get selectedContactDisplayStatusIndex {
    final status = selectedContactDisplayStatus;
    if (status == null || status.isEmpty) return null;
    final idx =
        contactDisplayStatus.indexWhere((item) => item.value == status);
    return idx >= 0 ? idx : null;
  }

  void selectContactDisplayStatusByIndex(int index) {
    if (!_isValidIndex(index, contactDisplayStatus.length)) return;
    selectedContactDisplayStatus = contactDisplayStatus[index].value;
    notifyListeners();
  }

  Future<ApiResponse?> saveContactDisplayStatusByIndex(int index) async {
    if (!_isValidIndex(index, contactDisplayStatus.length)) return null;
    final previous = selectedContactDisplayStatus;
    final newStatus = contactDisplayStatus[index].value;
    if (newStatus == null || newStatus.isEmpty) return null;

    selectedContactDisplayStatus = newStatus;
    isContactSaving = true;
    notifyListeners();

    final response =
        await AccountSettingsRepository.updateContactDisplayStatus(newStatus);

    if (!response.isSuccess) {
      selectedContactDisplayStatus = previous;
    }
    isContactSaving = false;
    notifyListeners();

    return response;
  }

  Future<ApiResponse> saveContactSettings() async {
    final status = selectedContactDisplayStatus;
    if (status == null || status.isEmpty) {
      return ApiResponse.error(
        message: 'Please select a contact display status',
        statusCode: 0,
      );
    }

    isContactSaving = true;
    notifyListeners();

    final response =
        await AccountSettingsRepository.updateContactDisplayStatus(status);

    isContactSaving = false;
    notifyListeners();

    return response;
  }

  Future<void> loadPremiumSettings() async {
    isPremiumLoading = true;
    premiumError = null;
    notifyListeners();

    final response = await AccountSettingsRepository.getPremiumSettings();

    if (response.isSuccess && response.data != null) {
      premiumSettings = response.data;
      autoRenew = response.data?.autoRenew ?? autoRenew;
    } else {
      premiumError = response.message;
    }

    isPremiumLoading = false;
    notifyListeners();
  }

  Future<ApiResponse> togglePremiumAutoRenew(bool value) async {
    final previous = premiumSettings;
    final optimistic = previous?.copyWith(autoRenew: value) ??
        PremiumSettings(autoRenew: value);
    premiumSettings = optimistic;
    autoRenew = value;
    notifyListeners();

    final response =
        await AccountSettingsRepository.updatePremiumAutoRenew(value);

    if (!response.isSuccess) {
      premiumSettings = previous;
      autoRenew = previous?.autoRenew ?? !value;
      notifyListeners();
    }

    return response;
  }

  Future<ApiResponse> saveAccountSettings() async {
    isAccountSaving = true;
    notifyListeners();

    final settings = AccountSettings(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
    );

    final response = await AccountSettingsRepository.updateAccountSettings(settings);

    isAccountSaving = false;
    notifyListeners();

    return response;
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

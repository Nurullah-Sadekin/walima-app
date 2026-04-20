import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
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
    this.imagePath,
    required this.apiKeys,
    required this.options,
  });
  final String? title;
  final String? imagePath;
  final String apiKeys;
  final List<NotificationAlertOption> options;
}

class AccountSettingProvider extends BaseChangeNotifier {
  AccountSettingProvider() {
    _setupListeners();
  }
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String currentPasswordError = '';
  String newPasswordError = '';
  String confirmPasswordError = '';
  bool? autoRenew = false;
  bool? hideProfile = false;
  bool? shortlistAlerts = false;
  bool? premiumCalls = false;
  bool? autoMessageConnect = false;
  
  // SMS Alert Settings
  bool? profileBlaster = false;
  bool? smsAlertInvitations = false;
  bool? smsAlertAccepts = false;

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

  bool isPasswordChanging = false;
  String? passwordChangeError;

  final List<NotificationAlertCategory> notificationCategories = const [
    NotificationAlertCategory(
      title: 'Match Mail & Photo Match Mail',
      imagePath: AppImages.emailSvgIcon,
      apiKeys: 'matchMailFrequency',
      options: [
        NotificationAlertOption(label: 'Daily', value: 'daily'),
        NotificationAlertOption(label: 'Tri-Weekly', value: 'tri_weekly'),
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Premium Match Mail',
      imagePath: AppImages.matchSvgIcon,
      apiKeys: 'premiumMatchMail',
      options: [
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Recent Visitors Email',
      imagePath: AppImages.languageSvgIcon,
      apiKeys: 'recentVisitorsEmail',
      options: [
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Members Who Shortlisted You Email',
      imagePath: AppImages.sortIcon,
      apiKeys: 'shortlistedEmail',
      options: [
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Viewed Profile Email',
      imagePath: AppImages.profileSvgIcon,
      apiKeys: 'viewedProfilesEmail',
      options: [
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Similar Profiles Email',
      imagePath: AppImages.weddingSvgIcon,
      apiKeys: 'similarProfilesEmail',
      options: [
        NotificationAlertOption(label: 'Weekly', value: 'weekly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Contact Alert',
      imagePath: AppImages.contactSvgIcon,
      apiKeys: 'contactAlert',
      options: [
        NotificationAlertOption(label: 'Instant-Email for every reply', value: 'instant'),
        NotificationAlertOption(label: 'Daily - All responses', value: 'daily'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Message Alert',
      imagePath: AppImages.notificationSvgIcon,
      apiKeys: 'messageAlert',
      options: [
        NotificationAlertOption(label: 'Daily Digest', value: 'daily_digest'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Walima Specials',
      imagePath: AppImages.walimaIcon,
      apiKeys: 'walimaSpecials',
      options: [
        NotificationAlertOption(
            label: 'Occasionally - Max twice a month', value: 'twice_monthly'),
        NotificationAlertOption(label: 'Unsubscribe', value: 'unsubscribe'),
      ],
    ),
    NotificationAlertCategory(
      title: 'Walima Insite',
      imagePath: AppImages.walimaIcon,
      apiKeys: 'walimaInsite',
      options: [
        NotificationAlertOption(label: 'Monthly', value: 'monthly'),
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

  String? selectedValueFor(NotificationAlertCategory category) {
    return notificationSettings?.valueOf([category.apiKeys]);
  }

  bool isOptionSelected(
    NotificationAlertCategory category,
    NotificationAlertOption option,
  ) {
    final current = selectedValueFor(category);
    if (current == null) return false;
    return current == option.value.trim().toLowerCase();
  }

  Future<ApiResponse> selectOptionForCategory(NotificationAlertCategory category, int optionIndex) async {
    if (optionIndex < 0 || optionIndex >= category.options.length) return ApiResponse.error(message: 'Invalid option', statusCode: 0);
    final option = category.options[optionIndex];
    final key = category.apiKeys;
    final newRaw = Map<String, dynamic>.from(notificationSettings?.raw ?? {});
    newRaw[key] = option.value;
    notificationSettings = NotificationSettings(raw: newRaw);
    notifyListeners();
    // Immediately save to API
    return _saveNotificationSetting(key, option.value);
  }

  Future<ApiResponse> _saveNotificationSetting(String key, dynamic value) async {
    final response = await AccountSettingsRepository.updateNotificationSetting(
      key,
      value,
    );
    if (!response.isSuccess) {
      // Revert local change on error
      notifyListeners();
    }
    return response;
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

  Future<ApiResponse> changePassword(bool hasPassword) async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Reset errors
    currentPasswordError = '';
    newPasswordError = '';
    confirmPasswordError = '';
    passwordChangeError = null;

    // Validation
    bool hasError = false;
    if (hasPassword && currentPassword.isEmpty) {
      currentPasswordError = 'Current password is required';
      hasError = true;
    }
    if (newPassword.isEmpty) {
      newPasswordError = 'New password is required';
      hasError = true;
    } else {
      final errors = <String>[];
      if (newPassword.length < 8) {
        errors.add('At least 8 characters');
      }
      if (!RegExp(r'[A-Z]').hasMatch(newPassword)) {
        errors.add('Uppercase letter');
      }
      if (!RegExp(r'[a-z]').hasMatch(newPassword)) {
        errors.add('Lowercase letter');
      }
      if (!RegExp(r'[0-9]').hasMatch(newPassword)) {
        errors.add('At least one number');
      }
      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(newPassword)) {
        errors.add('At least one special character');
      }
      if (errors.isNotEmpty) {
        newPasswordError = 'Missing: ${errors.join(', ')}';
        hasError = true;
      }
    }
    if (confirmPassword.isEmpty) {
      confirmPasswordError = 'Confirm password is required';
      hasError = true;
    } else if (newPassword != confirmPassword) {
      confirmPasswordError = 'Passwords do not match';
      hasError = true;
    }

    if (hasError) {
      notifyListeners();
      return ApiResponse.error(message: 'Please fix the errors', statusCode: 0);
    }

    isPasswordChanging = true;
    notifyListeners();

    final response = hasPassword
        ? await AccountSettingsRepository.changePassword(
            currentPassword,
            newPassword,
            confirmPassword,
          )
        : await AccountSettingsRepository.createPassword(
            newPassword,
            confirmPassword,
          );

    if (response.isSuccess) {
      // Clear controllers on success
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } else {
      passwordChangeError = response.message;
    }

    isPasswordChanging = false;
    notifyListeners();

    return response;
  }

  void _setupListeners() {
    // Add listeners for real-time validation or other purposes
    currentPasswordController.addListener(() {
      if (currentPasswordController.text.isNotEmpty) {
        currentPasswordError = '';
        notifyListeners();
      }
    });
    newPasswordController.addListener(() {
      _validateNewPassword();
      _validateConfirmPassword();
    });
    confirmPasswordController.addListener(() {
      _validateConfirmPassword();
    });

    firstNameController.addListener(() {
      // Handle first name changes
    });
    lastNameController.addListener(() {
      // Handle last name changes
    });
    emailController.addListener(() {
      // Handle email changes
    });
  }

  void _validateNewPassword() {
    final password = newPasswordController.text;
    if (password.isEmpty) {
      newPasswordError = '';
      return;
    }
    final errors = <String>[];
    if (password.length < 8) {
      errors.add('At least 8 characters');
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add('Uppercase letter');
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      errors.add('Lowercase letter');
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      errors.add('At least one number');
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      errors.add('At least one special character');
    }
    newPasswordError = errors.isNotEmpty ? 'Missing: ${errors.join(', ')}' : '';
    notifyListeners();
  }

  void _validateConfirmPassword() {
    final confirm = confirmPasswordController.text;
    final newPass = newPasswordController.text;
    if (confirm.isEmpty) {
      confirmPasswordError = '';
      return;
    }
    if (confirm != newPass) {
      confirmPasswordError = 'Passwords do not match';
    } else {
      confirmPasswordError = '';
    }
    notifyListeners();
  }
  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

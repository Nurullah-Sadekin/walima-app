import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/camel_case_utils.dart';
import 'package:flutter_boilerplate/features/account_setting/data/repository/account_settings_repository.dart';
import 'package:flutter_boilerplate/features/account_setting/presentation/providers/account_setting_provider.dart';
import 'package:flutter_boilerplate/features/account_setting/presentation/screens/widgets/alert_status.dart';
import 'package:flutter_boilerplate/features/account_setting/presentation/screens/widgets/card_border.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/screens/widgets/profile_action_tile.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/filter_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/setting_switcher_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSettingScreen extends ConsumerStatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  ConsumerState<AccountSettingScreen> createState() =>
      _AccountSettingScreenState();
}

class _AccountSettingScreenState extends ConsumerState<AccountSettingScreen> {
  late AccountSettingProvider provider;
  AccountSettingStep _step = AccountSettingStep.accountSetting;

  late final bool hasPassword = ref.read(globalProvider).currentUser?.hasPassword ?? false;

  @override
  void initState() {
    super.initState();
    provider = ref.read(accountSettingProvider);
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(accountSettingProvider);

    return PopScope(
      canPop: _step == AccountSettingStep.accountSetting,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _step != AccountSettingStep.accountSetting) {
          setState(() => _step = AccountSettingStep.accountSetting);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: _appBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _body(provider),
          ),
        ),
        floatingActionButton:_bottomAction(provider),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomBackAppBar(
      title: Text(_titleForStep(_step)),
      backgroundColor: Colors.transparent,
      onBackPressed: () {
        if (_step == AccountSettingStep.accountSetting) {
          Navigator.of(context).maybePop();
          return;
        }
        setState(() => _step = AccountSettingStep.accountSetting);
      },
    );
  }

  Widget? _body(AccountSettingProvider provider) {
    switch (_step) {
      case AccountSettingStep.accountSetting:
        return _overviewBody(provider);
      case AccountSettingStep.nameAndEmail:
        return _nameAndEmail();
      case AccountSettingStep.smsOrEmailAlerts:
        return _emailOrSmsAlerts();
      case AccountSettingStep.premiumMembership:
        return _premiumMembership();
      case AccountSettingStep.privacyOptions:
        return _privacyOptions();
      case AccountSettingStep.myContactSettings:
        return _myContactSettings();
      case AccountSettingStep.message:
        return _messages();
      case AccountSettingStep.deleteProfile:
        return _hideOrDeleteProfile();
      case AccountSettingStep.setPassword:
        return _setPassword();
    }
  }

  Widget _overviewBody(AccountSettingProvider provider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          const SizedBox(
            height: 1,
          ),
          ProfileActionTile(
            iconImagePath: AppImages.editSvgIcon,
            title: 'Name And Email Update',
            onTap: () {
              setState(() => _step = AccountSettingStep.nameAndEmail);
              provider.loadAccountSettings();
            },
          ),
          ProfileActionTile(
            iconImagePath: AppImages.contactPreview,
            title: 'My Contact Settings',
            onTap: () {
              setState(() => _step = AccountSettingStep.myContactSettings);
              provider.loadContactSettings();
            },
          ),
          ProfileActionTile(
            iconImagePath: AppImages.premiumSvgIcon,
            title: 'Premium Membership',
            onTap: () {
              setState(() => _step = AccountSettingStep.premiumMembership);
              provider.loadPremiumSettings();
            },
          ),
          ProfileActionTile(
            iconImagePath: AppImages.notificationSvgIcon,
            title: 'Email/SMS Alerts',
            onTap: () {
              setState(() => _step = AccountSettingStep.smsOrEmailAlerts);
              provider.loadNotificationSettings();
            },
          ),
          ProfileActionTile(
            iconImagePath: AppImages.messages,
            title: 'Messages',
            onTap: () {
              setState(() => _step = AccountSettingStep.message);
              provider.loadMessagesSettings();
            },
          ),
          ProfileActionTile(
            iconImagePath: hasPassword ?  AppImages.editSvgIcon : AppImages.lockPasswordSvgIcon,
            title: hasPassword ? 'Change Password' : 'Set Password',
            onTap: () {
              provider.clearPasswordErrors();
              setState(() => _step = AccountSettingStep.setPassword);
            },
            // Note: ProfileActionTile might need custom styling for the delete option
            // You may need to check if ProfileActionTile supports custom colors
          ),
          ProfileActionTile(
            iconImagePath: AppImages.safetySvgIcon,
            title: 'Privacy Options',
            onTap: () {
              setState(() => _step = AccountSettingStep.privacyOptions);
              provider.loadPrivacySettings();
            },
          ),
          ProfileActionTile(
            iconImagePath: AppImages.delete,
            title: 'Hide/Delete Profile',
            onTap: () =>
                setState(() => _step = AccountSettingStep.deleteProfile),
            // Note: ProfileActionTile might need custom styling for the delete option
            // You may need to check if ProfileActionTile supports custom colors
          ),
          const SizedBox(height: 88),
        ],
      ),
    );
  }

  Widget _premiumMembership() {
    if (provider.isPremiumLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentPlan = provider.premiumSettings?.currentPlan;

    return CardBorder(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          SettingsSwitchTile(
            title: 'Auto-renew my Plan',
            subtitle:
                'Auto-renewal for your ${CamelCaseUtils.formatCamelCase(currentPlan)} Membership is ${provider.premiumSettings?.autoRenew == true ? 'ON' : 'OFF'}.',
            value: provider.premiumSettings?.autoRenew ?? false,
            onChanged: (value) async {
              final response = await provider.togglePremiumAutoRenew(value);
              if (!mounted) return;
              _showResponseSnackBar(response);
            },
          ),
          const Divider(
            color: AppColors.greyLight,
            thickness: 1,
          ),
          SettingsSwitchTile(
            title: 'What is auto-renewal?',
            subtitle:
                '"Auto-renewal" automatically renews your plan before its expiry, from your registered Credit/Debit Card, so you can continue to enjoy your premium benefits.',
            value: true,
            onChanged: (value) {},
            isVisibleSwitcher: false,
          ),
          const Divider(
            color: AppColors.greyLight,
            thickness: 1,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Current Plan: ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryLight,
                  fontSize: TextSize.font12(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  (currentPlan != null && currentPlan.isNotEmpty)
                      ? CamelCaseUtils.formatCamelCase(currentPlan)
                      : '-',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: TextSize.font12(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hideOrDeleteProfile() {
    return CardBorder(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Column(
            children: [
              SettingsSwitchTile(
                title: 'Hide Profile',
                subtitle:
                    'Hiding your profile makes you invisible and disables messages and invitations',
                value: provider.hideProfile ?? false,
                onChanged: (value) {
                  provider.hideProfile = value;
                  provider.notifyListeners();
                },
              ),
              const SizedBox(
                height: 16,
              ),
              FilterWidget(
                items: provider.timelineDataList
                    .map(
                      (item) => FilterItem(name: item.label, isSelected: false),
                    )
                    .toList(),
                spacing: 0,
                itemSpacing: 10,
                onItemTap: (index) async {
                  final setTimelineValue = provider.setTimelineValue(index);
                  if (setTimelineValue == null) return;
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: AppColors.greyLight,
                thickness: 1,
              ),
              const SizedBox(
                height: 16,
              ),
              Text('Visibility Preferences',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimaryLight,
                      fontSize: TextSize.font16(
                        context,
                      ))),
              Text('Manage how others discover and connect with you',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font12(
                        context,
                      ))),
              const SizedBox(
                height: 16,
              ),
              SettingsSwitchTile(
                title: 'Shortlist Alerts',
                subtitle: 'Notify me when someone shortlists my profile',
                value: provider.shortlistAlerts ?? false,
                onChanged: (value) {
                  provider.shortlistAlerts = value;
                  provider.notifyListeners();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SettingsSwitchTile(
                title: 'Premium Calls',
                subtitle: 'Allow premium members to call me directly',
                value: provider.premiumCalls ?? false,
                onChanged: (value) {
                  provider.premiumCalls = value;
                  provider.notifyListeners();
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: AppColors.greyLight,
                thickness: 1,
              ),
              const SizedBox(
                height: 16,
              ),
              Text('Delete Profile',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimaryLight,
                      fontSize: TextSize.font16(
                        context,
                      ))),
              Text(
                  'You\'ll permanently lose all profile data, matches, and memberships',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font12(
                        context,
                      ))),
              const SizedBox(
                height: 16,
              ),
              FilterWidget(
                items: provider.deleteProfileStatus
                    .map(
                      (item) => FilterItem(name: item.label, isSelected: false),
                    )
                    .toList(),
                spacing: 0,
                itemSpacing: 10,
                onItemTap: (index) async {
                  final deleteProfileStatus =
                      provider.setDeleteProfileStatus(index);
                  if (deleteProfileStatus == null) return;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _myContactSettings() {
    if (provider.isContactLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final contact = provider.contactSettings?.primaryContact;
    final isEmail = contact?.isEmail ?? false;
    final contactTitle = isEmail ? 'Email Address' : 'Phone Number';
    final contactIcon = isEmail ? AppImages.emailSvgIcon : AppImages.callIcon;
    final contactValue = contact?.value ?? '-';
    final selectedIndex = provider.selectedContactDisplayStatusIndex;

    return Column(
      spacing: 10,
      children: [
        InfoTile(
          title: contactTitle,
          value: contactValue,
          leadingImagePath: contactIcon,
          showTrailingImage: false,
          showLeadingImage: true,
          borderRadius: 8,
          trailingText: 'Primary',
          padding: const EdgeInsets.all(16),
        ),
        CardBorder(
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact Display Status',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: TextSize.font16(context),
                    color: AppColors.textPrimaryLight,
                  )),
              const SizedBox(
                height: 16,
              ),
              FilterWidget(
                items: provider.contactDisplayStatus
                    .asMap()
                    .entries
                    .map(
                      (entry) => FilterItem(
                        name: entry.value.label,
                        isSelected: entry.key == selectedIndex,
                      ),
                    )
                    .toList(),
                spacing: 0,
                itemSpacing: 10,
                onItemTap: (index) async {
                  if (provider.isContactSaving) return;
                  final response =
                      await provider.saveContactDisplayStatusByIndex(index);
                  if (!mounted || response == null) return;
                  _showResponseSnackBar(response);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _privacyOptions() {
    if (provider.isPrivacyLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.privacyError != null) {
      return Center(
        child: Text(
          'Error loading privacy settings: ${provider.privacyError}',
          style: const TextStyle(color: AppColors.error),
        ),
      );
    }

    final settings = provider.privacySettings;
    if (settings == null) {
      return const Center(child: Text('No privacy settings available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        InfoTile(
          title: 'Display Name',
          value: _formatPrivacyValue(settings.displayNameFormat),
          leadingImagePath: AppImages.contactPreview,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Display Name',
            'displayNameFormat',
            settings.displayNameFormat ?? 'hide_first_name',
            ['show_full_name', 'hide_first_name', 'hide_last_name','hide_full_name'],
            ['Show Full Name', 'Hide First Name', 'Hide Last Name','Hide Full Name'],
          ),
        ),
        InfoTile(
          title: 'Photo',
          value: _formatPrivacyValue(settings.photoVisibility),
          leadingImagePath: AppImages.photoIcon,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Photo Visibility',
            'photoVisibility',
            settings.photoVisibility ?? 'visible_to_liked_only',
            ['visible_to_all', 'visible_to_liked_only','visible_on_connect','visible_to_premium_and_liked'],
            ['Visible to All', 'Visible to Liked Only','Visible on Connect','Visible to Premium and Liked'],
          ),
        ),
        InfoTile(
          title: 'Album Photo',
          value: _formatPrivacyValue(settings.albumPhotoVisibility),
          leadingImagePath: AppImages.albumSvgIcon,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Album Photo Visibility',
            'albumPhotoVisibility',
            settings.albumPhotoVisibility ?? 'visible_to_liked_only',
            ['visible_to_all', 'visible_to_liked_only','visible_on_connect','visible_to_premium_and_liked'],
            ['Visible to All', 'Visible to Liked Only','Visible on Connect','Visible to Premium and Liked'],
          ),
        ),
        InfoTile(
          title: 'Phone Number',
          value: _formatPrivacyValue(settings.phoneVisibility),
          leadingImagePath: AppImages.callIcon,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Phone Number Visibility',
            'phoneVisibility',
            settings.phoneVisibility ?? 'only_premium_members',
            ['only_premium_members', 'only_premium_members_i_like', 'no_one','all_matches'],
            ['Only Premium Members', 'Only Premium Members I Like', 'No One','All Matches'],
          ),
        ),
        InfoTile(
          title: 'Email',
          value: _formatPrivacyValue(settings.emailVisibility),
          leadingImagePath: AppImages.emailSvgIcon,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Email Visibility',
            'emailVisibility',
            settings.emailVisibility ?? 'visible_to_all_premium_members',
            ['visible_to_premium_and_wish_to_connect', 'visible_to_all_premium_members', 'hide_email_address','visible_to_all_matches'],
            ['Visible to Premium and Wish to Connect', 'Visible to All Premium Members', 'Hide Email Address','Visible to All Matches'],
          ),
        ),
        InfoTile(
          title: 'Date of Birth',
          value: _formatPrivacyValue(settings.dobDisplay),
          leadingImagePath: AppImages.calenderTimer,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Date of Birth Display',
            'dobDisplay',
            settings.dobDisplay ?? 'full_dob',
            ['month_and_year_only', 'full_dob'],
            ['Month and Year Only', 'Full Date of Birth'],
          ),
        ),
        InfoTile(
          title: 'Annual Income',
          value: _formatPrivacyValue(settings.incomeVisibility),
          leadingImagePath: AppImages.walletSvgIcon,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Income Visibility',
            'incomeVisibility',
            settings.incomeVisibility ?? 'visible_to_all',
            ['visible_to_all', 'hidden'],
            ['Visible to All', 'Hidden'],
          ),
        ),
        InfoTile(
          title: 'Shortlist Alerts',
          value: _formatPrivacyValue(settings.shortlistAlert == true ? 'enable' : 'disable'),
          leadingImagePath: AppImages.sortFilter,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Shortlist Alerts',
            'shortlistAlert',
            settings.shortlistAlert == true ? 'enable' : 'disable',
            ['enable', 'disable'],
            ['Enable', 'Disable'],
          ),
        ),
        InfoTile(
          title: 'Allow Premium Calls',
          value: _formatPrivacyValue(settings.allowPremiumCalls == true ? 'enable' : 'disable'),
          leadingImagePath: AppImages.callIcon,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Allow Premium Calls',
            'allowPremiumCalls',
            settings.allowPremiumCalls == true ? 'enable' : 'disable',
            ['enable', 'disable'],
            ['Enable', 'Disable'],
          ),
        ),
        InfoTile(
          title: 'Profile Privacy',
          value: _formatPrivacyValue(settings.profilePrivacy),
          leadingImagePath: AppImages.safetySvgIcon,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Profile Privacy',
            'profilePrivacy',
            settings.profilePrivacy ?? 'for_registered_members',
            ['visible_to_all_visitors', 'visible_to_registered_members'],
            ['For All Visitors', 'For Registered Members'],
          ),
        ),
        InfoTile(
          title: 'Show Online Status',
          value: _formatPrivacyValue(settings.showOnlineStatus == true ? 'enable' : 'disable'),
          leadingImagePath: AppImages.contactPreview,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Show Online Status',
            'showOnlineStatus',
            settings.showOnlineStatus == true ? 'enable' : 'disable',
            ['enable', 'disable'],
            ['Enable', 'Disable'],
          ),
        ),
        InfoTile(
          title: 'Show Last Seen',
          value: _formatPrivacyValue(settings.showLastSeen == true ? 'enable' : 'disable'),
          leadingImagePath: AppImages.contactPreview,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Show Last Seen',
            'showLastSeen',
            settings.showLastSeen == true ? 'enable' : 'disable',
            ['enable', 'disable'],
            ['Enable', 'Disable'],
          ),
        ),
        InfoTile(
          title: 'Show Activity Status',
          value: _formatPrivacyValue(settings.showActivityStatus == true ? 'enable' : 'disable'),
          leadingImagePath: AppImages.cardView,
          showTrailingImage: true,
          showLeadingImage: true,
          onTap: () => _showPrivacyOptionDialog(
            context,
            'Show Activity Status',
            'showActivityStatus',
            settings.showActivityStatus == true ? 'enable' : 'disable',
            ['enable', 'disable'],
            ['Enable', 'Disable'],
          ),
        ),
      ],
    );
  }

  Widget _messages() {
    if (provider.isMessagesLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        CardBorder(
          widget: SettingsSwitchTile(
            title: 'Auto-Message on Connect',
            subtitle:
                'Your saved message will auto-send with each Connect Request',
            value: provider.autoMessageConnect ?? false,
            onChanged: (value) {
              provider.autoMessageConnect = value;
              provider.notifyListeners();
            },
          ),
        ),
        InfoTile(
          title: 'Message on Connect',
          subtitle:  'This message is sent with your Connect Request when auto-message is enable',
          leadingImagePath: AppImages.contactPreview,
          showTrailingImage: true,
          showLeadingImage: false,
          borderRadius: 8,
          padding: const EdgeInsets.all(16),
          onTap: () => _openMessageEditor(
            title: 'Edit Connect Message',
            subtitle: 'Customize the sent to other members automatically',
            initialValue: provider.messageOnConnect,
            onSave: provider.setMessageOnConnect,
          ),
        ),
        InfoTile(
          title: 'Message on Accept',
          subtitle:'This message is sent to members upon accepting their Connect request',
          leadingImagePath: AppImages.contactPreview,
          showTrailingImage: true,
          showLeadingImage: false,
          borderRadius: 8,
          padding: const EdgeInsets.all(16),
          onTap: () => _openMessageEditor(
            title: 'Edit Accept Message',
            subtitle: 'Customize the sent to other members automatically',
            initialValue: provider.messageOnAccept,
            onSave: provider.setMessageOnAccept,
          ),
        ),
        InfoTile(
          title: 'Message on Remind',
          subtitle:  'This message is sent to members when you send them a reminder',
          leadingImagePath: AppImages.contactPreview,
          showTrailingImage: true,
          showLeadingImage: false,
          borderRadius: 8,
          padding: const EdgeInsets.all(16),
          onTap: () => _openMessageEditor(
            title: 'Edit Remind Message',
            subtitle: 'Customize the sent to other members automatically',
            initialValue: provider.messageOnRemind,
            onSave: provider.setMessageOnRemind,
          ),
        ),
      ],
    );
  }

  Widget _emailOrSmsAlerts() {
    if (provider.isNotificationsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          for (final category in provider.notificationCategories)
            AlertStatus(
              title: category.title,
              imagePath: category.imagePath,
              alertStatusList: category.options
                  .asMap()
                  .entries
                  .map(
                    (entry) => AlertStatusItem(
                      label: entry.value.label,
                      isSelected: provider.isOptionSelected(category, entry.value),
                    ),
                  )
                  .toList(),
              onStatusTap: (index) async {
                final response = await provider.selectOptionForCategory(category, index);
                if (!mounted) return;
                _showResponseSnackBar(response);
              },
            ),

          CardBorder(
            verticalPadding: 8,
            widget: SettingsSwitchTile(
              title: 'Profile Blaster',
              value: provider.profileBlaster ?? false,
              onChanged: (value) async {
                provider.profileBlaster = value;
                provider.notifyListeners();
                final response = await AccountSettingsRepository.updateNotificationSetting('profileBlaster', value);
                if (!mounted) return;
                _showResponseSnackBar(response);
              },
            ),
          ),
          CardBorder(
            verticalPadding: 8,
            widget: SettingsSwitchTile(
              title: 'SMS Alert Invitations',
              value: provider.smsAlertInvitations ?? false,
              onChanged: (value) async {
                provider.smsAlertInvitations = value;
                provider.notifyListeners();
                final response = await AccountSettingsRepository.updateNotificationSetting('smsAlertInvitations', value);
                if (!mounted) return;
                _showResponseSnackBar(response);
              },
            ),
          ),
          CardBorder(
            verticalPadding: 8,
            widget: SettingsSwitchTile(
              title: 'SMS Alert Accepts',
              value: provider.smsAlertAccepts ?? false,
              onChanged: (value) async {
                provider.smsAlertAccepts = value;
                provider.notifyListeners();
                final response = await AccountSettingsRepository.updateNotificationSetting('smsAlertAccepts', value);
                if (!mounted) return;
                _showResponseSnackBar(response);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _nameAndEmail() {
    if (provider.isAccountLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        PrimaryTextField(
          controller: provider.firstNameController,
          headLine: 'First Name',
          hintText: 'Enter first name',
          noPrefix: true,
          onTap: () {},
        ),
        PrimaryTextField(
          controller: provider.lastNameController,
          headLine: 'Last Name',
          hintText: 'Enter last name',
          noPrefix: true,
          onTap: () {},
        ),
        PrimaryTextField(
          controller: provider.emailController,
          headLine: 'Email Address',
          hintText: 'Enter email address',
          noPrefix: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _setPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        if (hasPassword)
        PrimaryTextField(
          controller: provider.currentPasswordController,
          headLine: 'Current Password',
          hintText: 'Enter new password',
          noPrefix: true,
          errorText: provider.currentPasswordError,
          showPassIcon: true,
          onTap: () {},
          isRequired: true,
        ),

        PrimaryTextField(
          controller: provider.newPasswordController,
          headLine: 'New Password',
          hintText: 'Enter new password',
          noPrefix: true,
          errorText: provider.newPasswordError,
          showPassIcon: true,
          onTap: () {},
          isRequired: true,
        ),
        PrimaryTextField(
          controller: provider.confirmPasswordController,
          headLine: 'Confirm Password',
          hintText: 'Enter confirm password',
          noPrefix: true,
          errorText: provider.confirmPasswordError,
          showPassIcon: true,
          onTap: () {},
          isRequired: true,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: CardBorder(
                backgroundColor: AppColors.disableBackground,
                borderColor: AppColors.transparent,
                widget: Column(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password Must contain:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimaryLight,
                        fontSize: TextSize.font14(context),
                      ),
                    ),
                    Row(
                      spacing: 6,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 5,
                          color: AppColors.textSecondaryLight,
                        ),
                        Text(
                          'At least 8 characters',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryLight,
                            fontSize: TextSize.font12(context),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 6,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 5,
                          color: AppColors.textSecondaryLight,
                        ),
                        Text(
                          'Uppercase and lowercase letters',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryLight,
                            fontSize: TextSize.font12(context),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 6,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 5,
                          color: AppColors.textSecondaryLight,
                        ),
                        Text(
                          'At least one number',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryLight,
                            fontSize: TextSize.font12(context),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 6,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 5,
                          color: AppColors.textSecondaryLight,
                        ),
                        Text(
                          'At least one special character',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryLight,
                            fontSize: TextSize.font12(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }


  String _titleForStep(AccountSettingStep step) {
    switch (step) {
      case AccountSettingStep.accountSetting:
        return 'Account Setting';
      case AccountSettingStep.nameAndEmail:
        return 'Name And Email Update';
      case AccountSettingStep.smsOrEmailAlerts:
        return 'Email/SMS Alerts';
      case AccountSettingStep.premiumMembership:
        return 'Premium Membership';
      case AccountSettingStep.privacyOptions:
        return 'Privacy Settings';
      case AccountSettingStep.myContactSettings:
        return 'My Contact Settings';
      case AccountSettingStep.message:
        return 'Manage Messages';
      case AccountSettingStep.deleteProfile:
        return 'Hide/Delete Profile';
      case AccountSettingStep.setPassword:
        return hasPassword ? 'Change Password' : 'Set Password';
    }
  }

  Future<void> _openMessageEditor({
    required String title,
    String? subtitle,
    required String initialValue,
    required ValueChanged<String> onSave,
  }) async {
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _MessageEditDialog(
        title: title,
        subtitle: subtitle,
        initialValue: initialValue,
      ),
    );
    if (result != null) onSave(result);
  }

  void _showResponseSnackBar(ApiResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor:
            response.isSuccess ? AppColors.success : AppColors.error,
        content: Text(
          response.isSuccess
              ? (response.message.isNotEmpty
                  ? response.message
                  : 'Status updated')
              : (response.message.isNotEmpty
                  ? response.message
                  : 'Unable to update'),
          style: TextStyle(
            color: Colors.white,
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }


  Widget _bottomAction(AccountSettingProvider provider) {
    final isRoot = _step == AccountSettingStep.accountSetting;
    final isPremium = _step == AccountSettingStep.premiumMembership;
    final isContact = _step == AccountSettingStep.myContactSettings;
    final isSmsAlerts = _step == AccountSettingStep.smsOrEmailAlerts;
    final isPrivacySetting = _step == AccountSettingStep.privacyOptions;

    if (isRoot || isPremium || isContact || isSmsAlerts || isPrivacySetting) {
      return const SizedBox.shrink();
    }

    final isNameAndEmail = _step == AccountSettingStep.nameAndEmail;
    final isMessages = _step == AccountSettingStep.message;
    final isSetPassword = _step == AccountSettingStep.setPassword;
    final isSaving = (isNameAndEmail && provider.isAccountSaving) ||
        (isMessages && provider.isMessagesSaving) ||
        (isSetPassword && provider.isPasswordChanging);

    return BottomBorderedWidget(
      widget : PrimaryButtons(
        buttonStyle: isSaving
            ? ButtonsStyle.disableButton
            : ButtonsStyle.activePrimaryButton,
        title: 'Save Changes',
        onTap: () async {
          if (isSaving) return;

          if (isNameAndEmail) {
            final response = await provider.saveAccountSettings();
            if (!mounted) return;
            _showResponseSnackBar(response);
            return;
          }

          if (isMessages) {
            final response = await provider.saveMessagesSettings();
            if (!mounted) return;
            _showResponseSnackBar(response);
            return;
          }

          if (isSetPassword) {
            final response = await provider.changePassword(hasPassword);
            if (!mounted) return;
            if (response.isSuccess) {
              _showResponseSnackBar(response);
            }
            return;
          }
        },
      ),
    );
  }

  String _formatPrivacyValue(String? value) {
    if (value == null || value.isEmpty) return 'Not Set';

    switch (value) {
      case 'show_full_name':
        return 'Show Full Name';
      case 'hide_first_name':
        return 'Hide First Name';
      case 'hide_full_name':
        return 'Hide Full Name';
      case 'visible_to_all':
        return 'Visible to All';
      case 'visible_to_liked_only':
        return 'Visible to Liked Only';
      case 'visible_to_premium':
        return 'Visible to Premium';
      case 'visible_to_all_premium_members':
        return 'Visible to Premium Members';
      case 'only_premium_members':
        return 'Only Premium Members';
      case 'show_age':
        return 'Show Age';
      case 'show_date':
        return 'Show Date';
      case 'full_dob':
        return 'Show Full DOB';
      case 'hide':
        return 'Hide';
      case 'enable':
        return 'Enable';
      case 'disable':
        return 'Disable';
      case 'for_registered_members':
        return 'For Registered Members';
      case 'for_premium_members':
        return 'For Premium Members';
      case 'for_all':
        return 'For All';
      default:
        return CamelCaseUtils.formatCamelCase(value);
    }
  }

  Future<void> _showPrivacyOptionDialog(
    BuildContext context,
    String title,
    String key,
    String currentValue,
    List<String> options,
    List<String> displayOptions,
  ) async {
    final selectedValue = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final displayOption = displayOptions[index];
            return RadioListTile<String>(
              title: Text(displayOption),
              value: option,
              groupValue: currentValue,
              onChanged: (value) {
                Navigator.of(dialogContext).pop(value);
              },
            );
          }).toList(),
        ),
        actions: [
          PrimaryButtons(buttonStyle: ButtonsStyle.activeSecondaryButton, onTap: () => Navigator.of(dialogContext).pop(), title: 'Cancel'),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),)
      ),
    );

    if (selectedValue != null && selectedValue != currentValue) {
      provider.updatePrivacySetting(key, selectedValue);
      final response = await provider.savePrivacySettings();
      if (!mounted) return;
      _showResponseSnackBar(response);
    }
  }
}

enum AccountSettingStep {
  accountSetting,
  nameAndEmail,
  smsOrEmailAlerts,
  premiumMembership,
  privacyOptions,
  myContactSettings,
  message,
  deleteProfile,
  setPassword
}

class _MessageEditDialog extends StatefulWidget {
  const _MessageEditDialog({
    required this.title,
    this.subtitle,
    this.textController,
    required this.initialValue,
  });

  final String title;
  final String? subtitle;
  final TextEditingController? textController;
  final String initialValue;

  @override
  State<_MessageEditDialog> createState() => _MessageEditDialogState();
}

class _MessageEditDialogState extends State<_MessageEditDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AlertDialog(
          title: Text(widget.title),
          titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.subtitle ?? 'Customize the message sent to members.',
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8,),
              PrimaryTextField(
                controller: _controller,
                hintText: 'Type your message here...',
                noPrefix: true,
                maxLine: 5,
                minLine: 4,
                onTap: () {  },
              ),
              const SizedBox(height: 8,),
            ],
          ),
          actions: [
            InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500,
                  ),
                )),
            InkWell(
                onTap: () => Navigator.of(context).pop(_controller.text.trim()),
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Set',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: TextSize.font14(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ))),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}





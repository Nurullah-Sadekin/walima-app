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
  ConsumerState<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends ConsumerState<AccountSettingScreen> {
  late AccountSettingProvider provider;
  AccountSettingStep _step = AccountSettingStep.accountSetting;

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
        floatingActionButton: BottomBorderedWidget(
          widget: _bottomAction(provider),
        ),
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
            onTap: () => setState(() => _step = AccountSettingStep.smsOrEmailAlerts),
          ),

          ProfileActionTile(
            iconImagePath: AppImages.messages,
            title: 'Messages',
            onTap: () => setState(() => _step = AccountSettingStep.message),
          ),
          ProfileActionTile(
            iconImagePath: AppImages.lockPasswordSvgIcon,
            title: 'Set Password',
            onTap: () => setState(() => _step = AccountSettingStep.setPassword),
            // Note: ProfileActionTile might need custom styling for the delete option
            // You may need to check if ProfileActionTile supports custom colors
          ),
          ProfileActionTile(
            iconImagePath: AppImages.safetySvgIcon,
            title: 'Privacy Options',
            onTap: () => setState(() => _step = AccountSettingStep.privacyOptions),
          ),
          ProfileActionTile(
            iconImagePath: AppImages.delete,
            title: 'Hide/Delete Profile',
            onTap: () => setState(() => _step = AccountSettingStep.deleteProfile),
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
            subtitle: 'Auto-renewal for your ${CamelCaseUtils.formatCamelCase(currentPlan)} Membership is ${provider.premiumSettings?.autoRenew == true ? 'ON' : 'OFF'}.',
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
                subtitle: 'Hiding your profile makes you invisible and disables messages and invitations',
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
              Text('You\'ll permanently lose all profile data, matches, and memberships',
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
                  final deleteProfileStatus = provider.setDeleteProfileStatus(index);
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
    final contactIcon =
        isEmail ? AppImages.emailSvgIcon : AppImages.callIcon;
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
                onItemTap: (index) {
                  provider.selectContactDisplayStatusByIndex(index);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _privacyOptions() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        InfoTile(
          title: 'Display Name',
          value: 'Hide Full Name',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.contactPreview,
          showTrailingImage: true,
          showLeadingImage: true,
        ),
        InfoTile(
          title: 'Photo',
          value: 'Visible To Liked Only',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.photoIcon,
          showTrailingImage: true,
          showLeadingImage: true,
        ),
        InfoTile(
          title: 'Phone Number',
          value: 'Only Premium Members',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.callIcon,
          showTrailingImage: true,
          showLeadingImage: true,
        ),
        InfoTile(
          title: 'Email',
          value: 'Hide',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.emailSvgIcon,
          showTrailingImage: true,
          showLeadingImage: true,
        ),
        InfoTile(
          title: 'Date of Birth',
          value: 'Hide',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.calenderTimer,
          showTrailingImage: true,
          showLeadingImage: true,
        ),
        InfoTile(
          title: 'Annual Income',
          value: 'Hide',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.walletSvgIcon,
          showTrailingImage: true,
          showLeadingImage: true,
        ),
        InfoTile(
          title: 'Shortlist Settings',
          value: 'Enable',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.sortFilter,
          showTrailingImage: true,
          showLeadingImage: true,
        ),
        InfoTile(
          title: 'Do Not Disturb',
          value: 'Enable',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.cancelSvgIcon,
          showTrailingImage: true,
          showLeadingImage: true,
        ),
        InfoTile(
          title: 'Profile Policy',
          value: 'Enable',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.safetySvgIcon,
          showTrailingImage: true,
          showLeadingImage: true,
        ),
      ],
    );
  }

  Widget _messages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        CardBorder(
          widget: SettingsSwitchTile(
            title: 'Auto-Message on Connect',
            subtitle: 'Your saved message will auto-send with each Connect Request',
            value: provider.autoMessageConnect ?? false,
            onChanged: (value) {
              provider.autoMessageConnect = value;
              provider.notifyListeners();
            },
          ),
        ),
        const InfoTile(
          title: 'Message on Connect',
          subtitle: 'This message is sent with your Connect Request when auto-message is enable',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.contactPreview,
          showTrailingImage: true,
          showLeadingImage: false,
          borderRadius: 8,
          padding: EdgeInsets.all(16),
        ),
        const InfoTile(
          title: 'Message on Accept',
          subtitle: 'This message is sent to members upon accepting their Connect request',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.contactPreview,
          showTrailingImage: true,
          showLeadingImage: false,
          borderRadius: 8,
          padding: EdgeInsets.all(16),
        ),
        const InfoTile(
          title: 'Message on Remind',
          subtitle: 'This message is sent to members when you send them a reminder',
          //   onTap: () => setState(() => _step = ContactFilterStep.ageRange),
          leadingImagePath: AppImages.contactPreview,
          showTrailingImage: true,
          showLeadingImage: false,
          borderRadius: 8,
          padding: EdgeInsets.all(16),
        ),
      ],
    );
  }

  Widget _emailOrSmsAlerts() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          AlertStatus(
            title: 'Match Mail & Photo Match Mail',
            alertStatusList: [
              AlertStatusItem(label: 'Daily', isSelected: true),
              AlertStatusItem(label: 'Tri-Weekly', isSelected: false),
              AlertStatusItem(label: 'Weekly', isSelected: false),
              AlertStatusItem(label: 'Unsubscribe', isSelected: false),
            ],
            onStatusTap: (index) {},
          ),
          AlertStatus(
            alertStatusList: [
              AlertStatusItem(label: 'Weekly', isSelected: true),
              AlertStatusItem(label: 'Unsubscribe', isSelected: false),
            ],
            onStatusTap: (index) {},
          ),
          AlertStatus(
            title: 'Recent Visitors Email',
            alertStatusList: [
              AlertStatusItem(label: 'Weekly', isSelected: true),
              AlertStatusItem(label: 'Unsubscribe', isSelected: false),
            ],
            onStatusTap: (index) {},
          ),
          AlertStatus(
            title: 'Members Who Shortlisted You Email',
            alertStatusList: [
              AlertStatusItem(label: 'Weekly', isSelected: true),
              AlertStatusItem(label: 'Unsubscribe', isSelected: false),
            ],
            onStatusTap: (index) {},
          ),
          AlertStatus(
            title: 'Viewed Profile Email',
            alertStatusList: [
              AlertStatusItem(label: 'Weekly', isSelected: true),
              AlertStatusItem(label: 'Unsubscribe', isSelected: false),
            ],
            onStatusTap: (index) {},
          ),
          AlertStatus(
            title: 'Similar Profiles Email',
            alertStatusList: [
              AlertStatusItem(label: 'Weekly', isSelected: true),
              AlertStatusItem(label: 'Unsubscribe', isSelected: false),
            ],
            onStatusTap: (index) {},
          ),
          AlertStatus(
            title: 'Contact Alert',
            alertStatusList: [
              AlertStatusItem(label: 'Instant-Email for every reply', isSelected: true),
              AlertStatusItem(label: 'Daily - All responses', isSelected: false),
              AlertStatusItem(label: 'Unsubscribe', isSelected: false),
            ],
            onStatusTap: (index) {},
          ),
          AlertStatus(
            title: 'Walima.com Profile Blaster',
            alertStatusList: [
              AlertStatusItem(label: 'Subscribe', isSelected: true),
              AlertStatusItem(label: 'Unsubscribe', isSelected: false),
            ],
            onStatusTap: (index) {},
          ),
          AlertStatus(
            title: 'Walima Specials',
            alertStatusList: [
              AlertStatusItem(label: 'Occasionally - Max twice a month', isSelected: true),
              AlertStatusItem(label: 'Unsubscribe', isSelected: false),
            ],
            onStatusTap: (index) {},
          ),
          const SizedBox(
            height: 60,
          )
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

  Widget _bottomAction(AccountSettingProvider provider) {
    final isRoot = _step == AccountSettingStep.accountSetting;
    final isPremium = _step == AccountSettingStep.premiumMembership;

    if (isRoot || isPremium) {
      return const SizedBox.shrink();
    }

    final isNameAndEmail = _step == AccountSettingStep.nameAndEmail;
    final isContact = _step == AccountSettingStep.myContactSettings;
    final isSaving = (isNameAndEmail && provider.isAccountSaving) ||
        (isContact && provider.isContactSaving);

    return PrimaryButtons(
      buttonStyle: isSaving
          ? ButtonsStyle.disableButton
          : ButtonsStyle.activePrimaryButton,
      title: 'Save Changes',
      onTap: () async {
        if (isSaving) return;

        if (isNameAndEmail) {
          final response = await provider.saveAccountSettings();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.isSuccess
                    ? (response.message.isNotEmpty
                        ? response.message
                        : 'Account updated')
                    : (response.message.isNotEmpty
                        ? response.message
                        : 'Unable to update account'),
              ),
            ),
          );
          return;
        }

        if (isContact) {
          final response = await provider.saveContactSettings();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.isSuccess
                    ? (response.message.isNotEmpty
                        ? response.message
                        : 'Contact display status updated')
                    : (response.message.isNotEmpty
                        ? response.message
                        : 'Unable to update contact display status'),
              ),
            ),
          );
          return;
        }
      },
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
        return 'Set Password';
    }
  }

  void _showResponseSnackBar(ApiResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: response.isSuccess ? AppColors.greenButtonColor : AppColors.errorBorderColor,
        content: Text(
          response.isSuccess
              ? (response.message.isNotEmpty
              ? response.message
              : 'Status updated')
              : (response.message.isNotEmpty
              ? response.message
              : 'Unable to update'),
        ),
      ),
    );
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

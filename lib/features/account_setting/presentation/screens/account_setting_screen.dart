import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/account_setting/presentation/providers/account_setting_provider.dart';
import 'package:flutter_boilerplate/features/account_setting/presentation/screens/widgets/card_border.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/screens/widgets/profile_action_tile.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
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
      case AccountSettingStep.alerts:
        return null;
      case AccountSettingStep.premiumMembership:
        return _premiumMembership();
      case AccountSettingStep.contactPrivacy:
        return _detailBody(
          description:
              'Control who can access your contact details and how visible your private information stays.',
          items: provider.contactPrivacyOptions,
          onTap: provider.toggleContactPrivacyOption,
        );
      case AccountSettingStep.verificationBadge:
        return _detailBody(
          description:
              'Manage badge visibility and verification-related reminders for your profile.',
          items: provider.verificationBadgeOptions,
          onTap: provider.toggleVerificationBadgeOption,
        );
      case AccountSettingStep.dateOfBirth:
        return _detailBody(
          description:
              'Select how your date of birth should be shown to other members.',
          items: provider.dateOfBirthOptions,
          onTap: provider.selectDateOfBirthOption,
        );
      case AccountSettingStep.message:
        return _detailBody(
          description:
              'Adjust who can message you and how message-related preferences should work.',
          items: provider.messageOptions,
          onTap: provider.toggleMessageOption,
        );
      case AccountSettingStep.deleteProfile:
        return _hideOrDeleteProfile();
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
            iconImagePath: AppImages.notificationSvgIcon,
            title: 'Alerts',
            onTap: () =>
                setState(() => _step = AccountSettingStep.premiumMembership),
          ),
          ProfileActionTile(
            iconImagePath: AppImages.premiumSvgIcon,
            title: 'Premium Membership',
            onTap: () =>
                setState(() => _step = AccountSettingStep.premiumMembership),
          ),
          ProfileActionTile(
            iconImagePath: AppImages.contactPreview,
            title: 'Contact Privacy',
            onTap: () =>
                setState(() => _step = AccountSettingStep.contactPrivacy),
          ),
          ProfileActionTile(
            iconImagePath: AppImages.verifyIcon,
            iconColor: AppColors.disableDark,
            title: 'Verification Badge',
            onTap: () =>
                setState(() => _step = AccountSettingStep.verificationBadge),
          ),
          ProfileActionTile(
            iconImagePath: AppImages.calenderTimer,
            title: 'Date of Birth',
            onTap: () => setState(() => _step = AccountSettingStep.dateOfBirth),
          ),
          ProfileActionTile(
            iconImagePath: AppImages.messages,
            title: 'Message',
            onTap: () => setState(() => _step = AccountSettingStep.message),
          ),
          ProfileActionTile(
            iconImagePath: AppImages.delete,
            title: 'Delete Profile',
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

  Widget _detailBody({
    required String description,
    required List<dynamic> items,
    required void Function(int) onTap,
    bool isDangerZone = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDangerZone
                ? AppColors.error.withValues(alpha: 0.06)
                : AppColors.primaryVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDangerZone
                  ? AppColors.error.withValues(alpha: 0.18)
                  : AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          child: Text(
            description,
            style: TextStyle(
              color:
                  isDangerZone ? AppColors.error : AppColors.textSecondaryLight,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(items.length, (index) {
                final item = items[index];
                return SelectionCard(
                  buttonStyle: item.isSelected
                      ? SelectionStyle.selectedCheckbox
                      : SelectionStyle.unSelectedCheckbox,
                  onTap: () => onTap(index),
                  isSelected: item.isSelected,
                  title: item.name,
                  isExpand: true,
                );
              }),
            ),
          ),
        ),
      ],
    );
  }


  Widget _premiumMembership() {
    return CardBorder(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          SettingsSwitchTile(
            title: 'Auto-renew my Plan',
            subtitle: 'Auto-renewal for your Membership',
            value: provider.autoRenew ?? false,
            onChanged: (value) {
              provider.autoRenew = value;
              provider.notifyListeners();
            },
          ),
          SettingsSwitchTile(
            title: 'What is auto-renewal?',
            subtitle:
                '"Auto-renewal" automatically renews your plan before its expiry, from your registered Credit/Debit Card, so you can continue to enjoy your premium benefits.',
            value: true,
            onChanged: (value) {},
            isVisibleSwitcher: false,
          ),
          Text('Current Plan:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font12(context,)
              )
          )
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

          SettingsSwitchTile(
            title: 'Hide Profile',
            subtitle: 'Hiding your profile makes you invisible and disables messages and invitations',
            value: provider.autoRenew ?? false,
            onChanged: (value) {
              provider.autoRenew = value;
              provider.notifyListeners();
            },
          ),

          Divider(
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
          Text('Current Plan:',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryLight,
                  fontSize: TextSize.font12(context,)
              )
          )
        ],
      ),
    );
  }


  Widget _bottomAction(AccountSettingProvider provider) {
    final isRoot = _step == AccountSettingStep.accountSetting;

    if (isRoot) {
      return const SizedBox.shrink();
    }

    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Save Changes',
      onTap: () {
        Navigator.pop(context, provider.buildResult());
      },
    );
  }

  String _titleForStep(AccountSettingStep step) {
    switch (step) {
      case AccountSettingStep.accountSetting:
        return 'Account Setting';
      case AccountSettingStep.alerts:
        return 'Alerts';
      case AccountSettingStep.premiumMembership:
        return 'Premium Membership';
      case AccountSettingStep.contactPrivacy:
        return 'Contact Privacy';
      case AccountSettingStep.verificationBadge:
        return 'Verification Badge';
      case AccountSettingStep.dateOfBirth:
        return 'Date of Birth';
      case AccountSettingStep.message:
        return 'Message';
      case AccountSettingStep.deleteProfile:
        return 'Delete Profile';
    }
  }
}

enum AccountSettingStep {
  accountSetting,
  alerts,
  premiumMembership,
  contactPrivacy,
  verificationBadge,
  dateOfBirth,
  message,
  deleteProfile,
}

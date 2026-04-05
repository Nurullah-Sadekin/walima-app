import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/profile_summary_card.dart';
import 'package:flutter_boilerplate/core/global/repositorys/global_repository.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/app_router.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/link_opener.dart';
import 'package:flutter_boilerplate/core/utils/picker_dialog.dart';
import 'package:flutter_boilerplate/features/anchor_point/anchor_point.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/providers/app_drawer_provider.dart';
import 'package:flutter_boilerplate/features/profile/presentation/utils/profile_summary_utils.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/screens/widgets/profile_action_tile.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});
  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  static const String _helpCenterUrl =
      'https://dev.walima.app/en/account/help-desk';
  static const String _beSafeOnlineUrl =
      'https://dev.walima.app/en/be-safe-online';
  static const String _termsUrl = 'https://dev.walima.app/en/terms';

  Future<void> _openLink(String title, String url) {
    return LinkOpener.open(
      context,
      title: title,
      url: url,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(drawerProvider);
    final router = ref.watch(goRouterProvider);
    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: TransparentLoading(
        isLoading:
            provider.loaderState == DrawerScreenStates.transparentLoading,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  spacing: 16,
                  children: [
                    _topBar(context),
                    _profileSummary(context),
                    _account(),
                    _findYourMatches(),
                    _optionsAndControls(),
                    _general(),
                    _footer(context),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: BottomBorderedWidget(
            widget: PrimaryButtons(
              title: 'Log Out',
              titleSize: TextSize.font14(context),
              textColor: AppColors.white,
              bgColor: AppColors.primary,
              svgIconPath: AppImages.logOutSvgIcon,
              svgIconColor: AppColors.white,
              onTap: () async {
                await provider.logout(
                  () {
                    router.go(Paths.login);
                  },
                  onBeforeLogout: () {
                    ref.read(chatProvider).clearChatState();
                  },
                );
              },
              buttonStyle: ButtonsStyle.iconicDynamicButton,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.textPrimaryLight,
          ),
        ),
        Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font18(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 48), // Placeholder to balance the close button
      ],
    );
  }

  Widget _profileSummary(BuildContext context) {
    final profileData = ref.watch(profileProvider).dashboard?.profile;
    final displayName = resolveDisplayName(profileData);
    final memberId = resolveMemberId(profileData);
    final planName = resolvePlanName(profileData?.membership);
    final expiryText =
        formatExpiry(profileData?.membership?.membershipExpiresAt);
    return ProfileSummaryCard(
      displayName: displayName,
      memberId: memberId,
      planName: planName,
      expiryText: expiryText,
      profileImagePath:
          profileData?.profilePicture?.url ?? AppImages.demoProfile,
      showTopIcon: profileData?.isVerified ?? true,
      showBottomIcon: true,
      topIconPath: AppImages.verifiedBadgeSvgIcon,
      bottomIconPath: AppImages.cameraSvgIcon,
      onBottomIconPressed: () async {
        final String? imagePath = await PickerDialog().imagePicker(context);
        if (!context.mounted) return;
        if (imagePath != null) {
          await ref.watch(profileProvider).updateProfileImage(
                context: context,
                filePath: imagePath,
              );
        }
      },
    );
  }

  Widget _account() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const SizedBox(
          height: 4,
        ),
        Text(
          'ACCOUNT',
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        ProfileActionTile(
          iconImagePath: AppImages.profileSvgIcon,
          title: 'View & Edit Your profile',
          onTap: () {
            context.pushNamed(Routes.editProfile);
          },
        ),
        ProfileActionTile(
          iconImagePath: AppImages.shareSvgIcon,
          title: 'Download & Share profile',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _findYourMatches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          'find your matches'.toUpperCase(),
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        ProfileActionTile(
          iconImagePath: AppImages.userLoveSvgIcon,
          title: 'Matches',
          onTap: () {
            Navigator.of(context).pop();
            ref.read(currentTabProvider.notifier).state = 1;
            context.goNamed(Routes.anchor);
          },
        ),
        ProfileActionTile(
          iconImagePath: AppImages.emailSvgIcon,
          title: 'Inbox',
          onTap: () {
            Navigator.of(context).pop();
            ref.read(currentTabProvider.notifier).state = 2;
            context.goNamed(Routes.anchor);
          },
        ),
        ProfileActionTile(
          iconImagePath: AppImages.chatSvgIcon,
          title: 'Chat',
          onTap: () {
            Navigator.of(context).pop();
            ref.read(currentTabProvider.notifier).state = 3;
            context.goNamed(Routes.anchor);
          },
        ),
      ],
    );
  }

  Widget _optionsAndControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          'options and controls'.toUpperCase(),
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        ProfileActionTile(
          iconImagePath: AppImages.settingsSvgIcon,
          title: 'Partner Preferences',
          onTap: () {
            context.pushNamed(
              Routes.partnerPreferences,
              extra: <String, dynamic>{'fromDrawer': true},
            );
          },
        ),
        ProfileActionTile(
          iconImagePath: AppImages.filterSvgIcon,
          title: 'Contacts Filters',
          onTap: () {
            context.pushNamed(Routes.contactFilter);
          },
        ),
        ProfileActionTile(
          iconImagePath: AppImages.accountSettingSvgIcon,
          title: 'Account Settings',
          onTap: () {
            context.pushNamed(Routes.accountSetting);
          },
        ),
      ],
    );
  }

  Widget _general() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          'general'.toUpperCase(),
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        ProfileActionTile(
          iconImagePath: AppImages.customerSupportSvgIcon,
          title: 'Help & Support',
          onTap: () => _openLink('Help Center', _helpCenterUrl),
        ),
        ProfileActionTile(
          iconImagePath: AppImages.bubbleChatSvgIcon,
          title: 'Be Safe Online',
          onTap: () => _openLink('Be Safe Online', _beSafeOnlineUrl),
        ),
        ProfileActionTile(
          iconImagePath: AppImages.starSvgIcon,
          title: 'Rate The App',
          onTap: () {},
        ),
        ProfileActionTile(
          iconImagePath: AppImages.documentValidationSvgIcon,
          title: 'Terms & Conditions',
          onTap: () => _openLink('Terms & Conditions', _termsUrl),
        ),
      ],
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColors.disableBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.greyLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            'Copyright© walima.com',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w400,
            ),
          ),
          FutureBuilder<String>(
            future: GlobalRepository().getAppVersion(),
            builder: (context, snapshot) {
              final versionLabel =
                  snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData
                      ? 'Version ${snapshot.data}'
                      : 'Version';
              return Text(
                versionLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: TextSize.font12(context),
                  fontWeight: FontWeight.w400,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

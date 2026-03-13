import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/profile_image_card.dart';
import 'package:flutter_boilerplate/core/global/repositorys/global_repository.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/app_router.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/providers/app_drawer_provider.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/screens/widgets/profile_action_tile.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});
  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
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
          icon: const Icon(Icons.close_rounded,
              color: AppColors.textPrimaryLight),
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
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileImageCard(
            imagePath: AppImages.demoProfile,
            imageSize: 97,
            iconSize: 20,
            showTopIcon: true,
            showBottomIcon: true,
            topPositionImagePath: AppImages.verifiedBadgeSvgIcon,
            bottomPositionImagePath: AppImages.editSvgIcon,
            onTopPressed: () {
              print('Edit pressed');
            },
            onBottomPressed: () {
              print('Check pressed');
            },
          ),
          const SizedBox(width: 12),
          Expanded(child: _profileDetails(context)),
        ],
      ),
    );
  }

  Widget _profileDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tahmina Rahman',
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: TextSize.font20(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          _memberIdChip(context),
          _subscriptionRow(context),
        ],
      ),
    );
  }

  Widget _memberIdChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: AppColors.greyLight,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'ID : 1234567890',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.copy_rounded,
            color: AppColors.textSecondaryLight,
            size: TextSize.font12(context),
          ),
        ],
      ),
    );
  }

  Widget _subscriptionRow(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            'Gold',
            style: TextStyle(
              color: AppColors.white,
              fontSize: TextSize.font10(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Expires: March 2026',
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
          onTap: () {},
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
          onTap: () {},
        ),
        ProfileActionTile(
          iconImagePath: AppImages.emailSvgIcon,
          title: 'Inbox',
          onTap: () {},
        ),
        ProfileActionTile(
          iconImagePath: AppImages.chatSvgIcon,
          title: 'Chat',
          onTap: () {},
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
          onTap: () {},
        ),
        ProfileActionTile(
          iconImagePath: AppImages.filterSvgIcon,
          title: 'Contacts Filters',
          onTap: () {},
        ),
        ProfileActionTile(
          iconImagePath: AppImages.accountSettingSvgIcon,
          title: 'Account Settings',
          onTap: () {},
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
          onTap: () {},
        ),
        ProfileActionTile(
          iconImagePath: AppImages.bubbleChatSvgIcon,
          title: 'Be Safe Online',
          onTap: () {},
        ),
        ProfileActionTile(
          iconImagePath: AppImages.starSvgIcon,
          title: 'Rate The App',
          onTap: () {},
        ),
        ProfileActionTile(
          iconImagePath: AppImages.documentValidationSvgIcon,
          title: 'Terms & Conditions',
          onTap: () {},
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

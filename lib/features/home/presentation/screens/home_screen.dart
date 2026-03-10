import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/connect_now_card.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/profile_image_card.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/app_drawer.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/verification_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Key profileImageKey = const ValueKey('home_profile_image');
  // Use a scaffold key to reliably open the drawer from anywhere in this State
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: Column(
        children: [
          _headerSection(context),
          _bodySection(),
        ],
      ),
    );
  }

  Widget _headerSection(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: ShowImage(
            imagePath: AppImages.homeProfileBg,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              _topBar(context),
              const SizedBox(height: 30),
              _profileSummary(context),
              const SizedBox(height: 16),
              _headerActions(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBar(BuildContext context) {
    return AppBar(
      leadingWidth: 40,
      leading: IconButton(
        icon: const ShowImage(
          imagePath: AppImages.menuSvgIcon,
          color: AppColors.textPrimaryLight,
          height: 20,
          width: 20,
        ),
        onPressed: _openDrawerOverNav,
      ),
      title: Text(
        'My Walima',
        style: TextStyle(
          color: AppColors.textPrimaryLight,
          fontSize: TextSize.font18(context),
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: const [
        ShowImage(
          imagePath: AppImages.notificationSvgIcon,
          color: AppColors.textPrimaryLight,
          height: 20,
          width: 20,
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
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
            bottomPositionImagePath: AppImages.cameraSvgIcon,
            onBottomPressed: () {
              // print('Check pressed');
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
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _headerActions() {
    return Row(
      children: [
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.iconicDynamicButton,
            textColor: AppColors.textSecondaryLight,
            bgColor: AppColors.white,
            borderColor: AppColors.greyLight,
            svgIconPath: AppImages.editProfileSvgIcon,
            svgIconColor: AppColors.textSecondaryLight,
            iconLeftPosition: false,
            onTap: () async {
              await DialogUtils.showSuccessDialog(
                  context: context,
                  message:
                      'Purchase done! Instant alerts for matches and profile views are now enabled.',
                  title: 'Subscription Done',
                  buttonText: 'Done',
                  autoClose: true,
                  autoCloseDuration: const Duration(seconds: 2));
            },
            title: 'Edit Profile',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.iconicDynamicButton,
            textColor: AppColors.white,
            bgColor: AppColors.primary,
            svgIconPath: AppImages.premiumSvgIcon,
            iconLeftPosition: false,
            onTap: () async {
              await DialogUtils.showInfoDialog(
                  context: context,
                  message:
                      'Purchase done! Instant alerts for matches and profile views are now enabled.',
                  title: 'Subscription Done',
                  autoClose: true,
                  autoCloseDuration: const Duration(seconds: 2));
            },
            title: 'Renew Plan',
          ),
        ),
      ],
    );
  }

  Widget _bodySection() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _completeProfileStatus(),
            _premiumMatches(),
          ],
        ),
      ),
    );
  }

  Widget _completeProfileStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Complete Your Profile',
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: TextSize.font18(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Complete profiles get 2x more matches',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          const VerificationTile(
            iconImagePath: AppImages.verifiedBadgeSvgIcon,
            title: 'Government ID Verify',
            statusText: 'Unverified',
            statusColor: AppColors.primary,
            statusBackgroundColor: AppColors.primaryVariant,
          ),
          const SizedBox(height: 10),
          VerificationTile(
            iconImagePath: AppImages.verifyContact,
            title: 'Verify Phone Number',
            statusText: 'Verified',
            statusColor: AppColors.success,
            statusBackgroundColor: Colors.green.withOpacity(
              0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _premiumMatches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text(
                    'Premium Matches',
                    style: TextStyle(
                      color: AppColors.textPrimaryLight,
                      fontSize: TextSize.font18(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '26 Profiles Found',
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font14(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: AppColors.greyLight),
                ),
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: TextSize.font14(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.textSecondaryLight,
                      size: TextSize.font12(context),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: ConnectNowCard(
              imagePath: AppImages.demoProfile,
              iconPath: AppImages.premiumSvgIcon,
              isPremiumConnect: true,
              name: 'Profile Name',
              age: '28 Years',
              height: '5 Feet 3 Inches',
              location: 'Gulshan, Dhaka, BD',
            ),
          ),
        ],
      ),
    );
  }

  void _openDrawerOverNav() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Drawer',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        // Full screen container (no SafeArea) so the drawer overlays the status/notification bar
        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context)
                .size
                .height, // full height to cover status bar
            child: const Material(
              color: Colors.transparent,
              child: AppDrawer(),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween =
            Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

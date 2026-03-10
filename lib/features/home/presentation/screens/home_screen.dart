import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/connect_now_card.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/profile_image_card.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/app_drawer.dart';

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

  Widget _headerActions() {
    return Row(
      children: [
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.activeSecondaryButton,
            onTap: () {},
            title: 'Connect Now',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.activeSecondaryButton,
            onTap: () {},
            title: 'Connect Now',
          ),
        ),
      ],
    );
  }

  Widget _bodySection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: const SingleChildScrollView(
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

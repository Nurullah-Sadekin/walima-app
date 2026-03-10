import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/profile_image_card.dart';
import 'package:flutter_boilerplate/features/home/presentation/widgets/profile_info_card.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          _topBar(context),
          _headerSection(context),
          _bodySection(),
        ],
      ),
    );
  }

  Widget _headerSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _profileSummary(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return CustomBackAppBar(
      title: const Text('Edit Profile'),
      backIconBackground: AppColors.transparent,
      onBackPressed: () {
        Navigator.pop(context);
      },
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
          _activeStatus(context),
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
          border: Border.all(color: AppColors.greyLight)
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

  Widget _activeStatus(BuildContext context) {
    return Text(
      'Last Online: Today',
      style: TextStyle(
        color: AppColors.textSecondaryLight,
        fontSize: TextSize.font14(context),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _bodySection() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            spacing: 12,
            children: [
              _aboutMyself(),
              _basicDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _aboutMyself() {
    return ProfileInfoCard(
      title: 'About Yourself',
      showEdit: true,
      onEdit: () {
      },
      child: Text(
        'I have obtained my Masters in Management. I\'ve been an active student throughout my academic years. I am self-employed and handle my own business.A kind heart and a bright smile would be an apt way to describe me. I am seeking a simple and loving partner who will support me in every phase of life. Thank you for expressing interest in my profile.',
        style: TextStyle(
          color: AppColors.textSecondaryLight,
          fontSize: TextSize.font14(context),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _basicDetails() {
    return ProfileInfoCard(
      title: 'Basic Details',
      showEdit: true,
      onEdit: () {},
      infoList: const [
        MapEntry('Age', '33'),
        MapEntry('Date of Birth', '07-Aug-1992'),
        MapEntry('Marital Status', 'Never Married'),
        MapEntry('Height', '5\' 3"(167cm) '),
        MapEntry('Grew up in', 'Bangladesh'),
        MapEntry('Diet', 'Non-Veg'),
        MapEntry('Blood Group', 'B Positive (B+)'),
        MapEntry('Health Information', 'Not Specified'),
        MapEntry('Disability', 'None'),
      ],
    );
  }
}

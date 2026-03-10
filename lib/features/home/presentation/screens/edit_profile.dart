import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/connect_now_card.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/profile_image_card.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/app_drawer.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/social_media_icon.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/verification_tile.dart';

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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'About Yourself',
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.greyLight),
                  ),
                  child: Row(
                    spacing: 4,
                    children: [
                      ShowImage(
                        imagePath: AppImages.editWrite,
                        width: TextSize.font16(context),
                        height: TextSize.font16(context),
                        color: AppColors.primary,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: TextSize.font14(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.greyLight),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'I have obtained my Masters in Management. I\'ve been an active student throughout my academic years. I am self-employed and handle my own business.A kind heart and a bright smile would be an apt way to describe me. I am seeking a simple and loving partner who will support me in every phase of life. Thank you for expressing interest in my profile.',
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font14(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _basicDetails() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Basic Details',
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.greyLight),
                  ),
                  child: Row(
                    spacing: 4,
                    children: [
                      ShowImage(
                        imagePath: AppImages.editWrite,
                        width: TextSize.font16(context),
                        height: TextSize.font16(context),
                        color: AppColors.primary,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: TextSize.font14(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.greyLight),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Column(
              spacing: 6,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                   Expanded(
                     flex: 3,
                     child: Text(
                        'Age:',
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                   ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        '33',
                        style: TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                   Expanded(
                     flex: 3,
                     child: Text(
                        'Date of Birth:',
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                   ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        '07-Aug-1992',
                        style: TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                   Expanded(
                     flex: 3,
                     child: Text(
                        'Marital Status:',
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                   ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Never Married',
                        style: TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

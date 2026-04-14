import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet_widget/widgets/icon_title_card.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';

import 'widgets/preference_match_card.dart';
import 'widgets/profile_view_card.dart';

class ProfilePreviewScreen extends StatelessWidget {
  const ProfilePreviewScreen({
    super.key,
    this.userData,
  });

  final Map<String, dynamic>? userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: _body(context),
      floatingActionButton: _actionButtons(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return const CustomBackAppBar(
      backgroundColor: Colors.white,
      isBackButton: true,
      backIconBackground: Colors.transparent,
      elevation: 0,
      title: Text('Profile Preview',
          style: TextStyle(color: AppColors.textPrimaryLight)),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            _profileHeader(context),
            const SizedBox(height: 24),
            _basicDetailsSection(context),
            const SizedBox(height: 16),
            _aboutSection(context),
            const SizedBox(height: 16),
            _habitsAndInterests(context),
            const SizedBox(height: 16),
            _contact(context),
            const SizedBox(height: 16),
            _lifestyleSection(context),
            const SizedBox(height: 16),
            _backgroundSection(context),
            const SizedBox(height: 16),
            _familyDetailsSection(context),
            const SizedBox(height: 16),
            _educationCareerSection(context),
            const SizedBox(height: 16),
            _preferenceMatchSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader(BuildContext context) {
    return Column(
      children: [
        ProfileComprehensiveCard(
          imagePath: AppImages.demoProfile,
          name: '${userData?['firstName'] ?? 'John'} ${userData?['lastName'] ?? 'Doe'}',
          noButton: true,
          activeStatusText: 'Online',
          photoCount: '5',
          menu: true,
        ),
      ],
    );
  }

  Widget _basicDetailsSection(BuildContext context) {
    return const ProfileViewCard(
      title: 'Basic Details',
      userId: 'SH3563XTS',
      profileManageStatus: 'Profile Created by Self',
      infoList: [
        MapEntry('Age', '20'),
        MapEntry('Date of Birth', '07-Aug-1995'),
        MapEntry('Marital Status', 'Never Married'),
        MapEntry('Height', '170cm'),
        MapEntry('Grew up in', 'Bangladesh'),
        MapEntry('Diet', 'Non-Vegetarian'),
        MapEntry('Blood Group', 'B+ (B positive)'),
        MapEntry('Health Information', 'Well'),
        MapEntry('Disability', 'None'),
      ],
    );
  }

  Widget _aboutSection(BuildContext context) {
    return ProfileViewCard(
      title: 'About',
      subtitle: 'Her short bio',
      iconPath: AppImages.person,
      child: Text(
        'I have obtained my Masters in Management. I\'ve been an active student throughout my academic years. I am self-employed and handle my own business.A kind heart and a bright smile would be an apt way to describe me. I am seeking a simple and loving partner who will support me in every phase of life. Thank you for expressing interest in my profile.',
        style: TextStyle(
          fontSize: TextSize.font12(context),
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondaryLight,
        ),
      ),
    );
  }

  Widget _habitsAndInterests(BuildContext context) {
    return const ProfileViewCard(
      title: 'Habits & Interests',
      subtitle: 'Activities, Hobbies, Interests, Lifestyle',
      iconPath: AppImages.habitsSvgIcon,
      itemList: [
        'Reading',
        'Traveling',
        'Cooking',
        'Sports',
        'Music',
        'Movies',
        'Fitness',
        'Photography',
      ],
    );
  }

  Widget _contact(BuildContext context) {
    return const ProfileViewCard(
      title: 'Contact',
      subtitle: 'Contact Information',
      iconPath: AppImages.contactPreview,
      itemList: [
        'Phone: +88018774******',
        'Email: *********@gmail.com'
      ],
    );
  }

  Widget _lifestyleSection(BuildContext context) {
    return const ProfileViewCard(
      title: 'Lifestyle',
      subtitle: 'Lifestyle, Hobbies, Interests',
      iconPath: AppImages.lifeStyleSvgIcon,
      itemList: [
        'Diet: Non-Vegetarian',
        'Smoking: No',
        'Drinking: No',
        'Exercise: Regularly',
      ],
    );
  }

  Widget _backgroundSection(BuildContext context) {
    return const ProfileViewCard(
      title: 'Background',
      subtitle: 'About Background',
      iconPath: AppImages.propertySvgIcon,
      infoList: [
        MapEntry('Religion', 'Muslim'),
        MapEntry('Community', 'Sunni'),
        MapEntry('Marital Status', 'Never Married'),
        MapEntry('Location', 'Dhaka'),
        MapEntry('Residency Status', 'Citizen'),
      ],
    );
  }

  Widget _familyDetailsSection(BuildContext context) {
    return const ProfileViewCard(
      title: 'Family',
      subtitle: 'About Family background',
      iconPath: AppImages.groupsIcon,
      infoList: [
        MapEntry('Father\'s Status', 'Employed'),
        MapEntry('Mother\'s Status', 'Homemaker'),
        MapEntry('Siblings', '1 Brother, 1 Sister'),
        MapEntry('Family Type', 'Joint Family'),
        MapEntry('Family Status', 'Middle Class'),
        MapEntry('Family Location', 'Dhaka'),
      ],
    );
  }

  Widget _educationCareerSection(BuildContext context) {
    return const ProfileViewCard(
      title: 'Education & Career',
      subtitle: 'Her Educational & career journey',
      iconPath: AppImages.educationSvgIcon,
      infoList: [
        MapEntry('Height Qualification', 'Bachelor\'s Degree'),
        MapEntry('College\'s Attended', 'Northern University Bangladesh Engineer'),
        MapEntry('Annual Income', 'Not Mentioned'),
        MapEntry('Working With', 'Business'),
        MapEntry('Working As', 'Business Owner'),
        MapEntry('Employer Name', 'Walima'),
      ],
    );
  }

  Widget _preferenceMatchSection() {
    return const PreferenceMatchCard();
  }

  Widget _actionButtons(BuildContext context) {
    return BottomBorderedWidget(
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconTitleCard(
            title: 'Super Connect',
            imagePath: AppImages.chatIcon,
            backgroundColor: AppColors.primary,
            textColor: AppColors.textSecondaryLight,
            iconColor: AppColors.white,
            onTap: () {},
          ),
          IconTitleCard(
            title: 'Connect Now',
            imagePath: AppImages.favouriteIcon,
            backgroundColor: AppColors.greenButtonColor,
            textColor: AppColors.textSecondaryLight,
            iconColor: AppColors.white,
            onTap: () {},
          ),
          IconTitleCard(
            title: 'Contact Now',
            imagePath: AppImages.callIcon,
            backgroundColor: Colors.transparent,
            borderColor: AppColors.primary,
            textColor: AppColors.textSecondaryLight,
            iconColor: AppColors.primary,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

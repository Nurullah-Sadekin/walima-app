import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:go_router/go_router.dart';

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
            _demographicsSection(context),
            const SizedBox(height: 16),
            _backgroundSection(context),
            const SizedBox(height: 16),
            _lifestyleSection(context),
            const SizedBox(height: 16),
            _familyDetailsSection(context),
            const SizedBox(height: 16),
            _educationCareerSection(context),
            const SizedBox(height: 32),
            _actionButtons(context),
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
      iconPath: AppImages.profileSvgIcon,
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

  Widget _demographicsSection(BuildContext context) {
    return _infoCard(
      context,
      title: 'Demographics',
      items: [
        MapEntry('Occupation', userData?['occupation'] ?? 'Software Engineer'),
        MapEntry('Highest Qualification',
            userData?['qualification'] ?? 'Bachelor\'s Degree'),
        MapEntry('Annual Income', userData?['income'] ?? 'Not Mentioned'),
        MapEntry('Family Status', userData?['familyStatus'] ?? 'Middle Class'),
      ],
    );
  }

  Widget _lifestyleSection(BuildContext context) {
    return _infoCard(
      context,
      title: 'Lifestyle & Interests',
      items: [
        MapEntry('Hobbies', userData?['hobbies'] ?? 'Reading, Gaming'),
        MapEntry(
            'Interests', userData?['interests'] ?? 'Technology, Traveling'),
        MapEntry('Diet', userData?['diet'] ?? 'Non-Vegetarian'),
        MapEntry('Smoking', userData?['smoking'] ?? 'None'),
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
        MapEntry('Family Location','Dhaka'),
      ],
    );
  }

  Widget _backgroundSection(BuildContext context) {
    return const ProfileViewCard(
      title: 'Background',
      subtitle: 'About Family background',
      iconPath: AppImages.groupsIcon,
      infoList: [
        MapEntry('Father\'s Status', 'Employed'),
        MapEntry('Mother\'s Status', 'Homemaker'),
        MapEntry('Siblings', '1 Brother, 1 Sister'),
        MapEntry('Family Type', 'Joint Family'),
        MapEntry('Family Status', 'Middle Class'),
        MapEntry('Family Location','Dhaka'),
      ],
    );
  }


  Widget _educationCareerSection(BuildContext context) {
    return _infoCard(
      context,
      title: 'Education & Career',
      items: [
        MapEntry('Highest Qualification',
            userData?['highestQualification'] ?? 'MBA - Management'),
        MapEntry(
            'Qualification In', userData?['qualificationIn'] ?? 'Technology'),
        MapEntry(
            'Working With', userData?['workingWith'] ?? 'Software Company'),
        MapEntry('Working As', userData?['workingAs'] ?? 'Senior Developer'),
      ],
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required String title,
    required List<MapEntry<String, String>> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(
            items.length,
            (index) => Padding(
              padding:
                  EdgeInsets.only(bottom: index < items.length - 1 ? 12 : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    items[index].key,
                    style: TextStyle(
                      fontSize: TextSize.font12(context),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      items[index].value,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: TextSize.font12(context),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return BottomBorderedWidget(
      widget: PrimaryButtons(
        title: 'Preview Profile',
        titleSize: TextSize.font14(context),
        textColor: AppColors.white,
        bgColor: AppColors.primary,
        svgIconColor: AppColors.white,
        onTap: () {
          context.pop({'preview': true});
        },
        buttonStyle: ButtonsStyle.activePrimaryButton,
      ),
    );
  }
}

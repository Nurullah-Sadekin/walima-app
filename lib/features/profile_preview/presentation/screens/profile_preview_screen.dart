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

class ProfilePreviewScreen extends StatelessWidget {
  const ProfilePreviewScreen({
    super.key,
    this.userData,
  });

  final Map<String, dynamic>? userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: const CustomBackAppBar(
        backgroundColor: Color(0xFFF9F9F9),
        isBackButton: true,
        backIconBackground: Colors.transparent,
        elevation: 0,
        title: Text('Profile Preview',
            style: TextStyle(color: AppColors.textPrimaryLight)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              _profileHeader(context),
              const SizedBox(height: 24),
              _basicDetailsSection(context),
              const SizedBox(height: 16),
              _demographicsSection(context),
              const SizedBox(height: 16),
              _lifestyleSection(context),
              const SizedBox(height: 16),
              _familyDetailsSection(context),
              const SizedBox(height: 16),
              _educationCareerSection(context),
              const SizedBox(height: 32),
              _actionButtons(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: BottomBorderedWidget(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
    return _infoCard(
      context,
      title: 'Basic Details',
      items: [
        MapEntry('Age', '${userData?['age'] ?? 'N/A'} years'),
        MapEntry('Date of Birth', userData?['dateOfBirth'] ?? '23 Aug 2002'),
        MapEntry('Height', userData?['height'] ?? '5\'8"(165cm)'),
        MapEntry('Grown up in', userData?['grewUpIn'] ?? 'Desh'),
        MapEntry(
            'Marital Status', userData?['maritalStatus'] ?? 'Never Married'),
      ],
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
    return _infoCard(
      context,
      title: 'Family Details',
      items: [
        MapEntry('Father Status', userData?['fatherStatus'] ?? 'Service'),
        MapEntry('Mother Status', userData?['motherStatus'] ?? 'Homemaker'),
        MapEntry('No. of Brothers', userData?['brothers'] ?? '1'),
        MapEntry('No. of Sisters', userData?['sisters'] ?? '2'),
        MapEntry('Family Status', userData?['familyClass'] ?? 'Middle Class'),
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
    return Column(
      spacing: 12,
      children: [
        PrimaryButtons(
          title: 'Super Connect',
          buttonStyle: ButtonsStyle.activePrimaryButton,
          onTap: () {},
        ),
        PrimaryButtons(
          title: 'Connect Now',
          buttonStyle: ButtonsStyle.activePrimaryButton,
          onTap: () {},
        ),
        Row(
          children: [
            Expanded(
              child: PrimaryButtons(
                title: 'Contact Now',
                buttonStyle: ButtonsStyle.activePrimaryButton,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryVariant,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: ShowImage(
                  imagePath: AppImages.callIcon,
                  width: TextSize.font20(context),
                  height: TextSize.font20(context),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

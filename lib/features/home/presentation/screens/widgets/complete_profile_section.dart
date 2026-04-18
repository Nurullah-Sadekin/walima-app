import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/home/data/model/response/profile_strength_response.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/verification_tile.dart';
import 'package:flutter_boilerplate/features/profile/presentation/screen/profile_edit_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CompleteProfileSection extends ConsumerWidget {
  const CompleteProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(homeProvider);
    final profileStrength = provider.profileStrength;
    final completionPercentage = profileStrength?.overallScore ?? 0;
    final incompleteItems = (profileStrength?.incompleteSections ??
            const <ProfileStrengthSection>[])
        .map(_CompleteProfileTileData.fromStrengthSection)
        .toList();

    if (provider.isLoadingProfileStrength && profileStrength == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (completionPercentage >= 100 ||
        incompleteItems.isEmpty ||
        provider.profileStrengthError != null) {
      return const SizedBox.shrink();
    }

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
            'Your profile is $completionPercentage% complete',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(incompleteItems.length, (index) {
            final item = incompleteItems[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == incompleteItems.length - 1 ? 0 : 10,
              ),
              child: VerificationTile(
                iconImagePath: item.iconImagePath,
                title: item.title,
                statusText: item.statusText,
                statusColor: AppColors.primary,
                statusBackgroundColor: AppColors.primaryVariant,
                onTap: () => item.open(context),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CompleteProfileTileData {
  const _CompleteProfileTileData({
    required this.title,
    required this.iconImagePath,
    required this.statusText,
    required this.onTap,
  });

  static const String completeProfileSource = 'completeProfile';

  final String title;
  final String iconImagePath;
  final String statusText;
  final Future<void> Function(BuildContext context) onTap;

  Future<void> open(BuildContext context) => onTap(context);

  static _CompleteProfileTileData fromStrengthSection(
    ProfileStrengthSection section,
  ) {
    final sectionKey = section.key?.trim().toLowerCase();
    final fieldKey = section.firstIncompleteFieldKey;
    final title = 'Complete ${section.label ?? 'Profile Section'}';
    final statusText = '${section.completionPercentage ?? 0}%';

    switch (sectionKey) {
      case 'preferences':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.premiumSvgIcon,
          section: _preferenceSectionForField(fieldKey),
        );
      case 'basic_profile':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.profileSvgIcon,
          section: _basicProfileSectionForField(fieldKey),
        );
      case 'appearance':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.person,
          section: ProfileEditSection.basicDetails,
        );
      case 'location':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.locationSvgIcon,
          section: ProfileEditSection.location,
        );
      case 'education':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.educationSvgIcon,
          section: ProfileEditSection.educationCareer,
        );
      case 'profession':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.workSvgIcon,
          section: ProfileEditSection.educationCareer,
        );
      case 'religion':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.religionSvgIcon,
          section: ProfileEditSection.religiousBackground,
        );
      case 'family':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.familyDetails,
          section: ProfileEditSection.familyDetails,
        );
      case 'lifestyle':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.lifeStyleSvgIcon,
          section: ProfileEditSection.basicDetails,
        );
      case 'contact':
      case 'contacts':
        return _CompleteProfileTileData(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.verifyContact,
          onTap: _openVerifyNumber,
        );
      case 'photos':
        return _CompleteProfileTileData(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.photoIcon,
          onTap: _openPhotoUpload,
        );
      case 'interests':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.favouriteIcon,
          section: ProfileEditSection.hobbiesInterests,
        );
      default:
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.profileSvgIcon,
          section: ProfileEditSection.aboutYourself,
        );
    }
  }

  static _CompleteProfileTileData _profileEditTile({
    required String title,
    required String statusText,
    required String iconImagePath,
    required ProfileEditSection section,
  }) {
    return _CompleteProfileTileData(
      title: title,
      statusText: statusText,
      iconImagePath: iconImagePath,
      onTap: (context) async {
        await context.pushNamed(
          Routes.profileSectionEdit,
          extra: {'section': section.key},
        );
        if (!context.mounted) return;
        await ProviderScope.containerOf(
          context,
          listen: false,
        ).read(homeProvider).loadProfileStrength(force: true);
      },
    );
  }

  static ProfileEditSection _basicProfileSectionForField(String? fieldKey) {
    switch (fieldKey) {
      case 'bio':
        return ProfileEditSection.aboutYourself;
      case 'languages':
      case 'dateOfBirth':
      case 'maritalStatus':
      case 'displayName':
        return ProfileEditSection.basicDetails;
      case 'motherTongue':
        return ProfileEditSection.religiousBackground;
      default:
        return ProfileEditSection.basicDetails;
    }
  }

  static ProfileEditSection _preferenceSectionForField(String? fieldKey) {
    switch (fieldKey) {
      case 'locationPreference':
        return ProfileEditSection.preferenceLocationDetails;
      case 'educationPreference':
        return ProfileEditSection.preferenceEducationCareer;
      case 'partnerExpectations':
      case 'dietPreference':
        return ProfileEditSection.preferenceOtherDetails;
      case 'ageRange':
      case 'heightRange':
      case 'maritalStatusPreference':
      case 'religionPreference':
      default:
        return ProfileEditSection.preferenceBasicInfo;
    }
  }

  static Future<void> _openVerifyNumber(BuildContext context) async {
    await context.pushNamed(
      Routes.verifyNumber,
      extra: {'fromScreen': completeProfileSource},
    );
    if (!context.mounted) return;
    await ProviderScope.containerOf(
      context,
      listen: false,
    ).read(homeProvider).loadProfileStrength(force: true);
  }

  static Future<void> _openPhotoUpload(BuildContext context) async {
    await context.pushNamed(
      Routes.photoUpload,
      extra: {'fromScreen': completeProfileSource},
    );
    if (!context.mounted) return;
    await ProviderScope.containerOf(
      context,
      listen: false,
    ).read(homeProvider).loadProfileStrength(force: true);
  }
}

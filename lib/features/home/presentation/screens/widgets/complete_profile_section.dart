import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/verification_tile.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:flutter_boilerplate/features/profile/presentation/screen/profile_edit_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CompleteProfileSection extends ConsumerWidget {
  const CompleteProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(profileProvider);
    final completionPercentage = provider.profile?.profileCompletion?.percentage ?? 0;
    final incompleteItems = (provider.profile?.profileCompletion?.missingSectionItems ?? const <ProfileCompletionSection>[])
        .map(_CompleteProfileTileData.fromSection)
        .toList();

    if (completionPercentage >= 100 || incompleteItems.isEmpty) {
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
            'Complete profiles get 2x more matches',
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
                statusText: 'Incomplete',
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
    required this.onTap,
  });

  static const String completeProfileSource = 'completeProfile';

  final String title;
  final String iconImagePath;
  final Future<void> Function(BuildContext context) onTap;

  Future<void> open(BuildContext context) => onTap(context);

  static _CompleteProfileTileData fromSection(
    ProfileCompletionSection section,
  ) {
    switch (section) {
      case ProfileCompletionSection.basicProfile:
        return _profileEditTile(
          title: 'Complete Basic Profile',
          iconImagePath: AppImages.profileSvgIcon,
          section: ProfileEditSection.aboutYourself,
        );
      case ProfileCompletionSection.appearance:
        return _profileEditTile(
          title: 'Complete Appearance',
          iconImagePath: AppImages.person,
          section: ProfileEditSection.basicDetails,
        );
      case ProfileCompletionSection.location:
        return _profileEditTile(
          title: 'Complete Location',
          iconImagePath: AppImages.locationSvgIcon,
          section: ProfileEditSection.location,
        );
      case ProfileCompletionSection.educationCareer:
        return _profileEditTile(
          title: 'Complete Education & Career',
          iconImagePath: AppImages.educationSvgIcon,
          section: ProfileEditSection.educationCareer,
        );
      case ProfileCompletionSection.religion:
        return _profileEditTile(
          title: 'Complete Religious Background',
          iconImagePath: AppImages.religionSvgIcon,
          section: ProfileEditSection.religiousBackground,
        );
      case ProfileCompletionSection.family:
        return _profileEditTile(
          title: 'Complete Family Details',
          iconImagePath: AppImages.familyDetails,
          section: ProfileEditSection.familyDetails,
        );
      case ProfileCompletionSection.lifestyle:
        return _profileEditTile(
          title: 'Complete Lifestyle',
          iconImagePath: AppImages.lifeStyleSvgIcon,
          section: ProfileEditSection.basicDetails,
        );
      case ProfileCompletionSection.contacts:
        return const _CompleteProfileTileData(
          title: 'Verify Phone Number',
          iconImagePath: AppImages.verifyContact,
          onTap: _openVerifyNumber,
        );
      case ProfileCompletionSection.photos:
        return const _CompleteProfileTileData(
          title: 'Add Photos',
          iconImagePath: AppImages.photoIcon,
          onTap: _openPhotoUpload,
        );
      case ProfileCompletionSection.hobbiesInterests:
        return _profileEditTile(
          title: 'Add Hobbies & Interests',
          iconImagePath: AppImages.favouriteIcon,
          section: ProfileEditSection.hobbiesInterests,
        );
    }
  }

  static _CompleteProfileTileData _profileEditTile({
    required String title,
    required String iconImagePath,
    required ProfileEditSection section,
  }) {
    return _CompleteProfileTileData(
      title: title,
      iconImagePath: iconImagePath,
      onTap: (context) => context.pushNamed(
        Routes.profileSectionEdit,
        extra: {'section': section.key},
      ),
    );
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
    ).read(profileProvider).getProfile(context);
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
    ).read(profileProvider).getProfile(context);
  }
}

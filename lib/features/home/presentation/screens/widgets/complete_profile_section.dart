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

class CompleteProfileSection extends ConsumerStatefulWidget {
  const CompleteProfileSection({super.key});

  @override
  ConsumerState<CompleteProfileSection> createState() => _CompleteProfileSectionState();
}

class _CompleteProfileSectionState extends ConsumerState<CompleteProfileSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(homeProvider);
    final profileStrength = provider.profileStrength;
    final completionPercentage = profileStrength?.overallScore ?? 0;
    final incompleteItems =
        (profileStrength?.incompleteSections ?? const <ProfileStrengthSection>[]).map(_CompleteProfileTileData.fromStrengthSection).toList();

    if (provider.isLoadingProfileStrength && profileStrength == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (completionPercentage >= 100 || incompleteItems.isEmpty || provider.profileStrengthError != null) {
      return const SizedBox.shrink();
    }

    final itemsToShow = _isExpanded ? incompleteItems : incompleteItems.take(2).toList();
    final hasMoreItems = incompleteItems.length > 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
          if (incompleteItems.isNotEmpty)
            ...List.generate(itemsToShow.length, (index) {
              final item = itemsToShow[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == itemsToShow.length - 1 ? 0 : 10,
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

          if (hasMoreItems && !_isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () => setState(() => _isExpanded = true),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'See More',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: TextSize.font14(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.expand_more,
                      color: AppColors.primary,
                      size: TextSize.font18(context),
                    ),
                  ],
                ),
              ),
            ),
          // Show "See Less" button if expanded
          if (hasMoreItems && _isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () => setState(() => _isExpanded = false),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'See Less',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: TextSize.font14(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.expand_less,
                      color: AppColors.primary,
                      size: TextSize.font18(context),
                    ),
                  ],
                ),
              ),
            ),
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
  static const Map<String, List<String>> _requiredFieldsBySection = <String, List<String>>{
    'preferences': <String>[
      'ageRange',
      'heightRange',
      'maritalStatusPreference',
      'educationPreference',
      'religionPreference',
      'locationPreference',
      'partnerExpectations',
      'dietPreference',
    ],
    'basic_profile': <String>[
      'dateOfBirth',
      'maritalStatus',
      'bio',
      'motherTongue',
      'languages',
      'displayName',
    ],
    'photos': <String>[
      'hasPhoto',
      'hasPrimaryPhoto',
      'hasMultiplePhotos',
    ],
    'family': <String>[
      'familyType',
      'familyValues',
      'parentInfo',
      'aboutFamily',
      'marriageTimeline',
    ],
    'education': <String>[
      'hasEducation',
      'educationLevel',
      'fieldOfStudy',
    ],
    'profession': <String>[
      'hasProfession',
      'profession',
      'incomeRange',
    ],
    'appearance': <String>[
      'height',
      'weight',
      'bodyType',
    ],
    'religion': <String>[
      'religion',
      'community',
      'religiousBackground',
    ],
    'lifestyle': <String>[
      'dietType',
      'drinkingHabits',
      'smokingHabits',
    ],
    'location': <String>[
      'hasLocation',
      'country',
      'city',
    ],
    'interests': <String>[
      'hasInterests',
    ],
    'contact': <String>[
      'hasContact',
    ],
  };

  final String title;
  final String iconImagePath;
  final String statusText;
  final Future<void> Function(BuildContext context) onTap;

  Future<void> open(BuildContext context) => onTap(context);

  static _CompleteProfileTileData fromStrengthSection(
    ProfileStrengthSection section,
  ) {
    final sectionKey = _normalizeKey(section.key);
    final strengthFields = section.incompleteFields.isNotEmpty ? section.incompleteFields : (section.fields ?? const <ProfileStrengthField>[]);
    final fieldKey = section.firstIncompleteFieldKey ?? _requiredFieldsBySection[sectionKey]?.first;
    final title = 'Complete ${section.label ?? 'Profile Section'}';
    final statusText = _statusTextFor(section);

    switch (sectionKey) {
      case 'preferences':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.userLoveSvgIcon,
          section: _preferenceSectionForField(fieldKey),
          strengthSectionKey: sectionKey,
          strengthSectionLabel: section.label,
          strengthFields: strengthFields,
        );
      case 'basic_profile':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.profileSvgIcon,
          section: _basicProfileSectionForField(fieldKey),
          strengthSectionKey: sectionKey,
          strengthSectionLabel: section.label,
          strengthFields: strengthFields,
        );
      case 'appearance':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.person,
          section: _appearanceSectionForField(fieldKey),
          strengthSectionKey: sectionKey,
          strengthSectionLabel: section.label,
          strengthFields: strengthFields,
        );
      case 'location':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.locationSvgIcon,
          section: _locationSectionForField(fieldKey),
          strengthSectionKey: sectionKey,
          strengthSectionLabel: section.label,
          strengthFields: strengthFields,
        );
      case 'education':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.educationSvgIcon,
          section: _educationSectionForField(fieldKey),
          strengthSectionKey: sectionKey,
          strengthSectionLabel: section.label,
          strengthFields: strengthFields,
        );
      case 'profession':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.workSvgIcon,
          section: _professionSectionForField(fieldKey),
          strengthSectionKey: sectionKey,
          strengthSectionLabel: section.label,
          strengthFields: strengthFields,
        );
      case 'religion':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.religionSvgIcon,
          section: ProfileEditSection.religiousBackground,
          strengthSectionKey: sectionKey,
          strengthSectionLabel: section.label,
          strengthFields: strengthFields,
        );
      case 'family':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.groupsIcon,
          section: _familySectionForField(fieldKey),
          strengthSectionKey: sectionKey,
          strengthSectionLabel: section.label,
          strengthFields: strengthFields,
        );
      case 'lifestyle':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.lifeStyleSvgIcon,
          section: _lifestyleSectionForField(fieldKey),
          strengthSectionKey: sectionKey,
          strengthSectionLabel: section.label,
          strengthFields: strengthFields,
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
      case 'hobbies':
      case 'hobbies_interests':
      case 'interest':
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.habitsSvgIcon,
          section: _interestsSectionForField(fieldKey),
          strengthSectionKey: sectionKey,
          strengthSectionLabel: section.label,
          strengthFields: strengthFields,
        );
      default:
        return _profileEditTile(
          title: title,
          statusText: statusText,
          iconImagePath: AppImages.profileSvgIcon,
          section: ProfileEditSection.aboutYourself,
          strengthSectionKey: sectionKey,
          strengthSectionLabel: section.label,
          strengthFields: strengthFields,
        );
    }
  }

  static _CompleteProfileTileData _profileEditTile({
    required String title,
    required String statusText,
    required String iconImagePath,
    required ProfileEditSection section,
    String? strengthSectionKey,
    String? strengthSectionLabel,
    List<ProfileStrengthField>? strengthFields,
  }) {
    return _CompleteProfileTileData(
      title: title,
      statusText: statusText,
      iconImagePath: iconImagePath,
      onTap: (context) async {
        final resolvedStrengthFields =
            strengthFields?.where((field) => field.key?.trim().isNotEmpty ?? false).toList(growable: false) ?? const <ProfileStrengthField>[];
        await context.pushNamed(
          Routes.profileSectionEdit,
          extra: {
            'section': section.key,
            if (strengthSectionKey != null) 'strengthSectionKey': strengthSectionKey,
            if (strengthSectionLabel != null) 'strengthSectionLabel': strengthSectionLabel,
            if (resolvedStrengthFields.isNotEmpty) 'strengthFields': resolvedStrengthFields.map((field) => field.toJson()).toList(growable: false),
          },
        );
        if (!context.mounted) return;
        await ProviderScope.containerOf(
          context,
          listen: false,
        ).read(homeProvider).loadProfileStrength(force: true);
      },
    );
  }

  static String _normalizeKey(String? value) {
    return value?.trim().toLowerCase() ?? '';
  }

  static String _statusTextFor(ProfileStrengthSection section) {
    final remaining = section.remainingFieldCount;
    if (remaining > 0) {
      final suffix = remaining == 1 ? 'field left' : 'fields left';
      return '$remaining $suffix';
    }
    return '${section.completionPercentage ?? 0}%';
  }

  static ProfileEditSection _basicProfileSectionForField(String? fieldKey) {
    switch (_normalizeKey(fieldKey)) {
      case 'bio':
        return ProfileEditSection.aboutYourself;
      case 'mothertongue':
      case 'languages':
      case 'dateofbirth':
      case 'maritalstatus':
      case 'displayname':
        return ProfileEditSection.basicDetails;
      default:
        return ProfileEditSection.basicDetails;
    }
  }

  static ProfileEditSection _preferenceSectionForField(String? fieldKey) {
    switch (_normalizeKey(fieldKey)) {
      case 'locationpreference':
        return ProfileEditSection.preferenceLocationDetails;
      case 'educationpreference':
      case 'professionpreference':
      case 'workingaspreference':
      case 'annualincomepreference':
        return ProfileEditSection.preferenceEducationCareer;
      case 'partnerexpectations':
      case 'expectationsfromlifepartner':
      case 'dietpreference':
      case 'drinkingpreference':
      case 'smokingpreference':
      case 'profilemanagedbypreference':
        return ProfileEditSection.preferenceOtherDetails;
      case 'agerange':
      case 'heightrange':
      case 'maritalstatuspreference':
      case 'religionpreference':
      case 'communitypreference':
      case 'mothertonguepreference':
      case 'languagepreference':
      default:
        return ProfileEditSection.preferenceBasicInfo;
    }
  }

  static ProfileEditSection _familySectionForField(String? fieldKey) {
    switch (_normalizeKey(fieldKey)) {
      case 'familytype':
      case 'familyvalues':
      case 'parentinfo':
      case 'aboutfamily':
      case 'marriagetimeline':
      default:
        return ProfileEditSection.familyDetails;
    }
  }

  static ProfileEditSection _appearanceSectionForField(String? fieldKey) {
    switch (_normalizeKey(fieldKey)) {
      case 'height':
      case 'weight':
      case 'bodytype':
      default:
        return ProfileEditSection.basicDetails;
    }
  }

  static ProfileEditSection _lifestyleSectionForField(String? fieldKey) {
    switch (_normalizeKey(fieldKey)) {
      case 'diettype':
      case 'drinkinghabits':
      case 'smokinghabits':
      default:
        return ProfileEditSection.basicDetails;
    }
  }

  static ProfileEditSection _educationSectionForField(String? fieldKey) {
    switch (_normalizeKey(fieldKey)) {
      case 'haseducation':
      case 'educationlevel':
      case 'fieldofstudy':
      default:
        return ProfileEditSection.educationCareer;
    }
  }

  static ProfileEditSection _professionSectionForField(String? fieldKey) {
    switch (_normalizeKey(fieldKey)) {
      case 'hasprofession':
      case 'profession':
      case 'incomerange':
      default:
        return ProfileEditSection.educationCareer;
    }
  }

  static ProfileEditSection _locationSectionForField(String? fieldKey) {
    switch (_normalizeKey(fieldKey)) {
      case 'haslocation':
      case 'country':
      case 'city':
      default:
        return ProfileEditSection.location;
    }
  }

  static ProfileEditSection _interestsSectionForField(String? fieldKey) {
    switch (_normalizeKey(fieldKey)) {
      case 'hasinterests':
      default:
        return ProfileEditSection.hobbiesInterests;
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

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet_widget/widgets/icon_title_card.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/camel_case_utils.dart';
import 'package:flutter_boilerplate/core/utils/date_time_utils.dart';
import 'package:flutter_boilerplate/core/utils/height_utils.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:flutter_boilerplate/features/profile_preview/data/models/profile_preview_response.dart';
import 'package:flutter_boilerplate/features/profile_preview/presentation/providers/profile_preview_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/preference_match_card.dart';
import 'widgets/profile_view_card.dart';

class ProfilePreviewScreen extends ConsumerStatefulWidget {
  const ProfilePreviewScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  ConsumerState<ProfilePreviewScreen> createState() =>
      _ProfilePreviewScreenState();
}

class _ProfilePreviewScreenState extends ConsumerState<ProfilePreviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profilePreviewProvider).loadPreview(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(profilePreviewProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: _body(context, provider),
      // floatingActionButton: provider.preview != null
      //     ? _actionButtons(context)
      //     : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

  Widget _body(BuildContext context, ProfilePreviewProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.preview == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            provider.error!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font14(context),
            ),
          ),
        ),
      );
    }

    final preview = provider.preview;
    if (preview == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            _profileHeader(context, preview),
            const SizedBox(height: 24),
            _basicDetailsSection(context, preview),
            const SizedBox(height: 16),
            if ((preview.about ?? '').trim().isNotEmpty) ...[
              _aboutSection(context, preview.about!),
              const SizedBox(height: 16),
            ],
            if (preview.interests != null &&
                preview.interests!.all.isNotEmpty) ...[
              _habitsAndInterests(context, preview.interests!),
              const SizedBox(height: 16),
            ],
            _contact(context, preview),
            const SizedBox(height: 16),
            if (preview.lifestyle != null) ...[
              _lifestyleSection(context, preview.lifestyle!),
              const SizedBox(height: 16),
            ],
            _backgroundSection(context, preview),
            const SizedBox(height: 16),
            if (preview.family != null) ...[
              _familyDetailsSection(context, preview.family!),
              const SizedBox(height: 16),
            ],
            if (preview.educations != null || preview.professions != null) ...[
              _educationCareerSection(context, preview),
              const SizedBox(height: 16),
            ],
            _preferenceMatchSection(context, provider, preview),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader(BuildContext context, ProfilePreviewData preview) {
    final user = preview.user;
    final profile = preview.profile;
    final primaryPhoto = profile?.primaryPhoto;
    final photoUrl = primaryPhoto?.url;
    final fallback =
        (profile?.gender ?? '').toLowerCase() == 'female'
            ? AppImages.womenAvatar
            : AppImages.manAvatar;

    final displayName = profile?.displayName?.trim().isNotEmpty == true
        ? profile!.displayName!
        : (user?.fullName.isNotEmpty == true
            ? user!.fullName
            : 'Walima Member');

    final ageText = profile?.age != null ? '${profile!.age} Yr' : null;
    final heightText = profile?.height != null
        ? HeightUtils.formatHeight(profile!.height!.toStringAsFixed(0))
        : null;
    final location = preview.presentLocation?.displayLocation;
    final religionText = _formatReligion(preview);
    final activeStatus = _activeStatus(user);
    final photoCount = profile?.profilePictures.isNotEmpty == true
        ? '${profile!.profilePictures.length}'
        : null;


    return ProfileComprehensiveCard(
      imagePath: (photoUrl != null && photoUrl.isNotEmpty) ? photoUrl : fallback,
      name: displayName,
      age: ageText,
      height: heightText,
      location: location,
      religion: religionText,
      maritalStatus: CamelCaseUtils.formatCamelCase(profile?.maritalStatus),
      noButton: true,
      activeStatusText: activeStatus,
      photoCount: photoCount,
      menu: false,
      isVerified: user?.isVerified ?? false,
      isOnline: user?.isOnline ?? false,
    );
  }

  Widget _basicDetailsSection(
      BuildContext context, ProfilePreviewData preview) {
    final profile = preview.profile;
    final location = preview.presentLocation;
    final lifestyle = preview.lifestyle;
    final dobFormatted = _formatDob(profile?.dateOfBirth);
    final heightText = profile?.height != null ? '${profile!.height} cm' : '-';

    final entries = <MapEntry<String, String>>[
      if (profile?.age != null) MapEntry('Age', '${profile!.age}'),
      if (dobFormatted != null) MapEntry('Date of Birth', dobFormatted),
      if ((profile?.maritalStatus ?? '').isNotEmpty)
        MapEntry('Marital Status',
            CamelCaseUtils.formatCamelCase(profile!.maritalStatus)),
      if (profile?.height != null) MapEntry('Height', heightText),
      if ((location?.grewUpIn ?? '').isNotEmpty)
        MapEntry('Grew up in', location!.grewUpIn!),
      if ((lifestyle?.diet ?? '').isNotEmpty)
        MapEntry('Diet', CamelCaseUtils.formatCamelCase(lifestyle!.diet)),
      if ((profile?.motherTongue ?? '').isNotEmpty)
        MapEntry('Mother Tongue', profile!.motherTongue!),
    ];

    return ProfileViewCard(
      title: 'Basic Details',
      userId: preview.user?.userReference,
      profileManageStatus: (profile?.profileManagedBy ?? '').isNotEmpty
          ? 'Profile Created by ${CamelCaseUtils.formatCamelCase(profile!.profileManagedBy)}'
          : null,
      infoList:
          entries.isEmpty ? const [MapEntry('Info', 'Not Mentioned')] : entries,
    );
  }

  Widget _aboutSection(BuildContext context, String about) {
    return ProfileViewCard(
      title: 'About',
      subtitle: 'Short bio',
      iconPath: AppImages.person,
      child: Text(
        about,
        style: TextStyle(
          fontSize: TextSize.font12(context),
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondaryLight,
        ),
      ),
    );
  }

  Widget _habitsAndInterests(
      BuildContext context, PreviewInterests interests) {
    final items = interests.all
        .map(CamelCaseUtils.formatCamelCase)
        .where((s) => s.isNotEmpty)
        .toList(growable: false);
    return ProfileViewCard(
      title: 'Habits & Interests',
      subtitle: 'Activities, Hobbies, Interests, Lifestyle',
      iconPath: AppImages.habitsSvgIcon,
      itemList: items,
    );
  }

  Widget _contact(BuildContext context, ProfilePreviewData preview) {
    final user = preview.user;
    final items = <String>[
      if (user?.isPhoneVerified == true) 'Phone: Verified',
      if (user?.isEmailVerified == true) 'Email: Verified',
      if (user?.isIdVerified == true) 'ID: Verified',
      if (user?.isPhotoVerified == true) 'Photo: Verified',
    ];
    return ProfileViewCard(
      title: 'Contact',
      subtitle: 'Verification status',
      iconPath: AppImages.contactPreview,
      itemList: items.isEmpty ? const ['Not Verified'] : items,
    );
  }

  Widget _lifestyleSection(BuildContext context, PreviewLifestyle lifestyle) {
    final items = <String>[
      if ((lifestyle.diet ?? '').isNotEmpty)
        'Diet: ${CamelCaseUtils.formatCamelCase(lifestyle.diet)}',
      if ((lifestyle.smoking ?? '').isNotEmpty)
        'Smoking: ${CamelCaseUtils.formatCamelCase(lifestyle.smoking)}',
      if ((lifestyle.drinking ?? '').isNotEmpty)
        'Drinking: ${CamelCaseUtils.formatCamelCase(lifestyle.drinking)}',
    ];
    return ProfileViewCard(
      title: 'Lifestyle',
      subtitle: 'Lifestyle, Hobbies, Interests',
      iconPath: AppImages.lifeStyleSvgIcon,
      itemList: items.isEmpty ? const ['Not Mentioned'] : items,
    );
  }

  Widget _backgroundSection(
      BuildContext context, ProfilePreviewData preview) {
    final religion = preview.religion;
    final location = preview.presentLocation;
    final entries = <MapEntry<String, String>>[
      if ((religion?.religion ?? '').isNotEmpty)
        MapEntry(
            'Religion', CamelCaseUtils.formatCamelCase(religion!.religion)),
      if ((religion?.community ?? '').isNotEmpty)
        MapEntry(
            'Community', CamelCaseUtils.formatCamelCase(religion!.community)),
      if ((preview.profile?.maritalStatus ?? '').isNotEmpty)
        MapEntry(
          'Marital Status',
          CamelCaseUtils.formatCamelCase(preview.profile!.maritalStatus),
        ),
      if ((location?.displayLocation ?? '').isNotEmpty)
        MapEntry('Location', location!.displayLocation),
      if ((location?.residencyStatus ?? '').isNotEmpty)
        MapEntry(
          'Residency Status',
          CamelCaseUtils.formatCamelCase(location!.residencyStatus),
        ),
    ];
    return ProfileViewCard(
      title: 'Background',
      subtitle: 'About Background',
      iconPath: AppImages.propertySvgIcon,
      infoList:
          entries.isEmpty ? const [MapEntry('Info', 'Not Mentioned')] : entries,
    );
  }

  Widget _familyDetailsSection(BuildContext context, PreviewFamily family) {
    final entries = <MapEntry<String, String>>[
      if ((family.fatherStatus ?? '').isNotEmpty)
        MapEntry("Father's Status",
            CamelCaseUtils.formatCamelCase(family.fatherStatus)),
      if ((family.motherStatus ?? '').isNotEmpty)
        MapEntry("Mother's Status",
            CamelCaseUtils.formatCamelCase(family.motherStatus)),
      if (family.numberOfSiblings != null)
        MapEntry('Siblings', '${family.numberOfSiblings}'),
      if ((family.familyType ?? '').isNotEmpty)
        MapEntry(
            'Family Type', CamelCaseUtils.formatCamelCase(family.familyType)),
      if ((family.familyStatus ?? '').isNotEmpty)
        MapEntry('Family Status',
            CamelCaseUtils.formatCamelCase(family.familyStatus)),
      if ((family.familyLocation ?? '').isNotEmpty)
        MapEntry('Family Location', family.familyLocation!),
    ];
    return ProfileViewCard(
      title: 'Family',
      subtitle: 'About Family background',
      iconPath: AppImages.groupsIcon,
      infoList:
          entries.isEmpty ? const [MapEntry('Info', 'Not Mentioned')] : entries,
    );
  }

  Widget _educationCareerSection(
      BuildContext context, ProfilePreviewData preview) {
    final education = preview.educations;
    final profession = preview.professions;
    final entries = <MapEntry<String, String>>[
      if ((education?.educationLevel ?? '').isNotEmpty)
        MapEntry('Highest Qualification',
            CamelCaseUtils.formatCamelCase(education!.educationLevel)),
      if ((education?.institutionName ?? '').isNotEmpty)
        MapEntry('Institution', education!.institutionName!),
      if ((education?.fieldOfStudy ?? '').isNotEmpty)
        MapEntry('Field of Study',
            CamelCaseUtils.formatCamelCase(education!.fieldOfStudy)),
      if ((profession?.incomeRange ?? '').isNotEmpty)
        MapEntry('Annual Income', profession!.incomeRange!),
      if ((profession?.workingWith ?? '').isNotEmpty)
        MapEntry('Working With',
            CamelCaseUtils.formatCamelCase(profession!.workingWith)),
      if ((profession?.workingAs ?? '').isNotEmpty)
        MapEntry('Working As',
            CamelCaseUtils.formatCamelCase(profession!.workingAs)),
      if ((profession?.employerName ?? '').isNotEmpty)
        MapEntry('Employer Name', profession!.employerName!),
    ];
    return ProfileViewCard(
      title: 'Education & Career',
      subtitle: 'Educational & career journey',
      iconPath: AppImages.educationSvgIcon,
      infoList:
          entries.isEmpty ? const [MapEntry('Info', 'Not Mentioned')] : entries,
    );
  }

  Widget _preferenceMatchSection(
    BuildContext context,
    ProfilePreviewProvider provider,
    ProfilePreviewData preview,
  ) {
    if (provider.isCompareLoading && provider.compare == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.greyLight),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    final compare = provider.compare;
    if (compare == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.greyLight),
        ),
        child: Text(
          provider.compareError ?? 'Compatibility data unavailable.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: TextSize.font12(context),
            color: AppColors.textSecondaryLight,
          ),
        ),
      );
    }
    return PreferenceMatchCard(
      data: compare,
      ownerGender: preview.profile?.gender,
      otherImage: preview.profile?.primaryPhoto?.url,
    );
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

  String? _formatReligion(ProfilePreviewData preview) {
    final religion = preview.religion?.religion ?? preview.profile?.religionName;
    final community = preview.religion?.community ?? preview.profile?.community;
    final parts = [religion, community]
        .where((v) => v != null && v.trim().isNotEmpty)
        .map((v) => CamelCaseUtils.formatCamelCase(v))
        .toList();
    return parts.isEmpty ? null : parts.join(', ');
  }

  String? _activeStatus(PreviewUser? user) {
    if (user == null) return null;
    if (user.isOnline == true) return 'Online';
    if ((user.lastSeenAt ?? '').isNotEmpty) {
      return DateTimeUtils.formatDate(DateTime.tryParse(user.lastSeenAt!));
    }
    return 'Offline';
  }

  String? _formatDob(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateTimeUtils.onlyDate(parsed);
  }
}

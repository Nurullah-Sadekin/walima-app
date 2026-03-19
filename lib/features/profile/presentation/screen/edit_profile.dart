import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/profile_image_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/home/presentation/widgets/profile_info_card.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/profile/presentation/screen/profile_edit_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider).profile;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            _headerSection(context, profile),
            _bodySection(profile),
            // SizedBox(height: 50,)
          ],
        ),
      ),
      // floatingActionButton: BottomBorderedWidget(
      //   widget: PrimaryButtons(
      //     title: 'Preview Profile',
      //     titleSize: TextSize.font14(context),
      //     textColor: AppColors.white,
      //     bgColor: AppColors.primary,
      //     svgIconColor: AppColors.white,
      //     onTap: () {
      //       context.pop({'preview': true});
      //     },
      //     buttonStyle: ButtonsStyle.activePrimaryButton,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _headerSection(BuildContext context, CompleteProfile? profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _profileSummary(context, profile),
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

  Widget _profileSummary(BuildContext context, CompleteProfile? profile) {
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileImageCard(
            imagePath: _resolveProfileImagePath(profile),
            imageSize: 97,
            iconSize: 20,
            showTopIcon: profile?.profile?.isVerified ?? false,
            showBottomIcon: true,
            topPositionImagePath: AppImages.verifiedBadgeSvgIcon,
            bottomPositionImagePath: AppImages.cameraSvgIcon,
            onEdit: () {
              // print('Check pressed');
            },
          ),
          const SizedBox(width: 12),
          Expanded(child: _profileDetails(context, profile)),
        ],
      ),
    );
  }

  Widget _profileDetails(BuildContext context, CompleteProfile? profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _resolveDisplayName(profile),
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: TextSize.font20(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          _memberIdChip(context, profile),
          _activeStatus(context, profile),
        ],
      ),
    );
  }

  Widget _memberIdChip(BuildContext context, CompleteProfile? profile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'ID : ${_valueOrDefault(profile?.user?.userReference, '--')}',
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

  Widget _activeStatus(BuildContext context, CompleteProfile? profile) {
    return Text(
      'Status: ${_valueOrDefault(profile?.user?.status, 'Unknown')}',
      style: TextStyle(
        color: AppColors.textSecondaryLight,
        fontSize: TextSize.font14(context),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _bodySection(CompleteProfile? profile) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            spacing: 12,
            children: [
              _aboutMyself(profile),
              _basicDetails(profile),
              _religiousBackground(profile),
              _familyDetails(profile),
              _educationCareer(profile),
              _location(profile),
              _hobbiesInterests(profile),
              _partnerPreferencesHeader(),
              _partnerPreferenceBasic(profile),
              _partnerPreferenceLocation(profile),
              _partnerPreferenceEducationCareer(profile),
              _partnerPreferenceOther(profile),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _aboutMyself(CompleteProfile? profile) {
    return ProfileInfoCard(
      title: 'About Yourself',
      showEdit: true,
      onEdit: () => _openSectionEditor(ProfileEditSection.aboutYourself),
      child: Text(
        _valueOrDefault(profile?.profile?.bio),
        style: TextStyle(
          color: AppColors.textSecondaryLight,
          fontSize: TextSize.font14(context),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _basicDetails(CompleteProfile? profile) {
    final appearance = profile?.appearance;
    final location = _firstLocation(profile);

    return ProfileInfoCard(
      title: 'Basic Details',
      showEdit: true,
      onEdit: () => _openSectionEditor(ProfileEditSection.basicDetails),
      infoList: [
        MapEntry('Age', _valueOrDefault(profile?.profile?.age)),
        MapEntry('Date of Birth', _formatDate(profile?.profile?.dateOfBirth)),
        MapEntry(
          'Marital Status',
          _valueOrDefault(profile?.profile?.maritalStatus),
        ),
        MapEntry('Height', _formatHeightCm(appearance?.height)),
        MapEntry('Grew up in', _valueOrDefault(location?.grewUpIn)),
        MapEntry('Diet', _valueOrDefault(profile?.lifestyle?.dietType)),
        MapEntry('Blood Group', _valueOrDefault(appearance?.bloodGroup)),
        MapEntry(
          'Health Information',
          _valueOrDefault(
            appearance?.healthDetails ?? appearance?.healthCondition,
          ),
        ),
        MapEntry(
          'Disability',
          _valueOrDefault(appearance?.specialCases, 'None'),
        ),
      ],
    );
  }

  Widget _religiousBackground(CompleteProfile? profile) {
    final religion = profile?.religion;

    return ProfileInfoCard(
      title: 'Religious Background',
      showEdit: true,
      onEdit: () => _openSectionEditor(ProfileEditSection.religiousBackground),
      infoList: [
        MapEntry(
          'Religion',
          _valueOrDefault(religion?.religion ?? profile?.profile?.religionName),
        ),
        MapEntry('Community', _valueOrDefault(religion?.community)),
        MapEntry(
          'Sub community',
          _valueOrDefault(religion?.religiousBackground),
        ),
        MapEntry(
          'Mother Tongue',
          _valueOrDefault(profile?.profile?.motherTongue),
        ),
      ],
    );
  }

  Widget _familyDetails(CompleteProfile? profile) {
    final family = profile?.family;

    return ProfileInfoCard(
      title: 'Family Details',
      showEdit: true,
      onEdit: () => _openSectionEditor(ProfileEditSection.familyDetails),
      infoList: [
        MapEntry(
          'Father\'s Details',
          _valueOrDefault(
            _combineNames(
              family?.fatherName,
              family?.fatherProfession,
            ),
          ),
        ),
        MapEntry(
          'Mother\'s Details',
          _valueOrDefault(
            _combineNames(
              family?.motherName,
              family?.motherProfession,
            ),
          ),
        ),
        MapEntry('Family Location', _valueOrDefault(family?.familyLocation)),
        MapEntry('No. of Sisters', _valueOrDefault(family?.sisters)),
        MapEntry('No. of Brothers', _valueOrDefault(family?.brothers)),
        MapEntry(
          'Family Financial Status',
          _valueOrDefault(family?.familyEconomicCondition),
        ),
      ],
    );
  }

  Widget _educationCareer(CompleteProfile? profile) {
    final education = _firstEducation(profile);
    final profession = _firstProfession(profile);

    return ProfileInfoCard(
      title: 'Education & Career',
      showEdit: true,
      onEdit: () => _openSectionEditor(ProfileEditSection.educationCareer),
      infoList: [
        MapEntry(
          'Highest Qualification',
          _valueOrDefault(
            education?.qualification ?? education?.educationLevel,
          ),
        ),
        MapEntry(
          'College(s) Attended',
          _valueOrDefault(education?.institutionName),
        ),
        MapEntry('Annual Income', _valueOrDefault(profession?.incomeRange)),
        MapEntry('Working with', _valueOrDefault(profession?.employmentType)),
        MapEntry(
          'Working as',
          _valueOrDefault(profession?.designation ?? profession?.profession),
        ),
        MapEntry('Employer Name', _valueOrDefault(profession?.employer)),
      ],
    );
  }

  Widget _location(CompleteProfile? profile) {
    final location = _firstLocation(profile);

    return ProfileInfoCard(
      title: 'Location of Groom',
      showEdit: true,
      onEdit: () => _openSectionEditor(ProfileEditSection.location),
      infoList: [
        MapEntry(
          'Current Location',
          _composeLocation(
            location?.city,
            location?.country,
          ),
        ),
        MapEntry('State of Residence', _valueOrDefault(location?.state)),
        MapEntry(
          'Residency Status',
          _valueOrDefault(location?.residencyStatus),
        ),
        MapEntry('ZIP/Pin code', _valueOrDefault(location?.zipCode)),
      ],
    );
  }

  Widget _hobbiesInterests(CompleteProfile? profile) {
    final interest = profile?.interest;

    return ProfileInfoCard(
      title: 'Hobbies & Interests',
      showEdit: true,
      onEdit: () => _openSectionEditor(ProfileEditSection.hobbiesInterests),
      infoList: [
        MapEntry(
          'Creative',
          _valueOrDefault(_joinList(interest?.creativePursuits)),
        ),
        MapEntry(
          'Fun',
          _valueOrDefault(_joinList(interest?.outdoorActivities)),
        ),
        MapEntry(
          'Fitness',
          _valueOrDefault(_joinList(interest?.fitnessAndSports)),
        ),
        MapEntry(
          'Other',
          _valueOrDefault(
            _joinList([
              ...?interest?.mediaAndLearning,
              ...?interest?.foodAndCuisine,
              ...?interest?.travelAndLeisure,
            ]),
          ),
        ),
      ],
    );
  }

  Widget _partnerPreferencesHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 2),
        child: Text(
          'Partner Preferences',
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font16(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _partnerPreferenceBasic(CompleteProfile? profile) {
    final preference = profile?.preferences;

    return ProfileInfoCard(
      title: 'Basic Info',
      showEdit: true,
      onEdit: () => _openSectionEditor(ProfileEditSection.preferenceBasicInfo),
      infoList: [
        MapEntry(
          'Age Range',
          _composeRange(preference?.ageMin, preference?.ageMax),
        ),
        MapEntry(
          'Height Range',
          _composeRange(
            preference?.heightMin,
            preference?.heightMax,
            suffix: ' cm',
          ),
        ),
        MapEntry(
          'Religion',
          _valueOrDefault(_joinList(preference?.religionPreference)),
        ),
        MapEntry(
          'Community',
          _valueOrDefault(_joinList(preference?.communityPreference)),
        ),
        MapEntry(
          'Mother Tongue',
          _valueOrDefault(_joinList(preference?.motherTonguePreference)),
        ),
      ],
    );
  }

  Widget _partnerPreferenceLocation(CompleteProfile? profile) {
    final preference = profile?.preferences;

    return ProfileInfoCard(
      title: 'Location Details',
      showEdit: true,
      onEdit: () =>
          _openSectionEditor(ProfileEditSection.preferenceLocationDetails),
      infoList: [
        MapEntry(
          'Countries',
          _valueOrDefault(_joinList(preference?.preferredCountries)),
        ),
        MapEntry(
          'States',
          _valueOrDefault(_joinList(preference?.preferredStates)),
        ),
        MapEntry(
          'Cities',
          _valueOrDefault(_joinList(preference?.preferredCities)),
        ),
      ],
    );
  }

  Widget _partnerPreferenceEducationCareer(CompleteProfile? profile) {
    final preference = profile?.preferences;

    return ProfileInfoCard(
      title: 'Education & Career',
      showEdit: true,
      onEdit: () =>
          _openSectionEditor(ProfileEditSection.preferenceEducationCareer),
      infoList: [
        MapEntry(
          'Education',
          _valueOrDefault(_joinList(preference?.educationPreference)),
        ),
        MapEntry(
          'Profession',
          _valueOrDefault(_joinList(preference?.professionPreference)),
        ),
        MapEntry(
          'Working As',
          _valueOrDefault(_joinList(preference?.workingAsPreference)),
        ),
        MapEntry(
          'Annual Income',
          _valueOrDefault(_joinList(preference?.annualIncomePreference)),
        ),
      ],
    );
  }

  Widget _partnerPreferenceOther(CompleteProfile? profile) {
    final preference = profile?.preferences;

    return ProfileInfoCard(
      title: 'Other Details',
      showEdit: true,
      onEdit: () =>
          _openSectionEditor(ProfileEditSection.preferenceOtherDetails),
      infoList: [
        MapEntry(
          'Profile Managed By',
          _valueOrDefault(_joinList(preference?.profileManagedByPreference)),
        ),
        MapEntry(
          'Diet',
          _valueOrDefault(_joinList(preference?.dietPreference)),
        ),
      ],
    );
  }

  void _openSectionEditor(ProfileEditSection section) {
    context.pushNamed(
      Routes.profileSectionEdit,
      extra: section.key,
    );
  }

  String _resolveDisplayName(CompleteProfile? profile) {
    final displayName = profile?.profile?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    final firstName = profile?.user?.firstName?.trim() ?? '';
    final lastName = profile?.user?.lastName?.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }

    return 'Unknown User';
  }

  String _resolveProfileImagePath(CompleteProfile? profile) {
    final pictures = profile?.profile?.profilePictures;
    if (pictures == null || pictures.isEmpty) {
      return AppImages.demoProfile;
    }

    for (final picture in pictures) {
      final url = picture.url?.trim();
      if (picture.isPrimary == true && url != null && url.isNotEmpty) {
        return url;
      }
    }

    for (final picture in pictures) {
      final url = picture.url?.trim();
      if (url != null && url.isNotEmpty) {
        return url;
      }
    }

    return AppImages.demoProfile;
  }

  Locations? _firstLocation(CompleteProfile? profile) {
    final locations = profile?.locations;
    if (locations == null || locations.isEmpty) return null;
    return locations.first;
  }

  Educations? _firstEducation(CompleteProfile? profile) {
    final educations = profile?.educations;
    if (educations == null || educations.isEmpty) return null;
    return educations.first;
  }

  Profession? _firstProfession(CompleteProfile? profile) {
    final professions = profile?.profession;
    if (professions == null || professions.isEmpty) return null;
    return professions.first;
  }

  String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Not Specified';
    }

    final parsed = DateTime.tryParse(value.trim());
    if (parsed == null) {
      return value;
    }

    return DateFormat('dd-MMM-yyyy').format(parsed);
  }

  String _formatHeightCm(int? heightCm) {
    if (heightCm == null || heightCm <= 0) {
      return 'Not Specified';
    }
    return '$heightCm cm';
  }

  String _composeLocation(dynamic city, dynamic country) {
    final cityText = _trimmed(city);
    final countryText = _trimmed(country);

    if (cityText.isEmpty && countryText.isEmpty) {
      return 'Not Specified';
    }
    if (cityText.isEmpty) return countryText;
    if (countryText.isEmpty) return cityText;
    return '$cityText, $countryText';
  }

  String _joinList(List<String>? values) {
    if (values == null || values.isEmpty) {
      return '';
    }

    final normalized = values
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);

    if (normalized.isEmpty) {
      return '';
    }

    return normalized.join(', ');
  }

  String _composeRange(
    dynamic minValue,
    dynamic maxValue, {
    String suffix = '',
  }) {
    final minText = _trimmed(minValue);
    final maxText = _trimmed(maxValue);

    if (minText.isEmpty && maxText.isEmpty) {
      return 'Not Specified';
    }
    if (minText.isEmpty) {
      return '$maxText$suffix';
    }
    if (maxText.isEmpty) {
      return '$minText$suffix';
    }
    return '$minText$suffix - $maxText$suffix';
  }

  String _combineNames(dynamic first, dynamic second) {
    final firstText = _trimmed(first);
    final secondText = _trimmed(second);

    if (firstText.isEmpty && secondText.isEmpty) {
      return '';
    }
    if (firstText.isEmpty) return secondText;
    if (secondText.isEmpty) return firstText;
    return '$firstText, $secondText';
  }

  String _valueOrDefault(dynamic value, [String fallback = 'Not Specified']) {
    final normalized = _trimmed(value);
    return normalized.isEmpty ? fallback : normalized;
  }

  String _trimmed(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }
}

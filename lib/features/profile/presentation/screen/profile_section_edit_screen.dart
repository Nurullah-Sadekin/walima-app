import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/profile/data/model/request/update_profile_section_request_body.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:flutter_boilerplate/features/profile/data/repository/profile_repository.dart';
import 'package:flutter_boilerplate/features/profile/presentation/screen/profile_edit_section.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/data/models/request/update_preferences_request_body.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/data/repository/preferences_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/update_family_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/family_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/hobbies_interests_custom_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileSectionEditScreen extends ConsumerStatefulWidget {
  const ProfileSectionEditScreen({
    super.key,
    required this.section,
  });

  final ProfileEditSection section;

  @override
  ConsumerState<ProfileSectionEditScreen> createState() =>
      _ProfileSectionEditScreenState();
}

class _ProfileSectionEditScreenState
    extends ConsumerState<ProfileSectionEditScreen> {
  final PreferencesRepository _preferencesRepository = PreferencesRepository();
  final FamilyRepository _familyRepository = FamilyRepository();

  final TextEditingController _aboutController = TextEditingController();

  final TextEditingController _managedByController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _dietController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _healthInfoController = TextEditingController();
  final TextEditingController _disabilityController = TextEditingController();

  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _communityController = TextEditingController();
  final TextEditingController _subCommunityController = TextEditingController();
  final TextEditingController _motherTongueController = TextEditingController();

  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _fatherProfessionController =
      TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _motherProfessionController =
      TextEditingController();
  final TextEditingController _familyLocationController =
      TextEditingController();
  final TextEditingController _brothersController = TextEditingController();
  final TextEditingController _sistersController = TextEditingController();
  final TextEditingController _familyFinancialController =
      TextEditingController();

  final TextEditingController _highestQualificationController =
      TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _annualIncomeController = TextEditingController();
  final TextEditingController _workingWithController = TextEditingController();
  final TextEditingController _workingAsController = TextEditingController();
  final TextEditingController _employerController = TextEditingController();

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _residencyStatusController =
      TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _grewUpController = TextEditingController();

  final TextEditingController _prefAgeMinController = TextEditingController();
  final TextEditingController _prefAgeMaxController = TextEditingController();
  final TextEditingController _prefHeightMinController =
      TextEditingController();
  final TextEditingController _prefHeightMaxController =
      TextEditingController();
  final TextEditingController _prefReligionController = TextEditingController();
  final TextEditingController _prefCommunityController =
      TextEditingController();
  final TextEditingController _prefMotherTongueController =
      TextEditingController();
  final TextEditingController _prefMaritalController = TextEditingController();

  final TextEditingController _prefCountryController = TextEditingController();
  final TextEditingController _prefStateController = TextEditingController();
  final TextEditingController _prefCityController = TextEditingController();

  final TextEditingController _prefEducationController =
      TextEditingController();
  final TextEditingController _prefProfessionController =
      TextEditingController();
  final TextEditingController _prefWorkingAsController =
      TextEditingController();
  final TextEditingController _prefIncomeController = TextEditingController();

  final TextEditingController _prefProfileManagedByController =
      TextEditingController();
  final TextEditingController _prefDietController = TextEditingController();

  bool _isSaving = false;
  bool _didPrefill = false;

  late final List<SingleStringModel> _creativeOptions;
  late final List<SingleStringModel> _funOptions;
  late final List<SingleStringModel> _fitnessOptions;
  late final List<SingleStringModel> _otherOptions;

  @override
  void initState() {
    super.initState();
    _creativeOptions = _cloneOptions(creativeItemListDataInserted);
    _funOptions = _cloneOptions(funItemListDataInserted);
    _fitnessOptions = _cloneOptions(fitnessItemListDataInserted);
    _otherOptions = _cloneOptions(otherInterestsItemListDataInserted);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = ref.read(profileProvider);
      if (provider.profile == null) {
        await provider.getProfile();
      }
      if (!mounted) {
        return;
      }
      _prefill(provider.profile);
    });
  }

  @override
  void dispose() {
    for (final controller in _allControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> get _allControllers => [
        _aboutController,
        _managedByController,
        _genderController,
        _dobController,
        _maritalStatusController,
        _heightController,
        _dietController,
        _bloodGroupController,
        _healthInfoController,
        _disabilityController,
        _religionController,
        _communityController,
        _subCommunityController,
        _motherTongueController,
        _fatherNameController,
        _fatherProfessionController,
        _motherNameController,
        _motherProfessionController,
        _familyLocationController,
        _brothersController,
        _sistersController,
        _familyFinancialController,
        _highestQualificationController,
        _collegeController,
        _annualIncomeController,
        _workingWithController,
        _workingAsController,
        _employerController,
        _countryController,
        _stateController,
        _cityController,
        _residencyStatusController,
        _zipController,
        _grewUpController,
        _prefAgeMinController,
        _prefAgeMaxController,
        _prefHeightMinController,
        _prefHeightMaxController,
        _prefReligionController,
        _prefCommunityController,
        _prefMotherTongueController,
        _prefMaritalController,
        _prefCountryController,
        _prefStateController,
        _prefCityController,
        _prefEducationController,
        _prefProfessionController,
        _prefWorkingAsController,
        _prefIncomeController,
        _prefProfileManagedByController,
        _prefDietController,
      ];

  @override
  Widget build(BuildContext context) {
    return TransparentLoading(
      isLoading: _isSaving,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CustomBackAppBar(
                title: Text(widget.section.title),
                backIconBackground: AppColors.transparent,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                  child: _buildSectionBody(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: BottomBorderedWidget(
          widget: PrimaryButtons(
            buttonStyle: ButtonsStyle.activePrimaryButton,
            title: 'Save Changes',
            onTap: _handleSave,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildSectionBody() {
    switch (widget.section) {
      case ProfileEditSection.aboutYourself:
        return _buildCard(
          children: [
            _field(
              label: 'About Myself',
              controller: _aboutController,
              maxLines: 7,
              minLines: 7,
              hintText: 'Write something about yourself',
            ),
          ],
        );
      case ProfileEditSection.basicDetails:
        return _buildCard(
          children: [
            _field(
              label: 'Profile Managed by',
              controller: _managedByController,
            ),
            _field(label: 'Gender', controller: _genderController),
            _field(
              label: 'Date of Birth',
              controller: _dobController,
              datePicker: true,
            ),
            _field(
              label: 'Marital Status',
              controller: _maritalStatusController,
            ),
            _field(
              label: 'Height (cm)',
              controller: _heightController,
              keyboardType: TextInputType.number,
            ),
            _field(label: 'Diet', controller: _dietController),
            _field(label: 'Blood Group', controller: _bloodGroupController),
            _field(
              label: 'Health Information',
              controller: _healthInfoController,
            ),
            _field(label: 'Any Disability', controller: _disabilityController),
          ],
        );
      case ProfileEditSection.religiousBackground:
        return _buildCard(
          children: [
            _field(label: 'Religion', controller: _religionController),
            _field(label: 'Community', controller: _communityController),
            _field(label: 'Sub Community', controller: _subCommunityController),
            _field(label: 'Mother Tongue', controller: _motherTongueController),
          ],
        );
      case ProfileEditSection.familyDetails:
        return _buildCard(
          children: [
            _field(label: 'Father Name', controller: _fatherNameController),
            _field(
              label: 'Father Profession',
              controller: _fatherProfessionController,
            ),
            _field(label: 'Mother Name', controller: _motherNameController),
            _field(
              label: 'Mother Profession',
              controller: _motherProfessionController,
            ),
            _field(
              label: 'Family Location',
              controller: _familyLocationController,
            ),
            _field(
              label: 'No. of Brothers',
              controller: _brothersController,
              keyboardType: TextInputType.number,
            ),
            _field(
              label: 'No. of Sisters',
              controller: _sistersController,
              keyboardType: TextInputType.number,
            ),
            _field(
              label: 'Family Financial Status',
              controller: _familyFinancialController,
            ),
          ],
        );
      case ProfileEditSection.educationCareer:
        return _buildCard(
          children: [
            _field(
              label: 'Highest Qualification',
              controller: _highestQualificationController,
            ),
            _field(label: 'College', controller: _collegeController),
            _field(label: 'Annual Income', controller: _annualIncomeController),
            _field(label: 'Working With', controller: _workingWithController),
            _field(label: 'Working As', controller: _workingAsController),
            _field(label: 'Employer Name', controller: _employerController),
          ],
        );
      case ProfileEditSection.location:
        return _buildCard(
          children: [
            _field(label: 'Current Country', controller: _countryController),
            _field(label: 'State of Residence', controller: _stateController),
            _field(label: 'Current City', controller: _cityController),
            _field(
              label: 'Residency Status',
              controller: _residencyStatusController,
            ),
            _field(label: 'Zip/Pin code', controller: _zipController),
            _field(label: 'Grew up in', controller: _grewUpController),
          ],
        );
      case ProfileEditSection.hobbiesInterests:
        return Column(
          children: [
            HobbiesInterestsCard(
              title: 'Creative',
              dataList: _creativeOptions,
              onItemTap: (index) => _toggleOption(_creativeOptions, index),
            ),
            const SizedBox(height: 10),
            HobbiesInterestsCard(
              title: 'Fun',
              dataList: _funOptions,
              onItemTap: (index) => _toggleOption(_funOptions, index),
            ),
            const SizedBox(height: 10),
            HobbiesInterestsCard(
              title: 'Fitness',
              dataList: _fitnessOptions,
              onItemTap: (index) => _toggleOption(_fitnessOptions, index),
            ),
            const SizedBox(height: 10),
            HobbiesInterestsCard(
              title: 'Other Interests',
              dataList: _otherOptions,
              onItemTap: (index) => _toggleOption(_otherOptions, index),
            ),
          ],
        );
      case ProfileEditSection.preferenceBasicInfo:
        return _buildCard(
          children: [
            _field(
              label: 'Preferred Age Min',
              controller: _prefAgeMinController,
              keyboardType: TextInputType.number,
            ),
            _field(
              label: 'Preferred Age Max',
              controller: _prefAgeMaxController,
              keyboardType: TextInputType.number,
            ),
            _field(
              label: 'Preferred Height Min (cm)',
              controller: _prefHeightMinController,
              keyboardType: TextInputType.number,
            ),
            _field(
              label: 'Preferred Height Max (cm)',
              controller: _prefHeightMaxController,
              keyboardType: TextInputType.number,
            ),
            _field(
              label: 'Religion (comma separated)',
              controller: _prefReligionController,
            ),
            _field(
              label: 'Community (comma separated)',
              controller: _prefCommunityController,
            ),
            _field(
              label: 'Mother Tongue (comma separated)',
              controller: _prefMotherTongueController,
            ),
            _field(
              label: 'Marital Status (comma separated)',
              controller: _prefMaritalController,
            ),
          ],
        );
      case ProfileEditSection.preferenceLocationDetails:
        return _buildCard(
          children: [
            _field(
              label: 'Preferred Countries (comma separated)',
              controller: _prefCountryController,
            ),
            _field(
              label: 'Preferred States (comma separated)',
              controller: _prefStateController,
            ),
            _field(
              label: 'Preferred Cities (comma separated)',
              controller: _prefCityController,
            ),
          ],
        );
      case ProfileEditSection.preferenceEducationCareer:
        return _buildCard(
          children: [
            _field(
              label: 'Education Preference (comma separated)',
              controller: _prefEducationController,
            ),
            _field(
              label: 'Profession Preference (comma separated)',
              controller: _prefProfessionController,
            ),
            _field(
              label: 'Working As Preference (comma separated)',
              controller: _prefWorkingAsController,
            ),
            _field(
              label: 'Annual Income Preference (comma separated)',
              controller: _prefIncomeController,
            ),
          ],
        );
      case ProfileEditSection.preferenceOtherDetails:
        return _buildCard(
          children: [
            _field(
              label: 'Profile Managed By (comma separated)',
              controller: _prefProfileManagedByController,
            ),
            _field(
              label: 'Diet Preference (comma separated)',
              controller: _prefDietController,
            ),
          ],
        );
    }
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withSpacing(children),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool datePicker = false,
    int minLines = 1,
    int maxLines = 1,
    String? hintText,
  }) {
    return PrimaryTextField(
      headLine: label,
      hintText: hintText ?? 'Enter $label',
      controller: controller,
      keyboardType: keyboardType,
      datePicker: datePicker,
      minLine: minLines,
      maxLine: maxLines,
      errorText: '',
      onTap: () {},
    );
  }

  List<Widget> _withSpacing(List<Widget> children) {
    final widgets = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      widgets.add(children[i]);
      if (i < children.length - 1) {
        widgets.add(const SizedBox(height: 10));
      }
    }
    return widgets;
  }

  Future<void> _handleSave() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final success = await _saveCurrentSection();

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    if (!success) {
      return;
    }

    await ref.read(profileProvider).getProfile();
    if (!mounted) {
      return;
    }

    await DialogUtils.showSuccessDialog(
      context: context,
      title: 'Saved Successfully',
      message: 'Your changes have been saved successfully.',
      buttonText: 'Close',
      autoClose: true,
      autoCloseDuration: const Duration(seconds: 2),
      onClose: () {
        if (context.mounted) {
          context.pop(true);
        }
      },
    );
  }

  Future<bool> _saveCurrentSection() async {
    switch (widget.section) {
      case ProfileEditSection.aboutYourself:
        return _updateWithUniversal(
          fields: {
            'bio': _toTrimmedOrNull(_aboutController),
          },
          fallbackMessage: 'Failed to update about section',
        );
      case ProfileEditSection.basicDetails:
        return _updateWithUniversal(
          fields: {
            'profileManagedBy': _toTrimmedOrNull(_managedByController),
            'gender': _toTrimmedOrNull(_genderController),
            'dateOfBirth': _toTrimmedOrNull(_dobController),
            'maritalStatus': _toTrimmedOrNull(_maritalStatusController),
            'height': _toIntOrNull(_heightController),
            'diet': _toTrimmedOrNull(_dietController),
            'bloodGroup': _toTrimmedOrNull(_bloodGroupController),
            'healthDetails': _toTrimmedOrNull(_healthInfoController),
            'specialCases': _toTrimmedOrNull(_disabilityController),
          },
          fallbackMessage: 'Failed to update basic details',
        );
      case ProfileEditSection.religiousBackground:
        return _updateWithUniversal(
          fields: {
            'religionName': _toTrimmedOrNull(_religionController),
            'community': _toTrimmedOrNull(_communityController),
            'religiousBackground': _toTrimmedOrNull(_subCommunityController),
            'motherTongue': _toTrimmedOrNull(_motherTongueController),
          },
          fallbackMessage: 'Failed to update religious background',
        );
      case ProfileEditSection.familyDetails:
        final body = UpdateFamilyRequestBody(
          fatherName: _toTrimmedOrNull(_fatherNameController),
          fatherProfession: _toTrimmedOrNull(_fatherProfessionController),
          motherName: _toTrimmedOrNull(_motherNameController),
          motherProfession: _toTrimmedOrNull(_motherProfessionController),
          familyLocation: _toTrimmedOrNull(_familyLocationController),
          brothers: _toIntOrNull(_brothersController),
          sisters: _toIntOrNull(_sistersController),
          familyEconomicCondition: _toTrimmedOrNull(_familyFinancialController),
        );

        if (body.toJson().isEmpty) {
          return true;
        }

        final response = await _familyRepository.updateFamily(body);
        if ((response.code ?? '').toUpperCase() == 'SUCCESS') {
          return true;
        }

        await _showError(
          response.message ?? 'Failed to update family details',
        );
        return false;
      case ProfileEditSection.educationCareer:
        return _updateWithUniversal(
          fields: {
            'highestLevelOfEducation':
                _toTrimmedOrNull(_highestQualificationController),
            'institutionName': _toTrimmedOrNull(_collegeController),
            'incomeRange': _toTrimmedOrNull(_annualIncomeController),
            'workWith': _toTrimmedOrNull(_workingWithController),
            'workingAs': _toTrimmedOrNull(_workingAsController),
            'currentCompany': _toTrimmedOrNull(_employerController),
          },
          fallbackMessage: 'Failed to update education and career details',
        );
      case ProfileEditSection.location:
        return _updateWithUniversal(
          fields: {
            'livingIn': _toTrimmedOrNull(_countryController),
            'state': _toTrimmedOrNull(_stateController),
            'cityName': _toTrimmedOrNull(_cityController),
            'residencyStatus': _toTrimmedOrNull(_residencyStatusController),
            'zipCode': _toTrimmedOrNull(_zipController),
            'grewUpIn': _toTrimmedOrNull(_grewUpController),
          },
          fallbackMessage: 'Failed to update location details',
        );
      case ProfileEditSection.hobbiesInterests:
        final response = await ProfileRepository.updateProfileByEndpoint(
          endpoint: AppUrls.updateProfileInterests,
          body: UpdateProfileSectionRequestBody(
            fields: {
              'creativePursuits': _selectedValues(_creativeOptions),
              'outdoorActivities': _selectedValues(_funOptions),
              'fitnessAndSports': _selectedValues(_fitnessOptions),
              'mediaAndLearning': _selectedValues(_otherOptions),
            },
          ),
        );

        if (response.isSuccess) {
          return true;
        }

        await _showError(response.message ?? 'Failed to update hobbies');
        return false;
      case ProfileEditSection.preferenceBasicInfo:
        return _updatePreferences(
          body: UpdatePreferencesRequestBody(
            ageMin: _toIntOrNull(_prefAgeMinController),
            ageMax: _toIntOrNull(_prefAgeMaxController),
            heightMin: _toIntOrNull(_prefHeightMinController),
            heightMax: _toIntOrNull(_prefHeightMaxController),
            religionPreference: _toCsvListOrNull(_prefReligionController),
            communityPreference: _toCsvListOrNull(_prefCommunityController),
            motherTonguePreference:
                _toCsvListOrNull(_prefMotherTongueController),
            maritalStatusPreference: _toCsvListOrNull(_prefMaritalController),
          ),
          fallbackMessage: 'Failed to update preference basic details',
        );
      case ProfileEditSection.preferenceLocationDetails:
        return _updatePreferences(
          body: UpdatePreferencesRequestBody(
            preferredCountries: _toCsvListOrNull(_prefCountryController),
            preferredStates: _toCsvListOrNull(_prefStateController),
            preferredCities: _toCsvListOrNull(_prefCityController),
          ),
          fallbackMessage: 'Failed to update preference location details',
        );
      case ProfileEditSection.preferenceEducationCareer:
        return _updatePreferences(
          body: UpdatePreferencesRequestBody(
            educationPreference: _toCsvListOrNull(_prefEducationController),
            professionPreference: _toCsvListOrNull(_prefProfessionController),
            workingAsPreference: _toCsvListOrNull(_prefWorkingAsController),
            annualIncomePreference: _toCsvListOrNull(_prefIncomeController),
          ),
          fallbackMessage:
              'Failed to update preference education and career details',
        );
      case ProfileEditSection.preferenceOtherDetails:
        return _updatePreferences(
          body: UpdatePreferencesRequestBody(
            profileManagedByPreference:
                _toCsvListOrNull(_prefProfileManagedByController),
            dietPreference: _toCsvListOrNull(_prefDietController),
          ),
          fallbackMessage: 'Failed to update preference other details',
        );
    }
  }

  Future<bool> _updatePreferences({
    required UpdatePreferencesRequestBody body,
    required String fallbackMessage,
  }) async {
    if (body.toJson().isEmpty) {
      return true;
    }

    final response = await _preferencesRepository.updatePreferences(body);
    if ((response.code ?? '').toUpperCase() == 'SUCCESS') {
      return true;
    }

    await _showError(response.message ?? fallbackMessage);
    return false;
  }

  Future<bool> _updateWithUniversal({
    required Map<String, dynamic> fields,
    required String fallbackMessage,
  }) async {
    final response = await ProfileRepository.updateUniversalProfile(
      UpdateProfileSectionRequestBody(fields: fields),
    );

    if (response.isSuccess) {
      return true;
    }

    await _showError(response.message ?? fallbackMessage);
    return false;
  }

  Future<void> _showError(String message) async {
    await DialogUtils.showErrorDialog(
      context: context,
      message: message,
    );
  }

  void _prefill(CompleteProfile? profile) {
    if (_didPrefill) {
      return;
    }
    _didPrefill = true;

    final profileData = profile?.profile;
    final appearance = profile?.appearance;
    final family = profile?.family;
    final religion = profile?.religion;
    final lifestyle = profile?.lifestyle;
    final location = _firstOrNull(profile?.locations);
    final education = _firstOrNull(profile?.educations);
    final profession = _firstOrNull(profile?.profession);
    final preferences = profile?.preferences;
    final interest = profile?.interest;

    _aboutController.text = profileData?.bio ?? '';

    _managedByController.text = profileData?.profileManagedBy ?? '';
    _genderController.text = profileData?.gender ?? '';
    _dobController.text = _normalizeDate(profileData?.dateOfBirth);
    _maritalStatusController.text = profileData?.maritalStatus ?? '';
    _heightController.text = appearance?.height?.toString() ?? '';
    _dietController.text = lifestyle?.dietType ?? '';
    _bloodGroupController.text = appearance?.bloodGroup?.toString() ?? '';
    _healthInfoController.text = _firstNonEmpty(
      appearance?.healthDetails?.toString(),
      appearance?.healthCondition?.toString(),
    );
    _disabilityController.text = appearance?.specialCases?.toString() ?? '';

    _religionController.text =
        _firstNonEmpty(religion?.religion, profileData?.religionName);
    _communityController.text = religion?.community ?? '';
    _subCommunityController.text = religion?.religiousBackground ?? '';
    _motherTongueController.text = profileData?.motherTongue ?? '';

    _fatherNameController.text = family?.fatherName ?? '';
    _fatherProfessionController.text = family?.fatherProfession ?? '';
    _motherNameController.text = family?.motherName ?? '';
    _motherProfessionController.text = family?.motherProfession ?? '';
    _familyLocationController.text = family?.familyLocation ?? '';
    _brothersController.text = family?.brothers?.toString() ?? '';
    _sistersController.text = family?.sisters?.toString() ?? '';
    _familyFinancialController.text = family?.familyEconomicCondition ?? '';

    _highestQualificationController.text = _firstNonEmpty(
      education?.qualification?.toString(),
      education?.educationLevel?.toString(),
    );
    _collegeController.text = education?.institutionName?.toString() ?? '';
    _annualIncomeController.text = profession?.incomeRange ?? '';
    _workingWithController.text = profession?.employmentType?.toString() ?? '';
    _workingAsController.text = _firstNonEmpty(
      profession?.designation,
      profession?.profession?.toString(),
    );
    _employerController.text = profession?.employer ?? '';

    _countryController.text = location?.country ?? '';
    _stateController.text = location?.state?.toString() ?? '';
    _cityController.text = location?.city ?? '';
    _residencyStatusController.text = location?.residencyStatus ?? '';
    _zipController.text = location?.zipCode?.toString() ?? '';
    _grewUpController.text = location?.grewUpIn?.toString() ?? '';

    _setSelectedValues(_creativeOptions, interest?.creativePursuits);
    _setSelectedValues(_funOptions, interest?.outdoorActivities);
    _setSelectedValues(_fitnessOptions, interest?.fitnessAndSports);
    _setSelectedValues(
      _otherOptions,
      [
        ...?interest?.mediaAndLearning,
        ...?interest?.foodAndCuisine,
        ...?interest?.travelAndLeisure,
      ],
    );

    _prefAgeMinController.text = preferences?.ageMin?.toString() ?? '';
    _prefAgeMaxController.text = preferences?.ageMax?.toString() ?? '';
    _prefHeightMinController.text = preferences?.heightMin?.toString() ?? '';
    _prefHeightMaxController.text = preferences?.heightMax?.toString() ?? '';
    _prefReligionController.text = _toCsv(preferences?.religionPreference);
    _prefCommunityController.text = _toCsv(preferences?.communityPreference);
    _prefMotherTongueController.text =
        _toCsv(preferences?.motherTonguePreference);
    _prefMaritalController.text = _toCsv(preferences?.maritalStatusPreference);

    _prefCountryController.text = _toCsv(preferences?.preferredCountries);
    _prefStateController.text = _toCsv(preferences?.preferredStates);
    _prefCityController.text = _toCsv(preferences?.preferredCities);

    _prefEducationController.text = _toCsv(preferences?.educationPreference);
    _prefProfessionController.text = _toCsv(preferences?.professionPreference);
    _prefWorkingAsController.text = _toCsv(preferences?.workingAsPreference);
    _prefIncomeController.text = _toCsv(preferences?.annualIncomePreference);

    _prefProfileManagedByController.text =
        _toCsv(preferences?.profileManagedByPreference);
    _prefDietController.text = _toCsv(preferences?.dietPreference);

    setState(() {});
  }

  void _toggleOption(List<SingleStringModel> list, int index) {
    setState(() {
      list[index].isSelected = !list[index].isSelected;
    });
  }

  List<SingleStringModel> _cloneOptions(List<SingleStringModel> source) {
    return source
        .map((item) => item.copyWith(isSelected: false))
        .toList(growable: false);
  }

  void _setSelectedValues(
    List<SingleStringModel> options,
    List<String>? selected,
  ) {
    final normalized = selected
            ?.map((item) => item.trim().toLowerCase())
            .where((item) => item.isNotEmpty)
            .toSet() ??
        <String>{};

    for (final option in options) {
      option.isSelected = normalized.contains(option.name.trim().toLowerCase());
    }
  }

  List<String>? _selectedValues(List<SingleStringModel> options) {
    final values = options
        .where((option) => option.isSelected)
        .map((option) => option.name.trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);

    if (values.isEmpty) {
      return null;
    }
    return values;
  }

  String? _toTrimmedOrNull(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) {
      return null;
    }
    return value;
  }

  int? _toIntOrNull(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) {
      return null;
    }
    return int.tryParse(value);
  }

  List<String>? _toCsvListOrNull(TextEditingController controller) {
    final raw = controller.text.trim();
    if (raw.isEmpty) {
      return null;
    }

    final values = raw
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);

    if (values.isEmpty) {
      return null;
    }
    return values;
  }

  T? _firstOrNull<T>(List<T>? list) {
    if (list == null || list.isEmpty) {
      return null;
    }
    return list.first;
  }

  String _toCsv(List<String>? values) {
    if (values == null || values.isEmpty) {
      return '';
    }
    return values.join(', ');
  }

  String _normalizeDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value;
    }
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    return '${parsed.year}-$month-$day';
  }

  String _firstNonEmpty(String? first, String? second) {
    final normalizedFirst = first?.trim() ?? '';
    if (normalizedFirst.isNotEmpty) {
      return normalizedFirst;
    }
    return second?.trim() ?? '';
  }
}

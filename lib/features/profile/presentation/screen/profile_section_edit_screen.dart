import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/enums/enums.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/paginated_search_picker_sheet.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
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
import 'package:flutter_boilerplate/features/registration/data/models/lookup_option.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/update_family_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/family_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/lookup_repository.dart';
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
  static final Map<String, String> _familyEconomicConditionAliases =
      <String, String>{
    for (final condition in RegistrationFamilyEconomicCondition.values)
      condition.label.toLowerCase(): condition.apiValue,
    'elite': RegistrationFamilyEconomicCondition.eliteClass.apiValue,
    'elite class': RegistrationFamilyEconomicCondition.eliteClass.apiValue,
    'high': RegistrationFamilyEconomicCondition.upperClass.apiValue,
    'upper class': RegistrationFamilyEconomicCondition.upperClass.apiValue,
    'middle': RegistrationFamilyEconomicCondition.middleClass.apiValue,
    'middle class': RegistrationFamilyEconomicCondition.middleClass.apiValue,
    'middle_class': RegistrationFamilyEconomicCondition.middleClass.apiValue,
    'aspiring': RegistrationFamilyEconomicCondition.lowerMiddleClass.apiValue,
    'lower middle class':
        RegistrationFamilyEconomicCondition.lowerMiddleClass.apiValue,
  };

  static const List<LookupOption> _religionOptions = <LookupOption>[
    LookupOption(key: 'islam', label: 'Islam'),
    LookupOption(key: 'hinduism', label: 'Hinduism'),
    LookupOption(key: 'christianity', label: 'Christianity'),
    LookupOption(key: 'buddhism', label: 'Buddhism'),
    LookupOption(key: 'others', label: 'Others'),
  ];

  final PreferencesRepository _preferencesRepository = PreferencesRepository();
  final FamilyRepository _familyRepository = FamilyRepository();
  final LookupRepository _lookupRepository = LookupRepository();

  List<LookupOption> _educationLevelOptions = <LookupOption>[];
  List<LookupOption> _professionOptions = <LookupOption>[];
  List<LookupOption> _incomeRangeOptions = <LookupOption>[];
  List<LookupOption> _communityOptions = <LookupOption>[];
  List<LookupOption> _healthInfoOptions = <LookupOption>[];

  static final List<int> _heightInchOptions = List<int>.generate(
    33,
    (index) => 51 + index,
  );

  final Map<String, String> _selectedApiValues = <String, String>{};

  final TextEditingController _aboutController = TextEditingController();

  final TextEditingController _managedByController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _maritalStatusController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _heightDisplayController = TextEditingController();
  final TextEditingController _dietController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _healthInfoController = TextEditingController();
  final TextEditingController _disabilityController = TextEditingController();

  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _communityController = TextEditingController();
  final TextEditingController _subCommunityController = TextEditingController();
  final TextEditingController _motherTongueController = TextEditingController();
  final TextEditingController _grewUpInController = TextEditingController();

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

  List<SingleStringModel> _creativeOptions = <SingleStringModel>[];
  List<SingleStringModel> _funOptions = <SingleStringModel>[];
  List<SingleStringModel> _fitnessOptions = <SingleStringModel>[];
  List<SingleStringModel> _otherOptions = <SingleStringModel>[];

  bool _isLookupLoading = false;

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
        await provider.getProfile(context);
      }
      if (!mounted) {
        return;
      }
      await _loadLookupsForSection();
      if (!mounted) {
        return;
      }
      _prefill(provider.profile);
    });
  }

  Future<void> _loadLookupsForSection() async {
    final futures = <Future<void>>[];

    switch (widget.section) {
      case ProfileEditSection.basicDetails:
        futures.add(_loadBasicDetailsLookups());
        break;
      case ProfileEditSection.educationCareer:
        futures.add(_loadEducationLevelLookup());
        futures.add(_loadProfessionAndIncomeLookup());
        break;
      case ProfileEditSection.hobbiesInterests:
        futures.add(_loadHobbyLookups());
        break;
      default:
        break;
    }

    if (futures.isEmpty) {
      return;
    }

    setState(() => _isLookupLoading = true);
    try {
      await Future.wait(futures);
    } catch (_) {
      // Silent fallback: dropdowns will show whatever data was loaded successfully.
    } finally {
      if (mounted) {
        setState(() => _isLookupLoading = false);
      }
    }
  }

  Future<void> _loadBasicDetailsLookups() async {
    if (_healthInfoOptions.isNotEmpty) return;
    final options =
        await _lookupRepository.getLookups(LookupCategory.healthInformation);
    if (!mounted) return;
    _healthInfoOptions = options;
  }

  Future<void> _loadEducationLevelLookup() async {
    if (_educationLevelOptions.isNotEmpty) return;
    final options =
        await _lookupRepository.getLookups(LookupCategory.educationLevels);
    if (!mounted) return;
    _educationLevelOptions = options;
  }

  Future<void> _loadProfessionAndIncomeLookup() async {
    if (_professionOptions.isNotEmpty && _incomeRangeOptions.isNotEmpty) return;
    final results = await Future.wait<List<LookupOption>>([
      _lookupRepository.getLookups(LookupCategory.professions),
      _lookupRepository.getLookups(LookupCategory.incomeRange),
    ]);
    if (!mounted) return;
    _professionOptions = results[0];
    _incomeRangeOptions = results[1];
  }

  Future<void> _loadHobbyLookups() async {
    final results = await Future.wait<List<LookupOption>>([
      _lookupRepository.getLookups(LookupCategory.creativePursuits),
      _lookupRepository.getLookups(LookupCategory.outdoorActivities),
      _lookupRepository.getLookups(LookupCategory.fitnessAndSports),
      _lookupRepository.getLookups(LookupCategory.mediaAndLearning),
      _lookupRepository.getLookups(LookupCategory.foodAndCuisine),
      _lookupRepository.getLookups(LookupCategory.travelAndLeisure),
    ]);
    if (!mounted) return;

    final creative = _lookupToSingleStrings(results[0]);
    final fun = _lookupToSingleStrings(results[1]);
    final fitness = _lookupToSingleStrings(results[2]);
    final other = <SingleStringModel>[
      ..._lookupToSingleStrings(results[3]),
      ..._lookupToSingleStrings(results[4]),
      ..._lookupToSingleStrings(results[5]),
    ];

    if (creative.isNotEmpty) _creativeOptions = creative;
    if (fun.isNotEmpty) _funOptions = fun;
    if (fitness.isNotEmpty) _fitnessOptions = fitness;
    if (other.isNotEmpty) _otherOptions = other;
  }

  List<SingleStringModel> _lookupToSingleStrings(List<LookupOption> options) {
    return options
        .map(
          (option) => SingleStringModel(
            name: option.label,
            value: option.key,
          ),
        )
        .toList(growable: false);
  }

  Future<void> _loadCommunityOptionsForReligion(String? religionInput) async {
    final religionKey = _resolveLookupKey(
      _religionOptions,
      religionInput,
    );
    if (religionKey == null) {
      if (!mounted) return;
      setState(() {
        _communityOptions = <LookupOption>[];
      });
      return;
    }

    setState(() => _isLookupLoading = true);
    try {
      final options = await _lookupRepository.getLookupsBySlug(religionKey);
      if (!mounted) return;
      _communityOptions = options;
    } catch (_) {
      if (!mounted) return;
      _communityOptions = <LookupOption>[];
    } finally {
      if (mounted) {
        setState(() => _isLookupLoading = false);
      }
    }
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
        _heightDisplayController,
        _dietController,
        _bloodGroupController,
        _healthInfoController,
        _disabilityController,
        _religionController,
        _communityController,
        _subCommunityController,
        _motherTongueController,
        _grewUpInController,
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
      isLoading: _isSaving || _isLookupLoading,
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
            _enumDropdown<RegistrationProfileManagedBy>(
              label: 'Profile Managed by',
              controller: _managedByController,
              values: RegistrationProfileManagedBy.values,
              popupHeader: 'Select Profile Managed By',
              fieldKey: 'managedBy',
            ),
            _enumDropdown<Gender>(
              label: 'Gender',
              controller: _genderController,
              values: Gender.values,
              popupHeader: 'Select Gender',
              fieldKey: 'gender',
            ),
            _field(
              label: 'Date of Birth',
              controller: _dobController,
              datePicker: true,
            ),
            _enumDropdown<RegistrationMaritalStatus>(
              label: 'Marital Status',
              controller: _maritalStatusController,
              values: RegistrationMaritalStatus.values,
              popupHeader: 'Select Marital Status',
              fieldKey: 'maritalStatus',
            ),
            DropDownField(
              headLine: 'Height',
              hintText: 'Select Height',
              popUpHeader: 'Select Height',
              items: _heightDropdownItems,
              controller: _heightDisplayController,
              isSearch: true,
              onConfirm: (value) => _selectHeight(value?.toString()),
            ),
            PrimaryTextField(
              headLine: 'Grew up in',
              hintText: 'Select',
              controller: _grewUpInController,
              errorText: '',
              noPrefix: true,
              readOnly: true,
              onTap: _openGrewUpInCountryPicker,
              suffix: Icon(
                Icons.keyboard_arrow_down_outlined,
                size: TextSize.font20(context),
                color: AppColors.grey,
              ),
            ),
            _enumDropdown<RegistrationDiet>(
              label: 'Diet',
              controller: _dietController,
              values: RegistrationDiet.values,
              popupHeader: 'Select Diet',
              fieldKey: 'diet',
            ),
            _enumDropdown<BloodGroup>(
              label: 'Blood Group',
              controller: _bloodGroupController,
              values: BloodGroup.values,
              popupHeader: 'Select Blood Group',
              fieldKey: 'bloodGroup',
            ),
            _lookupDropdown(
              label: 'Health Information',
              controller: _healthInfoController,
              options: _healthInfoOptions,
              popupHeader: 'Select Health Information',
              fieldKey: 'healthDetails',
              onTap: _loadBasicDetailsLookups,
            ),
            _field(label: 'Any Disability', controller: _disabilityController),
          ],
        );
      case ProfileEditSection.religiousBackground:
        return _buildCard(
          children: [
            _lookupDropdown(
              label: 'Religion',
              controller: _religionController,
              options: _religionOptions,
              popupHeader: 'Select Religion',
              fieldKey: 'religion',
              onSelected: (_) {
                _communityController.clear();
                _selectedApiValues.remove('community');
                unawaited(
                  _loadCommunityOptionsForReligion(_religionController.text),
                );
              },
            ),
            _lookupDropdown(
              label: 'Community',
              controller: _communityController,
              options: _communityOptions,
              popupHeader: 'Select Community',
              fieldKey: 'community',
              onTap: () =>
                  _loadCommunityOptionsForReligion(_religionController.text),
            ),
            _field(label: 'Sub Community', controller: _subCommunityController),
            _field(label: 'Mother Tongue', controller: _motherTongueController),
          ],
        );
      case ProfileEditSection.familyDetails:
        return _buildCard(
          children: [
            _field(label: 'Father Name', controller: _fatherNameController),
            _singleStringDropdown(
              label: 'Father Profession',
              controller: _fatherProfessionController,
              options: fatherDetailsItemListDataInserted,
              popupHeader: 'Select Father Profession',
              fieldKey: 'fatherProfession',
            ),
            _field(label: 'Mother Name', controller: _motherNameController),
            _singleStringDropdown(
              label: 'Mother Profession',
              controller: _motherProfessionController,
              options: motherDetailsItemListDataInserted,
              popupHeader: 'Select Mother Profession',
              fieldKey: 'motherProfession',
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
              hintText: 'Select Family Financial Status',
              readOnly: true,
              onTap: _pickFamilyEconomicCondition,
            ),
          ],
        );
      case ProfileEditSection.educationCareer:
        return _buildCard(
          children: [
            _lookupDropdown(
              label: 'Highest Qualification',
              controller: _highestQualificationController,
              options: _educationLevelOptions,
              popupHeader: 'Select Highest Qualification',
              fieldKey: 'highestQualification',
              onTap: _loadEducationLevelLookup,
            ),
            _field(label: 'College', controller: _collegeController),
            _lookupDropdown(
              label: 'Annual Income',
              controller: _annualIncomeController,
              options: _incomeRangeOptions,
              popupHeader: 'Select Annual Income',
              fieldKey: 'annualIncome',
              onTap: _loadProfessionAndIncomeLookup,
            ),
            _singleStringDropdown(
              label: 'Working With',
              controller: _workingWithController,
              options: yourWorkListInserted,
              popupHeader: 'Select Working With',
              fieldKey: 'workingWith',
            ),
            _lookupDropdown(
              label: 'Working As',
              controller: _workingAsController,
              options: _professionOptions,
              popupHeader: 'Select Working As',
              fieldKey: 'workingAs',
              onTap: _loadProfessionAndIncomeLookup,
            ),
            _field(label: 'Employer Name', controller: _employerController),
          ],
        );
      case ProfileEditSection.location:
        return _buildCard(
          children: [
            _field(label: 'Current Country', controller: _countryController),
            _field(label: 'State of Residence', controller: _stateController),
            _field(label: 'Current City', controller: _cityController),
            _enumDropdown<ResidencyStatus>(
              label: 'Residency Status',
              controller: _residencyStatusController,
              values: ResidencyStatus.values,
              popupHeader: 'Select Residency Status',
              fieldKey: 'residencyStatus',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _withSpacing(children),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool datePicker = false,
    bool readOnly = false,
    int minLines = 1,
    int maxLines = 1,
    String? hintText,
    VoidCallback? onTap,
  }) {
    return PrimaryTextField(
      headLine: label,
      hintText: hintText ?? 'Enter $label',
      controller: controller,
      keyboardType: keyboardType,
      datePicker: datePicker,
      readOnly: readOnly,
      minLine: minLines,
      maxLine: maxLines,
      errorText: '',
      onTap: onTap ?? () {},
    );
  }

  Widget _enumDropdown<T extends ApiUiEnum>({
    required String label,
    required TextEditingController controller,
    required List<T> values,
    required String popupHeader,
    required String fieldKey,
  }) {
    final items = values.map((value) => value.label).toList(growable: false);
    return DropDownField(
      headLine: label,
      hintText: 'Select $label',
      popUpHeader: popupHeader,
      items: items,
      controller: controller,
      isSearch: false,
      onConfirm: (value) {
        final selected = value?.toString() ?? '';
        final match = _findEnumByLabelOrValue(values, selected);
        if (match != null) {
          _selectedApiValues[fieldKey] = match.apiValue;
        } else {
          _selectedApiValues.remove(fieldKey);
        }
      },
    );
  }

  Widget _lookupDropdown({
    required String label,
    required TextEditingController controller,
    required List<LookupOption> options,
    required String popupHeader,
    required String fieldKey,
    FutureOr<void> Function()? onTap,
    ValueChanged<LookupOption?>? onSelected,
  }) {
    final items = options.map((o) => o.label).toList(growable: false);
    return DropDownField(
      headLine: label,
      hintText: 'Select $label',
      popUpHeader: popupHeader,
      items: items,
      controller: controller,
      isSearch: true,
      onTap: onTap,
      onConfirm: (value) {
        final selected = value?.toString() ?? '';
        final match = _findLookupOption(options, selected);
        if (match != null) {
          _selectedApiValues[fieldKey] = match.key;
        } else {
          _selectedApiValues.remove(fieldKey);
        }
        onSelected?.call(match);
      },
    );
  }

  Widget _singleStringDropdown({
    required String label,
    required TextEditingController controller,
    required List<SingleStringModel> options,
    required String popupHeader,
    required String fieldKey,
  }) {
    final items = options.map((o) => o.name).toList(growable: false);
    return DropDownField(
      headLine: label,
      hintText: 'Select $label',
      popUpHeader: popupHeader,
      items: items,
      controller: controller,
      isSearch: false,
      onConfirm: (value) {
        final selected = value?.toString() ?? '';
        final match = options.firstWhere(
          (o) => o.name.toLowerCase() == selected.toLowerCase(),
          orElse: () => SingleStringModel(name: selected),
        );
        final apiValue = match.value;
        if (apiValue != null && apiValue.isNotEmpty) {
          _selectedApiValues[fieldKey] = apiValue;
        } else {
          _selectedApiValues.remove(fieldKey);
        }
      },
    );
  }

  LookupOption? _findLookupOption(List<LookupOption> options, String input) {
    final normalized = input.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    for (final option in options) {
      if (option.label.toLowerCase() == normalized ||
          option.key.toLowerCase() == normalized) {
        return option;
      }
    }
    return null;
  }

  String? _resolveLookupKey(List<LookupOption> options, String? input) {
    if (input == null) return null;
    return _findLookupOption(options, input)?.key;
  }

  T? _findEnumByLabelOrValue<T extends ApiUiEnum>(
    List<T> values,
    String? input,
  ) {
    final normalized = input?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) return null;
    for (final value in values) {
      if (value.apiValue.toLowerCase() == normalized ||
          value.label.toLowerCase() == normalized) {
        return value;
      }
    }
    return null;
  }

  Future<void> _openGrewUpInCountryPicker() async {
    final registration = ref.read(registrationProvider);
    await registration.loadCountryData(
      reset: registration.countryDropdownItems.isEmpty,
    );
    if (!mounted) return;

    final selectedCountry = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Grew Up In',
      searchHintText: 'Search country',
      items: registration.countryDropdownItems,
      isInitialLoading: registration.isCountryLoading &&
          registration.countryDropdownItems.isEmpty,
      isLoadingMore: registration.isCountryLoadingMore,
      hasMoreItems: registration.hasMoreCountries,
      initialQuery: registration.countrySearchQuery,
      emptyStateText: 'No countries found',
      onSearchChanged: registration.setCountrySearchQuery,
      onLoadMore: registration.loadMoreCountries,
    );

    if (!mounted ||
        selectedCountry == null ||
        selectedCountry.trim().isEmpty) {
      return;
    }

    setState(() {
      _grewUpInController.text = selectedCountry.trim();
      _selectedApiValues['grewUpIn'] = selectedCountry.trim();
    });
  }

  Future<void> _pickFamilyEconomicCondition() async {
    final currentValue = _resolveFamilyEconomicConditionValue(
      _familyFinancialController.text,
    );
    final selected =
        await showModalBottomSheet<RegistrationFamilyEconomicCondition>(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Family Financial Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...RegistrationFamilyEconomicCondition.values.map((condition) {
                final isSelected = currentValue == condition.apiValue;
                return ListTile(
                  title: Text(condition.label),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(condition),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _familyFinancialController.text = selected.label;
    });
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

    await ref.read(profileProvider).getProfile(context);
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
        return _saveBasicDetails();
      case ProfileEditSection.religiousBackground:
        return _updateWithUniversal(
          fields: {
            'religionName': _apiValueOrText('religion', _religionController),
            'community': _apiValueOrText('community', _communityController),
            'religiousBackground': _toTrimmedOrNull(_subCommunityController),
            'motherTongue': _toTrimmedOrNull(_motherTongueController),
          },
          fallbackMessage: 'Failed to update religious background',
        );
      case ProfileEditSection.familyDetails:
        final familyEconomicCondition = _resolveFamilyEconomicConditionValue(
          _familyFinancialController.text,
        );
        if (_familyFinancialController.text.trim().isNotEmpty &&
            familyEconomicCondition == null) {
          await _showError('Please select a valid family financial status.');
          return false;
        }

        final body = UpdateFamilyRequestBody(
          fatherName: _toTrimmedOrNull(_fatherNameController),
          fatherProfession:
              _apiValueOrText('fatherProfession', _fatherProfessionController),
          motherName: _toTrimmedOrNull(_motherNameController),
          motherProfession:
              _apiValueOrText('motherProfession', _motherProfessionController),
          familyLocation: _toTrimmedOrNull(_familyLocationController),
          brothers: _toIntOrNull(_brothersController),
          sisters: _toIntOrNull(_sistersController),
          familyEconomicCondition: familyEconomicCondition,
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
            'highestLevelOfEducation': _apiValueOrText(
              'highestQualification',
              _highestQualificationController,
            ),
            'institutionName': _toTrimmedOrNull(_collegeController),
            'incomeRange':
                _apiValueOrText('annualIncome', _annualIncomeController),
            'workWith': _apiValueOrText('workingWith', _workingWithController),
            'workingAs': _apiValueOrText('workingAs', _workingAsController),
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
            'residencyStatus': _apiValueOrText(
              'residencyStatus',
              _residencyStatusController,
            ),
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

  Future<bool> _saveBasicDetails() async {
    final universalSuccess = await _updateWithUniversal(
      fields: {
        'profileManagedBy': _apiValueOrText('managedBy', _managedByController),
        'gender': _apiValueOrText('gender', _genderController),
        'dateOfBirth': _toTrimmedOrNull(_dobController),
        'maritalStatus': _apiValueOrText('maritalStatus', _maritalStatusController),
        'height': _toIntOrNull(_heightController),
        'grewUpIn': _apiValueOrText('grewUpIn', _grewUpInController),
        'diet': _apiValueOrText('diet', _dietController),
        'bloodGroup': _apiValueOrText('bloodGroup', _bloodGroupController),
        'healthDetails': _apiValueOrText('healthDetails', _healthInfoController),
        'specialCases': _toTrimmedOrNull(_disabilityController),
      },
      fallbackMessage: 'Failed to update basic details',
    );

    if (!universalSuccess) {
      return false;
    }

    final grewUpInValue = _apiValueOrText('grewUpIn', _grewUpInController);
    if (grewUpInValue == null || grewUpInValue.isEmpty) {
      return true;
    }

    final response = await ProfileRepository.updateProfileByEndpoint(
      endpoint: AppUrls.updateProfileLocations,
      body: UpdateProfileSectionRequestBody(
        fields: {
          'grewUpIn': grewUpInValue,
        },
      ),
    );

    if (response.isSuccess) {
      return true;
    }

    await _showError(response.message ?? 'Failed to update grew up in');
    return false;
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

    _prefillEnum<RegistrationProfileManagedBy>(
      controller: _managedByController,
      raw: profileData?.profileManagedBy,
      values: RegistrationProfileManagedBy.values,
      fieldKey: 'managedBy',
    );
    _prefillEnum<Gender>(
      controller: _genderController,
      raw: profileData?.gender,
      values: Gender.values,
      fieldKey: 'gender',
    );
    _dobController.text = _normalizeDate(profileData?.dateOfBirth);
    _prefillEnum<RegistrationMaritalStatus>(
      controller: _maritalStatusController,
      raw: profileData?.maritalStatus,
      values: RegistrationMaritalStatus.values,
      fieldKey: 'maritalStatus',
    );
    _prefillHeight(appearance?.height);
    _prefillEnum<RegistrationDiet>(
      controller: _dietController,
      raw: lifestyle?.dietType,
      values: RegistrationDiet.values,
      fieldKey: 'diet',
    );
    _prefillEnum<BloodGroup>(
      controller: _bloodGroupController,
      raw: appearance?.bloodGroup?.toString(),
      values: BloodGroup.values,
      fieldKey: 'bloodGroup',
    );
    _prefillLookup(
      controller: _healthInfoController,
      raw: _firstNonEmpty(
        appearance?.healthDetails?.toString(),
        appearance?.healthCondition?.toString(),
      ),
      options: _healthInfoOptions,
      fieldKey: 'healthDetails',
    );
    _disabilityController.text = appearance?.specialCases?.toString() ?? '';

    _prefillLookup(
      controller: _religionController,
      raw: _firstNonEmpty(religion?.religion, profileData?.religionName),
      options: _religionOptions,
      fieldKey: 'religion',
    );
    _prefillLookup(
      controller: _communityController,
      raw: religion?.community,
      options: _communityOptions,
      fieldKey: 'community',
    );
    if (_religionController.text.isNotEmpty) {
      unawaited(_loadCommunityOptionsForReligion(_religionController.text));
    }
    _subCommunityController.text = religion?.religiousBackground ?? '';
    _motherTongueController.text = profileData?.motherTongue ?? '';
    final grewUpInValue = location?.grewUpIn?.toString().trim() ?? '';
    _grewUpInController.text = grewUpInValue;
    if (grewUpInValue.isEmpty) {
      _selectedApiValues.remove('grewUpIn');
    } else {
      _selectedApiValues['grewUpIn'] = grewUpInValue;
    }

    _fatherNameController.text = family?.fatherName ?? '';
    _prefillSingleString(
      controller: _fatherProfessionController,
      raw: family?.fatherProfession,
      options: fatherDetailsItemListDataInserted,
      fieldKey: 'fatherProfession',
    );
    _motherNameController.text = family?.motherName ?? '';
    _prefillSingleString(
      controller: _motherProfessionController,
      raw: family?.motherProfession,
      options: motherDetailsItemListDataInserted,
      fieldKey: 'motherProfession',
    );
    _familyLocationController.text = family?.familyLocation ?? '';
    _brothersController.text = family?.brothers?.toString() ?? '';
    _sistersController.text = family?.sisters?.toString() ?? '';
    _familyFinancialController.text =
        _familyEconomicConditionLabel(family?.familyEconomicCondition) ?? '';

    _prefillLookup(
      controller: _highestQualificationController,
      raw: _firstNonEmpty(
        education?.qualification?.toString(),
        education?.educationLevel?.toString(),
      ),
      options: _educationLevelOptions,
      fieldKey: 'highestQualification',
    );
    _collegeController.text = education?.institutionName?.toString() ?? '';
    _prefillLookup(
      controller: _annualIncomeController,
      raw: profession?.incomeRange,
      options: _incomeRangeOptions,
      fieldKey: 'annualIncome',
    );
    _prefillSingleString(
      controller: _workingWithController,
      raw: profession?.employmentType?.toString(),
      options: yourWorkListInserted,
      fieldKey: 'workingWith',
    );
    _prefillLookup(
      controller: _workingAsController,
      raw: _firstNonEmpty(
        profession?.designation,
        profession?.profession?.toString(),
      ),
      options: _professionOptions,
      fieldKey: 'workingAs',
    );
    _employerController.text = profession?.employer ?? '';

    _countryController.text = location?.country ?? '';
    _stateController.text = location?.state?.toString() ?? '';
    _cityController.text = location?.city ?? '';
    _prefillEnum<ResidencyStatus>(
      controller: _residencyStatusController,
      raw: location?.residencyStatus,
      values: ResidencyStatus.values,
      fieldKey: 'residencyStatus',
    );
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

  void _prefillEnum<T extends ApiUiEnum>({
    required TextEditingController controller,
    required String? raw,
    required List<T> values,
    required String fieldKey,
  }) {
    final match = _findEnumByLabelOrValue(values, raw);
    if (match != null) {
      controller.text = match.label;
      _selectedApiValues[fieldKey] = match.apiValue;
    } else {
      controller.text = raw?.trim() ?? '';
      _selectedApiValues.remove(fieldKey);
    }
  }

  void _prefillLookup({
    required TextEditingController controller,
    required String? raw,
    required List<LookupOption> options,
    required String fieldKey,
  }) {
    final match = _findLookupOption(options, raw ?? '');
    if (match != null) {
      controller.text = match.label;
      _selectedApiValues[fieldKey] = match.key;
    } else {
      controller.text = raw?.trim() ?? '';
      _selectedApiValues.remove(fieldKey);
    }
  }

  void _prefillSingleString({
    required TextEditingController controller,
    required String? raw,
    required List<SingleStringModel> options,
    required String fieldKey,
  }) {
    final normalized = raw?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      controller.text = '';
      _selectedApiValues.remove(fieldKey);
      return;
    }
    for (final option in options) {
      final matchesName = option.name.toLowerCase() == normalized;
      final matchesValue = option.value?.toLowerCase() == normalized;
      if (matchesName || matchesValue) {
        controller.text = option.name;
        final apiValue = option.value;
        if (apiValue != null && apiValue.isNotEmpty) {
          _selectedApiValues[fieldKey] = apiValue;
        } else {
          _selectedApiValues.remove(fieldKey);
        }
        return;
      }
    }
    controller.text = raw?.trim() ?? '';
    _selectedApiValues.remove(fieldKey);
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

  String? _apiValueOrText(String fieldKey, TextEditingController controller) {
    final tracked = _selectedApiValues[fieldKey]?.trim();
    if (tracked != null && tracked.isNotEmpty) {
      return tracked;
    }
    return _toTrimmedOrNull(controller);
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

  List<String> get _heightDropdownItems => _heightInchOptions
      .map((heightInches) => _formatHeightDisplay(heightInches))
      .toList(growable: false);

  void _selectHeight(String? displayValue) {
    final selectedValue = displayValue?.trim() ?? '';
    if (selectedValue.isEmpty) return;

    final heightInCm = _heightCmFromDisplay(selectedValue);
    if (heightInCm == null) return;

    _heightController.text = heightInCm.toString();
    _heightDisplayController.text = selectedValue;
  }

  void _prefillHeight(num? heightInCm) {
    if (heightInCm == null) {
      _heightController.text = '';
      _heightDisplayController.text = '';
      return;
    }
    final cmValue = heightInCm.round();
    _heightController.text = cmValue.toString();
    _heightDisplayController.text = _formatHeightDisplayFromCm(cmValue);
  }

  String _formatHeightDisplay(int totalInches) {
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return '$feet ft $inches in';
  }

  String _formatHeightDisplayFromCm(int cm) {
    final totalInches = (cm / 2.54).round();
    return _formatHeightDisplay(totalInches);
  }

  int? _heightCmFromDisplay(String displayValue) {
    final normalized = displayValue.trim().toLowerCase();
    final match = RegExp(r'^(\d+)\s*ft\s*(\d+)\s*in$').firstMatch(normalized);
    if (match == null) return null;
    final feet = int.tryParse(match.group(1)!);
    final inches = int.tryParse(match.group(2)!);
    if (feet == null || inches == null) return null;
    return (((feet * 12) + inches) * 2.54).round();
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

  String? _resolveFamilyEconomicConditionValue(String? rawValue) {
    final selected = rawValue?.trim() ?? '';
    if (selected.isEmpty) {
      return null;
    }

    final normalized = selected.toLowerCase();
    final candidate =
        _familyEconomicConditionAliases[normalized] ?? _toSnakeCase(selected);

    for (final condition in RegistrationFamilyEconomicCondition.values) {
      if (condition.apiValue == candidate) {
        return candidate;
      }
    }

    return null;
  }

  String? _familyEconomicConditionLabel(String? apiValue) {
    final normalized = apiValue?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    for (final condition in RegistrationFamilyEconomicCondition.values) {
      if (condition.apiValue == normalized) {
        return condition.label;
      }
    }

    return null;
  }

  String _toSnakeCase(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}

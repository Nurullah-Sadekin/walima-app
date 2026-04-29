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
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/profile/data/model/request/update_profile_section_request_body.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:flutter_boilerplate/features/profile/data/repository/profile_repository.dart';
import 'package:flutter_boilerplate/features/profile/presentation/screen/profile_edit_section.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/data/models/request/update_preferences_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/lookup_option.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/location_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/update_family_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/lookup_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/hobbies_interests_custom_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;

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

  final LookupRepository _lookupRepository = LookupRepository();
  final LocationDataRepositoryImpl _locationRepository =
      LocationDataRepositoryImpl();

  List<LookupOption> _educationLevelOptions = <LookupOption>[];
  List<LookupOption> _professionOptions = <LookupOption>[];
  List<LookupOption> _incomeRangeOptions = <LookupOption>[];
  List<LookupOption> _communityOptions = <LookupOption>[];
  List<LookupOption> _healthInfoOptions = <LookupOption>[];
  List<LookupOption> _motherTongueOptions = <LookupOption>[];
  List<LookupOption> _familyTypeOptions = <LookupOption>[];
  List<LookupOption> _familyValuesOptions = <LookupOption>[];
  List<LookupOption> _marriageTimelineOptions = <LookupOption>[];
  List<SingleStringModel> _languageOptions = <SingleStringModel>[];

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
  final TextEditingController _motherTongueController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _heightDisplayController = TextEditingController();
  final TextEditingController _dietController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _healthInfoController = TextEditingController();
  final TextEditingController _disabilityController = TextEditingController();

  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _communityController = TextEditingController();
  final TextEditingController _religiousBackgroundController = TextEditingController();
  final TextEditingController _grewUpInController = TextEditingController();

  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _fatherProfessionController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _motherProfessionController = TextEditingController();
  final TextEditingController _familyLocationController = TextEditingController();
  final TextEditingController _brothersController = TextEditingController();
  final TextEditingController _sistersController = TextEditingController();
  final TextEditingController _familyFinancialController = TextEditingController();
  final TextEditingController _familyTypeController = TextEditingController();
  final TextEditingController _familyValuesController = TextEditingController();
  final TextEditingController _aboutFamilyController = TextEditingController();
  final TextEditingController _marriageTimelineController = TextEditingController();

  final TextEditingController _highestQualificationController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _annualIncomeController = TextEditingController();
  final TextEditingController _workingWithController = TextEditingController();
  final TextEditingController _workingAsController = TextEditingController();
  final TextEditingController _employerController = TextEditingController();

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _residencyStatusController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _grewUpController = TextEditingController();

  final TextEditingController _prefAgeMinController = TextEditingController();
  final TextEditingController _prefAgeMaxController = TextEditingController();
  final TextEditingController _prefHeightMinController = TextEditingController();
  final TextEditingController _prefHeightMaxController = TextEditingController();
  final TextEditingController _prefReligionController = TextEditingController();
  final TextEditingController _prefCommunityController = TextEditingController();
  final TextEditingController _prefMotherTongueController = TextEditingController();
  final TextEditingController _prefMaritalController = TextEditingController();

  final TextEditingController _prefCountryController = TextEditingController();
  final TextEditingController _prefStateController = TextEditingController();
  final TextEditingController _prefCityController = TextEditingController();

  final TextEditingController _prefEducationController = TextEditingController();
  final TextEditingController _prefProfessionController = TextEditingController();
  final TextEditingController _prefWorkingAsController = TextEditingController();
  final TextEditingController _prefIncomeController = TextEditingController();

  final TextEditingController _prefProfileManagedByController = TextEditingController();
  final TextEditingController _prefDietController = TextEditingController();
  final TextEditingController _prefPartnerExpectationsController = TextEditingController();
  final TextEditingController _prefSmokingExpectationsController = TextEditingController();
  final TextEditingController _prefDrinkingExpectationsController = TextEditingController();

  bool _isSaving = false;
  bool _didPrefill = false;
  bool _didLoadFamilyLookups = false;

  List<SingleStringModel> _creativeOptions = <SingleStringModel>[];
  List<SingleStringModel> _funOptions = <SingleStringModel>[];
  List<SingleStringModel> _fitnessOptions = <SingleStringModel>[];
  List<SingleStringModel> _otherOptions = <SingleStringModel>[];
  List<SingleStringModel> _prefEducationOptions = <SingleStringModel>[];
  List<SingleStringModel> _prefWorkingAsOptions = <SingleStringModel>[];
  late List<SingleStringModel> _prefMaritalOptions;
  late List<SingleStringModel> _prefProfileManagedByOptions;
  late List<SingleStringModel> _prefDietOptions;

  bool _isLookupLoading = false;
  List<String> _countryDropdownItems = <String>[];
  List<String> _cityDropdownItems = <String>[];
  bool _isCountryLoading = false;
  bool _isCountryLoadingMore = false;
  bool _hasMoreCountries = false;
  bool _isCityLoading = false;
  bool _isCityLoadingMore = false;
  bool _hasMoreCities = false;
  int _countryPage = 1;
  int _cityPage = 1;
  String _countrySearchQuery = '';
  String _citySearchQuery = '';
  String? _selectedCityCountry;
  static const int _prefAgeMinLimit = 18;
  static const int _prefAgeMaxLimit = 70;
  static const int _prefHeightMinLimit = 120;
  static const int _prefHeightMaxLimit = 220;
  int _prefAgeStart = 25;
  int _prefAgeEnd = 35;
  int _prefHeightStart = 160;
  int _prefHeightEnd = 180;
  final List<String> _preferredCitySelections = <String>[];

  @override
  void initState() {
    super.initState();
    _creativeOptions = _cloneOptions(creativeItemListDataInserted);
    _funOptions = _cloneOptions(funItemListDataInserted);
    _fitnessOptions = _cloneOptions(fitnessItemListDataInserted);
    _otherOptions = _cloneOptions(otherInterestsItemListDataInserted);
    _prefMaritalOptions = RegistrationMaritalStatus.values
        .map(
          (item) => SingleStringModel(
            name: item.label,
            value: item.apiValue,
          ),
        )
        .toList(growable: false);
    _prefProfileManagedByOptions = RegistrationProfileManagedBy.values
        .map(
          (item) => SingleStringModel(
            name: item.label,
            value: item.apiValue,
          ),
        )
        .toList(growable: false);
    _prefDietOptions = _cloneOptions(dietDataListInserted);

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
      case ProfileEditSection.preferenceBasicInfo:
        futures.add(_loadPreferenceBasicInfoLookups());
        break;
      case ProfileEditSection.preferenceLocationDetails:
        futures.add(_loadPreferenceLocationLookups());
        break;
      case ProfileEditSection.preferenceEducationCareer:
        futures.add(_loadPreferenceEducationCareerLookups());
        break;
      case ProfileEditSection.preferenceOtherDetails:
        futures.add(_loadPreferenceOtherDetailLookups());
        break;
      case ProfileEditSection.educationCareer:
        futures.add(_loadEducationLevelLookup());
        futures.add(_loadProfessionAndIncomeLookup());
        break;
      case ProfileEditSection.familyDetails:
        futures.add(_loadFamilyLookups());
        break;
      case ProfileEditSection.location:
        futures.add(_loadLocationLookups());
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
    final tasks = <Future<void>>[];

    if (_healthInfoOptions.isEmpty) {
      tasks.add(() async {
        final options = await _lookupRepository
            .getLookups(LookupCategory.healthInformation);
        if (!mounted) return;
        _healthInfoOptions = options;
      }());
    }

    if (_motherTongueOptions.isEmpty || _languageOptions.isEmpty) {
      tasks.add(() async {
        final options = await _lookupRepository.getLookupsBySlug(
          'mother-tongue',
        );
        if (!mounted) return;
        if (_motherTongueOptions.isEmpty) {
          _motherTongueOptions = options;
        }
        if (_languageOptions.isEmpty) {
          _languageOptions = options
              .map(
                (option) => SingleStringModel(
                  name: option.label,
                  value: option.key,
                ),
              )
              .toList(growable: false);
        }
      }());
    }

    if (tasks.isEmpty) return;
    await Future.wait(tasks);
  }

  Future<void> _loadEducationLevelLookup() async {
    if (_educationLevelOptions.isNotEmpty) return;
    _educationLevelOptions = await _lookupRepository.getLookups(LookupCategory.educationLevels);
    if(_educationLevelOptions.isEmpty) _educationLevelOptions = EducationLevel.values.map((e) => LookupOption(key: e.apiValue, label: e.label)).toList(growable: false);
    if (!mounted) return;
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

  Future<void> _loadFamilyLookups() async {
    if (_didLoadFamilyLookups) return;
    _didLoadFamilyLookups = true;

    _familyTypeOptions = await _loadLookupByPrioritySlugs(
      slugs: const <String>[
        'family-type',
        'familyType',
        'family_type',
      ],
      fallback: _enumValuesToLookupOptions(FamilyType.values),
    );

    _familyValuesOptions = await _loadLookupByPrioritySlugs(
      slugs: const <String>[
        'family-values',
        'familyValues',
        'family_values',
      ],
      fallback: _enumValuesToLookupOptions(FamilyValues.values),
    );

    _marriageTimelineOptions = await _loadLookupByPrioritySlugs(
      slugs: const <String>[
        'marriage-timeline',
        'marriageTimeline',
        'marriage_time_line',
      ],
      fallback: const <LookupOption>[],
    );
  }

  Future<void> _loadLocationLookups() async {
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    final selectedCountry = _countryController.text.trim();
    if (selectedCountry.isNotEmpty) {
      await _syncCityOptionsForCountry(selectedCountry, reset: true);
    }
  }

  Future<void> _loadPreferenceBasicInfoLookups() async {
    await _loadBasicDetailsLookups();
    if (_prefReligionController.text.trim().isNotEmpty) {
      await _loadCommunityOptionsForReligion(_prefReligionController.text);
    }
  }

  Future<void> _loadPreferenceLocationLookups() async {
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    final selectedCountry = _prefCountryController.text.trim();
    if (selectedCountry.isNotEmpty) {
      await _syncCityOptionsForCountry(
        selectedCountry,
        reset: true,
        usePreferenceSelection: true,
      );
    }
  }

  Future<void> _loadPreferenceEducationCareerLookups() async {
    await _loadEducationLevelLookup();
    await _loadProfessionAndIncomeLookup();

    _prefEducationOptions = _educationLevelOptions
        .map(
          (option) => SingleStringModel(
            name: option.label,
            value: option.key,
          ),
        )
        .toList(growable: false);

    _prefWorkingAsOptions = _professionOptions
        .map(
          (option) => SingleStringModel(
            name: option.label,
            value: option.key,
          ),
        )
        .toList(growable: false);
  }

  Future<void> _loadPreferenceOtherDetailLookups() async {
    // Preference chips already come from local enums/static data.
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

  Future<List<LookupOption>> _loadLookupByPrioritySlugs({
    required List<String> slugs,
    required List<LookupOption> fallback,
  }) async {
    for (final slug in slugs) {
      try {
        final options = await _lookupRepository.getLookupsBySlug(slug);
        if (options.isNotEmpty) {
          return options;
        }
      } catch (_) {
        // Try next slug and fall back if none works.
      }
    }

    return fallback;
  }

  List<LookupOption> _enumValuesToLookupOptions<T extends ApiUiEnum>(
    Iterable<T> values,
  ) {
    return values
        .map(
          (value) => LookupOption(
            key: value.apiValue,
            label: value.label,
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

  Future<void> _syncPreferredCommunitySelection(String? rawCommunity) async {
    await _loadCommunityOptionsForReligion(_prefReligionController.text);
    if (!mounted) return;

    final normalized = rawCommunity?.trim();
    if (normalized == null || normalized.isEmpty) {
      return;
    }

    final match = _findLookupOption(_communityOptions, normalized);
    if (match == null) {
      setState(() {
        _selectedApiValues.remove('prefCommunity');
      });
      return;
    }

    setState(() {
      _prefCommunityController.text = match.label;
      _selectedApiValues['prefCommunity'] = match.key;
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
        _motherTongueController,
        _languagesController,
        _heightController,
        _heightDisplayController,
        _dietController,
        _bloodGroupController,
        _healthInfoController,
        _disabilityController,
        _religionController,
        _communityController,
        _religiousBackgroundController,
        _grewUpInController,
        _fatherNameController,
        _fatherProfessionController,
        _motherNameController,
        _motherProfessionController,
        _familyLocationController,
        _brothersController,
        _sistersController,
        _familyFinancialController,
        _familyTypeController,
        _familyValuesController,
        _aboutFamilyController,
        _marriageTimelineController,
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
        _prefPartnerExpectationsController,
        _prefDrinkingExpectationsController,
        _prefSmokingExpectationsController
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
            Row(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _field(
                    label: 'Date of Birth',
                    controller: _dobController,
                    datePicker: true,
                  ),
                ),
                Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                        color: AppColors.disableBackground,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.greyLight, width: 1)),
                    child: Text(
                      ageText(),
                      style: TextStyle(
                        fontSize: TextSize.font14(context),
                        fontWeight: FontWeight.w500,
                        color: _dobController.text.isNotEmpty
                            ? AppColors.textPrimaryLight
                            : AppColors.grey,
                      ),
                    ))
              ],
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
            _enumDropdown<RegistrationMaritalStatus>(
              label: 'Marital Status',
              controller: _maritalStatusController,
              values: RegistrationMaritalStatus.values,
              popupHeader: 'Select Marital Status',
              fieldKey: 'maritalStatus',
            ),

            PrimaryTextField(
              headLine: 'Grew up in',
              hintText: 'Select Country',
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
            _lookupDropdown(
              label: 'Mother Tongue',
              controller: _motherTongueController,
              options: _motherTongueOptions,
              popupHeader: 'Select Mother Tongue',
              fieldKey: 'motherTongue',
              onTap: _loadBasicDetailsLookups,
            ),
            _multiLookupField(
              label: 'Languages',
              controller: _languagesController,
              hintText: 'Select Languages',
              onTap: _openLanguagesPicker,
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
            _enumDropdown<ReligiousBackground>(
              label: 'Religious Background',
              controller: _religiousBackgroundController,
              values: ReligiousBackground.values,
              popupHeader: 'Select Religious Background',
              fieldKey: 'religiousBackground',
            ),
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
            _field(
              label: 'About Family',
              controller: _aboutFamilyController,
              minLines: 4,
              maxLines: 5,
              hintText: 'Write about your family',
            ),
            _lookupDropdown(
              label: 'Family Type',
              controller: _familyTypeController,
              options: _familyTypeOptions,
              popupHeader: 'Select Family Type',
              fieldKey: 'familyType',
              onTap: _loadFamilyLookups,
            ),
            _lookupDropdown(
              label: 'Family Values',
              controller: _familyValuesController,
              options: _familyValuesOptions,
              popupHeader: 'Select Family Values',
              fieldKey: 'familyValues',
              onTap: _loadFamilyLookups,
            ),
            if (_marriageTimelineOptions.isNotEmpty)
              _lookupDropdown(
                label: 'Marriage Timeline',
                controller: _marriageTimelineController,
                options: _marriageTimelineOptions,
                popupHeader: 'Select Marriage Timeline',
                fieldKey: 'marriageTimeline',
                onTap: _loadFamilyLookups,
              )
            else
              _field(
                label: 'Marriage Timeline',
                controller: _marriageTimelineController,
                hintText: 'Enter Marriage Timeline',
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
            _pickerField(
              label: 'Current Country',
              controller: _countryController,
              hintText: 'Select Country',
              onTap: _openCurrentCountryPicker,
            ),
            _field(label: 'State of Residence', controller: _stateController),
            _pickerField(
              label: 'Current City',
              controller: _cityController,
              hintText: _countryController.text.trim().isEmpty
                  ? 'Select Country First'
                  : 'Select City',
              enabled: _countryController.text.trim().isNotEmpty,
              onTap: _openCurrentCityPicker,
            ),
            _enumDropdown<ResidencyStatus>(
              label: 'Residency Status',
              controller: _residencyStatusController,
              values: ResidencyStatus.values,
              popupHeader: 'Select Residency Status',
              fieldKey: 'residencyStatus',
            ),
            _field(label: 'Zip/Pin code', controller: _zipController),
            _pickerField(
              label: 'Grew up in',
              controller: _grewUpController,
              hintText: 'Select Country',
              onTap: _openCurrentGrewUpCountryPicker,
            ),
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
            _rangeSelector(
              label: 'Age Range',
              startValue: _prefAgeStart,
              endValue: _prefAgeEnd,
              min: _prefAgeMinLimit,
              max: _prefAgeMaxLimit,
              startLabel: '$_prefAgeStart',
              endLabel: '$_prefAgeEnd',
              onChanged: _setPreferredAgeRange,
            ),
            _rangeSelector(
              label: 'Height Range',
              startValue: _prefHeightStart,
              endValue: _prefHeightEnd,
              min: _prefHeightMinLimit,
              max: _prefHeightMaxLimit,
              startLabel: _formatPreferenceHeight(_prefHeightStart),
              endLabel: _formatPreferenceHeight(_prefHeightEnd),
              onChanged: _setPreferredHeightRange,
            ),
            _multiSelectField(
              label: 'Marital Status',
              options: _prefMaritalOptions,
              onItemTap: (index) => _toggleOption(_prefMaritalOptions, index),
            ),
            _lookupDropdown(
              label: 'Religion',
              controller: _prefReligionController,
              options: _religionOptions,
              popupHeader: 'Select Religion',
              fieldKey: 'prefReligion',
              onSelected: (_) {
                _prefCommunityController.clear();
                _selectedApiValues.remove('prefCommunity');
                unawaited(
                  _loadCommunityOptionsForReligion(_prefReligionController.text),
                );
              },
            ),
            _lookupDropdown(
              label: 'Community',
              controller: _prefCommunityController,
              options: _communityOptions,
              popupHeader: 'Select Community',
              fieldKey: 'prefCommunity',
              onTap: () =>
                  _loadCommunityOptionsForReligion(_prefReligionController.text),
            ),
            _lookupDropdown(
              label: 'Mother Tongue',
              controller: _prefMotherTongueController,
              options: _motherTongueOptions,
              popupHeader: 'Select Mother Tongue',
              fieldKey: 'prefMotherTongue',
              onTap: _loadBasicDetailsLookups,
            ),
          ],
        );
      case ProfileEditSection.preferenceLocationDetails:
        return _buildCard(
          children: [
            _pickerField(
              label: 'Country Living In',
              controller: _prefCountryController,
              hintText: 'Select Country',
              onTap: _openPreferredCountryPicker,
            ),
            if (_prefCountryController.text.trim().isNotEmpty)
              _multiTextSelectionField(
                label: 'City',
                options: _cityDropdownItems,
                selectedValues: _preferredCitySelections,
                isLoading: _isCityLoading && _cityDropdownItems.isEmpty,
                isLoadingMore: _isCityLoadingMore,
                emptyText: 'No cities available for the selected country.',
                onItemTap: _togglePreferredCitySelection,
                onLoadMore: _hasMoreCities ? _loadMorePreferredCities : null,
              ),
          ],
        );
      case ProfileEditSection.preferenceEducationCareer:
        return _buildCard(
          children: [
            _multiSelectField(
              label: 'Education Qualification',
              options: _prefEducationOptions,
              onItemTap: (index) => _toggleOption(_prefEducationOptions, index),
            ),
            _multiSelectField(
              label: 'Working As',
              options: _prefWorkingAsOptions,
              onItemTap: (index) => _toggleOption(_prefWorkingAsOptions, index),
            ),
            _lookupDropdown(
              label: 'Profession',
              controller: _prefProfessionController,
              options: _professionOptions,
              popupHeader: 'Select Profession',
              fieldKey: 'prefProfession',
              onTap: _loadProfessionAndIncomeLookup,
            ),
            _lookupDropdown(
              label: 'Annual Income',
              controller: _prefIncomeController,
              options: _incomeRangeOptions,
              popupHeader: 'Select Annual Income',
              fieldKey: 'prefIncome',
              onTap: _loadProfessionAndIncomeLookup,
            ),
          ],
        );
      case ProfileEditSection.preferenceOtherDetails:
        return _buildCard(
          children: [
            _multiSelectField(
              label: 'Profile Managed By',
              options: _prefProfileManagedByOptions,
              onItemTap: (index) =>
                  _toggleOption(_prefProfileManagedByOptions, index),
            ),
            _multiSelectField(
              label: 'Diet Preference',
              options: _prefDietOptions,
              onItemTap: (index) => _toggleOption(_prefDietOptions, index),
            ),
            _field(
              label: 'Smoking',
              controller: _prefSmokingExpectationsController,
              hintText: 'expectation',
            ),
            _field(
              label: 'Drinking',
              controller: _prefDrinkingExpectationsController,

              hintText: 'expectation',
            ),
            _field(
              label: 'Partner Expectations',
              controller: _prefPartnerExpectationsController,
              maxLines: 5,
              minLines: 4,
              hintText: 'Write what you expect from your partner',
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

  Widget _multiLookupField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onTap,
  }) {
    return PrimaryTextField(
      headLine: label,
      hintText: hintText,
      controller: controller,
      readOnly: true,
      errorText: '',
      noPrefix: true,
      onTap: onTap,
      suffix: Icon(
        Icons.keyboard_arrow_down_outlined,
        size: TextSize.font20(context),
        color: AppColors.grey,
      ),
    );
  }

  Widget _pickerField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return PrimaryTextField(
      headLine: label,
      hintText: hintText,
      controller: controller,
      readOnly: true,
      enabled: enabled,
      errorText: '',
      noPrefix: true,
      onTap: onTap,
      suffix: Icon(
        Icons.keyboard_arrow_down_outlined,
        size: TextSize.font20(context),
        color: AppColors.grey,
      ),
    );
  }

  Widget _multiSelectField({
    required String label,
    required List<SingleStringModel> options,
    required ValueChanged<int> onItemTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(options.length, (index) {
            final item = options[index];
            return SelectionCard(
              buttonStyle: item.isSelected
                  ? SelectionStyle.selectedCheckbox
                  : SelectionStyle.unSelectedCheckbox,
              onTap: () => onItemTap(index),
              isSelected: item.isSelected,
              title: item.name,
            );
          }),
        ),
      ],
    );
  }

  Widget _rangeSelector({
    required String label,
    required int startValue,
    required int endValue,
    required int min,
    required int max,
    required String startLabel,
    required String endLabel,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        _StyledRangeSlider(
          values: RangeValues(startValue.toDouble(), endValue.toDouble()),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          startLabel: startLabel,
          endLabel: endLabel,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _multiTextSelectionField({
    required String label,
    required List<String> options,
    required List<String> selectedValues,
    required bool isLoading,
    required bool isLoadingMore,
    required String emptyText,
    required ValueChanged<String> onItemTap,
    VoidCallback? onLoadMore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (options.isEmpty)
          Text(
            emptyText,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font13(context),
              fontWeight: FontWeight.w400,
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((value) {
              final isSelected = selectedValues.any(
                (item) => item.toLowerCase() == value.toLowerCase(),
              );
              return SelectionCard(
                buttonStyle: isSelected
                    ? SelectionStyle.selectedCheckbox
                    : SelectionStyle.unSelectedCheckbox,
                onTap: () => onItemTap(value),
                isSelected: isSelected,
                title: value,
              );
            }).toList(growable: false),
          ),
        if (isLoadingMore)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (onLoadMore != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextButton(
              onPressed: onLoadMore,
              child: const Text('Load more'),
            ),
          ),
      ],
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
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    if (!mounted) return;

    final selectedCountry = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Grew Up In',
      searchHintText: 'Search country',
      items: _countryDropdownItems,
      isInitialLoading: _isCountryLoading && _countryDropdownItems.isEmpty,
      isLoadingMore: _isCountryLoadingMore,
      hasMoreItems: _hasMoreCountries,
      initialQuery: _countrySearchQuery,
      emptyStateText: 'No countries found',
      onSearchChanged: _setCountrySearchQuery,
      onLoadMore: _loadMoreCountries,
    );

    if (!mounted || selectedCountry == null || selectedCountry.trim().isEmpty) {
      return;
    }

    setState(() {
      _grewUpInController.text = selectedCountry.trim();
      _selectedApiValues['grewUpIn'] = selectedCountry.trim();
    });
  }

  Future<void> _openCurrentCountryPicker() async {
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    if (!mounted) return;

    final selectedCountry = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Current Country',
      searchHintText: 'Search country',
      items: _countryDropdownItems,
      isInitialLoading: _isCountryLoading && _countryDropdownItems.isEmpty,
      isLoadingMore: _isCountryLoadingMore,
      hasMoreItems: _hasMoreCountries,
      initialQuery: _countrySearchQuery,
      emptyStateText: 'No countries found',
      onSearchChanged: _setCountrySearchQuery,
      onLoadMore: _loadMoreCountries,
    );

    if (!mounted || selectedCountry == null || selectedCountry.trim().isEmpty) {
      return;
    }

    final normalizedCountry = selectedCountry.trim();
    final previousCountry = _countryController.text.trim();

    setState(() {
      _countryController.text = normalizedCountry;
      if (previousCountry.toLowerCase() != normalizedCountry.toLowerCase()) {
        _cityController.clear();
        _citySearchQuery = '';
      }
    });

    await _syncCityOptionsForCountry(normalizedCountry, reset: true);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openCurrentCityPicker() async {
    final selectedCountry = _countryController.text.trim();
    if (selectedCountry.isEmpty) {
      return;
    }

    await _syncCityOptionsForCountry(
      selectedCountry,
      reset: _cityDropdownItems.isEmpty ||
          _selectedCityCountry?.toLowerCase() != selectedCountry.toLowerCase(),
    );
    if (!mounted) return;

    final selectedCity = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Current City',
      searchHintText: 'Search city',
      items: _cityDropdownItems,
      isInitialLoading: _isCityLoading && _cityDropdownItems.isEmpty,
      isLoadingMore: _isCityLoadingMore,
      hasMoreItems: _hasMoreCities,
      initialQuery: _citySearchQuery,
      emptyStateText: 'No cities found',
      onSearchChanged: _setCitySearchQuery,
      onLoadMore: _loadMoreCities,
    );

    if (!mounted || selectedCity == null || selectedCity.trim().isEmpty) {
      return;
    }

    setState(() {
      _cityController.text = selectedCity.trim();
    });
  }

  Future<void> _openCurrentGrewUpCountryPicker() async {
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    if (!mounted) return;

    final selectedCountry = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Grew Up In',
      searchHintText: 'Search country',
      items: _countryDropdownItems,
      isInitialLoading: _isCountryLoading && _countryDropdownItems.isEmpty,
      isLoadingMore: _isCountryLoadingMore,
      hasMoreItems: _hasMoreCountries,
      initialQuery: _countrySearchQuery,
      emptyStateText: 'No countries found',
      onSearchChanged: _setCountrySearchQuery,
      onLoadMore: _loadMoreCountries,
    );

    if (!mounted || selectedCountry == null || selectedCountry.trim().isEmpty) {
      return;
    }

    setState(() {
      _grewUpController.text = selectedCountry.trim();
    });
  }

  Future<void> _openPreferredCountryPicker() async {
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    if (!mounted) return;

    final selectedCountry = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Preferable Country Living In',
      searchHintText: 'Search country',
      items: _countryDropdownItems,
      isInitialLoading: _isCountryLoading && _countryDropdownItems.isEmpty,
      isLoadingMore: _isCountryLoadingMore,
      hasMoreItems: _hasMoreCountries,
      initialQuery: _countrySearchQuery,
      emptyStateText: 'No countries found',
      onSearchChanged: _setCountrySearchQuery,
      onLoadMore: _loadMoreCountries,
    );

    if (!mounted || selectedCountry == null || selectedCountry.trim().isEmpty) {
      return;
    }

    final normalizedCountry = selectedCountry.trim();
    final previousCountry = _prefCountryController.text.trim();

    setState(() {
      _prefCountryController.text = normalizedCountry;
      if (previousCountry.toLowerCase() != normalizedCountry.toLowerCase()) {
        _preferredCitySelections.clear();
        _prefCityController.clear();
        _prefStateController.clear();
        _citySearchQuery = '';
      }
    });

    await _syncCityOptionsForCountry(
      normalizedCountry,
      reset: true,
      usePreferenceSelection: true,
    );
  }

  void _setPreferredAgeRange(RangeValues values) {
    setState(() {
      _prefAgeStart =
          values.start.round().clamp(_prefAgeMinLimit, _prefAgeMaxLimit);
      _prefAgeEnd =
          values.end.round().clamp(_prefAgeMinLimit, _prefAgeMaxLimit);
      if (_prefAgeStart > _prefAgeEnd) {
        final temp = _prefAgeStart;
        _prefAgeStart = _prefAgeEnd;
        _prefAgeEnd = temp;
      }
      _prefAgeMinController.text = _prefAgeStart.toString();
      _prefAgeMaxController.text = _prefAgeEnd.toString();
    });
  }

  void _setPreferredHeightRange(RangeValues values) {
    setState(() {
      _prefHeightStart = values.start
          .round()
          .clamp(_prefHeightMinLimit, _prefHeightMaxLimit);
      _prefHeightEnd = values.end
          .round()
          .clamp(_prefHeightMinLimit, _prefHeightMaxLimit);
      if (_prefHeightStart > _prefHeightEnd) {
        final temp = _prefHeightStart;
        _prefHeightStart = _prefHeightEnd;
        _prefHeightEnd = temp;
      }
      _prefHeightMinController.text = _prefHeightStart.toString();
      _prefHeightMaxController.text = _prefHeightEnd.toString();
    });
  }

  Future<void> _setCountrySearchQuery(String value) async {
    final normalized = value.trim();
    if (_countrySearchQuery == normalized) {
      return;
    }

    _countrySearchQuery = normalized;
    await _syncCountryOptions(reset: true);
  }

  Future<void> _setCitySearchQuery(String value) async {
    final normalized = value.trim();
    if (_citySearchQuery == normalized) {
      return;
    }

    _citySearchQuery = normalized;
    final selectedCountry = _countryController.text.trim();
    if (selectedCountry.isEmpty) {
      return;
    }
    await _syncCityOptionsForCountry(selectedCountry, reset: true);
  }

  Future<void> _loadMoreCountries() async {
    if (!_hasMoreCountries || _isCountryLoading || _isCountryLoadingMore) {
      return;
    }
    await _syncCountryOptions(reset: false);
  }

  Future<void> _loadMoreCities() async {
    final selectedCountry = _countryController.text.trim();
    if (selectedCountry.isEmpty ||
        !_hasMoreCities ||
        _isCityLoading ||
        _isCityLoadingMore) {
      return;
    }
    await _syncCityOptionsForCountry(selectedCountry, reset: false);
  }

  Future<void> _loadMorePreferredCities() async {
    final selectedCountry = _prefCountryController.text.trim();
    if (selectedCountry.isEmpty ||
        !_hasMoreCities ||
        _isCityLoading ||
        _isCityLoadingMore) {
      return;
    }
    await _syncCityOptionsForCountry(
      selectedCountry,
      reset: false,
      usePreferenceSelection: true,
    );
  }

  void _togglePreferredCitySelection(String cityName) {
    final normalized = cityName.trim();
    if (normalized.isEmpty) {
      return;
    }

    setState(() {
      final existingIndex = _preferredCitySelections.indexWhere(
        (item) => item.toLowerCase() == normalized.toLowerCase(),
      );
      if (existingIndex >= 0) {
        _preferredCitySelections.removeAt(existingIndex);
      } else {
        _preferredCitySelections.add(normalized);
      }
      _prefCityController.text = _preferredCitySelections.join(', ');
    });
  }

  Future<void> _syncCountryOptions({required bool reset}) async {
    try {
      if (reset) {
        _countryPage = 1;
        _hasMoreCountries = true;
        _countryDropdownItems = <String>[];
        _isCountryLoading = true;
        _isCountryLoadingMore = false;
      } else {
        _isCountryLoadingMore = true;
      }
      if (mounted) {
        setState(() {});
      }

      final result = await _locationRepository.getCountriesPage(
        page: _countryPage,
        keyword: _countrySearchQuery,
      );

      final merged =
          reset ? <String>[] : List<String>.from(_countryDropdownItems);
      for (final country in result.items) {
        if (!merged.any(
          (item) => item.toLowerCase() == country.name.toLowerCase(),
        )) {
          merged.add(country.name);
        }
      }

      _countryDropdownItems = merged;
      _hasMoreCountries = result.hasNextPage;
      if (_hasMoreCountries) {
        _countryPage++;
      }
    } catch (_) {
      if (reset) {
        _countryDropdownItems = <String>[];
      }
      _hasMoreCountries = false;
    } finally {
      _isCountryLoading = false;
      _isCountryLoadingMore = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _syncCityOptionsForCountry(
    String country, {
    required bool reset,
    bool usePreferenceSelection = false,
  }) async {
    final normalizedCountry = country.trim();
    if (normalizedCountry.isEmpty) {
      _cityDropdownItems = <String>[];
      _hasMoreCities = false;
      _selectedCityCountry = null;
      _cityPage = 1;
      if (mounted) {
        setState(() {});
      }
      return;
    }

    try {
      final shouldReset = reset ||
          _selectedCityCountry?.toLowerCase() !=
              normalizedCountry.toLowerCase();

      if (shouldReset) {
        _selectedCityCountry = normalizedCountry;
        _cityPage = 1;
        _hasMoreCities = true;
        _cityDropdownItems = <String>[];
        _isCityLoading = true;
        _isCityLoadingMore = false;
      } else {
        _isCityLoadingMore = true;
      }
      if (mounted) {
        setState(() {});
      }

      final result = await _locationRepository.getCitiesByCountryPage(
        country: normalizedCountry,
        page: _cityPage,
        keyword: _citySearchQuery,
      );

      final merged =
          shouldReset ? <String>[] : List<String>.from(_cityDropdownItems);
      for (final city in result.items) {
        if (!merged.any((item) => item.toLowerCase() == city.toLowerCase())) {
          merged.add(city);
        }
      }

      _cityDropdownItems = merged;
      _hasMoreCities = result.hasNextPage;
      if (_hasMoreCities) {
        _cityPage++;
      }
    } catch (_) {
      if (reset) {
        _cityDropdownItems = <String>[];
      }
      _hasMoreCities = false;
    } finally {
      _isCityLoading = false;
      _isCityLoadingMore = false;
      if (_cityController.text.trim().isNotEmpty) {
        if (!usePreferenceSelection) {
          final selectedCity = _cityController.text.trim().toLowerCase();
          final exists = _cityDropdownItems.any(
            (item) => item.toLowerCase() == selectedCity,
          );
          if (!exists) {
            _cityController.clear();
          }
        }
      }

      if (usePreferenceSelection) {
        _preferredCitySelections.removeWhere(
          (city) => !_cityDropdownItems.any(
            (item) => item.toLowerCase() == city.toLowerCase(),
          ),
        );
        _prefCityController.text = _preferredCitySelections.join(', ');
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _openLanguagesPicker() async {
    if (_languageOptions.isEmpty) {
      setState(() => _isLookupLoading = true);
      try {
        await _loadBasicDetailsLookups();
      } finally {
        if (mounted) {
          setState(() => _isLookupLoading = false);
        }
      }
    }

    if (!mounted || _languageOptions.isEmpty) return;

    final draftOptions = _languageOptions
        .map((item) => item.copyWith(isSelected: item.isSelected))
        .toList(growable: false);

    final selectedOptions = await showModalBottomSheet<List<SingleStringModel>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Select Languages',
                            style: TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontSize: TextSize.font18(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(draftOptions.length, (index) {
                            final item = draftOptions[index];
                            return SelectionCard(
                              buttonStyle: item.isSelected
                                  ? SelectionStyle.selectedCheckbox
                                  : SelectionStyle.unSelectedCheckbox,
                              onTap: () {
                                setModalState(() {
                                  draftOptions[index].isSelected =
                                      !draftOptions[index].isSelected;
                                });
                              },
                              isSelected: item.isSelected,
                              title: item.name,
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pop(draftOptions),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (!mounted || selectedOptions == null) return;

    setState(() {
      _languageOptions = selectedOptions;
      _languagesController.text = _selectedDisplayValues(_languageOptions);
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
    final profileSnapshot = ref.read(profileProvider).profile;
    final primaryLocation = _firstOrNull(profileSnapshot?.locations);
    final primaryEducation = _firstOrNull(profileSnapshot?.educations);
    final primaryProfession = _firstOrNull(profileSnapshot?.profession);

    switch (widget.section) {
      case ProfileEditSection.aboutYourself:
        return _updateWithUniversal(
          fields: {
            'profile': <String, dynamic>{
              'bio': _toTrimmedOrNull(_aboutController),
            },
          },
          fallbackMessage: 'Failed to update about section',
        );
      case ProfileEditSection.basicDetails:
        return _saveBasicDetails(
          existingLocationId: primaryLocation?.id,
          existingLocationType: primaryLocation?.locationType,
        );
      case ProfileEditSection.religiousBackground:
        final religionValue = _apiValueOrText('religion', _religionController);
        return _updateWithUniversal(
          fields: {
            'profile': <String, dynamic>{
              'religionName': religionValue,
            },
            'religion': <String, dynamic>{
              'religion': religionValue,
              'community': _apiValueOrText('community', _communityController),
              'religiousBackground': _apiValueOrText(
                'religiousBackground',
                _religiousBackgroundController,
              ),
            },
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
          familyType: _apiValueOrText('familyType', _familyTypeController),
          familyValues:
              _apiValueOrText('familyValues', _familyValuesController),
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
          aboutFamily: _toTrimmedOrNull(_aboutFamilyController),
          marriageTimeline:
              _apiValueOrText('marriageTimeline', _marriageTimelineController),
        );

        return _updateWithUniversal(
          fields: {
            'family': body.toJson(),
          },
          fallbackMessage: 'Failed to update family details',
        );
      case ProfileEditSection.educationCareer:
        final educationPayload = _buildRecordPayload(
          id: primaryEducation?.id,
          fields: <String, dynamic>{
            'qualification': _apiValueOrText(
              'highestQualification',
              _highestQualificationController,
            ),
            'educationLevel': _apiValueOrText(
              'highestQualification',
              _highestQualificationController,
            ),

            'institutionName': _toTrimmedOrNull(_collegeController),
          },
        );
        final professionPayload = _buildRecordPayload(
          id: primaryProfession?.id,
          fields: <String, dynamic>{
            'incomeRange': _apiValueOrText(
              'annualIncome',
              _annualIncomeController,
            ),
            'employmentType': _apiValueOrText(
              'workingWith',
              _workingWithController,
            ),
            'designation': _apiValueOrText('workingAs', _workingAsController),
            'profession': _apiValueOrText('workingAs', _workingAsController),
            'employer': _toTrimmedOrNull(_employerController),
          },
        );
        return _updateWithUniversal(
          fields: {
            if (educationPayload != null)
              'educations': <Map<String, dynamic>>[
                educationPayload,
              ],
            if (professionPayload != null)
              'professions': <Map<String, dynamic>>[
                professionPayload,
              ],
          },
          fallbackMessage: 'Failed to update education and career details',
        );
      case ProfileEditSection.location:
        final locationType =
            _resolveLocationType(primaryLocation?.locationType);
        final locationPayload = _buildRecordPayload(
          id: primaryLocation?.id,
          fields: <String, dynamic>{
            'locationType': locationType,
            'country': _toTrimmedOrNull(_countryController),
            'state': _toTrimmedOrNull(_stateController),
            'city': _toTrimmedOrNull(_cityController),
            'residencyStatus': _apiValueOrText(
              'residencyStatus',
              _residencyStatusController,
            ),
            'zipCode': _toTrimmedOrNull(_zipController),
            'grewUpIn': _toTrimmedOrNull(_grewUpController),
          },
        );
        return _updateWithUniversal(
          fields: {
            if (locationPayload != null)
              'locations': <Map<String, dynamic>>[
                locationPayload,
              ],
          },
          fallbackMessage: 'Failed to update location details',
        );
      case ProfileEditSection.hobbiesInterests:
        return _updateWithUniversal(
          fields: {
            'interests': {
              'creativePursuits': _selectedValues(_creativeOptions),
              'outdoorActivities': _selectedValues(_funOptions),
              'fitnessAndSports': _selectedValues(_fitnessOptions),
              'mediaAndLearning': _selectedValues(_otherOptions),
            },
          },
          fallbackMessage: 'Failed to update hobbies',
        );
      case ProfileEditSection.preferenceBasicInfo:
        return _updateWithUniversal(
          fields: {
            'preferences': UpdatePreferencesRequestBody(
              ageMin: _prefAgeStart,
              ageMax: _prefAgeEnd,
              heightMin: _prefHeightStart,
              heightMax: _prefHeightEnd,
              religionPreference: _singlePreferenceList(
                _prefReligionController,
                fieldKey: 'prefReligion',
              ),
              communityPreference: _singlePreferenceList(
                _prefCommunityController,
                fieldKey: 'prefCommunity',
              ),
              motherTonguePreference: _singlePreferenceList(
                _prefMotherTongueController,
                fieldKey: 'prefMotherTongue',
              ),
              maritalStatusPreference:
                  _selectedApiValuesOrNames(_prefMaritalOptions),
            ).toJson(),
          },
          fallbackMessage: 'Failed to update preference basic details',
        );
      case ProfileEditSection.preferenceLocationDetails:
        return _updateWithUniversal(
          fields: {
            'preferences': UpdatePreferencesRequestBody(
              preferredCountries: _singlePreferenceList(_prefCountryController),
              preferredStates: _toCsvListOrNull(_prefStateController),
              preferredCities:
                  _preferredCitySelections.isEmpty
                      ? _toCsvListOrNull(_prefCityController)
                      : List<String>.from(_preferredCitySelections),
            ).toJson(),
          },
          fallbackMessage: 'Failed to update preference location details',
        );
      case ProfileEditSection.preferenceEducationCareer:
        return _updateWithUniversal(
          fields: {
            'preferences': UpdatePreferencesRequestBody(
              educationPreference:
                  _selectedApiValuesOrNames(_prefEducationOptions),
              professionPreference: _singlePreferenceList(
                _prefProfessionController,
                fieldKey: 'prefProfession',
              ),
              workingAsPreference:
                  _selectedApiValuesOrNames(_prefWorkingAsOptions),
              annualIncomePreference: _singlePreferenceList(
                _prefIncomeController,
                fieldKey: 'prefIncome',
              ),
            ).toJson(),
          },
          fallbackMessage:
              'Failed to update preference education and career details',
        );
      case ProfileEditSection.preferenceOtherDetails:
        return _updateWithUniversal(
          fields: {
            'preferences': UpdatePreferencesRequestBody(
              profileManagedByPreference: _selectedApiValuesOrNames(_prefProfileManagedByOptions),
              dietPreference: _selectedApiValuesOrNames(_prefDietOptions),
              expectationsFromLifePartner: _toTrimmedOrNull(_prefPartnerExpectationsController),
              drinkingPreference: [_prefDrinkingExpectationsController.text],
              smokingPreference:   [ _prefSmokingExpectationsController.text],

            ).toJson(),
          },
          fallbackMessage: 'Failed to update preference other details',
        );
    }
  }

  Future<bool> _saveBasicDetails({
    String? existingLocationId,
    String? existingLocationType,
  }) async {
    final locationType = _resolveLocationType(existingLocationType);
    final locationPayload = _buildRecordPayload(
      id: existingLocationId,
      fields: <String, dynamic>{
        'locationType': locationType,
        'grewUpIn': _apiValueOrText('grewUpIn', _grewUpInController),
      },
    );

    return _updateWithUniversal(
      fields: {
        'profile': <String, dynamic>{
          'profileManagedBy':
              _apiValueOrText('managedBy', _managedByController),
          'gender': _apiValueOrText('gender', _genderController),
          'dateOfBirth': _toTrimmedOrNull(_dobController),
          'maritalStatus':
              _apiValueOrText('maritalStatus', _maritalStatusController),
          'motherTongue': _apiValueOrText(
            'motherTongue',
            _motherTongueController,
          ),
          'languages': _selectedApiValuesOrNames(_languageOptions),
        },
        'appearance': <String, dynamic>{
          'height': _toIntOrNull(_heightController),
          'bloodGroup': _apiValueOrText('bloodGroup', _bloodGroupController),
          'healthDetails':
              _apiValueOrText('healthDetails', _healthInfoController),
          'specialCases': _toTrimmedOrNull(_disabilityController),
        },
        'lifestyle': <String, dynamic>{
          'dietType': _apiValueOrText('diet', _dietController),
        },
        if (locationPayload != null)
          'locations': <Map<String, dynamic>>[
            locationPayload,
          ],
      },
      fallbackMessage: 'Failed to update basic details',
    );
  }

  Map<String, dynamic>? _buildRecordPayload({
    String? id,
    required Map<String, dynamic> fields,
  }) {
    final payload = UpdateProfileSectionRequestBody(fields: fields).toJson();
    if (payload.isEmpty) {
      return null;
    }
    final normalizedId = id?.trim();
    if (normalizedId != null && normalizedId.isNotEmpty) {
      payload['id'] = normalizedId;
    }
    return payload;
  }

  String _resolveLocationType(String? value) {
    final normalized = value?.trim().toLowerCase();
    if (normalized == 'present' || normalized == 'permanent') {
      return normalized!;
    }
    return 'present';
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
    _prefillLookup(
      controller: _motherTongueController,
      raw: profileData?.motherTongue,
      options: _motherTongueOptions,
      fieldKey: 'motherTongue',
    );
    _setSelectedValues(
      _languageOptions,
      profileData?.languages
          ?.map((value) => value.toString())
          .toList(growable: false),
    );
    _languagesController.text = _selectedDisplayValues(_languageOptions);
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
    _prefillEnum<ReligiousBackground>(
      controller: _religiousBackgroundController,
      raw: religion?.religiousBackground,
      values: ReligiousBackground.values,
      fieldKey: 'religiousBackground',
    );
    final grewUpInValue = location?.grewUpIn?.toString().trim() ?? '';
    _grewUpInController.text = grewUpInValue;
    if (grewUpInValue.isEmpty) {
      _selectedApiValues.remove('grewUpIn');
    } else {
      _selectedApiValues['grewUpIn'] = grewUpInValue;
    }

    _fatherNameController.text = family?.fatherName ?? '';
    _prefillLookup(
      controller: _familyTypeController,
      raw: family?.familyType,
      options: _familyTypeOptions,
      fieldKey: 'familyType',
    );
    _prefillLookup(
      controller: _familyValuesController,
      raw: family?.familyValues,
      options: _familyValuesOptions,
      fieldKey: 'familyValues',
    );
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
    _aboutFamilyController.text = family?.aboutFamily ?? '';
    if (_marriageTimelineOptions.isNotEmpty) {
      _prefillLookup(
        controller: _marriageTimelineController,
        raw: family?.marriageTimeline?.toString(),
        options: _marriageTimelineOptions,
        fieldKey: 'marriageTimeline',
      );
    } else {
      _marriageTimelineController.text =
          family?.marriageTimeline?.toString() ?? '';
      _selectedApiValues.remove('marriageTimeline');
    }

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

    _prefAgeStart = (preferences?.ageMin ?? _prefAgeStart)
        .clamp(_prefAgeMinLimit, _prefAgeMaxLimit);
    _prefAgeEnd = (preferences?.ageMax ?? _prefAgeEnd)
        .clamp(_prefAgeMinLimit, _prefAgeMaxLimit);
    if (_prefAgeStart > _prefAgeEnd) {
      final temp = _prefAgeStart;
      _prefAgeStart = _prefAgeEnd;
      _prefAgeEnd = temp;
    }
    _prefAgeMinController.text = _prefAgeStart.toString();
    _prefAgeMaxController.text = _prefAgeEnd.toString();
    _prefHeightStart = (preferences?.heightMin ?? _prefHeightStart)
        .clamp(_prefHeightMinLimit, _prefHeightMaxLimit);
    _prefHeightEnd = (preferences?.heightMax ?? _prefHeightEnd)
        .clamp(_prefHeightMinLimit, _prefHeightMaxLimit);
    if (_prefHeightStart > _prefHeightEnd) {
      final temp = _prefHeightStart;
      _prefHeightStart = _prefHeightEnd;
      _prefHeightEnd = temp;
    }
    _prefHeightMinController.text = _prefHeightStart.toString();
    _prefHeightMaxController.text = _prefHeightEnd.toString();
    _prefillLookup(
      controller: _prefReligionController,
      raw: _firstOrNull(preferences?.religionPreference),
      options: _religionOptions,
      fieldKey: 'prefReligion',
    );
    _prefCommunityController.text =
        _firstOrNull(preferences?.communityPreference)?.trim() ?? '';
    _selectedApiValues.remove('prefCommunity');
    if (_prefReligionController.text.trim().isNotEmpty &&
        _prefCommunityController.text.trim().isNotEmpty) {
      unawaited(
        _syncPreferredCommunitySelection(_prefCommunityController.text),
      );
    }
    _prefillLookup(
      controller: _prefMotherTongueController,
      raw: _firstOrNull(preferences?.motherTonguePreference),
      options: _motherTongueOptions,
      fieldKey: 'prefMotherTongue',
    );
    _setSelectedValues(
      _prefMaritalOptions,
      preferences?.maritalStatusPreference,
    );
    _prefMaritalController.text = _selectedDisplayValues(_prefMaritalOptions);

    _prefCountryController.text =
        _firstOrNull(preferences?.preferredCountries)?.trim() ?? '';
    _prefStateController.text = _toCsv(preferences?.preferredStates);
    _preferredCitySelections
      ..clear()
      ..addAll(preferences?.preferredCities ?? const <String>[]);
    _prefCityController.text = _preferredCitySelections.join(', ');
    if (_prefCountryController.text.trim().isNotEmpty) {
      unawaited(
        _syncCityOptionsForCountry(
          _prefCountryController.text,
          reset: true,
          usePreferenceSelection: true,
        ),
      );
    }

    _setSelectedValues(_prefEducationOptions, preferences?.educationPreference);
    _prefEducationController.text = _selectedDisplayValues(_prefEducationOptions);
    _prefillLookup(
      controller: _prefProfessionController,
      raw: _firstOrNull(preferences?.professionPreference),
      options: _professionOptions,
      fieldKey: 'prefProfession',
    );
    _setSelectedValues(_prefWorkingAsOptions, preferences?.workingAsPreference);
    _prefWorkingAsController.text = _selectedDisplayValues(_prefWorkingAsOptions);
    _prefillLookup(
      controller: _prefIncomeController,
      raw: _firstOrNull(preferences?.annualIncomePreference),
      options: _incomeRangeOptions,
      fieldKey: 'prefIncome',
    );

    _prefProfileManagedByController.text =
        _toCsv(preferences?.profileManagedByPreference);
    _prefDietController.text = _toCsv(preferences?.dietPreference);
    _prefPartnerExpectationsController.text = _firstNonEmpty(
      preferences?.expectationsFromLifePartner,
      preferences?.partnerExpectations?.toString(),
    );
    _setSelectedValues(
      _prefProfileManagedByOptions,
      preferences?.profileManagedByPreference,
    );
    _setSelectedValues(_prefDietOptions, preferences?.dietPreference);
    _prefSmokingExpectationsController.text = (preferences?.smokingPreference ?? []).join(', ');
    _prefDrinkingExpectationsController.text = (preferences?.drinkingPreference ?? []).join(', ');
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
      final normalizedName = option.name.trim().toLowerCase();
      final normalizedValue = option.value?.trim().toLowerCase();
      option.isSelected = normalized.contains(normalizedName) ||
          (normalizedValue != null && normalized.contains(normalizedValue));
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

  List<String>? _selectedApiValuesOrNames(List<SingleStringModel> options) {
    final values = options
        .where((option) => option.isSelected)
        .map((option) {
          final apiValue = option.value?.trim();
          if (apiValue != null && apiValue.isNotEmpty) {
            return apiValue;
          }
          return option.name.trim();
        })
        .where((value) => value.isNotEmpty)
        .toList(growable: false);

    if (values.isEmpty) {
      return null;
    }
    return values;
  }

  List<String>? _singlePreferenceList(
    TextEditingController controller, {
    String? fieldKey,
  }) {
    final tracked =
        fieldKey == null ? null : _selectedApiValues[fieldKey]?.trim();
    if (tracked != null && tracked.isNotEmpty) {
      return <String>[tracked];
    }

    final value = controller.text.trim();
    if (value.isEmpty) {
      return null;
    }
    return <String>[value];
  }

  String _selectedDisplayValues(List<SingleStringModel> options) {
    final values = options
        .where((option) => option.isSelected)
        .map((option) => option.name.trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
    if (values.isEmpty) return '';
    return values.join(', ');
  }

  String _formatPreferenceHeight(int heightCm) {
    final totalInches = (heightCm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet' $inches\"";
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

  String ageText() {
    final txt = _dobController.text;
    if (txt.isEmpty) return '0 Year Age';

    DateTime? dob;
    try {
      dob = DateTime.tryParse(txt);
      dob ??= DateFormat('yyyy-MM-dd').parseLoose(txt);
    } catch (_) {
      dob = null;
    }

    if (dob == null) return '0 Year Age';

    final now = DateTime.now();
    int years = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    if (years < 0) years = 0;
    return '$years years old'.replaceFirst('\u007f', '');
  }

}

class _StyledRangeSlider extends StatelessWidget {
  const _StyledRangeSlider({
    required this.values,
    required this.min,
    required this.max,
    required this.startLabel,
    required this.endLabel,
    required this.onChanged,
    this.divisions,
  });

  final RangeValues values;
  final double min;
  final double max;
  final int? divisions;
  final String startLabel;
  final String endLabel;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 20.0;
    const thumbDiameter = 22.0;
    const sliderTop = 34.0;
    final availableWidth =
        MediaQuery.of(context).size.width - 40 - (horizontalPadding * 2);
    final startFactor = ((values.start - min) / (max - min)).clamp(0.0, 1.0);
    final endFactor = ((values.end - min) / (max - min)).clamp(0.0, 1.0);
    final startLeft = (availableWidth * startFactor) - 22;
    final endLeft = (availableWidth * endFactor) - 22;

    return SizedBox(
      height: 74,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: horizontalPadding + startLeft,
            top: 0,
            child: IgnorePointer(
              child: _SliderBubble(label: startLabel),
            ),
          ),
          Positioned(
            left: horizontalPadding + endLeft,
            top: 0,
            child: IgnorePointer(
              child: _SliderBubble(label: endLabel),
            ),
          ),
          Positioned.fill(
            top: sliderTop,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: const Color(0xFFF0F0F0),
                overlayShape: SliderComponentShape.noOverlay,
                rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                thumbColor: Colors.white,
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
                rangeThumbShape: const _RingRangeThumbShape(
                  thumbRadius: thumbDiameter / 2,
                ),
              ),
              child: RangeSlider(
                values: values,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderBubble extends StatelessWidget {
  const _SliderBubble({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ),
        CustomPaint(
          size: const Size(18, 10),
          painter: _BubblePointerPainter(),
        ),
      ],
    );
  }
}

class _BubblePointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RingRangeThumbShape extends RangeSliderThumbShape {
  const _RingRangeThumbShape({required this.thumbRadius});

  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        bool isDiscrete = false,
        bool isEnabled = false,
        bool isOnTop = false,
        required SliderThemeData sliderTheme,
        TextDirection textDirection = TextDirection.ltr,
        Thumb thumb = Thumb.start,
        bool isPressed = false,
      }) {
    final canvas = context.canvas;
    final outerPaint = Paint()..color = Colors.white;
    final innerPaint = Paint()..color = AppColors.primary;

    canvas.drawCircle(center, thumbRadius, outerPaint);
    canvas.drawCircle(center, thumbRadius - 7, innerPaint);
  }
}

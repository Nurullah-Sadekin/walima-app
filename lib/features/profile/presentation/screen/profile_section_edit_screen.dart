import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/enums/enums.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/paginated_search_picker_sheet.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:walima_llc/features/home/data/model/response/profile_strength_response.dart';
import 'package:walima_llc/features/profile/data/model/request/update_profile_section_request_body.dart';
import 'package:walima_llc/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:walima_llc/features/profile/domain/model/profile_section_edit_ui_model.dart';
import 'package:walima_llc/features/profile/domain/repository/profile_section_edit_domain_repository.dart';
import 'package:walima_llc/features/profile/domain/usecase/profile_section_field_key_usecase.dart';
import 'package:walima_llc/features/profile/domain/usecase/profile_section_lookup_slug_candidates_usecase.dart';
import 'package:walima_llc/features/profile/domain/usecase/profile_section_profile_value_usecase.dart';
import 'package:walima_llc/features/profile/domain/usecase/profile_section_strength_fields_usecase.dart';
import 'package:walima_llc/features/profile/presentation/screen/profile_edit_section.dart';
import 'package:walima_llc/features/profile/presentation/screen/profile_section_edit_ui_state.dart';
import 'package:walima_llc/features/recommended_preferences/data/models/request/update_preferences_request_body.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';
import 'package:walima_llc/features/registration/data/repository/location_data_repository_impl.dart';
import 'package:walima_llc/features/registration/data/models/request/update_family_request_body.dart';
import 'package:walima_llc/features/registration/domain/single_string_model.dart';
import 'package:walima_llc/features/registration/presentation/widgets/hobbies_interests_custom_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;

part 'profile_section_edit_lookup_dynamic_part.dart';
part 'profile_section_edit_ui_section_body_part.dart';
part 'profile_section_edit_ui_strength_part.dart';
part 'profile_section_edit_ui_binding_part.dart';
part 'profile_section_edit_ui_known_fields_part.dart';
part 'profile_section_edit_ui_form_fields_part.dart';
part 'profile_section_edit_ui_dropdown_helpers_part.dart';
part 'profile_section_edit_location_picker_actions_part.dart';
part 'profile_section_edit_location_picker_sync_part.dart';
part 'profile_section_edit_save_actions_part.dart';
part 'profile_section_edit_save_sections_primary_part.dart';
part 'profile_section_edit_save_sections_preference_part.dart';
part 'profile_section_edit_prefill_main_part.dart';
part 'profile_section_edit_save_prefill_utils_part.dart';

class ProfileSectionEditScreen extends ConsumerStatefulWidget {
  const ProfileSectionEditScreen({
    super.key,
    required this.section,
    this.strengthSectionKey,
    this.strengthSectionLabel,
    this.strengthFields = const <ProfileStrengthField>[],
  });

  final ProfileEditSection section;
  final String? strengthSectionKey;
  final String? strengthSectionLabel;
  final List<ProfileStrengthField> strengthFields;

  @override
  ConsumerState<ProfileSectionEditScreen> createState() => _ProfileSectionEditScreenState();
}

abstract class _ProfileSectionEditScreenFields extends ConsumerState<ProfileSectionEditScreen> {
  final ProfileSectionEditDomainRepository _domainRepository = ProfileSectionEditDomainRepositoryImpl();
  final LocationDataRepositoryImpl _locationRepository = LocationDataRepositoryImpl();
  final ProfileSectionStrengthFieldsUseCase _strengthFieldsUseCase = const ProfileSectionStrengthFieldsUseCase();
  final ProfileSectionFieldKeyUseCase _fieldKeyUseCase = const ProfileSectionFieldKeyUseCase();
  final ProfileSectionProfileValueUseCase _profileValueUseCase = const ProfileSectionProfileValueUseCase();
  final ProfileSectionLookupSlugCandidatesUseCase _lookupSlugCandidatesUseCase = const ProfileSectionLookupSlugCandidatesUseCase();

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

  final Map<String, String> _selectedApiValues = <String, String>{};
  final Map<String, TextEditingController> _dynamicFieldControllers = <String, TextEditingController>{};
  final Map<String, List<LookupOption>> _dynamicFieldLookupOptions = <String, List<LookupOption>>{};
  final Map<String, String> _dynamicFieldSelectedApiValues = <String, String>{};
  bool _didInitStrengthFieldMeta = false;

  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
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
  int _prefAgeStart = 25;
  int _prefAgeEnd = 35;
  int _prefHeightStart = 160;
  int _prefHeightEnd = 180;
  final List<String> _preferredCitySelections = <String>[];
}

class _ProfileSectionEditScreenState extends _ProfileSectionEditScreenFields {
  static final Map<String, String> _familyEconomicConditionAliases = <String, String>{
    for (final condition in RegistrationFamilyEconomicCondition.values) condition.label.toLowerCase(): condition.apiValue,
    'elite': RegistrationFamilyEconomicCondition.eliteClass.apiValue,
    'elite class': RegistrationFamilyEconomicCondition.eliteClass.apiValue,
    'high': RegistrationFamilyEconomicCondition.upperClass.apiValue,
    'upper class': RegistrationFamilyEconomicCondition.upperClass.apiValue,
    'middle': RegistrationFamilyEconomicCondition.middleClass.apiValue,
    'middle class': RegistrationFamilyEconomicCondition.middleClass.apiValue,
    'middle_class': RegistrationFamilyEconomicCondition.middleClass.apiValue,
    'aspiring': RegistrationFamilyEconomicCondition.lowerMiddleClass.apiValue,
    'lower middle class': RegistrationFamilyEconomicCondition.lowerMiddleClass.apiValue,
  };

  static const List<LookupOption> _religionOptions = <LookupOption>[
    LookupOption(key: 'islam', label: 'Islam'),
    LookupOption(key: 'hinduism', label: 'Hinduism'),
    LookupOption(key: 'christianity', label: 'Christianity'),
    LookupOption(key: 'buddhism', label: 'Buddhism'),
    LookupOption(key: 'others', label: 'Others'),
  ];

  static final List<int> _heightInchOptions = List<int>.generate(
    33,
    (index) => 51 + index,
  );

  static const int _prefAgeMinLimit = 18;
  static const int _prefAgeMaxLimit = 70;
  static const int _prefHeightMinLimit = 120;
  static const int _prefHeightMaxLimit = 220;

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
      await _initializeStrengthFieldMeta(provider.profile);
      if (mounted) {
        setState(() {});
      }
    });
  }

  String get _screenStateKey => '${widget.section.key}:${widget.strengthSectionKey ?? ''}';

  ProfileSectionEditUiState get _uiState => ref.read(
        profileSectionEditUiProvider(_screenStateKey),
      );

  bool get _isSaving => _uiState.isSaving;

  void _setSaving(bool value) => _uiState.setSaving(value);

  void _setLookupLoading(bool value) => _uiState.setLookupLoading(value);

  @override
  void dispose() {
    for (final controller in _allControllers) {
      controller.dispose();
    }
    for (final controller in _dynamicFieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> get _allControllers => [
        _aboutController,
        _displayNameController,
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
        _prefSmokingExpectationsController,
      ];

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(profileSectionEditUiProvider(_screenStateKey));
    return TransparentLoading(
      isLoading: uiState.isSaving || uiState.isLookupLoading,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CustomBackAppBar(
                title: Text(_screenTitle),
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
    final availableWidth = MediaQuery.of(context).size.width - 40 - (horizontalPadding * 2);
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

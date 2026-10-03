part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditSaveSectionsPrimaryPart
    on _ProfileSectionEditScreenState {
  Future<bool> _saveAboutYourselfSection() {
    return _updateWithUniversal(
      fields: {
        'profile': <String, dynamic>{
          'bio': _toTrimmedOrNull(_aboutController),
        },
      },
      fallbackMessage: 'Failed to update about section',
    );
  }

  Future<bool> _saveBasicDetailsSection() async {
    final profileSnapshot = ref.read(profileProvider).profile;
    final primaryLocation = _firstOrNull(profileSnapshot?.locations);
    return _saveBasicDetails(
      existingLocationId: primaryLocation?.id,
      existingLocationType: primaryLocation?.locationType,
    );
  }

  Future<bool> _saveReligiousBackgroundSection() {
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
  }

  Future<bool> _saveFamilyDetailsSection() async {
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
      familyValues: _apiValueOrText('familyValues', _familyValuesController),
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
  }

  Future<bool> _saveEducationCareerSection() async {
    final profileSnapshot = ref.read(profileProvider).profile;
    final primaryEducation = _firstOrNull(profileSnapshot?.educations);
    final primaryProfession = _firstOrNull(profileSnapshot?.profession);

    final educationPayload = _buildRecordPayload(
      id: primaryEducation?.id,
      fields: <String, dynamic>{
        'qualification': _apiValueOrText(
          'highestQualification',
          _highestQualificationController,
        ),
        'educationLevel': _resolveEducationLevelValue(
          _highestQualificationController,
        ),
        'fieldOfStudy': _toTrimmedOrNull(_fieldOfStudyController),
        'institutionName': _toTrimmedOrNull(_collegeController),
      },
    );
    final professionPayload = _buildRecordPayload(
      id: primaryProfession?.id,
      fields: <String, dynamic>{
        'incomeRange': _apiValueOrText('annualIncome', _annualIncomeController),
        'employmentType':
            _apiValueOrText('workingWith', _workingWithController),
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
  }

  Future<bool> _saveLocationSection() async {
    final profileSnapshot = ref.read(profileProvider).profile;
    final primaryLocation = _firstOrNull(profileSnapshot?.locations);
    final locationType = _resolveLocationType(primaryLocation?.locationType);

    final locationPayload = _buildRecordPayload(
      id: primaryLocation?.id,
      fields: <String, dynamic>{
        'locationType': locationType,
        'country': _toTrimmedOrNull(_countryController),
        'state': _toTrimmedOrNull(_stateController),
        'city': _toTrimmedOrNull(_cityController),
        'residencyStatus':
            _apiValueOrText('residencyStatus', _residencyStatusController),
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
          'displayName': _toTrimmedOrNull(_displayNameController),
          'profileManagedBy':
              _apiValueOrText('managedBy', _managedByController),
          'gender': _apiValueOrText('gender', _genderController),
          'dateOfBirth': _toTrimmedOrNull(_dobController),
          'maritalStatus':
              _apiValueOrText('maritalStatus', _maritalStatusController),
          'motherTongue':
              _apiValueOrText('motherTongue', _motherTongueController),
          'languages': _selectedApiValuesOrNames(_languageOptions) ??
              _toCsvListOrNull(_languagesController),
        },
        'appearance': <String, dynamic>{
          'height': _toIntOrNull(_heightController),
          'bloodGroup': _apiValueOrText('bloodGroup', _bloodGroupController),
          'healthCondition':
              _apiValueOrText('healthDetails', _healthInfoController),
          'healthDetails':
              _apiValueOrText('healthDetails', _healthInfoController),
          'specialCases': _toTrimmedOrNull(_disabilityController),
        },
        'lifestyle': <String, dynamic>{
          'dietType': _apiValueOrText('diet', _dietController),
          'drinkingHabits': _apiValueOrText(
            'drinkingHabits',
            _drinkingHabitsController,
          ),
          'smokingHabits': _apiValueOrText(
            'smokingHabits',
            _smokingHabitsController,
          ),
        },
        if (locationPayload != null)
          'locations': <Map<String, dynamic>>[
            locationPayload,
          ],
      },
      fallbackMessage: 'Failed to update basic details',
    );
  }
}

// ignore_for_file: invalid_use_of_protected_member

part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditPrefillMainPart on _ProfileSectionEditScreenState {
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
    _displayNameController.text = profileData?.displayName ?? '';

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
      options: _ProfileSectionEditScreenState._religionOptions,
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

    _prefAgeStart = (preferences?.ageMin ?? _prefAgeStart).clamp(
      _ProfileSectionEditScreenState._prefAgeMinLimit,
      _ProfileSectionEditScreenState._prefAgeMaxLimit,
    );
    _prefAgeEnd = (preferences?.ageMax ?? _prefAgeEnd).clamp(
      _ProfileSectionEditScreenState._prefAgeMinLimit,
      _ProfileSectionEditScreenState._prefAgeMaxLimit,
    );
    if (_prefAgeStart > _prefAgeEnd) {
      final temp = _prefAgeStart;
      _prefAgeStart = _prefAgeEnd;
      _prefAgeEnd = temp;
    }
    _prefAgeMinController.text = _prefAgeStart.toString();
    _prefAgeMaxController.text = _prefAgeEnd.toString();
    _prefHeightStart = (preferences?.heightMin ?? _prefHeightStart).clamp(
      _ProfileSectionEditScreenState._prefHeightMinLimit,
      _ProfileSectionEditScreenState._prefHeightMaxLimit,
    );
    _prefHeightEnd = (preferences?.heightMax ?? _prefHeightEnd).clamp(
      _ProfileSectionEditScreenState._prefHeightMinLimit,
      _ProfileSectionEditScreenState._prefHeightMaxLimit,
    );
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
      options: _ProfileSectionEditScreenState._religionOptions,
      fieldKey: 'prefReligion',
    );
    _prefCommunityController.text =
        _firstOrNull(preferences?.communityPreference)?.trim() ?? '';
    _selectedApiValues.remove('prefCommunity');
    if (_prefReligionController.text.trim().isNotEmpty &&
        _prefCommunityController.text.trim().isNotEmpty) {
      unawaited(
          _syncPreferredCommunitySelection(_prefCommunityController.text));
    }
    _prefillLookup(
      controller: _prefMotherTongueController,
      raw: _firstOrNull(preferences?.motherTonguePreference),
      options: _motherTongueOptions,
      fieldKey: 'prefMotherTongue',
    );
    _setSelectedValues(
        _prefMaritalOptions, preferences?.maritalStatusPreference);
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
    _prefEducationController.text =
        _selectedDisplayValues(_prefEducationOptions);
    _prefillLookup(
      controller: _prefProfessionController,
      raw: _firstOrNull(preferences?.professionPreference),
      options: _professionOptions,
      fieldKey: 'prefProfession',
    );
    _setSelectedValues(_prefWorkingAsOptions, preferences?.workingAsPreference);
    _prefWorkingAsController.text =
        _selectedDisplayValues(_prefWorkingAsOptions);
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
    _prefSmokingExpectationsController.text =
        (preferences?.smokingPreference ?? []).join(', ');
    _prefDrinkingExpectationsController.text =
        (preferences?.drinkingPreference ?? []).join(', ');
    setState(() {});
  }
}

part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditSaveSectionsPreferencePart
    on _ProfileSectionEditScreenState {
  Future<bool> _saveHobbiesInterestsSection() {
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
  }

  Future<bool> _savePreferenceBasicInfoSection() {
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
  }

  Future<bool> _savePreferenceLocationDetailsSection() {
    return _updateWithUniversal(
      fields: {
        'preferences': UpdatePreferencesRequestBody(
          preferredCountries: _singlePreferenceList(_prefCountryController),
          preferredStates: _toCsvListOrNull(_prefStateController),
          preferredCities: _preferredCitySelections.isEmpty
              ? _toCsvListOrNull(_prefCityController)
              : List<String>.from(_preferredCitySelections),
        ).toJson(),
      },
      fallbackMessage: 'Failed to update preference location details',
    );
  }

  Future<bool> _savePreferenceEducationCareerSection() {
    return _updateWithUniversal(
      fields: {
        'preferences': UpdatePreferencesRequestBody(
          educationPreference: _selectedApiValuesOrNames(_prefEducationOptions),
          professionPreference: _singlePreferenceList(
            _prefProfessionController,
            fieldKey: 'prefProfession',
          ),
          workingAsPreference: _selectedApiValuesOrNames(_prefWorkingAsOptions),
          annualIncomePreference: _singlePreferenceList(
            _prefIncomeController,
            fieldKey: 'prefIncome',
          ),
        ).toJson(),
      },
      fallbackMessage:
          'Failed to update preference education and career details',
    );
  }

  Future<bool> _savePreferenceOtherDetailsSection() {
    return _updateWithUniversal(
      fields: {
        'preferences': UpdatePreferencesRequestBody(
          profileManagedByPreference:
              _selectedApiValuesOrNames(_prefProfileManagedByOptions),
          dietPreference: _selectedApiValuesOrNames(_prefDietOptions),
          expectationsFromLifePartner:
              _toTrimmedOrNull(_prefPartnerExpectationsController),
          drinkingPreference: [_prefDrinkingExpectationsController.text],
          smokingPreference: [_prefSmokingExpectationsController.text],
        ).toJson(),
      },
      fallbackMessage: 'Failed to update preference other details',
    );
  }
}

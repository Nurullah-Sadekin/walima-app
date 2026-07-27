part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditUiSectionBodyPart
    on _ProfileSectionEditScreenState {
  Widget _buildSectionBody() {
    switch (widget.section) {
      case ProfileEditSection.aboutYourself:
        return _buildAboutYourselfSectionBody();
      case ProfileEditSection.basicDetails:
        return _buildBasicDetailsSectionBody();
      case ProfileEditSection.religiousBackground:
        return _buildReligiousBackgroundSectionBody();
      case ProfileEditSection.familyDetails:
        return _buildFamilyDetailsSectionBody();
      case ProfileEditSection.educationCareer:
        return _buildEducationCareerSectionBody();
      case ProfileEditSection.location:
        return _buildLocationSectionBody();
      case ProfileEditSection.hobbiesInterests:
        return _buildHobbiesInterestsSectionBody();
      case ProfileEditSection.preferenceBasicInfo:
        return _buildPreferenceBasicInfoSectionBody();
      case ProfileEditSection.preferenceLocationDetails:
        return _buildPreferenceLocationSectionBody();
      case ProfileEditSection.preferenceEducationCareer:
        return _buildPreferenceEducationCareerSectionBody();
      case ProfileEditSection.preferenceOtherDetails:
        return _buildPreferenceOtherDetailsSectionBody();
    }
  }

  Widget _buildAboutYourselfSectionBody() {
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
  }

  Widget _buildBasicDetailsSectionBody() {
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.disableBackground,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.greyLight, width: 1),
              ),
              child: Text(
                ageText(),
                style: TextStyle(
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                  color: _dobController.text.isNotEmpty
                      ? AppColors.textPrimaryLight
                      : AppColors.grey,
                ),
              ),
            ),
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
        _enumDropdown<DrinkingHabits>(
          label: 'Drinking Habits',
          controller: _drinkingHabitsController,
          values: DrinkingHabits.values,
          popupHeader: 'Select Drinking Habits',
          fieldKey: 'drinkingHabits',
        ),
        _enumDropdown<SmokingHabits>(
          label: 'Smoking Habits',
          controller: _smokingHabitsController,
          values: SmokingHabits.values,
          popupHeader: 'Select Smoking Habits',
          fieldKey: 'smokingHabits',
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
  }

  Widget _buildReligiousBackgroundSectionBody() {
    return _buildCard(
      children: [
        _lookupDropdown(
          label: 'Religion',
          controller: _religionController,
          options: _ProfileSectionEditScreenState._religionOptions,
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
  }

  Widget _buildFamilyDetailsSectionBody() {
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
        _field(label: 'Family Location', controller: _familyLocationController),
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
  }
}

extension _ProfileSectionEditUiSectionBodyPreferencePart
    on _ProfileSectionEditScreenState {
  Widget _buildEducationCareerSectionBody() {
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
        _field(
          label: 'Field of Study',
          controller: _fieldOfStudyController,
        ),
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
  }

  Widget _buildLocationSectionBody() {
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
  }

  Widget _buildHobbiesInterestsSectionBody() {
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
  }

  Widget _buildPreferenceBasicInfoSectionBody() {
    return _buildCard(
      children: [
        _rangeSelector(
          label: 'Age Range'.localized(context),
          startValue: _prefAgeStart,
          endValue: _prefAgeEnd,
          min: _ProfileSectionEditScreenState._prefAgeMinLimit,
          max: _ProfileSectionEditScreenState._prefAgeMaxLimit,
          startLabel: '$_prefAgeStart',
          endLabel: '$_prefAgeEnd',
          onChanged: _setPreferredAgeRange,
        ),
        _rangeSelector(
          label: 'Height Range'.localized(context),
          startValue: _prefHeightStart,
          endValue: _prefHeightEnd,
          min: _ProfileSectionEditScreenState._prefHeightMinLimit,
          max: _ProfileSectionEditScreenState._prefHeightMaxLimit,
          startLabel: _formatPreferenceHeight(_prefHeightStart),
          endLabel: _formatPreferenceHeight(_prefHeightEnd),
          onChanged: _setPreferredHeightRange,
        ),
        _multiSelectField(
          label: 'Marital Status'.localized(context),
          options: _prefMaritalOptions,
          onItemTap: (index) => _toggleOption(_prefMaritalOptions, index),
        ),
        _lookupDropdown(
          label: 'Religion'.localized(context),
          controller: _prefReligionController,
          options: _ProfileSectionEditScreenState._religionOptions,
          popupHeader: 'Select Religion'.localized(context),
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
          label: 'Community'.localized(context),
          controller: _prefCommunityController,
          options: _communityOptions,
          popupHeader: 'Select Community'.localized(context),
          fieldKey: 'prefCommunity',
          onTap: () => _loadCommunityOptionsForReligion(
            _prefReligionController.text,
          ),
        ),
        _lookupDropdown(
          label: 'Mother Tongue'.localized(context),
          controller: _prefMotherTongueController,
          options: _motherTongueOptions,
          popupHeader: 'Select Mother Tongue'.localized(context),
          fieldKey: 'prefMotherTongue',
          onTap: _loadBasicDetailsLookups,
        ),
      ],
    );
  }

  Widget _buildPreferenceLocationSectionBody() {
    return _buildCard(
      children: [
        _pickerField(
          label: 'Country Living In'.localized(context),
          controller: _prefCountryController,
          hintText: 'Select Country'.localized(context),
          onTap: _openPreferredCountryPicker,
        ),
        if (_prefCountryController.text.trim().isNotEmpty)
          _multiTextSelectionField(
            label: 'City'.localized(context),
            options: _cityDropdownItems,
            selectedValues: _preferredCitySelections,
            isLoading: _isCityLoading && _cityDropdownItems.isEmpty,
            isLoadingMore: _isCityLoadingMore,
            emptyText:
                'No cities available for the selected country.'.localized(
              context,
            ),
            onItemTap: _togglePreferredCitySelection,
            onLoadMore: _hasMoreCities ? _loadMorePreferredCities : null,
          ),
      ],
    );
  }

  Widget _buildPreferenceEducationCareerSectionBody() {
    return _buildCard(
      children: [
        _multiSelectField(
          label: 'Education Qualification'.localized(context),
          options: _prefEducationOptions,
          onItemTap: (index) => _toggleOption(_prefEducationOptions, index),
        ),
        _multiSelectField(
          label: 'Working As'.localized(context),
          options: _prefWorkingAsOptions,
          onItemTap: (index) => _toggleOption(_prefWorkingAsOptions, index),
        ),
        _lookupDropdown(
          label: 'Profession'.localized(context),
          controller: _prefProfessionController,
          options: _professionOptions,
          popupHeader: 'Select Profession'.localized(context),
          fieldKey: 'prefProfession',
          onTap: _loadProfessionAndIncomeLookup,
        ),
        _lookupDropdown(
          label: 'Annual Income'.localized(context),
          controller: _prefIncomeController,
          options: _incomeRangeOptions,
          popupHeader: 'Select Annual Income'.localized(context),
          fieldKey: 'prefIncome',
          onTap: _loadProfessionAndIncomeLookup,
        ),
      ],
    );
  }

  Widget _buildPreferenceOtherDetailsSectionBody() {
    return _buildCard(
      children: [
        _multiSelectField(
          label: 'Profile Managed By'.localized(context),
          options: _prefProfileManagedByOptions,
          onItemTap: (index) =>
              _toggleOption(_prefProfileManagedByOptions, index),
        ),
        _multiSelectField(
          label: 'Diet Preference'.localized(context),
          options: _prefDietOptions,
          onItemTap: (index) => _toggleOption(_prefDietOptions, index),
        ),
        _field(
          label: 'Smoking'.localized(context),
          controller: _prefSmokingExpectationsController,
          hintText: 'expectation'.localized(context),
        ),
        _field(
          label: 'Drinking'.localized(context),
          controller: _prefDrinkingExpectationsController,
          hintText: 'expectation'.localized(context),
        ),
        _field(
          label: 'Partner Expectations'.localized(context),
          controller: _prefPartnerExpectationsController,
          maxLines: 5,
          minLines: 4,
          hintText: 'Write what you expect from your partner'.localized(
            context,
          ),
        ),
      ],
    );
  }
}

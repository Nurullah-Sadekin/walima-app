part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditUiBindingPart on _ProfileSectionEditScreenState {
  ProfileSectionEditFieldBinding? _bindingForStrengthField(
    String normalizedKey,
    String rawFieldKey,
  ) {
    switch (normalizedKey) {
      case 'bio':
        return ProfileSectionEditFieldBinding(controller: _aboutController);
      case 'displayname':
        return ProfileSectionEditFieldBinding(
            controller: _displayNameController);
      case 'profilemanagedby':
        return ProfileSectionEditFieldBinding(
          controller: _managedByController,
          selectedApiValueKey: 'managedBy',
        );
      case 'gender':
        return ProfileSectionEditFieldBinding(
          controller: _genderController,
          selectedApiValueKey: 'gender',
        );
      case 'dateofbirth':
        return ProfileSectionEditFieldBinding(
          controller: _dobController,
          datePicker: true,
        );
      case 'maritalstatus':
        return ProfileSectionEditFieldBinding(
          controller: _maritalStatusController,
          selectedApiValueKey: 'maritalStatus',
        );
      case 'mothertongue':
        return ProfileSectionEditFieldBinding(
          controller: _motherTongueController,
          selectedApiValueKey: 'motherTongue',
        );
      case 'languages':
        return ProfileSectionEditFieldBinding(controller: _languagesController);
      case 'height':
        return ProfileSectionEditFieldBinding(
          controller: _heightController,
          keyboardType: TextInputType.number,
        );
      case 'diet':
      case 'diettype':
        return ProfileSectionEditFieldBinding(
          controller: _dietController,
          selectedApiValueKey: 'diet',
        );
      case 'bloodgroup':
        return ProfileSectionEditFieldBinding(
          controller: _bloodGroupController,
          selectedApiValueKey: 'bloodGroup',
        );
      case 'healthdetails':
      case 'healthinformation':
      case 'healthcondition':
        return ProfileSectionEditFieldBinding(
          controller: _healthInfoController,
          selectedApiValueKey: 'healthDetails',
        );
      case 'specialcases':
      case 'disability':
        return ProfileSectionEditFieldBinding(
            controller: _disabilityController);
      case 'religion':
        return ProfileSectionEditFieldBinding(
          controller: _religionController,
          selectedApiValueKey: 'religion',
        );
      case 'community':
        return ProfileSectionEditFieldBinding(
          controller: _communityController,
          selectedApiValueKey: 'community',
        );
      case 'religiousbackground':
        return ProfileSectionEditFieldBinding(
          controller: _religiousBackgroundController,
          selectedApiValueKey: 'religiousBackground',
        );
      case 'fathername':
        return ProfileSectionEditFieldBinding(
            controller: _fatherNameController);
      case 'fatherprofession':
        return ProfileSectionEditFieldBinding(
          controller: _fatherProfessionController,
          selectedApiValueKey: 'fatherProfession',
        );
      case 'mothername':
        return ProfileSectionEditFieldBinding(
            controller: _motherNameController);
      case 'motherprofession':
        return ProfileSectionEditFieldBinding(
          controller: _motherProfessionController,
          selectedApiValueKey: 'motherProfession',
        );
      case 'familylocation':
        return ProfileSectionEditFieldBinding(
          controller: _familyLocationController,
        );
      case 'brothers':
        return ProfileSectionEditFieldBinding(
          controller: _brothersController,
          keyboardType: TextInputType.number,
        );
      case 'sisters':
        return ProfileSectionEditFieldBinding(
          controller: _sistersController,
          keyboardType: TextInputType.number,
        );
      case 'familyeconomiccondition':
        return ProfileSectionEditFieldBinding(
          controller: _familyFinancialController,
        );
      case 'aboutfamily':
        return ProfileSectionEditFieldBinding(
            controller: _aboutFamilyController);
      case 'familytype':
        return ProfileSectionEditFieldBinding(
          controller: _familyTypeController,
          selectedApiValueKey: 'familyType',
        );
      case 'familyvalues':
        return ProfileSectionEditFieldBinding(
          controller: _familyValuesController,
          selectedApiValueKey: 'familyValues',
        );
      case 'marriagetimeline':
        return ProfileSectionEditFieldBinding(
          controller: _marriageTimelineController,
          selectedApiValueKey: 'marriageTimeline',
        );
      case 'educationlevel':
      case 'highestqualification':
      case 'qualification':
        return ProfileSectionEditFieldBinding(
          controller: _highestQualificationController,
          selectedApiValueKey: 'highestQualification',
        );
      case 'fieldofstudy':
      case 'institutionname':
      case 'college':
        return ProfileSectionEditFieldBinding(controller: _collegeController);
      case 'incomerange':
      case 'annualincome':
        return ProfileSectionEditFieldBinding(
          controller: _annualIncomeController,
          selectedApiValueKey: 'annualIncome',
        );
      case 'employmenttype':
      case 'workingwith':
        return ProfileSectionEditFieldBinding(
          controller: _workingWithController,
          selectedApiValueKey: 'workingWith',
        );
      case 'designation':
      case 'workingas':
      case 'profession':
        return ProfileSectionEditFieldBinding(
          controller: _workingAsController,
          selectedApiValueKey: 'workingAs',
        );
      case 'employer':
        return ProfileSectionEditFieldBinding(controller: _employerController);
      case 'country':
        return ProfileSectionEditFieldBinding(controller: _countryController);
      case 'state':
        return ProfileSectionEditFieldBinding(controller: _stateController);
      case 'city':
        return ProfileSectionEditFieldBinding(controller: _cityController);
      case 'residencystatus':
        return ProfileSectionEditFieldBinding(
          controller: _residencyStatusController,
          selectedApiValueKey: 'residencyStatus',
        );
      case 'zipcode':
      case 'pincode':
        return ProfileSectionEditFieldBinding(controller: _zipController);
      case 'grewupin':
        if (widget.section == ProfileEditSection.basicDetails) {
          return ProfileSectionEditFieldBinding(
              controller: _grewUpInController);
        }
        return ProfileSectionEditFieldBinding(controller: _grewUpController);
      case 'religionpreference':
        return ProfileSectionEditFieldBinding(
          controller: _prefReligionController,
          selectedApiValueKey: 'prefReligion',
        );
      case 'communitypreference':
        return ProfileSectionEditFieldBinding(
          controller: _prefCommunityController,
          selectedApiValueKey: 'prefCommunity',
        );
      case 'mothertonguepreference':
        return ProfileSectionEditFieldBinding(
          controller: _prefMotherTongueController,
          selectedApiValueKey: 'prefMotherTongue',
        );
      case 'professionpreference':
        return ProfileSectionEditFieldBinding(
          controller: _prefProfessionController,
          selectedApiValueKey: 'prefProfession',
        );
      case 'annualincomepreference':
        return ProfileSectionEditFieldBinding(
          controller: _prefIncomeController,
          selectedApiValueKey: 'prefIncome',
        );
      case 'partnerexpectations':
      case 'expectationsfromlifepartner':
        return ProfileSectionEditFieldBinding(
          controller: _prefPartnerExpectationsController,
        );
      case 'smokingpreference':
        return ProfileSectionEditFieldBinding(
          controller: _prefSmokingExpectationsController,
        );
      case 'drinkingpreference':
        return ProfileSectionEditFieldBinding(
          controller: _prefDrinkingExpectationsController,
        );
      default:
        final fallback = _dynamicFieldControllers[rawFieldKey];
        if (fallback != null) {
          return ProfileSectionEditFieldBinding(controller: fallback);
        }
        return null;
    }
  }
}

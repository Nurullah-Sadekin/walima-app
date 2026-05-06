part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditUiKnownFieldsPart
    on _ProfileSectionEditScreenState {
  Set<String> _knownFieldKeysForSection(ProfileEditSection section) {
    switch (section) {
      case ProfileEditSection.aboutYourself:
        return const <String>{'bio'};
      case ProfileEditSection.basicDetails:
        return const <String>{
          'displayname',
          'profilemanagedby',
          'gender',
          'dateofbirth',
          'maritalstatus',
          'mothertongue',
          'languages',
          'height',
          'diet',
          'diettype',
          'bloodgroup',
          'healthdetails',
          'healthinformation',
          'healthcondition',
          'specialcases',
          'disability',
          'grewupin',
        };
      case ProfileEditSection.religiousBackground:
        return const <String>{'religion', 'community', 'religiousbackground'};
      case ProfileEditSection.familyDetails:
        return const <String>{
          'fathername',
          'fatherprofession',
          'mothername',
          'motherprofession',
          'familylocation',
          'brothers',
          'sisters',
          'familyeconomiccondition',
          'aboutfamily',
          'familytype',
          'familyvalues',
          'marriagetimeline',
        };
      case ProfileEditSection.educationCareer:
        return const <String>{
          'educationlevel',
          'highestqualification',
          'qualification',
          'fieldofstudy',
          'institutionname',
          'college',
          'incomerange',
          'annualincome',
          'employmenttype',
          'workingwith',
          'designation',
          'workingas',
          'profession',
          'employer',
        };
      case ProfileEditSection.location:
        return const <String>{
          'country',
          'state',
          'city',
          'residencystatus',
          'zipcode',
          'pincode',
          'grewupin',
        };
      case ProfileEditSection.hobbiesInterests:
        return const <String>{'hasinterests'};
      case ProfileEditSection.preferenceBasicInfo:
        return const <String>{
          'agerange',
          'heightrange',
          'maritalstatuspreference',
          'religionpreference',
          'communitypreference',
          'mothertonguepreference',
        };
      case ProfileEditSection.preferenceLocationDetails:
        return const <String>{'locationpreference'};
      case ProfileEditSection.preferenceEducationCareer:
        return const <String>{
          'educationpreference',
          'workingaspreference',
          'professionpreference',
          'annualincomepreference',
        };
      case ProfileEditSection.preferenceOtherDetails:
        return const <String>{
          'profilemanagedbypreference',
          'dietpreference',
          'smokingpreference',
          'drinkingpreference',
          'partnerexpectations',
          'expectationsfromlifepartner',
        };
    }
  }

  Future<List<LookupOption>> _loadLookupOptionsForStrengthField(
    String rawFieldKey,
  ) async {
    final candidates = _lookupSlugCandidatesUseCase.execute(rawFieldKey);
    for (final slug in candidates) {
      try {
        final options = await _domainRepository.getLookupsBySlug(slug);
        if (options.isNotEmpty) {
          return options;
        }
      } catch (_) {
        // Try next slug
      }
    }
    return const <LookupOption>[];
  }
}

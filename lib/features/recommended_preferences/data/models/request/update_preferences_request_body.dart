class UpdatePreferencesRequestBody {
  final int? ageMin;
  final int? ageMax;
  final int? heightMin;
  final int? heightMax;
  final List<String>? maritalStatusPreference;
  final List<String>? educationPreference;
  final List<String>? professionPreference;
  final List<String>? workingAsPreference;
  final List<String>? religionPreference;
  final List<String>? communityPreference;
  final List<String>? motherTonguePreference;
  final List<String>? annualIncomePreference;
  final List<String>? preferredCountries;
  final List<String>? preferredStates;
  final List<String>? preferredCities;
  final List<String>? profileManagedByPreference;
  final List<String>? spouseWorkStudyAllowed;
  final List<String>? postMarriageLivingPreference;
  final bool? willingToRelocate;
  final String? expectationsFromLifePartner;
  final List<String>? dietPreference;
  final List<String>? drinkingPreference;
  final List<String>? smokingPreference;

  UpdatePreferencesRequestBody({
    this.ageMin,
    this.ageMax,
    this.heightMin,
    this.heightMax,
    this.maritalStatusPreference,
    this.educationPreference,
    this.professionPreference,
    this.workingAsPreference,
    this.religionPreference,
    this.communityPreference,
    this.motherTonguePreference,
    this.annualIncomePreference,
    this.preferredCountries,
    this.preferredStates,
    this.preferredCities,
    this.profileManagedByPreference,
    this.spouseWorkStudyAllowed,
    this.postMarriageLivingPreference,
    this.willingToRelocate,
    this.expectationsFromLifePartner,
    this.dietPreference,
    this.drinkingPreference,
    this.smokingPreference,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    void addValue(String key, dynamic value) {
      if (value == null) return;
      if (value is String && value.isEmpty) return;
      if (value is List && value.isEmpty) return;
      map[key] = value;
    }

    addValue('ageMin', ageMin);
    addValue('ageMax', ageMax);
    addValue('heightMin', heightMin);
    addValue('heightMax', heightMax);
    addValue('maritalStatusPreference', maritalStatusPreference);
    addValue('educationPreference', educationPreference);
    if (professionPreference != null) {
      map['professionPreference'] = professionPreference;
    }
    addValue('workingAsPreference', workingAsPreference);
    addValue('religionPreference', religionPreference);
    addValue('communityPreference', communityPreference);
    addValue('motherTonguePreference', motherTonguePreference);
    if (annualIncomePreference != null) {
      map['annualIncomePreference'] = annualIncomePreference;
    }
    addValue('preferredCountries', preferredCountries);
    addValue('preferredStates', preferredStates);
    if (preferredCities != null) map['preferredCities'] = preferredCities;
    addValue('profileManagedByPreference', profileManagedByPreference);
    addValue('spouseWorkStudyAllowed', spouseWorkStudyAllowed);
    addValue('postMarriageLivingPreference', postMarriageLivingPreference);
    if (willingToRelocate != null) map['willingToRelocate'] = willingToRelocate;
    addValue('expectationsFromLifePartner', expectationsFromLifePartner);
    addValue('dietPreference', dietPreference);
    addValue('drinkingPreference', drinkingPreference);
    addValue('smokingPreference', smokingPreference);

    return map;
  }
}

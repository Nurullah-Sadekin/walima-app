part of 'get_complete_profile_response.dart';

class Preferences {
  Preferences({
    this.id,
    this.profileId,
    this.expectationsFromLifePartner,
    this.ageMin,
    this.ageMax,
    this.heightMin,
    this.heightMax,
    this.maritalStatusPreference,
    this.educationPreference,
    this.workingAsPreference,
    this.professionPreference,
    this.annualIncomePreference,
    this.religionPreference,
    this.communityPreference,
    this.motherTonguePreference,
    this.spouseWorkStudyAllowed,
    this.postMarriageLivingPreference,
    this.additionalPreferences,
    this.preferredCountries,
    this.preferredStates,
    this.preferredCities,
    this.profileManagedByPreference,
    this.dietPreference,
    this.drinkingPreference,
    this.smokingPreference,
    this.familyTypePreference,
    this.familyValuesPreference,
    this.willingToRelocate,
    this.languagePreference,
    this.partnerExpectations,
    this.createdAt,
    this.updatedAt,
  });

  Preferences.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    expectationsFromLifePartner = json['expectationsFromLifePartner'];
    ageMin = json['ageMin'];
    ageMax = json['ageMax'];
    heightMin = json['heightMin'];
    heightMax = json['heightMax'];
    maritalStatusPreference = json['maritalStatusPreference'] != null
        ? json['maritalStatusPreference'].cast<String>()
        : [];
    educationPreference = json['educationPreference'] != null
        ? json['educationPreference'].cast<String>()
        : [];
    workingAsPreference = json['workingAsPreference'] != null
        ? json['workingAsPreference'].cast<String>()
        : [];
    professionPreference = json['professionPreference'] != null
        ? json['professionPreference'].cast<String>()
        : [];
    annualIncomePreference = json['annualIncomePreference'] != null
        ? json['annualIncomePreference'].cast<String>()
        : [];
    religionPreference = json['religionPreference'] != null
        ? json['religionPreference'].cast<String>()
        : [];
    communityPreference = json['communityPreference'] != null
        ? json['communityPreference'].cast<String>()
        : [];
    motherTonguePreference = json['motherTonguePreference'] != null
        ? json['motherTonguePreference'].cast<String>()
        : [];
    spouseWorkStudyAllowed = json['spouseWorkStudyAllowed'] != null
        ? json['spouseWorkStudyAllowed'].cast<String>()
        : [];
    postMarriageLivingPreference = json['postMarriageLivingPreference'] != null
        ? json['postMarriageLivingPreference'].cast<String>()
        : [];
    additionalPreferences = json['additionalPreferences'];
    preferredCountries = json['preferredCountries'] != null
        ? json['preferredCountries'].cast<String>()
        : [];
    preferredStates = json['preferredStates'] != null
        ? json['preferredStates'].cast<String>()
        : [];
    preferredCities = json['preferredCities'] != null
        ? json['preferredCities'].cast<String>()
        : [];
    profileManagedByPreference = json['profileManagedByPreference'] != null
        ? json['profileManagedByPreference'].cast<String>()
        : [];
    dietPreference = json['dietPreference'] != null
        ? json['dietPreference'].cast<String>()
        : [];
    drinkingPreference = json['drinkingPreference'] != null
        ? json['drinkingPreference'].cast<String>()
        : [];
    smokingPreference = json['smokingPreference'] != null
        ? json['smokingPreference'].cast<String>()
        : [];
    familyTypePreference = json['familyTypePreference'];
    familyValuesPreference = json['familyValuesPreference'];
    willingToRelocate = json['willingToRelocate'];
    languagePreference = json['languagePreference'];
    partnerExpectations = json['partnerExpectations'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  String? expectationsFromLifePartner;
  int? ageMin;
  int? ageMax;
  int? heightMin;
  int? heightMax;
  List<String>? maritalStatusPreference;
  List<String>? educationPreference;
  List<String>? workingAsPreference;
  List<String>? professionPreference;
  List<String>? annualIncomePreference;
  List<String>? religionPreference;
  List<String>? communityPreference;
  List<String>? motherTonguePreference;
  List<String>? spouseWorkStudyAllowed;
  List<String>? postMarriageLivingPreference;
  dynamic additionalPreferences;
  List<String>? preferredCountries;
  List<String>? preferredStates;
  List<String>? preferredCities;
  List<String>? profileManagedByPreference;
  List<String>? dietPreference;
  List<String>? drinkingPreference;
  List<String>? smokingPreference;
  dynamic familyTypePreference;
  dynamic familyValuesPreference;
  bool? willingToRelocate;
  dynamic languagePreference;
  dynamic partnerExpectations;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['expectationsFromLifePartner'] = expectationsFromLifePartner;
    map['ageMin'] = ageMin;
    map['ageMax'] = ageMax;
    map['heightMin'] = heightMin;
    map['heightMax'] = heightMax;
    map['maritalStatusPreference'] = maritalStatusPreference;
    map['educationPreference'] = educationPreference;
    map['workingAsPreference'] = workingAsPreference;
    map['professionPreference'] = professionPreference;
    map['annualIncomePreference'] = annualIncomePreference;
    map['religionPreference'] = religionPreference;
    map['communityPreference'] = communityPreference;
    map['motherTonguePreference'] = motherTonguePreference;
    map['spouseWorkStudyAllowed'] = spouseWorkStudyAllowed;
    map['postMarriageLivingPreference'] = postMarriageLivingPreference;
    map['additionalPreferences'] = additionalPreferences;
    map['preferredCountries'] = preferredCountries;
    map['preferredStates'] = preferredStates;
    map['preferredCities'] = preferredCities;
    map['profileManagedByPreference'] = profileManagedByPreference;
    map['dietPreference'] = dietPreference;
    map['drinkingPreference'] = drinkingPreference;
    map['smokingPreference'] = smokingPreference;
    map['familyTypePreference'] = familyTypePreference;
    map['familyValuesPreference'] = familyValuesPreference;
    map['willingToRelocate'] = willingToRelocate;
    map['languagePreference'] = languagePreference;
    map['partnerExpectations'] = partnerExpectations;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}


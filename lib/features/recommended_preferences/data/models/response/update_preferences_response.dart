class UpdatePreferencesResponse {
  final String? code;
  final String? message;
  final UpdatePreferencesResponseBody? response;

  UpdatePreferencesResponse({this.code, this.message, this.response});

  factory UpdatePreferencesResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePreferencesResponse(
      code: json['code'] as String?,
      message: json['message'] as String?,
      response: json['response'] is Map<String, dynamic>
          ? UpdatePreferencesResponseBody.fromJson(
              json['response'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UpdatePreferencesResponseBody {
  final bool? success;
  final UpdatePreferencesData? data;

  UpdatePreferencesResponseBody({this.success, this.data});

  factory UpdatePreferencesResponseBody.fromJson(Map<String, dynamic> json) {
    return UpdatePreferencesResponseBody(
      success: json['success'] as bool?,
      data: json['data'] is Map<String, dynamic>
          ? UpdatePreferencesData.fromJson(
              json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UpdatePreferencesData {
  final String? id;
  final String? profileId;
  final String? expectationsFromLifePartner;
  final int? ageMin;
  final int? ageMax;
  final int? heightMin;
  final int? heightMax;
  final List<String>? maritalStatusPreference;
  final List<String>? educationPreference;
  final List<String>? workingAsPreference;
  final List<String>? professionPreference;
  final List<String>? annualIncomePreference;
  final List<String>? religionPreference;
  final List<String>? communityPreference;
  final List<String>? motherTonguePreference;
  final List<String>? spouseWorkStudyAllowed;
  final List<String>? postMarriageLivingPreference;
  final List<String>? preferredCountries;
  final List<String>? preferredStates;
  final List<String>? preferredCities;
  final List<String>? profileManagedByPreference;
  final List<String>? dietPreference;
  final List<String>? drinkingPreference;
  final List<String>? smokingPreference;
  final bool? willingToRelocate;
  final String? createdAt;
  final String? updatedAt;

  UpdatePreferencesData({
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
    this.preferredCountries,
    this.preferredStates,
    this.preferredCities,
    this.profileManagedByPreference,
    this.dietPreference,
    this.drinkingPreference,
    this.smokingPreference,
    this.willingToRelocate,
    this.createdAt,
    this.updatedAt,
  });

  factory UpdatePreferencesData.fromJson(Map<String, dynamic> json) {
    List<String>? parseList(dynamic value) {
      if (value is List) return value.map((e) => e.toString()).toList();
      return null;
    }

    return UpdatePreferencesData(
      id: json['id'] as String?,
      profileId: json['profileId'] as String?,
      expectationsFromLifePartner:
          json['expectationsFromLifePartner'] as String?,
      ageMin: json['ageMin'] as int?,
      ageMax: json['ageMax'] as int?,
      heightMin: json['heightMin'] as int?,
      heightMax: json['heightMax'] as int?,
      maritalStatusPreference: parseList(json['maritalStatusPreference']),
      educationPreference: parseList(json['educationPreference']),
      workingAsPreference: parseList(json['workingAsPreference']),
      professionPreference: parseList(json['professionPreference']),
      annualIncomePreference: parseList(json['annualIncomePreference']),
      religionPreference: parseList(json['religionPreference']),
      communityPreference: parseList(json['communityPreference']),
      motherTonguePreference: parseList(json['motherTonguePreference']),
      spouseWorkStudyAllowed: parseList(json['spouseWorkStudyAllowed']),
      postMarriageLivingPreference:
          parseList(json['postMarriageLivingPreference']),
      preferredCountries: parseList(json['preferredCountries']),
      preferredStates: parseList(json['preferredStates']),
      preferredCities: parseList(json['preferredCities']),
      profileManagedByPreference: parseList(json['profileManagedByPreference']),
      dietPreference: parseList(json['dietPreference']),
      drinkingPreference: parseList(json['drinkingPreference']),
      smokingPreference: parseList(json['smokingPreference']),
      willingToRelocate: json['willingToRelocate'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}

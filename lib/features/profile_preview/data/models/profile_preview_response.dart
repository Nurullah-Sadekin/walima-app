class ProfilePreviewResponse {
  ProfilePreviewResponse({
    this.code,
    this.message,
    this.data,
    this.traceId,
  });

  factory ProfilePreviewResponse.fromJson(dynamic json) {
    if (json is! Map) return ProfilePreviewResponse();
    final map = Map<String, dynamic>.from(json);
    final response = map['response'];
    final responseData = response is Map
        ? (response['data'] is Map ? response['data'] : response)
        : null;
    return ProfilePreviewResponse(
      code: map['code']?.toString(),
      message: map['message']?.toString(),
      data: responseData is Map
          ? ProfilePreviewData.fromJson(Map<String, dynamic>.from(responseData))
          : null,
      traceId: map['traceId']?.toString(),
    );
  }

  final String? code;
  final String? message;
  final ProfilePreviewData? data;
  final String? traceId;

  bool get isSuccess => code == 'SUCCESS' && data != null;
}

class ProfilePreviewData {
  ProfilePreviewData({
    this.user,
    this.profile,
    this.about,
    this.interests,
    this.lifestyle,
    this.religion,
    this.locations = const <PreviewLocation>[],
    this.family,
    this.educations,
    this.professions,
    this.galleryImages = const <String>[],
    this.preferences,
    this.connection,
    this.matchNarrative,
  });

  factory ProfilePreviewData.fromJson(Map<String, dynamic> json) {
    final rawProfile = _asMap(json['profile']) ?? const <String, dynamic>{};
    final appearance = _asMap(rawProfile['appearance']);
    final profile = Map<String, dynamic>.from(rawProfile);
    if (profile['height'] == null && appearance?['height'] != null) {
      profile['height'] = appearance!['height'];
    }
    final gallery = json['galleryImages'];
    if (profile['profilePictures'] == null && gallery is List) {
      profile['profilePictures'] = gallery;
    }
    final firstEducation = _firstMap(json['educations']);
    final firstProfession = _firstMap(json['professions']);

    return ProfilePreviewData(
      user: _asMap(json['user']) != null
          ? PreviewUser.fromJson(_asMap(json['user'])!)
          : null,
      profile: rawProfile.isNotEmpty ? PreviewProfile.fromJson(profile) : null,
      about: json['about']?.toString() ?? rawProfile['aboutMe']?.toString(),
      interests: _asMap(json['interests']) != null
          ? PreviewInterests.fromJson(_asMap(json['interests'])!)
          : null,
      lifestyle: _asMap(json['lifestyle']) != null
          ? PreviewLifestyle.fromJson(_asMap(json['lifestyle'])!)
          : null,
      religion: _asMap(json['religion']) != null
          ? PreviewReligion.fromJson(_asMap(json['religion'])!)
          : rawProfile['religion'] != null || rawProfile['community'] != null
              ? PreviewReligion.fromJson(<String, dynamic>{
                  'religion': rawProfile['religion'],
                  'community': rawProfile['community'],
                })
              : null,
      locations: (json['locations'] is List)
          ? (json['locations'] as List)
              .whereType<Map>()
              .map(
                (e) => PreviewLocation.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList(growable: false)
          : const <PreviewLocation>[],
      family: _asMap(json['family']) != null
          ? PreviewFamily.fromJson(_asMap(json['family'])!)
          : null,
      educations: firstEducation != null
          ? PreviewEducation.fromJson(firstEducation)
          : null,
      professions: firstProfession != null
          ? PreviewProfession.fromJson(firstProfession)
          : null,
      galleryImages: (json['galleryImages'] is List)
          ? (json['galleryImages'] as List)
              .map((e) => e is Map ? e['url']?.toString() : e.toString())
              .whereType<String>()
              .toList(growable: false)
          : const <String>[],
      preferences: _asMap(json['preferences']) != null
          ? PreviewPreferences.fromJson(_asMap(json['preferences'])!)
          : null,
      connection: _asMap(json['connection']) != null
          ? PreviewConnection.fromJson(_asMap(json['connection'])!)
          : null,
      matchNarrative: json['matchNarrative']?.toString(),
    );
  }

  final PreviewUser? user;
  final PreviewProfile? profile;
  final String? about;
  final PreviewInterests? interests;
  final PreviewLifestyle? lifestyle;
  final PreviewReligion? religion;
  final List<PreviewLocation> locations;
  final PreviewFamily? family;
  final PreviewEducation? educations;
  final PreviewProfession? professions;
  final List<String> galleryImages;
  final PreviewPreferences? preferences;
  final PreviewConnection? connection;
  final String? matchNarrative;

  PreviewLocation? get presentLocation {
    for (final loc in locations) {
      if ((loc.locationType ?? '').toLowerCase() == 'present') return loc;
    }
    return locations.isNotEmpty ? locations.first : null;
  }
}

class PreviewUser {
  PreviewUser({
    this.id,
    this.firstName,
    this.lastName,
    this.userReference,
    this.status,
    this.isVerified,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.isIdVerified,
    this.isPhotoVerified,
    this.isOnline,
    this.lastSeenAt,
  });

  factory PreviewUser.fromJson(Map<String, dynamic> json) => PreviewUser(
        id: json['id']?.toString(),
        firstName: json['firstName']?.toString(),
        lastName: json['lastName']?.toString(),
        userReference: json['userReference']?.toString(),
        status: json['status']?.toString(),
        isVerified: json['isVerified'] as bool?,
        isPhoneVerified: json['isPhoneVerified'] as bool?,
        isEmailVerified: json['isEmailVerified'] as bool?,
        isIdVerified: json['isIdVerified'] as bool?,
        isPhotoVerified: json['isPhotoVerified'] as bool?,
        isOnline: json['isOnline'] as bool?,
        lastSeenAt: json['lastSeenAt']?.toString(),
      );

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? userReference;
  final String? status;
  final bool? isVerified;
  final bool? isPhoneVerified;
  final bool? isEmailVerified;
  final bool? isIdVerified;
  final bool? isPhotoVerified;
  final bool? isOnline;
  final String? lastSeenAt;

  String get fullName {
    final parts = [firstName, lastName]
        .where((v) => v != null && v.trim().isNotEmpty)
        .map((v) => v!.trim())
        .toList();
    return parts.isEmpty ? '' : parts.join(' ');
  }
}

class PreviewProfilePicture {
  PreviewProfilePicture({
    this.url,
    this.visibilityStatus,
    this.visibilitySetting,
    this.isVerified,
  });

  factory PreviewProfilePicture.fromJson(Map<String, dynamic> json) =>
      PreviewProfilePicture(
        url: json['url']?.toString(),
        visibilityStatus: json['visibilityStatus']?.toString(),
        visibilitySetting: json['visibilitySetting']?.toString(),
        isVerified: json['isVerified'] as bool?,
      );

  final String? url;
  final String? visibilityStatus;
  final String? visibilitySetting;
  final bool? isVerified;
}

class PreviewProfile {
  PreviewProfile({
    this.profileManagedBy,
    this.displayName,
    this.nickName,
    this.age,
    this.height,
    this.dateOfBirth,
    this.gender,
    this.maritalStatus,
    this.profilePictures = const <PreviewProfilePicture>[],
    this.motherTongue,
    this.religionName,
    this.community,
    this.countryCode,
    this.liveWithFamily,
  });

  factory PreviewProfile.fromJson(Map<String, dynamic> json) => PreviewProfile(
        profileManagedBy: json['profileManagedBy']?.toString(),
        displayName: json['displayName']?.toString(),
        nickName: json['nickName']?.toString(),
        age: (json['age'] as num?)?.toInt(),
        height: (json['height'] as num?)?.toDouble(),
        dateOfBirth: json['dateOfBirth']?.toString(),
        gender: json['gender']?.toString(),
        maritalStatus: json['maritalStatus']?.toString(),
        profilePictures: (json['profilePictures'] is List)
            ? (json['profilePictures'] as List)
                .whereType<Map>()
                .map(
                  (e) => PreviewProfilePicture.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList(growable: false)
            : const <PreviewProfilePicture>[],
        motherTongue: json['motherTongue']?.toString(),
        religionName: (json['religionName'] ?? json['religion'])?.toString(),
        community: json['community']?.toString(),
        countryCode: json['countryCode']?.toString(),
        liveWithFamily: json['liveWithFamily'] as bool?,
      );

  final String? profileManagedBy;
  final String? displayName;
  final String? nickName;
  final int? age;
  final double? height;
  final String? dateOfBirth;
  final String? gender;
  final String? maritalStatus;
  final List<PreviewProfilePicture> profilePictures;
  final String? motherTongue;
  final String? religionName;
  final String? community;
  final String? countryCode;
  final bool? liveWithFamily;

  PreviewProfilePicture? get primaryPhoto =>
      profilePictures.isEmpty ? null : profilePictures.first;
}

class PreviewInterests {
  PreviewInterests({
    this.creativePursuits = const <String>[],
    this.outdoorActivities = const <String>[],
    this.fitnessAndSports = const <String>[],
    this.mediaAndLearning = const <String>[],
    this.foodAndCuisine = const <String>[],
    this.travelAndLeisure = const <String>[],
  });

  factory PreviewInterests.fromJson(Map<String, dynamic> json) =>
      PreviewInterests(
        creativePursuits: _asStringList(json['creativePursuits']),
        outdoorActivities: _asStringList(json['outdoorActivities']),
        fitnessAndSports: _asStringList(json['fitnessAndSports']),
        mediaAndLearning: _asStringList(json['mediaAndLearning']),
        foodAndCuisine: _asStringList(json['foodAndCuisine']),
        travelAndLeisure: _asStringList(json['travelAndLeisure']),
      );

  final List<String> creativePursuits;
  final List<String> outdoorActivities;
  final List<String> fitnessAndSports;
  final List<String> mediaAndLearning;
  final List<String> foodAndCuisine;
  final List<String> travelAndLeisure;

  List<String> get all => [
        ...creativePursuits,
        ...outdoorActivities,
        ...fitnessAndSports,
        ...mediaAndLearning,
        ...foodAndCuisine,
        ...travelAndLeisure,
      ];
}

class PreviewLifestyle {
  PreviewLifestyle({this.smoking, this.drinking, this.diet});

  factory PreviewLifestyle.fromJson(Map<String, dynamic> json) =>
      PreviewLifestyle(
        smoking: json['smoking']?.toString(),
        drinking: json['drinking']?.toString(),
        diet: (json['diet'] ?? json['dietType'])?.toString(),
      );

  final String? smoking;
  final String? drinking;
  final String? diet;
}

class PreviewReligion {
  PreviewReligion({
    this.religion,
    this.community,
    this.religiousBackground,
  });

  factory PreviewReligion.fromJson(Map<String, dynamic> json) =>
      PreviewReligion(
        religion: json['religion']?.toString(),
        community: json['community']?.toString(),
        religiousBackground: json['religiousBackground']?.toString(),
      );

  final String? religion;
  final String? community;
  final String? religiousBackground;
}

class PreviewLocation {
  PreviewLocation({
    this.residencyStatus,
    this.grewUpIn,
    this.locationType,
    this.fullAddress,
    this.country,
    this.state,
    this.city,
  });

  factory PreviewLocation.fromJson(Map<String, dynamic> json) =>
      PreviewLocation(
        residencyStatus: json['residencyStatus']?.toString(),
        grewUpIn: json['grewUpIn']?.toString(),
        locationType: json['locationType']?.toString(),
        fullAddress: json['fullAddress']?.toString(),
        country: json['country']?.toString(),
        state: json['state']?.toString(),
        city: json['city']?.toString(),
      );

  final String? residencyStatus;
  final String? grewUpIn;
  final String? locationType;
  final String? fullAddress;
  final String? country;
  final String? state;
  final String? city;

  String get displayLocation {
    final parts = [city, state, country]
        .where((v) => v != null && v.trim().isNotEmpty)
        .map((v) => v!.trim())
        .toList();
    return parts.join(', ');
  }
}

class PreviewFamily {
  PreviewFamily({
    this.fatherStatus,
    this.motherStatus,
    this.numberOfSiblings,
    this.familyType,
    this.familyValues,
    this.familyStatus,
    this.familyLocation,
  });

  factory PreviewFamily.fromJson(Map<String, dynamic> json) => PreviewFamily(
        fatherStatus: json['fatherStatus']?.toString(),
        motherStatus: json['motherStatus']?.toString(),
        numberOfSiblings: (json['numberOfSiblings'] as num?)?.toInt(),
        familyType: json['familyType']?.toString(),
        familyValues: json['familyValues']?.toString(),
        familyStatus: json['familyStatus']?.toString(),
        familyLocation: json['familyLocation']?.toString(),
      );

  final String? fatherStatus;
  final String? motherStatus;
  final int? numberOfSiblings;
  final String? familyType;
  final String? familyValues;
  final String? familyStatus;
  final String? familyLocation;
}

class PreviewEducation {
  PreviewEducation({
    this.educationLevel,
    this.fieldOfStudy,
    this.institutionName,
  });

  factory PreviewEducation.fromJson(Map<String, dynamic> json) =>
      PreviewEducation(
        educationLevel: json['educationLevel']?.toString(),
        fieldOfStudy: (json['fieldOfStudy'] ?? json['degree'])?.toString(),
        institutionName:
            (json['institutionName'] ?? json['institution'])?.toString(),
      );

  final String? educationLevel;
  final String? fieldOfStudy;
  final String? institutionName;
}

class PreviewProfession {
  PreviewProfession({
    this.workingWith,
    this.workingAs,
    this.employerName,
    this.incomeRange,
    this.incomeFrequency,
  });

  factory PreviewProfession.fromJson(Map<String, dynamic> json) =>
      PreviewProfession(
        workingWith: json['workingWith']?.toString(),
        workingAs: (json['workingAs'] ?? json['profession'])?.toString(),
        employerName: json['employerName']?.toString(),
        incomeRange: (json['incomeRange'] ?? json['annualIncome'])?.toString(),
        incomeFrequency: json['incomeFrequency']?.toString(),
      );

  final String? workingWith;
  final String? workingAs;
  final String? employerName;
  final String? incomeRange;
  final String? incomeFrequency;
}

class PreviewRange {
  PreviewRange({this.min, this.max});

  factory PreviewRange.fromJson(Map<String, dynamic> json) => PreviewRange(
        min: (json['min'] as num?)?.toDouble(),
        max: (json['max'] as num?)?.toDouble(),
      );

  final double? min;
  final double? max;
}

class PreviewPreferences {
  PreviewPreferences({
    this.ageRange,
    this.heightRange,
    this.maritalStatusPreference = const <String>[],
    this.religionPreference = const <String>[],
    this.motherTonguePreference = const <String>[],
    this.communityPreference = const <String>[],
    this.preferredCountries = const <String>[],
    this.preferredStates = const <String>[],
    this.preferredCities = const <String>[],
    this.educationPreference = const <String>[],
    this.professionPreference = const <String>[],
    this.workingAsPreference = const <String>[],
    this.annualIncomePreference = const <String>[],
  });

  factory PreviewPreferences.fromJson(Map<String, dynamic> json) =>
      PreviewPreferences(
        ageRange: _asMap(json['ageRange']) != null
            ? PreviewRange.fromJson(_asMap(json['ageRange'])!)
            : null,
        heightRange: _asMap(json['heightRange']) != null
            ? PreviewRange.fromJson(_asMap(json['heightRange'])!)
            : null,
        maritalStatusPreference: _asStringList(json['maritalStatusPreference']),
        religionPreference: _asStringList(json['religionPreference']),
        motherTonguePreference: _asStringList(json['motherTonguePreference']),
        communityPreference: _asStringList(json['communityPreference']),
        preferredCountries: _asStringList(json['preferredCountries']),
        preferredStates: _asStringList(json['preferredStates']),
        preferredCities: _asStringList(json['preferredCities']),
        educationPreference: _asStringList(json['educationPreference']),
        professionPreference: _asStringList(json['professionPreference']),
        workingAsPreference: _asStringList(json['workingAsPreference']),
        annualIncomePreference: _asStringList(json['annualIncomePreference']),
      );

  final PreviewRange? ageRange;
  final PreviewRange? heightRange;
  final List<String> maritalStatusPreference;
  final List<String> religionPreference;
  final List<String> motherTonguePreference;
  final List<String> communityPreference;
  final List<String> preferredCountries;
  final List<String> preferredStates;
  final List<String> preferredCities;
  final List<String> educationPreference;
  final List<String> professionPreference;
  final List<String> workingAsPreference;
  final List<String> annualIncomePreference;
}

class PreviewConnection {
  PreviewConnection({this.status, this.message});

  factory PreviewConnection.fromJson(Map<String, dynamic> json) =>
      PreviewConnection(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
      );

  final String? status;
  final String? message;
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

Map<String, dynamic>? _firstMap(dynamic value) {
  if (value is List) {
    for (final item in value) {
      final map = _asMap(item);
      if (map != null) return map;
    }
  }
  return _asMap(value);
}

List<String> _asStringList(dynamic value) {
  if (value is List) {
    return value
        .where((e) => e != null)
        .map((e) => e.toString())
        .where((s) => s.trim().isNotEmpty)
        .toList(growable: false);
  }
  return const <String>[];
}

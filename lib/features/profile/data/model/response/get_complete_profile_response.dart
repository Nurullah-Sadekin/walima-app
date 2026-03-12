
class GetCompleteProfileResponse {
  GetCompleteProfileResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  GetCompleteProfileResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response =
        json['response'] != null ? CompleteProfile.fromJson(json['response']) : null;
    traceId = json['traceId'];
  }
  String? code;
  String? message;
  CompleteProfile? response;
  String? traceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.toJson();
    }
    map['traceId'] = traceId;
    return map;
  }
}

class CompleteProfile {
  CompleteProfile({
    this.user,
    this.profile,
    this.profileCompletion,
    this.statistics,
    this.appearance,
    this.locations,
    this.educations,
    this.profession,
    this.family,
    this.religion,
    this.lifestyle,
    this.preferences,
    this.contacts,
    this.galleryImages,
    this.interest,
  });

  CompleteProfile.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    profileCompletion = json['profileCompletion'] != null
        ? ProfileCompletion.fromJson(json['profileCompletion'])
        : null;
    statistics = json['statistics'] != null
        ? Statistics.fromJson(json['statistics'])
        : null;
    appearance = json['appearance'] != null
        ? Appearance.fromJson(json['appearance'])
        : null;
    if (json['locations'] != null) {
      locations = [];
      json['locations'].forEach((v) {
        locations?.add(Locations.fromJson(v));
      });
    }
    if (json['educations'] != null) {
      educations = [];
      json['educations'].forEach((v) {
        educations?.add(Educations.fromJson(v));
      });
    }
    if (json['profession'] != null) {
      profession = [];
      json['profession'].forEach((v) {
        profession?.add(Profession.fromJson(v));
      });
    }
    family = json['family'] != null ? Family.fromJson(json['family']) : null;
    religion =
        json['religion'] != null ? Religion.fromJson(json['religion']) : null;
    lifestyle = json['lifestyle'] != null
        ? Lifestyle.fromJson(json['lifestyle'])
        : null;
    preferences = json['preferences'] != null
        ? Preferences.fromJson(json['preferences'])
        : null;
    if (json['contacts'] != null) {
      contacts = [];
      json['contacts'].forEach((v) {
        contacts?.add(Contacts.fromJson(v));
      });
    }
    if (json['galleryImages'] != null) {
      galleryImages = [];
      // json['galleryImages'].forEach((v) {
      //   galleryImages?.add(Dynamic.fromJson(v));
      // });
    }
    interest =
        json['interest'] != null ? Interest.fromJson(json['interest']) : null;
  }
  User? user;
  Profile? profile;
  ProfileCompletion? profileCompletion;
  Statistics? statistics;
  Appearance? appearance;
  List<Locations>? locations;
  List<Educations>? educations;
  List<Profession>? profession;
  Family? family;
  Religion? religion;
  Lifestyle? lifestyle;
  Preferences? preferences;
  List<Contacts>? contacts;
  List<dynamic>? galleryImages;
  Interest? interest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (profile != null) {
      map['profile'] = profile?.toJson();
    }
    if (profileCompletion != null) {
      map['profileCompletion'] = profileCompletion?.toJson();
    }
    if (statistics != null) {
      map['statistics'] = statistics?.toJson();
    }
    if (appearance != null) {
      map['appearance'] = appearance?.toJson();
    }
    if (locations != null) {
      map['locations'] = locations?.map((v) => v.toJson()).toList();
    }
    if (educations != null) {
      map['educations'] = educations?.map((v) => v.toJson()).toList();
    }
    if (profession != null) {
      map['profession'] = profession?.map((v) => v.toJson()).toList();
    }
    if (family != null) {
      map['family'] = family?.toJson();
    }
    if (religion != null) {
      map['religion'] = religion?.toJson();
    }
    if (lifestyle != null) {
      map['lifestyle'] = lifestyle?.toJson();
    }
    if (preferences != null) {
      map['preferences'] = preferences?.toJson();
    }
    if (contacts != null) {
      map['contacts'] = contacts?.map((v) => v.toJson()).toList();
    }
    if (galleryImages != null) {
      map['galleryImages'] = galleryImages?.map((v) => v.toJson()).toList();
    }
    if (interest != null) {
      map['interest'] = interest?.toJson();
    }
    return map;
  }
}

class Interest {
  Interest({
    this.id,
    this.profileId,
    this.creativePursuits,
    this.outdoorActivities,
    this.fitnessAndSports,
    this.mediaAndLearning,
    this.foodAndCuisine,
    this.travelAndLeisure,
    this.createdAt,
    this.updatedAt,
  });

  Interest.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    creativePursuits = json['creativePursuits'] != null
        ? json['creativePursuits'].cast<String>()
        : [];
    outdoorActivities = json['outdoorActivities'] != null
        ? json['outdoorActivities'].cast<String>()
        : [];
    fitnessAndSports = json['fitnessAndSports'] != null
        ? json['fitnessAndSports'].cast<String>()
        : [];
    mediaAndLearning = json['mediaAndLearning'] != null
        ? json['mediaAndLearning'].cast<String>()
        : [];
    foodAndCuisine = json['foodAndCuisine'] != null
        ? json['foodAndCuisine'].cast<String>()
        : [];
    travelAndLeisure = json['travelAndLeisure'] != null
        ? json['travelAndLeisure'].cast<String>()
        : [];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  List<String>? creativePursuits;
  List<String>? outdoorActivities;
  List<String>? fitnessAndSports;
  List<String>? mediaAndLearning;
  List<String>? foodAndCuisine;
  List<String>? travelAndLeisure;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['creativePursuits'] = creativePursuits;
    map['outdoorActivities'] = outdoorActivities;
    map['fitnessAndSports'] = fitnessAndSports;
    map['mediaAndLearning'] = mediaAndLearning;
    map['foodAndCuisine'] = foodAndCuisine;
    map['travelAndLeisure'] = travelAndLeisure;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Contacts {
  Contacts({
    this.id,
    this.profileId,
    this.contactType,
    this.contactValue,
    this.contactOwner,
    this.contactOwnerType,
    this.isVerified,
    this.isPrimary,
    this.isPublic,
    this.convenientTime,
    this.countryCode,
    this.timezone,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  Contacts.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    contactType = json['contactType'];
    contactValue = json['contactValue'];
    contactOwner = json['contactOwner'];
    contactOwnerType = json['contactOwnerType'];
    isVerified = json['isVerified'];
    isPrimary = json['isPrimary'];
    isPublic = json['isPublic'];
    convenientTime = json['convenientTime'];
    countryCode = json['countryCode'];
    timezone = json['timezone'];
    notes = json['notes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  String? contactType;
  String? contactValue;
  String? contactOwner;
  dynamic contactOwnerType;
  bool? isVerified;
  bool? isPrimary;
  bool? isPublic;
  dynamic convenientTime;
  dynamic countryCode;
  dynamic timezone;
  dynamic notes;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['contactType'] = contactType;
    map['contactValue'] = contactValue;
    map['contactOwner'] = contactOwner;
    map['contactOwnerType'] = contactOwnerType;
    map['isVerified'] = isVerified;
    map['isPrimary'] = isPrimary;
    map['isPublic'] = isPublic;
    map['convenientTime'] = convenientTime;
    map['countryCode'] = countryCode;
    map['timezone'] = timezone;
    map['notes'] = notes;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

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

class Lifestyle {
  Lifestyle({
    this.id,
    this.profileId,
    this.dietType,
    this.foodHabits,
    this.drinkingHabits,
    this.smokingHabits,
    this.exerciseHabits,
    this.travelFrequency,
    this.socialMediaUsage,
    this.lifestyleDescription,
    this.weekendActivities,
    this.fashionStyle,
    this.createdAt,
    this.updatedAt,
  });

  Lifestyle.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    dietType = json['dietType'];
    foodHabits = json['foodHabits'];
    drinkingHabits = json['drinkingHabits'];
    smokingHabits = json['smokingHabits'];
    exerciseHabits = json['exerciseHabits'];
    travelFrequency = json['travelFrequency'];
    socialMediaUsage = json['socialMediaUsage'];
    lifestyleDescription = json['lifestyleDescription'];
    weekendActivities = json['weekendActivities'];
    fashionStyle = json['fashionStyle'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  String? dietType;
  dynamic foodHabits;
  dynamic drinkingHabits;
  dynamic smokingHabits;
  dynamic exerciseHabits;
  dynamic travelFrequency;
  dynamic socialMediaUsage;
  dynamic lifestyleDescription;
  dynamic weekendActivities;
  dynamic fashionStyle;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['dietType'] = dietType;
    map['foodHabits'] = foodHabits;
    map['drinkingHabits'] = drinkingHabits;
    map['smokingHabits'] = smokingHabits;
    map['exerciseHabits'] = exerciseHabits;
    map['travelFrequency'] = travelFrequency;
    map['socialMediaUsage'] = socialMediaUsage;
    map['lifestyleDescription'] = lifestyleDescription;
    map['weekendActivities'] = weekendActivities;
    map['fashionStyle'] = fashionStyle;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Religion {
  Religion({
    this.id,
    this.profileId,
    this.religion,
    this.community,
    this.religiousBackground,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  Religion.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    religion = json['religion'];
    community = json['community'];
    religiousBackground = json['religiousBackground'];
    metadata = json['metadata'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  String? religion;
  String? community;
  String? religiousBackground;
  dynamic metadata;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['religion'] = religion;
    map['community'] = community;
    map['religiousBackground'] = religiousBackground;
    map['metadata'] = metadata;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Family {
  Family({
    this.id,
    this.profileId,
    this.familyType,
    this.familyValues,
    this.familyEconomicCondition,
    this.fatherName,
    this.fatherProfession,
    this.motherName,
    this.motherProfession,
    this.brothers,
    this.sisters,
    this.brothersMarried,
    this.sistersMarried,
    this.brothersDetails,
    this.sistersDetails,
    this.extendedFamilyMembers,
    this.additionalFamilyMembers,
    this.familyLocation,
    this.familyIncome,
    this.familyBackground,
    this.ancestralOrigin,
    this.aboutFamily,
    this.marriageTimeline,
    this.childrenPreference,
    this.createdAt,
    this.updatedAt,
  });

  Family.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    familyType = json['familyType'];
    familyValues = json['familyValues'];
    familyEconomicCondition = json['familyEconomicCondition'];
    fatherName = json['fatherName'];
    fatherProfession = json['fatherProfession'];
    motherName = json['motherName'];
    motherProfession = json['motherProfession'];
    brothers = json['brothers'];
    sisters = json['sisters'];
    brothersMarried = json['brothersMarried'];
    sistersMarried = json['sistersMarried'];
    if (json['brothersDetails'] != null) {
      brothersDetails = [];
      // json['brothersDetails'].forEach((v) {
      //   brothersDetails?.add(Dynamic.fromJson(v));
      // });
    }
    if (json['sistersDetails'] != null) {
      sistersDetails = [];
      // json['sistersDetails'].forEach((v) {
      //   sistersDetails?.add(Dynamic.fromJson(v));
      // });
    }
    if (json['extendedFamilyMembers'] != null) {
      extendedFamilyMembers = [];
      // json['extendedFamilyMembers'].forEach((v) {
      //   extendedFamilyMembers?.add(Dynamic.fromJson(v));
      // });
    }
    if (json['additionalFamilyMembers'] != null) {
      additionalFamilyMembers = [];
      // json['additionalFamilyMembers'].forEach((v) {
      //   additionalFamilyMembers?.add(Dynamic.fromJson(v));
      // });
    }
    familyLocation = json['familyLocation'];
    familyIncome = json['familyIncome'];
    familyBackground = json['familyBackground'];
    ancestralOrigin = json['ancestralOrigin'];
    aboutFamily = json['aboutFamily'];
    marriageTimeline = json['marriageTimeline'];
    childrenPreference = json['childrenPreference'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  String? familyType;
  String? familyValues;
  String? familyEconomicCondition;
  String? fatherName;
  String? fatherProfession;
  String? motherName;
  String? motherProfession;
  int? brothers;
  int? sisters;
  int? brothersMarried;
  int? sistersMarried;
  List<List<dynamic>>? brothersDetails;
  List<List<dynamic>>? sistersDetails;
  List<List<dynamic>>? extendedFamilyMembers;
  List<List<dynamic>>? additionalFamilyMembers;
  String? familyLocation;
  String? familyIncome;
  String? familyBackground;
  String? ancestralOrigin;
  String? aboutFamily;
  dynamic marriageTimeline;
  dynamic childrenPreference;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['familyType'] = familyType;
    map['familyValues'] = familyValues;
    map['familyEconomicCondition'] = familyEconomicCondition;
    map['fatherName'] = fatherName;
    map['fatherProfession'] = fatherProfession;
    map['motherName'] = motherName;
    map['motherProfession'] = motherProfession;
    map['brothers'] = brothers;
    map['sisters'] = sisters;
    map['brothersMarried'] = brothersMarried;
    map['sistersMarried'] = sistersMarried;
    if (brothersDetails != null) {
      // map['brothersDetails'] = brothersDetails?.map((v) => v.toJson()).toList();
    }
    if (sistersDetails != null) {
      // map['sistersDetails'] = sistersDetails?.map((v) => v.toJson()).toList();
    }
    if (extendedFamilyMembers != null) {
      // map['extendedFamilyMembers'] = extendedFamilyMembers?.map((v) => v.toJson()).toList();
    }
    if (additionalFamilyMembers != null) {
      // map['additionalFamilyMembers'] = additionalFamilyMembers?.map((v) => v.toJson()).toList();
    }
    map['familyLocation'] = familyLocation;
    map['familyIncome'] = familyIncome;
    map['familyBackground'] = familyBackground;
    map['ancestralOrigin'] = ancestralOrigin;
    map['aboutFamily'] = aboutFamily;
    map['marriageTimeline'] = marriageTimeline;
    map['childrenPreference'] = childrenPreference;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Profession {
  Profession({
    this.id,
    this.profileId,
    this.employmentType,
    this.profession,
    this.industry,
    this.employer,
    this.designation,
    this.workLocation,
    this.startDate,
    this.endDate,
    this.incomeRange,
    this.incomeFrequency,
    this.incomeCurrency,
    this.incomeHidden,
    this.yearsOfExperience,
    this.jobType,
    this.companySize,
    this.skills,
    this.createdAt,
    this.updatedAt,
  });

  Profession.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    employmentType = json['employmentType'];
    profession = json['profession'];
    industry = json['industry'];
    employer = json['employer'];
    designation = json['designation'];
    workLocation = json['workLocation'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    incomeRange = json['incomeRange'];
    incomeFrequency = json['incomeFrequency'];
    incomeCurrency = json['incomeCurrency'];
    incomeHidden = json['incomeHidden'];
    yearsOfExperience = json['yearsOfExperience'];
    jobType = json['jobType'];
    companySize = json['companySize'];
    skills = json['skills'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  dynamic employmentType;
  dynamic profession;
  dynamic industry;
  String? employer;
  String? designation;
  dynamic workLocation;
  dynamic startDate;
  dynamic endDate;
  String? incomeRange;
  String? incomeFrequency;
  String? incomeCurrency;
  bool? incomeHidden;
  dynamic yearsOfExperience;
  String? jobType;
  dynamic companySize;
  dynamic skills;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['employmentType'] = employmentType;
    map['profession'] = profession;
    map['industry'] = industry;
    map['employer'] = employer;
    map['designation'] = designation;
    map['workLocation'] = workLocation;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['incomeRange'] = incomeRange;
    map['incomeFrequency'] = incomeFrequency;
    map['incomeCurrency'] = incomeCurrency;
    map['incomeHidden'] = incomeHidden;
    map['yearsOfExperience'] = yearsOfExperience;
    map['jobType'] = jobType;
    map['companySize'] = companySize;
    map['skills'] = skills;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Educations {
  Educations({
    this.id,
    this.profileId,
    this.educationLevel,
    this.qualification,
    this.fieldOfStudy,
    this.institutionName,
    this.isCurrent,
    this.startDate,
    this.endDate,
    this.result,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Educations.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    educationLevel = json['educationLevel'];
    qualification = json['qualification'];
    fieldOfStudy = json['fieldOfStudy'];
    institutionName = json['institutionName'];
    isCurrent = json['isCurrent'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    result = json['result'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  dynamic educationLevel;
  dynamic qualification;
  dynamic fieldOfStudy;
  dynamic institutionName;
  bool? isCurrent;
  dynamic startDate;
  dynamic endDate;
  dynamic result;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['educationLevel'] = educationLevel;
    map['qualification'] = qualification;
    map['fieldOfStudy'] = fieldOfStudy;
    map['institutionName'] = institutionName;
    map['isCurrent'] = isCurrent;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['result'] = result;
    map['deletedAt'] = deletedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Locations {
  Locations({
    this.id,
    this.profileId,
    this.locationType,
    this.fullAddress,
    this.country,
    this.state,
    this.city,
    this.district,
    this.locality,
    this.zipCode,
    this.residencyStatus,
    this.livingSince,
    this.nativePlace,
    this.grewUpIn,
    this.willingToRelocate,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  Locations.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    locationType = json['locationType'];
    fullAddress = json['fullAddress'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    district = json['district'];
    locality = json['locality'];
    zipCode = json['zipCode'];
    residencyStatus = json['residencyStatus'];
    livingSince = json['livingSince'];
    nativePlace = json['nativePlace'];
    grewUpIn = json['grewUpIn'];
    willingToRelocate = json['willingToRelocate'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  String? locationType;
  dynamic fullAddress;
  String? country;
  dynamic state;
  String? city;
  dynamic district;
  dynamic locality;
  dynamic zipCode;
  String? residencyStatus;
  dynamic livingSince;
  dynamic nativePlace;
  dynamic grewUpIn;
  dynamic willingToRelocate;
  dynamic latitude;
  dynamic longitude;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['locationType'] = locationType;
    map['fullAddress'] = fullAddress;
    map['country'] = country;
    map['state'] = state;
    map['city'] = city;
    map['district'] = district;
    map['locality'] = locality;
    map['zipCode'] = zipCode;
    map['residencyStatus'] = residencyStatus;
    map['livingSince'] = livingSince;
    map['nativePlace'] = nativePlace;
    map['grewUpIn'] = grewUpIn;
    map['willingToRelocate'] = willingToRelocate;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Appearance {
  Appearance({
    this.id,
    this.profileId,
    this.height,
    this.weight,
    this.complexion,
    this.bodyType,
    this.bloodGroup,
    this.specialCases,
    this.ailments,
    this.healthCondition,
    this.healthDetails,
    this.createdAt,
    this.updatedAt,
  });

  Appearance.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    height = json['height'];
    weight = json['weight'];
    complexion = json['complexion'];
    bodyType = json['bodyType'];
    bloodGroup = json['bloodGroup'];
    specialCases = json['specialCases'];
    ailments = json['ailments'];
    healthCondition = json['healthCondition'];
    healthDetails = json['healthDetails'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  int? height;
  dynamic weight;
  dynamic complexion;
  dynamic bodyType;
  dynamic bloodGroup;
  dynamic specialCases;
  dynamic ailments;
  dynamic healthCondition;
  dynamic healthDetails;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['height'] = height;
    map['weight'] = weight;
    map['complexion'] = complexion;
    map['bodyType'] = bodyType;
    map['bloodGroup'] = bloodGroup;
    map['specialCases'] = specialCases;
    map['ailments'] = ailments;
    map['healthCondition'] = healthCondition;
    map['healthDetails'] = healthDetails;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Statistics {
  Statistics({
    this.totalPhotos,
  });

  Statistics.fromJson(dynamic json) {
    totalPhotos = json['totalPhotos'];
  }
  int? totalPhotos;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalPhotos'] = totalPhotos;
    return map;
  }
}

class ProfileCompletion {
  ProfileCompletion({
    this.percentage,
    this.missingFields,
    this.completedSections,
  });

  ProfileCompletion.fromJson(dynamic json) {
    percentage = json['percentage'];
    if (json['missingFields'] != null) {
      missingFields = [];
      // json['missingFields'].forEach((v) {
      //   missingFields?.add(Dynamic.fromJson(v));
      // });
    }
    completedSections = json['completedSections'] != null
        ? json['completedSections'].cast<String>()
        : [];
  }
  int? percentage;
  List<dynamic>? missingFields;
  List<String>? completedSections;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['percentage'] = percentage;
    if (missingFields != null) {
      map['missingFields'] = missingFields?.map((v) => v.toJson()).toList();
    }
    map['completedSections'] = completedSections;
    return map;
  }
}

class Profile {
  Profile({
    this.id,
    this.userId,
    this.profileManagedBy,
    this.displayName,
    this.nickName,
    this.dateOfBirth,
    this.age,
    this.gender,
    this.maritalStatus,
    this.bio,
    this.profilePictures,
    this.motherTongue,
    this.languages,
    this.religionName,
    this.countryCode,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  Profile.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    profileManagedBy = json['profileManagedBy'];
    displayName = json['displayName'];
    nickName = json['nickName'];
    dateOfBirth = json['dateOfBirth'];
    age = json['age'];
    gender = json['gender'];
    maritalStatus = json['maritalStatus'];
    bio = json['bio'];
    if (json['profilePictures'] != null) {
      profilePictures = [];
      json['profilePictures'].forEach((v) {
        profilePictures?.add(ProfilePictures.fromJson(v));
      });
    }
    motherTongue = json['motherTongue'];
    if (json['languages'] != null) {
      languages = [];
      json['languages'].forEach((v) {
        // languages?.add(Dynamic.fromJson(v));
      });
    }
    religionName = json['religionName'];
    countryCode = json['countryCode'];
    isVerified = json['isVerified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? userId;
  String? profileManagedBy;
  String? displayName;
  String? nickName;
  String? dateOfBirth;
  int? age;
  String? gender;
  String? maritalStatus;
  String? bio;
  List<ProfilePictures>? profilePictures;
  String? motherTongue;
  List<dynamic>? languages;
  String? religionName;
  String? countryCode;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['profileManagedBy'] = profileManagedBy;
    map['displayName'] = displayName;
    map['nickName'] = nickName;
    map['dateOfBirth'] = dateOfBirth;
    map['age'] = age;
    map['gender'] = gender;
    map['maritalStatus'] = maritalStatus;
    map['bio'] = bio;
    if (profilePictures != null) {
      map['profilePictures'] = profilePictures?.map((v) => v.toJson()).toList();
    }
    map['motherTongue'] = motherTongue;
    if (languages != null) {
      map['languages'] = languages?.map((v) => v.toJson()).toList();
    }
    map['religionName'] = religionName;
    map['countryCode'] = countryCode;
    map['isVerified'] = isVerified;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class ProfilePictures {
  ProfilePictures({
    this.id,
    this.profileId,
    this.url,
    this.name,
    this.alt,
    this.caption,
    this.description,
    this.status,
    this.rejectReason,
    this.rejectedBy,
    this.mediaId,
    this.category,
    this.isPrimary,
    this.photoOrder,
    this.visibility,
    this.approvalStatus,
    this.photoSizes,
    this.createdAt,
    this.updatedAt,
  });

  ProfilePictures.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    url = json['url'];
    name = json['name'];
    alt = json['alt'];
    caption = json['caption'];
    description = json['description'];
    status = json['status'];
    rejectReason = json['rejectReason'];
    rejectedBy = json['rejectedBy'];
    mediaId = json['mediaId'];
    category = json['category'];
    isPrimary = json['isPrimary'];
    photoOrder = json['photoOrder'];
    visibility = json['visibility'];
    approvalStatus = json['approvalStatus'];
    photoSizes = json['photoSizes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  String? url;
  String? name;
  dynamic alt;
  dynamic caption;
  dynamic description;
  String? status;
  dynamic rejectReason;
  dynamic rejectedBy;
  String? mediaId;
  String? category;
  bool? isPrimary;
  int? photoOrder;
  String? visibility;
  String? approvalStatus;
  dynamic photoSizes;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['url'] = url;
    map['name'] = name;
    map['alt'] = alt;
    map['caption'] = caption;
    map['description'] = description;
    map['status'] = status;
    map['rejectReason'] = rejectReason;
    map['rejectedBy'] = rejectedBy;
    map['mediaId'] = mediaId;
    map['category'] = category;
    map['isPrimary'] = isPrimary;
    map['photoOrder'] = photoOrder;
    map['visibility'] = visibility;
    map['approvalStatus'] = approvalStatus;
    map['photoSizes'] = photoSizes;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.userReference,
    this.status,
    this.isVerified,
  });

  User.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    userReference = json['userReference'];
    status = json['status'];
    isVerified = json['isVerified'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? userReference;
  String? status;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['username'] = username;
    map['userReference'] = userReference;
    map['status'] = status;
    map['isVerified'] = isVerified;
    return map;
  }
}

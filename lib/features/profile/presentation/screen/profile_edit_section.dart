enum ProfileEditSection {
  aboutYourself,
  basicDetails,
  religiousBackground,
  familyDetails,
  educationCareer,
  location,
  hobbiesInterests,
  preferenceBasicInfo,
  preferenceLocationDetails,
  preferenceEducationCareer,
  preferenceOtherDetails,
}

extension ProfileEditSectionX on ProfileEditSection {
  String get key {
    switch (this) {
      case ProfileEditSection.aboutYourself:
        return 'about-yourself';
      case ProfileEditSection.basicDetails:
        return 'basic-details';
      case ProfileEditSection.religiousBackground:
        return 'religious-background';
      case ProfileEditSection.familyDetails:
        return 'family-details';
      case ProfileEditSection.educationCareer:
        return 'education-career';
      case ProfileEditSection.location:
        return 'location';
      case ProfileEditSection.hobbiesInterests:
        return 'hobbies-interests';
      case ProfileEditSection.preferenceBasicInfo:
        return 'preference-basic-info';
      case ProfileEditSection.preferenceLocationDetails:
        return 'preference-location-details';
      case ProfileEditSection.preferenceEducationCareer:
        return 'preference-education-career';
      case ProfileEditSection.preferenceOtherDetails:
        return 'preference-other-details';
    }
  }

  String get title {
    switch (this) {
      case ProfileEditSection.aboutYourself:
        return 'About Myself';
      case ProfileEditSection.basicDetails:
        return 'Basic Details';
      case ProfileEditSection.religiousBackground:
        return 'Religious Background';
      case ProfileEditSection.familyDetails:
        return 'Family Details';
      case ProfileEditSection.educationCareer:
        return 'Education & Career';
      case ProfileEditSection.location:
        return 'Location of Groom';
      case ProfileEditSection.hobbiesInterests:
        return 'Hobbies and Interests';
      case ProfileEditSection.preferenceBasicInfo:
        return 'Partner Preferences: Basic Info';
      case ProfileEditSection.preferenceLocationDetails:
        return 'Partner Preferences: Location Details';
      case ProfileEditSection.preferenceEducationCareer:
        return 'Partner Preferences: Education & Career';
      case ProfileEditSection.preferenceOtherDetails:
        return 'Partner Preferences: Other Details';
    }
  }

  static ProfileEditSection fromKey(String? rawKey) {
    final normalized = rawKey?.trim().toLowerCase();
    for (final section in ProfileEditSection.values) {
      if (section.key == normalized) {
        return section;
      }
    }
    return ProfileEditSection.aboutYourself;
  }
}

part of 'get_complete_profile_response.dart';

enum ProfileCompletionSection {
  basicProfile,
  appearance,
  location,
  educationCareer,
  religion,
  family,
  lifestyle,
  contacts,
  photos,
  hobbiesInterests,
}

extension ProfileCompletionSectionX on ProfileCompletionSection {
  static final Map<String, ProfileCompletionSection> _aliases =
      <String, ProfileCompletionSection>{
    'basic_profile': ProfileCompletionSection.basicProfile,
    'appearance': ProfileCompletionSection.appearance,
    'location': ProfileCompletionSection.location,
    'locations': ProfileCompletionSection.location,
    'education': ProfileCompletionSection.educationCareer,
    'educations': ProfileCompletionSection.educationCareer,
    'profession': ProfileCompletionSection.educationCareer,
    'professions': ProfileCompletionSection.educationCareer,
    'religion': ProfileCompletionSection.religion,
    'family': ProfileCompletionSection.family,
    'lifestyle': ProfileCompletionSection.lifestyle,
    'contacts': ProfileCompletionSection.contacts,
    'photos': ProfileCompletionSection.photos,
    'galleryimages': ProfileCompletionSection.photos,
    'gallery_images': ProfileCompletionSection.photos,
    'interest': ProfileCompletionSection.hobbiesInterests,
    'interests': ProfileCompletionSection.hobbiesInterests,
    'hobbies': ProfileCompletionSection.hobbiesInterests,
    'hobbies_interests': ProfileCompletionSection.hobbiesInterests,
  };

  static ProfileCompletionSection? fromApiValue(String? rawValue) {
    final normalized = rawValue?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return _aliases[normalized];
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
    missingFields = json['missingFields'] != null
        ? List<String>.from(json['missingFields'])
        : [];
    completedSections = json['completedSections'] != null
        ? json['completedSections'].cast<String>()
        : [];
  }
  int? percentage;
  List<String>? missingFields;
  List<String>? completedSections;

  List<ProfileCompletionSection> get missingSectionItems =>
      (missingFields ?? [])
          .map(ProfileCompletionSectionX.fromApiValue)
          .whereType<ProfileCompletionSection>()
          .toList(growable: false);

  List<ProfileCompletionSection> get completedSectionItems =>
      (completedSections ?? [])
          .map(ProfileCompletionSectionX.fromApiValue)
          .whereType<ProfileCompletionSection>()
          .toList(growable: false);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['percentage'] = percentage;
    map['missingFields'] = missingFields;
    map['completedSections'] = completedSections;
    return map;
  }
}

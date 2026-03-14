part of 'get_complete_profile_response.dart';

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


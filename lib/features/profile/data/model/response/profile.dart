part of 'get_complete_profile_response.dart';

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
    languages = _parseLanguages(json['languages']);
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

  static List<dynamic>? _parseLanguages(dynamic rawLanguages) {
    if (rawLanguages == null) {
      return null;
    }

    if (rawLanguages is List) {
      return rawLanguages
          .map((value) => value.toString().trim())
          .where((value) => value.isNotEmpty)
          .toList(growable: false);
    }

    if (rawLanguages is String) {
      return rawLanguages
          .split(',')
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .toList(growable: false);
    }

    final fallback = rawLanguages.toString().trim();
    if (fallback.isEmpty) {
      return null;
    }
    return [fallback];
  }

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
      map['languages'] = languages;
    }
    map['religionName'] = religionName;
    map['countryCode'] = countryCode;
    map['isVerified'] = isVerified;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

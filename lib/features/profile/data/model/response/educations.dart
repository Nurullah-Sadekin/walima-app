part of 'get_complete_profile_response.dart';

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


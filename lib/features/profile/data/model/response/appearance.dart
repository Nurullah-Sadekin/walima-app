part of 'get_complete_profile_response.dart';

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


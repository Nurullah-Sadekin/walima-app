part of 'get_complete_profile_response.dart';

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


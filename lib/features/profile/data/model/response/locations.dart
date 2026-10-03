part of 'get_complete_profile_response.dart';

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


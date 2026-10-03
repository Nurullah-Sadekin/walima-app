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